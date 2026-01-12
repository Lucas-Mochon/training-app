import { UpdateExerciseMuscleDto } from "../dto/exercise-muscle.dto";
import Exercise from "../models/exercice";
import ExerciseMuscle, { ExerciseMuscleCreationAttributes } from "../models/exerciceMuscle";
import MuscleGroup from "../models/muscleGroups";

export class ExerciseMuscleRepository {
    async list() {
        return ExerciseMuscle.findAll({
            include: [
                { model: Exercise, as: 'exercises', through: { attributes: [] }},
                { model: MuscleGroup, as: 'muscleGroups', through: { attributes: [] }}
            ],
        });
    }

    async getOne(id: number) {
        return ExerciseMuscle.findByPk(id, {
            include: [
                { model: Exercise, as: 'exercises', through: { attributes: [] }},
                { model: MuscleGroup, as: 'muscleGroups', through: { attributes: [] }}
            ],
        });
    }

    async create(data: ExerciseMuscleCreationAttributes) {
        return ExerciseMuscle.create(data);
    }

    async update(data : UpdateExerciseMuscleDto) {
        const updateData: Partial<ExerciseMuscle> = {};

        if (data.role !== null) updateData.role = data.role;
        if (data.exerciseId !== null) updateData.exerciseId = data.exerciseId;
        if (data.muscleGroupId !== null) updateData.muscleGroupId = data.muscleGroupId;

        await ExerciseMuscle.update(updateData, { where: { id: data.id } });

        return ExerciseMuscle.findByPk(data.id);
    }

    async delete(id: number) {
        await ExerciseMuscle.destroy({ where: { id } });
    }
}