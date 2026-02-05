import httpx
import os
from typing import Optional

class ExercisesAPIService:
    def __init__(self):
        self.host = os.getenv('HOST')
        self.base_url = self.host + ":3000/api"
        self.api_key = "secret-key"
        self.http_client = httpx.AsyncClient(timeout=10.0)
    
    async def get_exercises(self) -> list:
        try:
            headers = {
                "Content-Type": "application/json",
                "X-API-Key": self.api_key
            }
            
            url = f"{self.base_url}/exercices/"
            print(f"Appel API: {url}")
            
            response = await self.http_client.get(
                url, 
                headers=headers
            )
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError as e:
            print(f"❌ Erreur HTTP {e.response.status_code}: {e.response.text}")
            return []
        except httpx.ConnectError as e:
            print(f"❌ Erreur connexion: {e}")
            return []
        except Exception as e:
            print(f"❌ Erreur: {e}")
            return []
    
    async def close(self):
        await self.http_client.aclose()
