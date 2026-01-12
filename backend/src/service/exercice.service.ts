import { UpdateExercice } from "../dto/exercice.dto";
import { ExerciseCreationAttributes } from "../models/exercice";
import { ExercicesRepository } from "../repository/exercice.repository";

export class ExerciceService {
    private repo = new ExercicesRepository();

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