import { Request, Response, NextFunction } from 'express';
import { Logger } from '../common/logger';
import { ErrorResponse } from '../common/response/response.error';

export const adminMiddleware = (req: Request, res: Response, next: NextFunction) => {
  // @ts-ignore
  const roles = req.user?.roles || [];

  if (!roles.includes('admin')) {
    // @ts-ignore
    Logger.error(`Unauthorized admin access attempt by user ${req.user?.userId}`);
    return res.status(403).json(
      new ErrorResponse('Access denied. Admin role required.')
    );
  }

  next();
};
