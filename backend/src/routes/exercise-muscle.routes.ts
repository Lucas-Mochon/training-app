import { Router } from 'express';
import { ExerciseMuscleController } from '../controller/exercise-muscle.controller';

const router = Router();

router.get('/', ExerciseMuscleController.list)
router.get('/:id', ExerciseMuscleController.getOne)
router.post('/create', ExerciseMuscleController.create)
router.put('/update', ExerciseMuscleController.update)
router.delete('/:id', ExerciseMuscleController.delete)

export default router;
