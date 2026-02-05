import { Request, Response } from 'express';
import { WorkoutService } from '../service/workout.service';
import { FilterListWorkouts, WorkoutGenerationResponseDto } from '../dto/workout.dto';
import { SuccessResponse } from '../common/response/response.success';
import { ErrorResponse } from '../common/response/response.error';

export class WorkoutController {
  static async list(req: Request, res: Response) {
    try {
      const filter = req.query as unknown as FilterListWorkouts;
      const workouts = await WorkoutService.list(filter);

      return res.status(200).json(new SuccessResponse('List get successfully', workouts));
    } catch (err: any) {
      return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
    }
  }

  static async getOne(req: Request, res: Response) {
    try {
        const workout = await WorkoutService.getOne(req.params.id as string);
        return res.status(200).json(new SuccessResponse('Workout get successfully', workout));
    } catch (err: any) {
        return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
    }
  }

  static async create(req: Request, res: Response) {
    try {
        const workout = await WorkoutService.create(req.body);
        return res.status(201).json(new SuccessResponse('Workout created successfully', workout));
    } catch (err: any) {
        return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
    }
  }

  static async createFromGeneration(req: Request, res: Response) {
    try {
      const generationData = req.body as WorkoutGenerationResponseDto;
      
      if (!generationData.workout || !generationData.workoutExercises) {
        return res.status(400).json(
          new ErrorResponse('Invalid data: workout and workoutExercises are required')
        );
      }

      if (generationData.workoutExercises.length === 0) {
        return res.status(400).json(
          new ErrorResponse('At least one exercise is required')
        );
      }

      const workout = await WorkoutService.createWorkoutWithWorkoutExercise(generationData);

      return res.status(201).json(
        new SuccessResponse(
          `Workout created successfully with ${generationData.workoutExercises.length} exercises`,
          workout
        )
      );
    } catch (err: any) {
      return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
    }
  }

  static async update(req: Request, res: Response) {
    try {
        const workout = await WorkoutService.update(req.body);
        return res.status(200).json(new SuccessResponse('Workout updated successfully', workout));
    } catch (err: any) {
        return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
    }
  }
}
