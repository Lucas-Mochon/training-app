import { FilterListWorkouts, WorkoutGenerationResponseDto } from "../dto/workout.dto";
import Workout, { WorkoutAttributes, WorkoutCreationAttributes } from "../models/workout";
import { WorkoutExerciseRepository } from "../repository/workout-exercise.repository";
import { WorkoutRepository } from "../repository/workout.repository";

export class WorkoutService {

    static async list(filter: FilterListWorkouts): Promise<Workout[]> {
        return WorkoutRepository.list(filter);
    }

    static async getOne(id: string): Promise<Workout | null> {
        return WorkoutRepository.getOne(id);
    }

    static async create(data: WorkoutCreationAttributes): Promise<Workout | null> {
        return WorkoutRepository.create(data);
    }

    static async update(data: WorkoutAttributes): Promise<Workout | null> {
        return WorkoutRepository.update(data);
    }

    static async createWorkoutWithWorkoutExercise(data: WorkoutGenerationResponseDto) {
        try {
            const workoutId = (await WorkoutRepository.create(data.workout)).id;
            if (!workoutId) {
                throw new Error('Impossible de créer le workout');
            }
            const workoutExercisesWithId = data.workoutExercises.map(we => ({
                ...we,
                workoutId
            }));

            await Promise.all(
                workoutExercisesWithId.map(we => WorkoutExerciseRepository.create(we))
            );

            return await this.getOne(workoutId);
        } catch (error) {
            throw error;
        }
    }
}