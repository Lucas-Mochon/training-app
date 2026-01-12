import { Router } from 'express';
import { SessionSetController } from '../controller/session-set.controller';

const router = Router();

router.get('/', SessionSetController.list)
router.get('/:id', SessionSetController.getOne)
router.post('/create', SessionSetController.create)
router.put('/update', SessionSetController.update)
router.delete('/:id', SessionSetController.delete)

export default router;
