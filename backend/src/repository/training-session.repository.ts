import { UpdateTrainingSessionDto } from "../dto/training-session.dto";
import TrainingSession, { TrainingSessionCreationAttributes } from "../models/trainingSession";

export class TrainingSessionRepository {
    async list() {
        return TrainingSession.findAll();
    }

    async getOne(id: string) {
        return TrainingSession.findByPk(id);
    }

    async create(data: TrainingSessionCreationAttributes) {
        return TrainingSession.create(data);
    }

    async update(data: UpdateTrainingSessionDto) {
        const updateData: Partial<TrainingSession> = {};

        if (data.duration !== null) updateData.duration = data.duration;
        if (data.feeling !== null) updateData.feeling = data.feeling;

        await TrainingSession.update(updateData, {where: {id: data.id}})

        return TrainingSession.findByPk(data.id)
    }

    async delete(id: string) {
        return TrainingSession.destroy({where: {id: id}});
    }
}