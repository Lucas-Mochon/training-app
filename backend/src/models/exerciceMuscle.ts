import { DataTypes, Model, Optional } from 'sequelize';
import { sequelize } from '../config/database';
import { ExerciseMuscleRole } from '../enum/exercie-muscle-goal.enum';

interface ExerciseMuscleAttributes {
  id: string;
  role: ExerciseMuscleRole;
  exerciseId: string;
  muscleGroupId: number;
}

interface ExerciseMuscleCreationAttributes extends Optional<ExerciseMuscleAttributes, 'id'> {}

class ExerciseMuscle extends Model<ExerciseMuscleAttributes, ExerciseMuscleCreationAttributes> implements ExerciseMuscleAttributes {
  public id!: string;
  public role!: ExerciseMuscleRole;
  public exerciseId!: string;
  public muscleGroupId!: number;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

ExerciseMuscle.init(
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
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
