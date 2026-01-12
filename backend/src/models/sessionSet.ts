import { DataTypes, Model, Optional } from 'sequelize';
import { sequelize } from '../config/database';

interface SessionSetAttributes {
  id: number;
  set_number: number;
  reps: number;
  weight: number;
  trainingSessionId: string;
  exerciseId: number;
}

export interface SessionSetCreationAttributes extends Optional<SessionSetAttributes, 'id'> {}

class SessionSet extends Model<SessionSetAttributes, SessionSetCreationAttributes> implements SessionSetAttributes {
  id!: number;
  set_number!: number;
  reps!: number;
  weight!: number;
  trainingSessionId!: string;
  exerciseId!: number;

  readonly createdAt!: Date;
  readonly updatedAt!: Date;
}

SessionSet.init(
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
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
    exerciseId: {
      type: DataTypes.INTEGER,
      allowNull: false
    }
  },
  {
    sequelize,
    tableName: 'SessionSets',
    timestamps: true
  }
);

export default SessionSet;
