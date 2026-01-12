import { UpdateWorkoutExerciseDto } from "../dto/workout-exercise.dto";
import { WorkoutExerciseCreationAttributes } from "../models/workoutExercice";
import { WorkoutExerciseRepository } from "../repository/workout-exercise.repository";

export class WorkoutExerciseService {
    private repo = new WorkoutExerciseRepository();

    async list() {
        return this.repo.list();
    }

    async getOne(id: number) {
        return this.repo.getOne(id);
    }

    async create(data: WorkoutExerciseCreationAttributes) {
        return this.repo.create(data);
    }

    async update(data: UpdateWorkoutExerciseDto) {
        return this.repo.update(data);
    }

    async delete(id: number) {
        return this.repo.delete(id);
    }
}