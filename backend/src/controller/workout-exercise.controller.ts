import { ErrorResponse } from "../common/response/response.error";
import { SuccessResponse } from "../common/response/response.success";
import { WorkoutExerciseService } from "../service/workout-exercise.service";
import { Request, Response } from "express";
const service = new WorkoutExerciseService();

export class WorkoutExerciseController {

    static async list(req: Request, res: Response) {
        try {
            const result = await service.list();
            return res.status(200).json(new SuccessResponse('List get successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async getOne(req: Request, res: Response) {
        try {
            const result = await service.getOne(Number(req.params.id));
            return res.status(200).json(new SuccessResponse('Get one successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async create(req: Request, res: Response) {
        try {
            const result = await service.create(req.body);
            return res.status(201).json(new SuccessResponse('Created successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async update(req: Request, res: Response) {
        try {
            const result = await service.update(req.body);
            return res.status(200).json(new SuccessResponse('Updated successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async delete(req: Request, res: Response) {
        try {
            const result = await service.delete(Number(req.params.id));
            return res.status(204).json(new SuccessResponse('Deleted successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }
}