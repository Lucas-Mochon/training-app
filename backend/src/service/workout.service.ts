import { FilterListWorkouts } from "../dto/workout.dto";
import { WorkoutAttributes, WorkoutCreationAttributes } from "../models/workout";
import { WorkoutRepository } from "../repository/workout.repository";

export class WorkoutService {

    static async list(filter: FilterListWorkouts) {
        return WorkoutRepository.list(filter);
    }

    static async getOne(id: string) {
        return WorkoutRepository.getOne(id);
    }

    static async create(data: WorkoutCreationAttributes) {
        return WorkoutRepository.create(data);
    }

    static async update(data: WorkoutAttributes) {
        return WorkoutRepository.update(data);
    }
}