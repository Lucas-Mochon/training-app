import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder
from typing import Tuple

class WorkoutDataProcessor:
    def __init__(self):
        self.muscle_encoder = LabelEncoder()
        self.exercise_encoder = LabelEncoder()
        self.description_encoder = LabelEncoder()
        self.is_fitted = False
        self.muscle_classes = None
        self.description_classes = None
    
    def load_csv(self, filepath: str) -> pd.DataFrame:
        return pd.read_csv(filepath)
    
    def preprocess(self, df: pd.DataFrame) -> Tuple[np.ndarray, np.ndarray]:
        """Prétraiter les données et entraîner les encodeurs"""
        df_copy = df.copy()
    
        self.description_encoder.fit(df_copy['description'])
        self.muscle_encoder.fit(df_copy['muscle_group'])
        
        df_copy['description_encoded'] = self.description_encoder.transform(df_copy['description'])
        df_copy['muscle_encoded'] = self.muscle_encoder.transform(df_copy['muscle_group'])
        
        self.description_classes = self.description_encoder.classes_
        self.muscle_classes = self.muscle_encoder.classes_
        
        X = df_copy[[
            'description_encoded',
            'muscle_encoded',
            'duration',
            'sets',
            'reps',
            'rest_time'
        ]].values.astype(float)
        
        if 'exercise_id' in df_copy.columns:
            y = df_copy['exercise_id'].values.astype(float)
        else:
            raise ValueError("La colonne 'exercise_id' est manquante!")
        
        self.is_fitted = True
        return X, y
    
    def encode_input(self, description: str, muscle_group: str, duration: int) -> np.ndarray:
        """Encoder une entrée utilisateur"""
        
        if not self.is_fitted:
            raise ValueError("Le preprocessor n'a pas ete entraine. Appelle preprocess() d'abord.")
        
        desc_enc = self._encode_value(description, self.description_encoder, self.description_classes)
        muscle_enc = self._encode_value(muscle_group, self.muscle_encoder, self.muscle_classes)
        
        return np.array([[desc_enc, muscle_enc, duration, 0, 0, 0]], dtype=float)
    
    def _encode_value(self, value: str, encoder: LabelEncoder, classes: np.ndarray) -> int:
        """Encoder une valeur avec fallback"""
        try:
            return encoder.transform([value])[0]
        except ValueError:
            if len(classes) > 0:
                return encoder.transform([classes[0]])[0]
            return 0
    
    def initialize_with_defaults(self):
        """Initialiser les encodeurs avec des valeurs par défaut"""
        default_descriptions = np.array(['hypertrophie', 'force', 'endurance', 'puissance', 'cardio', 'flexibilite'])
        default_muscles = np.array(['Poitrine', 'Dos', 'Jambes', 'Bras', 'Epaules', 'Abdominaux'])
        
        self.description_encoder.fit(default_descriptions)
        self.muscle_encoder.fit(default_muscles)
        
        self.description_classes = self.description_encoder.classes_
        self.muscle_classes = self.muscle_encoder.classes_
        
        self.is_fitted = True
