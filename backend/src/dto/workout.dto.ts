import { WorkoutGoal } from "../enum/workout-goal.enum";

export interface FilterListWorkouts {
    userId: string;
    minDuration?: number;
    maxDuration?: number;
    goal?: WorkoutGoal;
}

export interface WorkoutGenerationResponseDto {
  workout: WorkoutDto;
  workoutExercises: WorkoutExerciseDto[];
}

export interface WorkoutDto {
  goal: WorkoutGoal;
  duration: number;
  userId: string;
}

export interface WorkoutExerciseDto {
  sets: number;
  reps: string;
  rest_seconds: number;
  order_index: number;
  workoutId: string;
  exerciseId: string;
}