import { UpdateWorkoutExerciseDto } from "../dto/workout-exercise.dto";
import WorkoutExercise, { WorkoutExerciseCreationAttributes } from "../models/workoutExercice";
import { WorkoutExerciseRepository } from "../repository/workout-exercise.repository";

export class WorkoutExerciseService {
    private repo = new WorkoutExerciseRepository();

    async list(): Promise<WorkoutExercise[]> {
        return this.repo.list();
    }

    async getOne(id: number): Promise<WorkoutExercise | null> {
        return this.repo.getOne(id);
    }

    async create(data: WorkoutExerciseCreationAttributes): Promise<WorkoutExercise | null> {
        return this.repo.create(data);
    }

    async update(data: UpdateWorkoutExerciseDto): Promise<WorkoutExercise | null> {
        return this.repo.update(data);
    }

    async delete(id: number): Promise<number> {
        return this.repo.delete(id);
    }
}