import express from 'express';
import userRoutes from './routes/user.routes';
import { initDb } from './models/index';

const app = express();
app.use(express.json());

initDb();

app.use('/api/users', userRoutes);


const PORT = process.env.PORT;
app.listen(PORT, () => console.log(`Server running on ${PORT}`));