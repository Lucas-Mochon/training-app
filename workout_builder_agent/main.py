from fastapi import FastAPI, HTTPException, Header
from pydantic import BaseModel
from services.api.exercise import ExercisesAPIService
from services.api.ml_service import MLService
from services.api.workout_service import WorkoutService
import os
import logging
import traceback

logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

app = FastAPI()
API_KEY = os.getenv("API_KEY", "default-key")

exercises_service = ExercisesAPIService()
ml_service = MLService()
workout_service = WorkoutService()


class WorkoutRequest(BaseModel):
    user_id: str
    description: str
    muscle_group: str
    duration: int


@app.get("/health")
async def health_check():
    model_status = "Not loaded"
    if ml_service.model:
        model_status = "Trained" if ml_service.model.is_trained else "Loaded but not trained"
    
    return {
        "status": "ok",
        "model": model_status,
        "api_key_set": bool(API_KEY)
    }


@app.get("/exercises")
async def get_exercises():
    try:
        exercises = await exercises_service.get_exercises()
        return exercises
    except Exception as e:
        logger.error(f"Error fetching exercises: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/generate-workout")
async def generate_workout(
    request: WorkoutRequest,
    x_api_key: str = Header(None)
):
    try:
        if x_api_key != API_KEY:
            raise HTTPException(status_code=401, detail="Unauthorized")
        
        if not ml_service.model or not ml_service.model.is_trained:
            raise Exception("Model not available or not trained")
        
        exercises_response = await exercises_service.get_exercises(
            muscle_group=request.muscle_group
        )
        exercises_list = exercises_response.get('data', [])
        
        generated_workout = ml_service.generate_workout(
            description=request.description,
            muscle_group=request.muscle_group,
            duration=request.duration,
            available_exercises=exercises_list
        )
        
        workout_data = await workout_service.create_workout(
            user_id=request.user_id,
            description=request.description,
            muscle_group=request.muscle_group,
            duration=request.duration,
            generated_workout=generated_workout
        )
        
        return workout_data
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error generating workout: {e}\n{traceback.format_exc()}")
        raise HTTPException(status_code=500, detail=str(e))


@app.on_event("shutdown")
async def shutdown_event():
    await exercises_service.close()
    await workout_service.close()
