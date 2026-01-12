import { Router } from 'express';
import { ExerciceController } from '../controller/exercice.controller';

const router = Router();

router.get('/', ExerciceController.list);
router.get('/:id', ExerciceController.getOne);
router.post('/create', ExerciceController.create);
router.put('/update', ExerciceController.update);
router.delete('/:id', ExerciceController.delete);

export default router;
