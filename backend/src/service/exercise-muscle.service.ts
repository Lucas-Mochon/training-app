import { UpdateExerciseMuscleDto } from "../dto/exercise-muscle.dto";
import ExerciseMuscle, { ExerciseMuscleCreationAttributes } from "../models/exerciceMuscle";
import { ExerciseMuscleRepository } from "../repository/exercise-muscle.repository";

export class ExerciseMuscleService {
    private repo = new ExerciseMuscleRepository();

    async list(): Promise<ExerciseMuscle[]> {
        return this.repo.list();
    }

    async getOne(id: number): Promise<ExerciseMuscle | null> {
        return this.repo.getOne(id);
    }

    async create(data: ExerciseMuscleCreationAttributes): Promise<ExerciseMuscle | null> {
        return this.repo.create(data);
    }

    async update(data: UpdateExerciseMuscleDto): Promise<ExerciseMuscle | null> {
        return this.repo.update(data);
    }

    async delete(id: number): Promise<void> {
        return this.repo.delete(id);
    }
}