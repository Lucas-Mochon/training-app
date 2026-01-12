import { ExerciseMuscleRole } from "../enum/exercie-muscle-goal.enum";

export interface UpdateExerciseMuscleDto {
    id: number;
    role?: ExerciseMuscleRole;
    exerciseId?: string;
    muscleGroupId?: number;
}