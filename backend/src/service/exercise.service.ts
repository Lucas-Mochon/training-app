import { UpdateExercice } from "../dto/exercice.dto";
import { ExerciseCreationAttributes } from "../models/exercice";
import { ExerciseRepository } from "../repository/exercise.repository";

export class ExerciseService {
    private repo = new ExerciseRepository();

    async list() {
        return this.repo.list();
    }

    async getOne(id: string) {
        return this.repo.getOne(id);
    }

    async create(data: ExerciseCreationAttributes) {
        return this.repo.create(data);
    }

    async update(data: UpdateExercice) {
        return this.repo.update(data);
    }

    async delete(id: string) {
        return this.repo.delete(id);
    }
}