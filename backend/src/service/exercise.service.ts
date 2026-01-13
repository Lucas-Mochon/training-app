import { UpdateExercice } from "../dto/exercice.dto";
import Exercise, { ExerciseCreationAttributes } from "../models/exercice";
import { ExerciseRepository } from "../repository/exercise.repository";

export class ExerciseService {
    private repo = new ExerciseRepository();

    async list(): Promise<Exercise[]> {
        return this.repo.list();
    }

    async getOne(id: string): Promise<Exercise | null> {
        return this.repo.getOne(id);
    }

    async create(data: ExerciseCreationAttributes): Promise<Exercise | null> {
        return this.repo.create(data);
    }

    async update(data: UpdateExercice): Promise<Exercise | null> {
        return this.repo.update(data);
    }

    async delete(id: string): Promise<number> {
        return this.repo.delete(id);
    }
}