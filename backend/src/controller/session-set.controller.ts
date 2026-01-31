import { Request, Response } from "express";
import { SessionSetService } from "../service/session-set.service";
import { SuccessResponse } from "../common/response/response.success";
import { ErrorResponse } from "../common/response/response.error";

const service = new SessionSetService();

export class SessionSetController {
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
            const result = await service.getOne(req.params.id as string);
            return res.status(200).json(new SuccessResponse('Session set get successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async create(req: Request, res: Response) {
        try {
            const result = await service.create(req.body);
            return res.status(201).json(new SuccessResponse('Session set created successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async update(req: Request, res: Response) {
        try {
            const result = await service.update(req.body);
            return res.status(200).json(new SuccessResponse('Session set updated successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }

    static async delete(req: Request, res: Response) {
        try {
            const result = await service.delete(req.params.id as string);
            return res.status(204).json(new SuccessResponse('Session set deleted successfully', result));
        } catch (err: any) {
            return res.status(500).json(new ErrorResponse(err.message || 'Internal server error'));
        }
    }
}