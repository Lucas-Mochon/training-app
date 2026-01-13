import { DataTypes, Model, Optional } from 'sequelize';
import { sequelize } from '../config/database';

interface TrainingSessionAttributes {
  id: string;
  performed_at: Date;
  duration: number;
  feeling: number;
  workoutId: string;
  userId: string;
}

export interface TrainingSessionCreationAttributes extends Optional<TrainingSessionAttributes, 'id' | 'performed_at'> {}

class TrainingSession extends Model<TrainingSessionAttributes, TrainingSessionCreationAttributes> implements TrainingSessionAttributes {
  declare id: string;
  declare performed_at: Date;
  declare duration: number;
  declare feeling: number;
  declare workoutId: string;
  declare userId: string;

  declare readonly createdAt: Date;
  declare readonly updatedAt: Date;
}

TrainingSession.init(
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    performed_at: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW
    },
    duration: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    feeling: {
      type: DataTypes.INTEGER,
      allowNull: false,
      validate: {
        min: 1,
        max: 5
      }
    },
    workoutId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: 'workoutId'
    },
    userId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: 'userId'
    }
  },
  {
    sequelize,
    tableName: 'TrainingSessions',
    timestamps: false
  }
);

export default TrainingSession;
