from fastapi import FastAPI, HTTPException, Header
from pydantic import BaseModel
from api.exercise import ExercisesAPIService
import os

app = FastAPI()
API_KEY = os.getenv("API_KEY")

exercises_service = ExercisesAPIService()

class WorkoutRequest(BaseModel):
    description: str
    muscle_group: str
    duration: int


@app.get("/exercises")
async def get_exercises():
    try:
        exercises = await exercises_service.get_exercises()
        return {
            "exercises": exercises
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/generate-workout")
async def generate_workout(
    request: WorkoutRequest,
    x_api_key: str = Header(None)
):

    if x_api_key != API_KEY:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    try:
        exercises = await exercises_service.get_exercises(
            muscle_group=request.muscle_group
        )
        return {
            "description": request.description,
            "muscle_group": request.muscle_group,
            "duration": request.duration,
            "exercises": exercises
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.on_event("shutdown")
async def shutdown_event():
    await exercises_service.close()
