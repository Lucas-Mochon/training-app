from fastapi import FastAPI, HTTPException
from api.exercise import ExercisesAPIService
import os

app = FastAPI()
API_KEY = os.getenv("API_KEY")

exercises_service = ExercisesAPIService()

@app.get("/exercises")
async def get_exercises():
    try:
        exercises = await exercises_service.get_exercises()
        return {
            "exercises": exercises
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.on_event("shutdown")
async def shutdown_event():
    await exercises_service.close()
