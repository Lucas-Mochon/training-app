from ml.models.workout_generator import WorkoutGenerator
from typing import Optional, List

class MLService:
    def __init__(self, model_path: str = 'ml/weights/workout_model.pkl'):
        try:
            self.model = WorkoutGenerator.load(model_path)
        except FileNotFoundError:
            self.model = None
    
    def generate_workout(
        self,
        description: str,
        muscle_group: str,
        duration: int,
        available_exercises: List[dict]
    ) -> dict:
        """Générer un workout avec IA"""
        
        if not self.model:
            raise Exception("Modèle non disponible")
        
        return self.model.generate_workout(
            description,
            muscle_group,
            duration,
            available_exercises
        )
