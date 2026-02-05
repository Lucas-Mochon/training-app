from pydantic import BaseModel, Field

class GenerateWorkoutRequest(BaseModel):
    description: str = Field(..., description="Objectif du workout (ex: 'hypertrophie', 'force')")
    muscle_group: str = Field(..., description="Groupe musculaire cible")
    duration: int = Field(..., ge=15, le=120, description="Durée en minutes")
    apiKey: str | None = None

class ExerciseItem(BaseModel):
    exerciseId: int
    name: str
    sets: int
    reps: str
    rest_seconds: int
    order_index: int

class GeneratedWorkoutResponse(BaseModel):
    exercises: list[ExerciseItem]
    total_duration: int
    description: str
