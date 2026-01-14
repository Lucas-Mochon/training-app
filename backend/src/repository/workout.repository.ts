import { FilterListWorkouts } from "../dto/workout.dto";
import Exercise from "../models/exercice";
import Workout, { WorkoutAttributes, WorkoutCreationAttributes } from "../models/workout";
import { Op, WhereOptions } from 'sequelize';

export class WorkoutRepository {
static async list(filter: FilterListWorkouts): Promise<Workout[]> {
    const where: WhereOptions<WorkoutAttributes> = {
        userId: filter.userId,
    };

    if (filter.goal) {
        where.goal = filter.goal;
    }

    if (filter.minDuration && filter.maxDuration) {
        where.duration = {
            [Op.between]: [filter.minDuration, filter.maxDuration],
        };
    } else if (filter.minDuration) {
        where.duration = {
            [Op.gte]: filter.minDuration,
        };
    } else if (filter.maxDuration) {
        where.duration = {
            [Op.lte]: filter.maxDuration,
        };
    }

    return Workout.findAll({
        where,
        include: [{ model: Exercise, as: 'exercises' }],
    });
}

    static async getOne(id: string): Promise<Workout | null> {
        return Workout.findByPk(id, {
            include: [{ model: Exercise, as: 'exercises' }],
        });
    }

    static async create(data: WorkoutCreationAttributes): Promise<Workout | null> {
        return Workout.create(data);
    }

    static async update(data: WorkoutAttributes): Promise<Workout | null> {
        const workout = await Workout.findByPk(data.id);
        if (!workout) throw new Error('Workout not found');
        return workout.update(data);
    }
}