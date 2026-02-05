import httpx
import os
from typing import Dict
import logging
import json

logger = logging.getLogger(__name__)

class WorkoutService:
    def __init__(self):
        self.host = os.getenv('HOST')
        self.base_url = self.host + ":3000/api"
        self.api_key = "secret-key"
        self.http_client = httpx.AsyncClient(timeout=10.0)
    
    async def create_workout(
        self,
        user_id: str,
        description: str,
        muscle_group: str,
        duration: int,
        generated_workout: dict
    ) -> dict:
        """Create a workout with exercises via the generation endpoint"""
        
        try:
            goal = self._map_description_to_goal(description)
            
            logger.info("Generated workout data:")
            logger.info(json.dumps(generated_workout, indent=2, ensure_ascii=False, default=str))
            
            exercises = generated_workout.get('exercises', [])
            
            workout_exercises = [
                {
                    "sets": generated_workout.get('sets', 3),
                    "reps": str(generated_workout.get('reps', '8-12')),
                    "rest_seconds": generated_workout.get('rest_time', 90),
                    "order_index": order_index,
                    "exerciseId": str(exercise.get('id'))
                }
                for order_index, exercise in enumerate(exercises)
            ]
            
            generation_payload = {
                "workout": {
                    "goal": goal,
                    "duration": duration,
                    "userId": user_id
                },
                "workoutExercises": workout_exercises
            }
            
            headers = {
                "Content-Type": "application/json",
                "X-API-Key": self.api_key
            }
            
            logger.info(f"Sending payload to {self.base_url}/workouts/from-generation")
            logger.info(json.dumps(generation_payload, indent=2, ensure_ascii=False, default=str))
            
            response = await self.http_client.post(
                f"{self.base_url}/workouts/from-generation",
                json=generation_payload,
                headers=headers
            )
            
            logger.info(f"Response status: {response.status_code}")
            
            if response.status_code in [200, 201]:
                response_data = response.json()
                logger.info("Workout created successfully")
                
                return {
                    "success": True,
                    "data": response_data
                }
            else:
                logger.error(f"HTTP {response.status_code}: {response.text}")
                
                return {
                    "success": False,
                    "error": f"HTTP {response.status_code}",
                    "details": response.text
                }
        
        except httpx.ConnectError as e:
            logger.error(f"Connection error: {e}")
            return {
                "success": False,
                "error": "Connection error to API",
                "details": str(e)
            }
        except httpx.HTTPStatusError as e:
            logger.error(f"HTTP error: {e.response.status_code}")
            return {
                "success": False,
                "error": f"HTTP error: {e.response.status_code}",
                "details": e.response.text
            }
        except Exception as e:
            logger.error(f"Error: {e}")
            return {
                "success": False,
                "error": str(e)
            }
    
    def _map_description_to_goal(self, description: str) -> str:
        """Map description to WorkoutGoal enum"""
        mapping = {
            "hypertrophie": "hypertrophy",
            "force": "strength",
            "endurance": "strength",
            "puissance": "strength",
            "cut": "cut",
            "sèche": "cut"
        }
        return mapping.get(description.lower(), "hypertrophy")
    
    async def close(self):
        await self.http_client.aclose()
