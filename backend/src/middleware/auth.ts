import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

export const authMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const authHeader = req.headers.authorization;
  const apiKey = req.headers['x-api-key'];

  if (apiKey) {
    if (apiKey === process.env.API_KEY) {
      // @ts-ignore
      req.user = { type: 'api-key', apiKey: true };
      return next();
    } else {
      return res.status(401).json({ message: 'Invalid API Key' });
    }
  }

  if (!authHeader) {
    return res.status(401).json({ message: 'No token or API Key provided' });
  }

  const token = authHeader.split(' ')[1];
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET!);
    // @ts-ignore
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(401).json({ message: 'Invalid token' });
  }
};
