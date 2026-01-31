import { Request, Response, NextFunction } from 'express';
import { AppError } from '../common/error';
import { Logger } from '../common/logger';

export const errorMiddleware = (
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  if (err instanceof AppError) {
    Logger.warn(err.message, { stack: err.stack, url: req.url });
    res.status(err.statusCode).json({
      success: false,
      message: err.message,
    });
  } else {
    Logger.error(err.message, { stack: err.stack, url: req.url });
    res.status(500).json({
      success: false,
      message: 'Internal Server Error',
    });
  }
};
