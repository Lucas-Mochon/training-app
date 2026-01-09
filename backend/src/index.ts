import express from 'express';
import userRoutes from './routes/user.routes';
import { initDb } from './models/index';
import { Logger } from './common/logger';
import { observabilityMiddleware } from './middleware/observability';

const app = express();
app.use(express.json());

initDb();

app.use('/api/users', observabilityMiddleware, userRoutes);


const PORT = process.env.PORT;
app.listen(PORT, () => Logger.info(`Server running on ${PORT}`));