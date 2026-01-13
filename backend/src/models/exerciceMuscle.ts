import { DataTypes, Model, Optional } from 'sequelize';
import { sequelize } from '../config/database';
import { ExerciseMuscleRole } from '../enum/exercie-muscle-goal.enum';

interface ExerciseMuscleAttributes {
  id: number;
  role: ExerciseMuscleRole;
  exerciseId: string;
  muscleGroupId: number;
}

export interface ExerciseMuscleCreationAttributes extends Optional<ExerciseMuscleAttributes, 'id'> {}

class ExerciseMuscle extends Model<ExerciseMuscleAttributes, ExerciseMuscleCreationAttributes> implements ExerciseMuscleAttributes {
  declare id: number;
  declare role: ExerciseMuscleRole;
  declare exerciseId: string;
  declare muscleGroupId: number;

  declare readonly createdAt: Date;
  declare readonly updatedAt: Date;
}

ExerciseMuscle.init(
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true
    },
    role: {
      type: DataTypes.ENUM(...Object.values(ExerciseMuscleRole)),
      allowNull: false
    },
    exerciseId: {
      type: DataTypes.UUID,
      allowNull: false
    },
    muscleGroupId: {
      type: DataTypes.INTEGER,
      allowNull: false
    }
  },
  {
    sequelize,
    tableName: 'ExerciseMuscles',
    timestamps: false
  }
);

export default ExerciseMuscle;
