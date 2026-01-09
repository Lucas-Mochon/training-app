import { DataTypes, Model, Optional } from 'sequelize';
import { UserLevel } from '../enum/user-level.enum';
import { UserGoal } from '../enum/user-goal.enum';
const sequelize = require('../index')

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
  public id!: string;
  public email!: string;
  public password_hash!: string;
  public level!: UserLevel;
  public goal!:  UserGoal;
  public refreshToken?: string | null;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
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
