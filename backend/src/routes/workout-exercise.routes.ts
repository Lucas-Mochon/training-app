import { Router } from 'express';
import { WorkoutExerciseController } from '../controller/workout-exercise.controller';


const router = Router();

router.get('/', WorkoutExerciseController.list);
router.get('/:id', WorkoutExerciseController.getOne);
router.post('/create', WorkoutExerciseController.create);
router.put('/update', WorkoutExerciseController.update);
router.delete('/:id', WorkoutExerciseController.delete);

export default router;
