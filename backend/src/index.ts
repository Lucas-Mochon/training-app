import express from 'express';
import userRoutes from './routes/user.routes';
import workoutRoutes from './routes/workout.routes';
import exerciceRoutes from './routes/exercise.routes';
import muscleGroupRoutes from './routes/muscle-group.routes';
import exerciseMuscleRoutes from './routes/exercise-muscle.routes';
import workoutExerciseRoutes from './routes/workout-exercise.routes';
import sessionSetRoutes from './routes/session-set.routes';
import trainingSessionRoutes from './routes/training-session.routes';
import { initDb } from './models/index';
import { Logger } from './common/logger';
import { observabilityMiddleware } from './middleware/observability';
import { authMiddleware } from './middleware/auth';
import cors from 'cors';
import { errorMiddleware } from './middleware/error';

const app = express();
app.use(express.json());

app.use(cors({
  origin: /localhost/,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}))

initDb();

app.use('/api/users', observabilityMiddleware, errorMiddleware, userRoutes);
app.use('/api/workouts', authMiddleware, observabilityMiddleware, errorMiddleware, workoutRoutes);
app.use('/api/exercices', authMiddleware, observabilityMiddleware, errorMiddleware, exerciceRoutes);
app.use('/api/muscle-groups', authMiddleware, observabilityMiddleware, errorMiddleware, muscleGroupRoutes);
app.use('/api/exercise-muscles', authMiddleware, observabilityMiddleware, errorMiddleware, exerciseMuscleRoutes);
app.use('/api/workout-exercises', authMiddleware, observabilityMiddleware, errorMiddleware, workoutExerciseRoutes);
app.use('/api/session-sets', authMiddleware, observabilityMiddleware, errorMiddleware, sessionSetRoutes);
app.use('/api/training-sessions', authMiddleware, observabilityMiddleware, errorMiddleware, trainingSessionRoutes);

const PORT = process.env.PORT;
app.listen(PORT, () => Logger.info(`Server running on ${PORT}`));