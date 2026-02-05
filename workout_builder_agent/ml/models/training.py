import sys
sys.path.insert(0, '/path/to/project')

from ml.models.data_processor import WorkoutDataProcessor
from ml.models.workout_generator import WorkoutGenerator
import numpy as np

def train_model():
    processor = WorkoutDataProcessor()
    df = processor.load_csv('ml/data/workouts.csv')
    
    X, y = processor.preprocess(df)
    
    generator = WorkoutGenerator()
    generator.train(X, y, X) 
    
    generator.save('ml/weights/workout_model.pkl')
    
    print("Entraînement terminé !")

if __name__ == "__main__":
    train_model()
