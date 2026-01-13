import { UpdateMuscleGroup } from "../dto/muscle-group.dto";
import MuscleGroup, { MuscleGroupCreationAttributes } from "../models/muscleGroups";

export class MuscleGroupRepository {
    async list(): Promise<MuscleGroup[]> {
        return MuscleGroup.findAll();
    }

    async getOne(id: number): Promise<MuscleGroup | null> {
        return MuscleGroup.findByPk(id);
    }

    async create(data: MuscleGroupCreationAttributes): Promise<MuscleGroup | null> {
        return MuscleGroup.create(data);
    }

    async update(data: UpdateMuscleGroup): Promise<MuscleGroup | null> {
        await MuscleGroup.update(
            { name: data.name },
            { where: { id: data.id } }
        );

        return MuscleGroup.findByPk(data.id);
    }

    async delete(id: number): Promise<number> {
        return MuscleGroup.destroy({ where: { id } });
    }
}