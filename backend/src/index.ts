import express from 'express';
import userRoutes from './routes/user.routes';
import workoutRoutes from './routes/workout.routes';
import exerciceRoutes from './routes/exercice.routes';
import muscleGroupRoutes from './routes/muscle-group.routes';
import exerciseMuscleRoutes from './routes/exercise-muscle.routes'
import { initDb } from './models/index';
import { Logger } from './common/logger';
import { observabilityMiddleware } from './middleware/observability';
import { authMiddleware } from './middleware/auth';

const app = express();
app.use(express.json());

initDb();

app.use('/api/users', observabilityMiddleware, userRoutes);
app.use('/api/workouts', authMiddleware, observabilityMiddleware, workoutRoutes);
app.use('/api/exercices', authMiddleware, observabilityMiddleware, exerciceRoutes);
app.use('/api/muscle-groups', authMiddleware, observabilityMiddleware, muscleGroupRoutes);
app.use('/api/exercise-muscles', authMiddleware, observabilityMiddleware, exerciseMuscleRoutes);

const PORT = process.env.PORT;
app.listen(PORT, () => Logger.info(`Server running on ${PORT}`));