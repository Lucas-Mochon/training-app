import { Router } from 'express';
import { ExerciseController } from '../controller/exercise.controller';

const router = Router();

router.get('/', ExerciseController.list);
router.get('/:id', ExerciseController.getOne);
router.post('/create', ExerciseController.create);
router.put('/update', ExerciseController.update);
router.delete('/:id', ExerciseController.delete);

export default router;
