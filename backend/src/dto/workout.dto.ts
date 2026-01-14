import { WorkoutGoal } from "../enum/workout-goal.enum";

export interface FilterListWorkouts {
    userId: string;
    minDuration?: number;
    maxDuration?: number;
    goal?: WorkoutGoal;
}