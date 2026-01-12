import { UpdateMuscleGroup } from "../dto/muscle-group.dto";
import MuscleGroup, { MuscleGroupCreationAttributes } from "../models/muscleGroups";

export class MuscleGroupRepository {
    async list() {
        return MuscleGroup.findAll();
    }

    async getOne(id: number) {
        return MuscleGroup.findByPk(id);
    }

    async create(data: MuscleGroupCreationAttributes) {
        return MuscleGroup.create(data);
    }

    async update(data: UpdateMuscleGroup) {
        await MuscleGroup.update(
            { name: data.name },
            { where: { id: data.id } }
        );

        return MuscleGroup.findByPk(data.id);
    }

    async delete(id: number) {
        return MuscleGroup.destroy({ where: { id } });
    }
}