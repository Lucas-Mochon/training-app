import { Router } from 'express';
import { UserController } from '../controller/user.controller';
import { authMiddleware } from '../middleware/auth';
import { adminMiddleware } from '../middleware/admin';

const router = Router();

router.post('/register', UserController.register);
router.post('/login', UserController.login);
router.post('/refresh', UserController.refresh);

router.get('/me', authMiddleware, UserController.getMe);
router.put('/edit', authMiddleware, UserController.edit);
router.delete('/delete', authMiddleware, UserController.delete);

router.post('/assign-admin/:userId', authMiddleware, adminMiddleware, UserController.assignAdmin);

export default router;
