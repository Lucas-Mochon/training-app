import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from ml.models.data_processor import WorkoutDataProcessor
from ml.models.workout_generator import WorkoutGenerator
import pandas as pd

def train_model():
    """Entraîner le modèle avec des données par défaut"""
    
    print("Création du modèle...")
    
    data = {
        'description': [
            'hypertrophie', 'hypertrophie', 'hypertrophie',
            'force', 'force', 'force',
            'endurance', 'endurance', 'endurance',
            'puissance', 'puissance', 'puissance'
        ],
        'muscle_group': [
            'Poitrine', 'Poitrine', 'Dos',
            'Poitrine', 'Dos', 'Jambes',
            'Poitrine', 'Bras', 'Epaules',
            'Jambes', 'Poitrine', 'Dos'
        ],
        'duration': [60, 45, 60, 45, 60, 90, 30, 40, 50, 60, 45, 75],
        'sets': [4, 4, 3, 5, 5, 4, 3, 3, 3, 5, 5, 4],
        'reps': [10, 8, 12, 4, 3, 5, 15, 12, 15, 6, 5, 4],
        'rest_time': [90, 90, 60, 120, 120, 90, 45, 60, 45, 120, 120, 90],
        'exercise_id': [7, 8, 15, 7, 16, 20, 10, 41, 25, 20, 7, 16]
    }
    
    df = pd.DataFrame(data)
    
    print("📊 Données d'entraînement:")
    print(df.head())
    print()
    
    processor = WorkoutDataProcessor()
    X, y = processor.preprocess(df)
    
    print(f"✅ X shape: {X.shape}, y shape: {y.shape}")
    print(f"✅ y dtype: {y.dtype}")
    print()
    
    os.makedirs('ml/weights', exist_ok=True)

    print("Entraînement du modèle...")
    generator = WorkoutGenerator()
    generator.train(X, y, df=df)
    
    generator.save('ml/weights/workout_model.pkl')
    
    print("Modèle entraîné et sauvegardé avec succès !")

if __name__ == "__main__":
    train_model()
