import { UpdateExercice } from "../dto/exercice.dto";
import Exercise, { ExerciseCreationAttributes } from "../models/exercice";

export class ExerciseRepository {
    async list(): Promise<Exercise[]> {
        return Exercise.findAll();
    }
    
    async getOne(id: string): Promise<Exercise | null> {
        return Exercise.findByPk(id);
    }

    async create(data: ExerciseCreationAttributes): Promise<Exercise | null> {
        return Exercise.create(data);
    }

    async update(data: UpdateExercice): Promise<Exercise | null> {
        const updateData: Partial<Exercise> = {};

        if (data.name !== null) updateData.name = data.name;
        if (data.description !== null) updateData.description = data.description;
        if (data.difficulty !== null) updateData.difficulty = data.difficulty;
        if (data.is_compound !== null) updateData.is_compound = data.is_compound;
        if (data.equipment !== null) updateData.equipment = data.equipment;
        
        Exercise.update(updateData, { 
            where: { id: data.id } 
        });

        return Exercise.findByPk(data.id);
    }

    async delete(id: string): Promise<number> {
        return Exercise.destroy({ where: { id } });
    }
}