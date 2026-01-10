import { DataTypes, Model, Optional } from 'sequelize';
import { sequelize } from '../config/database';

interface TrainingSessionAttributes {
  id: string;
  performed_at: Date;
  duration: number;
  feeling: number;
  userId: string;
}

interface TrainingSessionCreationAttributes extends Optional<TrainingSessionAttributes, 'id' | 'performed_at'> {}

class TrainingSession extends Model<TrainingSessionAttributes, TrainingSessionCreationAttributes> implements TrainingSessionAttributes {
  id!: string;
  performed_at!: Date;
  duration!: number;
  feeling!: number;
  userId!: string;

  readonly createdAt!: Date;
  readonly updatedAt!: Date;
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
    userId: {
      type: DataTypes.UUID,
      allowNull: false
    }
  },
  {
    sequelize,
    tableName: 'TrainingSessions',
    timestamps: false
  }
);

export default TrainingSession;
