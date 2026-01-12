import { Router } from 'express';
import { MuscleGroupController } from '../controller/muscle-group.controller';

const router = Router();

router.get('/', MuscleGroupController.list)
router.get('/:id', MuscleGroupController.getOne)
router.post('/create', MuscleGroupController.create)
router.put('/update', MuscleGroupController.update)
router.delete('/:id', MuscleGroupController.delete)

export default router;
