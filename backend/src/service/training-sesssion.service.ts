import { UpdateTrainingSessionDto } from "../dto/training-session.dto";
import TrainingSession, { TrainingSessionCreationAttributes } from "../models/trainingSession";
import { TrainingSessionRepository } from "../repository/training-session.repository";

export class TrainingSessionService {
    private repo = new TrainingSessionRepository();

    async list(userId: string): Promise<TrainingSession[]> {
        return this.repo.list(userId);
    }

    async getOne(id: string): Promise<TrainingSession | null> {
        return this.repo.getOne(id);
    }

    async create(data: TrainingSessionCreationAttributes): Promise<TrainingSession | null> {
        return this.repo.create(data);
    }

    async update(data: UpdateTrainingSessionDto): Promise<TrainingSession | null> {
        return this.repo.update(data);
    }

    async delete(id: string): Promise<number> {
        return this.repo.delete(id);
    }
}