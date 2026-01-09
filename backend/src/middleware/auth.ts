import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { AppError } from '../common/error';
import { Logger } from '../common/logger';

interface JwtPayload {
  userId: string;
  email: string;
}

export const authMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    Logger.warn('No Authorization header', { url: req.originalUrl });
    throw new AppError('Unauthorized', 401);
  }

  const token = authHeader.split(' ')[1];

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET!) as JwtPayload;
    (req as any).user = payload;
    next();
  } catch (err) {
    Logger.warn('Invalid token', { url: req.originalUrl });
    throw new AppError('Unauthorized', 401);
  }
};
