import { UpdateTrainingSessionDto } from "../dto/training-session.dto";
import TrainingSession, { TrainingSessionCreationAttributes } from "../models/trainingSession";

export class TrainingSessionRepository {
    async list(): Promise<TrainingSession[]> {
        return TrainingSession.findAll();
    }

    async getOne(id: string): Promise<TrainingSession | null> {
        return TrainingSession.findByPk(id);
    }

    async create(data: TrainingSessionCreationAttributes): Promise<TrainingSession | null> {
        return TrainingSession.create(data);
    }

    async update(data: UpdateTrainingSessionDto): Promise<TrainingSession | null> {
        const updateData: Partial<TrainingSession> = {};

        if (data.duration !== null) updateData.duration = data.duration;
        if (data.feeling !== null) updateData.feeling = data.feeling;

        await TrainingSession.update(updateData, {where: {id: data.id}})

        return TrainingSession.findByPk(data.id)
    }

    async delete(id: string): Promise<number> {
        return TrainingSession.destroy({where: {id: id}});
    }
}