import { Request, Response } from "express";
import { TrainingSessionService } from "../service/training-sesssion.service";
import { SuccessResponse } from "../common/response/response.success";
import { ErrorResponse } from "../common/response/response.error";

const service = new TrainingSessionService();

export class TrainingSessionController {
    static async list(req: Request, res: Response) {
        try {
            // @ts-ignore
            const userId = req.user.userId;
            const result = await service.list(userId);
            return res.status(200).json(new SuccessResponse('List get successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async getOne(req: Request, res: Response) {
        try {
            const result = await service.getOne(req.params.id as string);
            return res.status(200).json(new SuccessResponse('Training session get successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    } 

    static async create(req: Request, res: Response) {
        try {
            const result = await service.create(req.body);
            return res.status(200).json(new SuccessResponse('Training session created successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async update(req: Request, res: Response) {
        try {
            const result = await service.update(req.body);
            return res.status(200).json(new SuccessResponse('Training session updated successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async delete(req: Request, res: Response) {
        try {
            const result = await service.delete(req.params.id as string);
            return res.status(200).json(new SuccessResponse('Training session delete successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    } 
}