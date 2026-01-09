import { DataTypes, Model, Optional } from 'sequelize';
const sequelize = require('../index')
import { WorkoutGoal } from '../enum/workout-goal.enum';

interface WorkoutAttributes {
  id: string;
  goal: WorkoutGoal;
  duration: number;
}

interface WorkoutCreationAttributes extends Optional<WorkoutAttributes, 'id'> {}

class Workout extends Model<WorkoutAttributes, WorkoutCreationAttributes> implements WorkoutAttributes {
  public id!: string;
  public goal!: WorkoutGoal;
  public duration!: number;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

Workout.init(
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    goal: {
      type: DataTypes.ENUM(...Object.values(WorkoutGoal)),
      allowNull: false
    },
    duration: {
      type: DataTypes.INTEGER,
      allowNull: false
    }
  },
  {
    sequelize,
    tableName: 'Workouts',
    timestamps: true
  }
);

export default Workout;
