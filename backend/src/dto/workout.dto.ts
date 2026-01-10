import { WorkoutGoal } from "../enum/workout-goal.enum";

export interface FilterListWorkouts {
    duration?: number;
    goal?: WorkoutGoal;
}