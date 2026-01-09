import { DataTypes, Model, Optional } from 'sequelize';
import { sequelize } from '../config/database';

interface SessionSetAttributes {
  id: string;
  set_number: number;
  reps: number;
  weight: number;
  trainingSessionId: string;
  workoutExerciseId: string;
}

interface SessionSetCreationAttributes extends Optional<SessionSetAttributes, 'id'> {}

class SessionSet extends Model<SessionSetAttributes, SessionSetCreationAttributes> implements SessionSetAttributes {
  public id!: string;
  public set_number!: number;
  public reps!: number;
  public weight!: number;
  public trainingSessionId!: string;
  public workoutExerciseId!: string;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

SessionSet.init(
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    set_number: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    reps: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    weight: {
      type: DataTypes.FLOAT,
      allowNull: false
    },
    trainingSessionId: {
      type: DataTypes.UUID,
      allowNull: false
    },
    workoutExerciseId: {
      type: DataTypes.UUID,
      allowNull: false
    }
  },
  {
    sequelize,
    tableName: 'SessionSets',
    timestamps: false
  }
);

export default SessionSet;
