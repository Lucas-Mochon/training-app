import { FilterListWorkouts } from "../dto/workout.dto";
import Workout, { WorkoutAttributes, WorkoutCreationAttributes } from "../models/workout";
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
}