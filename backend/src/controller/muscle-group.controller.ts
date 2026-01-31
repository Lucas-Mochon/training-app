import { Logger } from "../common/logger";
import { ErrorResponse } from "../common/response/response.error";
import { SuccessResponse } from "../common/response/response.success";
import { MuscleGroupService } from "../service/muscle-group.service";
import { Request, Response } from 'express';

const service = new MuscleGroupService();

export class MuscleGroupController {
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
            return res.status(200).json(new SuccessResponse('Muscle group get successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async create(req: Request, res: Response) {
        try {
            const result = await service.create(req.body);
            return res.status(201).json(new SuccessResponse('Muscle group created successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async update(req: Request, res: Response) {
        try {
            const result = await service.update(req.body);
            return res.status(202).json(new SuccessResponse('Muscle group updated successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async delete(req: Request, res: Response) {
        try {
            const result = await service.delete(Number(req.params.id));
            return res.status(204).json(new SuccessResponse('Muscle group deleted successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }
}