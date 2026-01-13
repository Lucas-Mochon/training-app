import { UpdateTrainingSessionDto } from "../dto/training-session.dto";
import { TrainingSessionCreationAttributes } from "../models/trainingSession";
import { TrainingSessionRepository } from "../repository/training-session.repository";

export class TrainingSessionService {
    private repo = new TrainingSessionRepository();

    async list() {
        return this.repo.list();
    }

    async getOne(id: string) {
        return this.repo.getOne(id);
    }

    async create(data: TrainingSessionCreationAttributes) {
        return this.repo.create(data);
    }

    async update(data: UpdateTrainingSessionDto) {
        return this.repo.update(data);
    }

    async delete(id: string) {
        return this.repo.delete(id);
    }
}