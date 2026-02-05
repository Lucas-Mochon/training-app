import numpy as np
import joblib
from sklearn.neural_network import MLPRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import StandardScaler
from typing import List
from ml.models.data_processor import WorkoutDataProcessor

class WorkoutGenerator:
    def __init__(self, input_size: int = 6):
        self.scaler = StandardScaler()
        
        self.model = MLPRegressor(
            hidden_layer_sizes=(128, 64, 32),
            activation='relu',
            solver='adam',
            max_iter=500,
            random_state=42,
            learning_rate_init=0.001,
            batch_size=32,
            early_stopping=True,
            validation_fraction=0.1
        )
        
        self.exercise_selector = RandomForestRegressor(
            n_estimators=100,
            random_state=42,
            max_depth=10
        )
        
        self.data_processor = WorkoutDataProcessor()
        self.is_trained = False
    
    def train(self, X: np.ndarray, y: np.ndarray, df=None):
        """Entraîner le modèle"""
        print("Entrainement du modele...")
        
        if len(X) < 2:
            raise ValueError("Pas assez de donnees d'entrainement!")
        
        if len(X) != len(y):
            raise ValueError("X et y ont des tailles differentes!")
        
        if df is not None:
            print("Entrainement du preprocessor...")
            X, y = self.data_processor.preprocess(df)
        else:
            print("Initialisation du preprocessor avec valeurs par défaut...")
            self.data_processor.initialize_with_defaults()
        
        X_scaled = self.scaler.fit_transform(X)
        
        print("Entrainement du MLP...")
        self.model.fit(X_scaled, X)
        
        print("Entrainement du selecteur d'exercices...")
        self.exercise_selector.fit(X_scaled, y)
        
        self.is_trained = True
        print("Modele entraine !")
    
    def generate_workout(
        self,
        description: str,
        muscle_group: str,
        duration: int,
        available_exercises: List[dict] = None
    ) -> dict:
        """Générer un workout"""
        
        if not self.is_trained:
            raise Exception("Modele non entraine. Appelle train() d'abord.")
        
        if not self.data_processor.is_fitted:
            print("Preprocessor non entraîné, initialisation par défaut...")
            self.data_processor.initialize_with_defaults()
        
        input_data = self.data_processor.encode_input(description, muscle_group, duration)
        
        input_scaled = self.scaler.transform(input_data)
        
        predicted_params = self.model.predict(input_scaled)[0]
        
        exercise_id = int(self.exercise_selector.predict(input_scaled)[0])
        
        selected_exercises = []
        if available_exercises:
            selected_exercises = self._select_exercises(
                available_exercises,
                predicted_params,
                muscle_group,
                duration
            )
        
        return {
            "description": description,
            "muscle_group": muscle_group,
            "duration": duration,
            "exercises": selected_exercises,
            "exercise_id": exercise_id,
            "sets": max(3, min(6, int(predicted_params[2]))),
            "reps": max(5, min(20, int(predicted_params[3]))),
            "rest_time": max(30, min(180, int(predicted_params[4]))),
            "intensity": self._calculate_intensity(description, duration)
        }
    
    def _select_exercises(
        self,
        exercises: List[dict],
        params: np.ndarray,
        muscle_group: str,
        duration: int
    ) -> List[dict]:
        """Sélectionner les exercices appropriés"""
        
        filtered = [
            e for e in exercises 
            if e.get('muscleGroup', '').lower() == muscle_group.lower()
        ]
        
        if not filtered:
            return exercises[:3]
        
        num_exercises = max(3, min(6, duration // 15))
        
        scored = []
        for ex in filtered:
            difficulty_score = ex.get('difficulty', 5) / 10
            popularity_score = ex.get('popularity', 50) / 100
            compatibility = np.random.random() * 0.3
            
            total_score = (difficulty_score * 0.3 + 
                          popularity_score * 0.5 + 
                          compatibility * 0.2)
            
            scored.append((ex, total_score))
        
        top_exercises = sorted(scored, key=lambda x: x[1], reverse=True)[:num_exercises]
        
        return [ex[0] for ex in top_exercises]
    
    def _calculate_intensity(self, description: str, duration: int) -> str:
        """Calculer l'intensité"""
        
        intensity_map = {
            'hypertrophie': 'Moderee',
            'force': 'Elevee',
            'endurance': 'Basse',
            'puissance': 'Tres Elevee',
            'cardio': 'Moderee',
            'flexibilite': 'Basse'
        }
        
        base_intensity = intensity_map.get(description.lower(), 'Moderee')
        
        if duration > 90:
            return base_intensity
        elif duration < 30:
            return 'Elevee'
        
        return base_intensity
    
    def save(self, filepath: str):
        """Sauvegarder le modèle"""
        data = {
            'model': self.model,
            'exercise_selector': self.exercise_selector,
            'scaler': self.scaler,
            'data_processor': self.data_processor,
            'is_trained': self.is_trained
        }
        joblib.dump(data, filepath, compress=3)
        print(f"Modele sauvegarde: {filepath}")
    
    @staticmethod
    def load(filepath: str) -> 'WorkoutGenerator':
        """Charger le modèle"""
        try:
            data = joblib.load(filepath)
            
            generator = WorkoutGenerator()
            
            if isinstance(data, dict):
                generator.model = data.get('model', generator.model)
                generator.exercise_selector = data.get('exercise_selector', generator.exercise_selector)
                generator.scaler = data.get('scaler', generator.scaler)
                generator.data_processor = data.get('data_processor', WorkoutDataProcessor())
                generator.is_trained = data.get('is_trained', False)
            else:
                generator = data
                if not hasattr(generator, 'data_processor'):
                    generator.data_processor = WorkoutDataProcessor()
                if not hasattr(generator, 'scaler'):
                    generator.scaler = StandardScaler()
            
            if generator.data_processor and not generator.data_processor.is_fitted:
                print("⚠️  Initialisation du preprocessor...")
                generator.data_processor.initialize_with_defaults()
            
            print(f"✅ Modele charge: {filepath}")
            return generator
        
        except FileNotFoundError:
            print(f"Fichier non trouvé: {filepath}")
            print("Creation d'un nouveau modele...")
            return WorkoutGenerator()
        except Exception as e:
            print(f"Erreur lors du chargement: {e}")
            print("Creation d'un nouveau modele...")
            return WorkoutGenerator()
