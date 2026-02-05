import { SuccessResponse } from '../common/response/response.success';
import { ErrorResponse } from '../common/response/response.error';
import { WorkoutBuilderService } from '../service/workout-builder.service';
import { Request, Response } from "express";

export class WorkoutBuilderController {
    static async generateWorkout(req: Request, res: Response) {
        try {
            const service = new WorkoutBuilderService();
            const result = await service.generateWorkout(req.body)
            return res.status(201).json(new SuccessResponse('Created successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }
}
