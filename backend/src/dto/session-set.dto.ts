export interface UpdateSessionSetDto {
    id: string;
    set_number?: number;
    reps?: number;
    weight?: number;
    trainingSessionId?: string;
    exerciseId?: number;
}