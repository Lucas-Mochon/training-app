import { Request, Response } from 'express';
import { UserService } from '../service/user.service';
import { SuccessResponse } from '../common/response/response.success';
import { ErrorResponse } from '../common/response/response.error';

const service = new UserService();

export class UserController {
    static async register(req: Request, res: Response) {
    try {
        const result = await service.register(req.body);
        return res.status(201).json(
            new SuccessResponse('User registered successfully', result)
        );
    } catch (err: any) {
        return res.status(400).json(
            new ErrorResponse(err.message)
        );
    }
    }

  static async login(req: Request, res: Response) {
    try {
        const result = await service.login(req.body);
        return res.status(201).json(
            new SuccessResponse('User logged in successfully', result)
        );
    } catch (err: any) {
        return res.status(400).json(
            new ErrorResponse(err.message)
        );
    }
  }

  static async refresh(req: Request, res: Response) {
    try {
        const { refreshToken } = req.body;
        const result = await service.refresh(refreshToken);
        return res.status(201).json(
            new SuccessResponse('Token refreshed successfully', result)
        );
    } catch (err: any) {
      return res.status(400).json(
        new ErrorResponse(err.message)
    );
    }
  }

  static async getMe(req: Request, res: Response) {
    try {
        // @ts-ignore
        const user = await service.getMe(req.user.userId);
        return res.status(200).json(new SuccessResponse('User get successfully', user));
    } catch (err: any) {
        return res.status(400).json(
            new ErrorResponse(err.message)
        );
    }
  }

  static async edit(req: Request, res: Response) {
    try {
        // @ts-ignore
        const user = await service.edit(req.user.userId, req.body);
        return res.json(new SuccessResponse('User edited successfully', user));
    } catch (err: any) {
        return res.status(400).json(
            new ErrorResponse(err.message)
        );
    }
  }

  static async delete(req: Request, res: Response) {
    try {
      // @ts-ignore
      await service.delete(req.user.userId);
      return res.json(new SuccessResponse('User deleted successfully', null));
    } catch (err: any) {
        return res.status(400).json(
            new ErrorResponse(err.message)
        );
    }
  }
}
