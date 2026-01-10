import { Router } from 'express';
import { WorkoutController } from '../controller/workout.controller';

const router = Router();

router.get('/', WorkoutController.list);
router.get('/:id', WorkoutController.getOne);
router.post('/create', WorkoutController.create);
router.put('/update', WorkoutController.update);

export default router;
