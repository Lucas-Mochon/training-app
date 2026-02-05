import httpx
import json
from typing import Optional
import os

class WorkoutGeneratorService:
    def __init__(self):
        self.exercises_backend_url = os.getenv("BACKEND_API_URL")
        self.http_client = httpx.AsyncClient()
    
    async def generate_workout(
        self, 
        description: str, 
        muscle_group: str, 
        duration: int
    ) -> dict:
        """Génère un workout optimal"""
        
        # 1. Récupérer les exercices du backend
        exercises = await self._fetch_exercises(muscle_group)
        
        if not exercises:
            raise ValueError(f"Aucun exercice trouvé pour {muscle_group}")
        
        # 2. Calculer les paramètres optimaux selon description
        workout_params = self._calculate_workout_params(description, duration)
        
        # 3. Sélectionner et configurer les exercices
        selected_exercises = self._select_and_configure_exercises(
            exercises,
            workout_params,
            duration
        )
        
        return {"exercises": selected_exercises}
    
    async def _fetch_exercises(self, muscle_group: str) -> list:
        """Récupère les exercices du backend"""
        try:
            response = await self.http_client.get(
                f"{self.exercises_backend_url}/exercises",
                params={"muscle_group": muscle_group}
            )
            response.raise_for_status()
            return response.json()
        except Exception as e:
            print(f"Erreur fetch exercises: {e}")
            return []
    
    def _calculate_workout_params(self, description: str, duration: int) -> dict:
        """Calcule les paramètres optimaux selon l'objectif"""
        
        desc_lower = description.lower()
        
        # Déterminer le type d'entraînement
        if "force" in desc_lower or "strength" in desc_lower:
            return {
                "type": "strength",
                "sets_range": (4, 5),
                "reps_range": (3, 5),
                "rest_seconds": 120,
                "exercises_count": self._calculate_exercise_count(duration, 4)
            }
        
        elif "hypertrophie" in desc_lower or "muscle" in desc_lower:
            return {
                "type": "hypertrophy",
                "sets_range": (3, 4),
                "reps_range": (8, 12),
                "rest_seconds": 90,
                "exercises_count": self._calculate_exercise_count(duration, 3.5)
            }
        
        elif "endurance" in desc_lower or "cardio" in desc_lower:
            return {
                "type": "endurance",
                "sets_range": (2, 3),
                "reps_range": (15, 20),
                "rest_seconds": 45,
                "exercises_count": self._calculate_exercise_count(duration, 2.5)
            }
        
        else:  # Par défaut: équilibré
            return {
                "type": "balanced",
                "sets_range": (3, 4),
                "reps_range": (10, 12),
                "rest_seconds": 60,
                "exercises_count": self._calculate_exercise_count(duration, 3)
            }
    
    def _calculate_exercise_count(self, duration: int, avg_time_per_exercise: float) -> int:
        """Calcule le nombre d'exercices optimal"""
        # Formule: durée / temps moyen par exercice
        count = max(2, int(duration / avg_time_per_exercise))
        return min(count, 8)  # Max 8 exercices
    
    def _select_and_configure_exercises(
        self,
        exercises: list,
        workout_params: dict,
        duration: int
    ) -> list:
        """Sélectionne et configure les exercices"""
        
        num_exercises = workout_params["exercises_count"]
        sets_range = workout_params["sets_range"]
        reps_range = workout_params["reps_range"]
        rest_seconds = workout_params["rest_seconds"]
        
        # Prendre les N premiers exercices (ou les mieux notés si score existe)
        selected = exercises[:num_exercises]
        
        # Calculer sets/reps optimaux
        total_time = 0
        configured_exercises = []
        
        for idx, exercise in enumerate(selected):
            # Déterminer sets et reps
            sets = sets_range[0] if idx < len(selected) // 2 else sets_range[1]
            reps = f"{reps_range[0]}-{reps_range[1]}"
            
            # Temps estimé: (sets * 45 sec par set) + rest
            estimated_time = (sets * 0.75) + (rest_seconds / 60)
            
            configured_exercises.append({
                "exerciseId": exercise.get("id", idx + 1),
                "name": exercise.get("name", f"Exercise {idx + 1}"),
                "sets": sets,
                "reps": reps,
                "rest_seconds": rest_seconds,
                "order_index": idx
            })
            
            total_time += estimated_time
        
        # Ajuster si dépassement de durée
        if total_time > duration:
            configured_exercises = self._adjust_for_duration(
                configured_exercises,
                duration
            )
        
        return configured_exercises
    
    def _adjust_for_duration(self, exercises: list, target_duration: int) -> list:
        """Ajuste les exercices si dépassement de durée"""
        
        # Réduire les sets du dernier exercice
        if exercises:
            exercises[-1]["sets"] = max(2, exercises[-1]["sets"] - 1)
        
        # Ou réduire le repos
        for ex in exercises:
            if ex["rest_seconds"] > 45:
                ex["rest_seconds"] -= 15
        
        return exercises
