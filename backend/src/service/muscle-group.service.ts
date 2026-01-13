import { UpdateMuscleGroup } from "../dto/muscle-group.dto";
import MuscleGroup, { MuscleGroupCreationAttributes } from "../models/muscleGroups";
import { MuscleGroupRepository } from "../repository/muscle-group.repository";

export class MuscleGroupService {
    private repo = new MuscleGroupRepository();

    async list(): Promise<MuscleGroup[]> {
        return this.repo.list();
    }

    async getOne(id: number): Promise<MuscleGroup | null> {
        return this.repo.getOne(id);
    }

    async create(data: MuscleGroupCreationAttributes): Promise<MuscleGroup | null> {
        return this.repo.create(data);
    }

    async update(data: UpdateMuscleGroup): Promise<MuscleGroup | null> {
        return this.repo.update(data);
    }

    async delete(id: number): Promise<number>{
        return this.repo.delete(id);
    }
}