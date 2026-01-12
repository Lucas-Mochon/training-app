import { DataTypes, Model, Optional } from 'sequelize';
import { sequelize } from '../config/database';

interface MuscleGroupAttributes {
  id: number;
  name: string;
}

export interface MuscleGroupCreationAttributes extends Optional<MuscleGroupAttributes, 'id'> {}

class MuscleGroup extends Model<MuscleGroupAttributes, MuscleGroupCreationAttributes> implements MuscleGroupAttributes {
  id!: number;
  name!: string;

  readonly createdAt!: Date;
  readonly updatedAt!: Date;
}

MuscleGroup.init(
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true
    }
  },
  {
    sequelize,
    tableName: 'MuscleGroups',
    timestamps: false
  }
);

export default MuscleGroup;
