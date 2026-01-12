export interface UpdateWorkoutExerciseDto {
    id: number;
    sets?: number;
    reps?: string;
    rest_seconds?: number;
    order_index?: number;
    workoutId?: string;
    exerciseId?: string;
}