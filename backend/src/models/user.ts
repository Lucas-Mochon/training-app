import { DataTypes, Model, Optional } from 'sequelize';
import { UserLevel } from '../enum/user-level.enum';
import { UserGoal } from '../enum/user-goal.enum';
import { sequelize } from '../config/database';

interface UserAttributes {
  id: string;
  email: string;
  password_hash: string;
  level: UserLevel;
  goal: UserGoal;
  refreshToken?: string | null;
}

interface UserCreationAttributes extends Optional<UserAttributes, 'id' | 'refreshToken'> {}

class User extends Model<UserAttributes, UserCreationAttributes> implements UserAttributes {
  declare id: string;
  declare email: string;
  declare password_hash: string;
  declare level: UserLevel;
  declare goal:  UserGoal;
  declare refreshToken: string | null;

  declare readonly createdAt: Date;
  declare readonly updatedAt: Date;
}

User.init(
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true
    },
    password_hash: {
      type: DataTypes.STRING,
      allowNull: false
    },
    level: {
      type: DataTypes.ENUM(...Object.values(UserLevel)),
      allowNull: false
    },
    goal: {
      type: DataTypes.ENUM(...Object.values(UserGoal)),
      allowNull: false
    },
    refreshToken: {
      type: DataTypes.STRING,
      allowNull: true
    }
  },
  {
    sequelize,
    tableName: 'Users',
    timestamps: true
  }
);

export default User;
