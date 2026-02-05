import axios from 'axios';
import { GenerateWorkoutRequest } from '../dto/workout.dto';
import Workout from '../models/workout';
require('dotenv').config();

export class WorkoutBuilderService {
  private workoutBuilderUrl: string;
  private apiKey: string;
  
  constructor() {
    this.workoutBuilderUrl = `http://${process.env.DB_HOST}:8000`;
    
    if (!process.env.API_KEY) {
      throw new Error('API_KEY is not defined in environment variables');
    }
    this.apiKey = process.env.API_KEY;
  }

  async generateWorkout(request: GenerateWorkoutRequest): Promise<Workout> {
    try {
      const response = await axios.post<any>(
        `${this.workoutBuilderUrl}/generate-workout`,
        request,
        {
          headers: {
            'Content-Type': 'application/json',
            'X-API-Key': this.apiKey
          },
          timeout: 30000
        }
      );

      return response.data.data.data;
    } catch (error: any) {
      if (error.response?.data) {
        throw new Error(error.response.data.detail || error.message);
      }
      throw error;
    }
  }
}
