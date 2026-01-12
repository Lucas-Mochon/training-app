import express from 'express';
import userRoutes from './routes/user.routes';
import workoutRoutes from './routes/workout.routes';
import exerciceRoutes from './routes/exercice.routes'
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

const PORT = process.env.PORT;
app.listen(PORT, () => Logger.info(`Server running on ${PORT}`));