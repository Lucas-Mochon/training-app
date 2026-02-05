import { ExerciseFilters, UpdateExercice } from "../dto/exercice.dto";
import Exercise, { ExerciseCreationAttributes } from "../models/exercice";
import { ExerciseRepository } from "../repository/exercise.repository";

export class ExerciseService {
    private repo = new ExerciseRepository();

    async list(muscleGroup?: string): Promise<Exercise[]> {
        const filters: ExerciseFilters = {
            muscleGroup: muscleGroup
        }
        return this.repo.list(filters);
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