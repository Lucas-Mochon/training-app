import { UpdateSessionSetDto } from "../dto/session-set.dto";
import SessionSet, { SessionSetCreationAttributes } from "../models/sessionSet";

export class SessionSetRepository {
    async list(): Promise<SessionSet[]> {
        return SessionSet.findAll();
    }

    async getOne(id: string): Promise<SessionSet | null> {
        return SessionSet.findByPk(id);
    }

    async create(data: SessionSetCreationAttributes): Promise<SessionSet | null> {
        return await SessionSet.create(data);
    }

    async update(data: UpdateSessionSetDto): Promise<SessionSet | null> {
        const updateData: Partial<SessionSet> = {};

        if (data.set_number !== null) updateData.set_number = data.set_number;
        if (data.reps !== null) updateData.reps = data.reps;
        if (data.weight !== null) updateData.weight = data.weight;
        if (data.trainingSessionId !== null) updateData.trainingSessionId = data.trainingSessionId;
        if (data.exerciseId !== null) updateData.exerciseId = data.exerciseId;

        await SessionSet.update(updateData, { where: { id: data.id } });

        return SessionSet.findByPk(data.id);
    }

    async delete(id: string): Promise<void> {
        await SessionSet.destroy({ where: { id } });
    }
}