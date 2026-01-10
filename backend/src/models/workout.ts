import { DataTypes, Model, Optional } from 'sequelize';
import { sequelize } from '../config/database';
import { WorkoutGoal } from '../enum/workout-goal.enum';

export interface WorkoutAttributes {
  id: string;
  goal: WorkoutGoal;
  duration: number;
}

export interface WorkoutCreationAttributes extends Optional<WorkoutAttributes, 'id'> {}

class Workout extends Model<WorkoutAttributes, WorkoutCreationAttributes> implements WorkoutAttributes {
  id!: string;
  goal!: WorkoutGoal;
  duration!: number;

  readonly createdAt!: Date;
  readonly updatedAt!: Date;
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
