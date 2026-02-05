import { Router } from 'express';
import { WorkoutBuilderController } from '../controller/workout-builder.controller';

const router = Router();

router.post('/generate-workout', WorkoutBuilderController.generateWorkout)

export default router;
