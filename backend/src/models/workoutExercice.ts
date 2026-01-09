import { DataTypes, Model, Optional } from 'sequelize';
const sequelize = require('../index')

interface WorkoutExerciseAttributes {
  id: string;
  sets: number;
  reps: string;
  rest_seconds: number;
  order_index: number;
  workoutId: string;
  exerciseId: string;
}

interface WorkoutExerciseCreationAttributes extends Optional<WorkoutExerciseAttributes, 'id'> {}

class WorkoutExercise extends Model<WorkoutExerciseAttributes, WorkoutExerciseCreationAttributes> implements WorkoutExerciseAttributes {
  public id!: string;
  public sets!: number;
  public reps!: string;
  public rest_seconds!: number;
  public order_index!: number;
  public workoutId!: string;
  public exerciseId!: string;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

WorkoutExercise.init(
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
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
