import { DataTypes, Model, Optional } from 'sequelize';
import { sequelize } from '../config/database';

interface WorkoutExerciseAttributes {
  id: number;
  sets: number;
  reps: string;
  rest_seconds: number;
  order_index: number;
  workoutId: string;
  exerciseId: string;
}

export interface WorkoutExerciseCreationAttributes extends Optional<WorkoutExerciseAttributes, 'id'> {}

class WorkoutExercise extends Model<WorkoutExerciseAttributes, WorkoutExerciseCreationAttributes> implements WorkoutExerciseAttributes {
  id!: number;
  sets!: number;
  reps!: string;
  rest_seconds!: number;
  order_index!: number;
  workoutId!: string;
  exerciseId!: string;

  readonly createdAt!: Date;
  readonly updatedAt!: Date;
}

WorkoutExercise.init(
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true
    },
    sets: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    reps: {
      type: DataTypes.STRING,
      allowNull: false
    },
    rest_seconds: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    order_index: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    workoutId: {
      type: DataTypes.UUID,
      allowNull: false
    },
    exerciseId: {
      type: DataTypes.UUID,
      allowNull: false
    }
  },
  {
    sequelize,
    tableName: 'WorkoutExercises',
    timestamps: false
  }
);

export default WorkoutExercise;
