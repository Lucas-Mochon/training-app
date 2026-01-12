import { UpdateExerciseMuscleDto } from "../dto/exercise-muscle.dto";
import { ExerciseMuscleCreationAttributes } from "../models/exerciceMuscle";
import { ExerciseMuscleRepository } from "../repository/exercise-muscle.repository";

export class ExerciseMuscleService {
    private repo = new ExerciseMuscleRepository();

    async list() {
        return this.repo.list();
    }

    async getOne(id: number) {
        return this.repo.getOne(id);
    }

    async create(data: ExerciseMuscleCreationAttributes) {
        return this.repo.create(data);
    }

    async update(data: UpdateExerciseMuscleDto) {
        return this.repo.update(data);
    }

    async delete(id: number) {
        return this.repo.delete(id);
    }
}