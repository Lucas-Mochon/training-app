import { ErrorResponse } from "../common/response/response.error";
import { SuccessResponse } from "../common/response/response.success";
import { ExerciseService } from "../service/exercise.service";
import { Request, Response } from 'express';

const service = new ExerciseService();

export class ExerciseController {
    static async list(req: Request, res: Response) {
        try {
            const muscleGroup = req.query?.muscle_group as string;
            const result = await service.list(muscleGroup);
            return res.status(200).json(
                new SuccessResponse('List get successfully', result)
            );
        } catch (err: any) {
            return res.status(500).json(
                new ErrorResponse(err.message || 'Internal server error')
            );
        }
    }

    static async getOne(req: Request, res: Response) {
        try {
            const result = await service.getOne(req.params.id as string);
            return res.status(200).json(new SuccessResponse('Exercice get successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async create(req: Request, res: Response) {
        try {
            const result = await service.create(req.body);
            return res.status(201).json(new SuccessResponse('Exercice created successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async update(req: Request, res: Response) {
        try {
            const result = await service.update(req.body);
            return res.status(200).json(new SuccessResponse('Exercice updated successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async delete(req: Request, res: Response) {
        try {
            const result = await service.delete(req.params.id as string);
            return res.status(204).json(new SuccessResponse('Exercice deleted successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }
}