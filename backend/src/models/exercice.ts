import { DataTypes, Model, Optional } from 'sequelize';
import { sequelize } from '../config/database';
import { ExerciseDifficulty } from '../enum/exercice-difficulty.enum';
import { ExerciseEquipment } from '../enum/exercice-equipment.enum';

interface ExerciseAttributes {
  id: number;
  name: string;
  description?: string | null;
  difficulty?: ExerciseDifficulty | null;
  is_compound: boolean;
  equipment?: ExerciseEquipment | null;
}

interface ExerciseCreationAttributes extends Optional<ExerciseAttributes, 'id' | 'description' | 'difficulty' | 'equipment'> {}

class Exercise extends Model<ExerciseAttributes, ExerciseCreationAttributes> implements ExerciseAttributes {
  id!: number;
  name!: string;
  description?: string | null;
  difficulty?: ExerciseDifficulty | null;
  is_compound!: boolean;
  equipment?: ExerciseEquipment | null;

  readonly createdAt!: Date;
  readonly updatedAt!: Date;
}

Exercise.init(
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    difficulty: {
      type: DataTypes.ENUM(...Object.values(ExerciseDifficulty)),
      allowNull: true
    },
    is_compound: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
      allowNull: false
    },
    equipment: {
      type: DataTypes.ENUM(...Object.values(ExerciseEquipment)),
      allowNull: true
    }
  },
  {
    sequelize,
    tableName: 'Exercises',
    timestamps: true
  }
);

export default Exercise;
