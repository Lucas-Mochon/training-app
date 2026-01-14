import { WorkoutGoal } from "../enum/workout-goal.enum";

export interface FilterListWorkouts {
    userId: string;
    duration?: number;
    goal?: WorkoutGoal;
}