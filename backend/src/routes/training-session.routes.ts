import { Router } from 'express';
import { TrainingSessionController } from '../controller/training-session.controller';


const router = Router();

router.get('/', TrainingSessionController.list);
router.get('/:id', TrainingSessionController.getOne);
router.post('/create', TrainingSessionController.create);
router.put('/update', TrainingSessionController.update);
router.delete('/:id', TrainingSessionController.delete);

export default router;
