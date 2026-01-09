import { Request, Response, NextFunction } from 'express';
import { Logger } from '../common/logger';

export const observabilityMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const start = process.hrtime();

  res.on('finish', () => {
    const [seconds, nanoseconds] = process.hrtime(start);
    const durationMs = (seconds * 1000 + nanoseconds / 1e6).toFixed(2);

    Logger.info('HTTP Request', {
      method: req.method,
      url: req.originalUrl,
      status: res.statusCode,
      duration: `${durationMs}ms`,
      ip: req.ip
    });
  });

  next();
};
