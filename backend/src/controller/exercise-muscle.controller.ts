import { ErrorResponse } from "../common/response/response.error";
import { SuccessResponse } from "../common/response/response.success";
import { ExerciseMuscleService } from "../service/exercice-muscle.service";
import { Request, Response } from "express";

const service = new ExerciseMuscleService();

export class ExerciseMuscleController {
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
            const result = await service.getOne(parseInt(req.params.id));
            return res.status(200).json(new SuccessResponse('Exercice muscle get successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async create(req: Request, res: Response) {
        try {
            const result = await service.create(req.body);
            return res.status(201).json(new SuccessResponse('Exercice muscle created successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async update(req: Request, res: Response) {
        try {
            const result = await service.update(req.body);
            return res.status(200).json(new SuccessResponse('Exercice muscle updated successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async delete(req: Request, res: Response) {
        try {
            const result = await service.delete(parseInt(req.params.id));
            return res.status(204).json(new SuccessResponse('Exercice muscle deleted successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }
}