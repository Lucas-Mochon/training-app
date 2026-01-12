import { UpdateWorkoutExerciseDto } from "../dto/workout-exercise.dto";
import WorkoutExercise, { WorkoutExerciseCreationAttributes } from "../models/workoutExercice";

export class WorkoutExerciseRepository {
    async list() {
        return WorkoutExercise.findAll();
    }

    async getOne(id: number) {
        return WorkoutExercise.findByPk(id);
    }

    async create(data: WorkoutExerciseCreationAttributes) {
        return WorkoutExercise.create(data);
    }

    async update(data: UpdateWorkoutExerciseDto) {
        const updateData: Partial<WorkoutExercise> = {};

        if (data.sets !== null) updateData.sets = data.sets;
        if (data.reps !== null) updateData.reps = data.reps;
        if (data.rest_seconds !== null) updateData.rest_seconds = data.rest_seconds;
        if (data.order_index !== null) updateData.order_index = data.order_index;
        if (data.workoutId !== null) updateData.workoutId = data.workoutId;
        if (data.exerciseId !== null) updateData.exerciseId = data.exerciseId;

        await WorkoutExercise.update(updateData, { where: { id: data.id } });

        return WorkoutExercise.findByPk(data.id);
    }

    async delete(id: number) {
        return WorkoutExercise.destroy({ where: { id } });
    }
}