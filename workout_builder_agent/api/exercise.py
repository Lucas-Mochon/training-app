import httpx
import os
from typing import Optional

class ExercisesAPIService:
    def __init__(self):
        self.host = os.getenv('HOST')
        self.base_url = self.host + ":3000/api"
        self.api_key = "secret-key"
        self.http_client = httpx.AsyncClient(timeout=10.0)
    
    async def get_exercises(self, muscle_group: Optional[str] = None) -> list:
        try:
            headers = {
                "Content-Type": "application/json",
                "X-API-Key": self.api_key
            }
            
            params = {}
            if muscle_group:
                params["muscle_group"] = muscle_group
            
            url = f"{self.base_url}/exercices"
            
            response = await self.http_client.get(
                url, 
                headers=headers,
                params=params
            )
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError:
            return []
        except httpx.ConnectError:
            return []
        except Exception:
            return []
    
    async def close(self):
        await self.http_client.aclose()
