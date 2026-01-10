import { DataTypes, Model, Optional } from 'sequelize';
import { sequelize } from '../config/database';

interface WorkoutExerciseAttributes {

  sets: number;
  reps: string;
  rest_seconds: number;
  order_index: number;
  workoutId: string;
  exerciseId: string;
}

interface WorkoutExerciseCreationAttributes extends WorkoutExerciseAttributes {}

class WorkoutExercise extends Model<WorkoutExerciseAttributes, WorkoutExerciseCreationAttributes> implements WorkoutExerciseAttributes {
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
