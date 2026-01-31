import { DataTypes, Model, Optional } from 'sequelize';
import { sequelize } from '../config/database';
import { UserRoleEnum } from '../enum/user-roles-enum';

interface UserRoleAttributes {
  id: string;
  userId: string;
  name: UserRoleEnum;
}

interface UserRoleCreationAttributes extends Optional<UserRoleAttributes, 'id'> {}

class UserRole extends Model<UserRoleAttributes, UserRoleCreationAttributes> implements UserRoleAttributes {
  declare id: string;
  declare userId: string;
  declare name: UserRoleEnum;

  declare readonly createdAt: Date;
  declare readonly updatedAt: Date;
}

UserRole.init(
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    userId: {
      type: DataTypes.UUID,
      allowNull: false,
      references: {
        model: 'Users',
        key: 'id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
    name: {
      type: DataTypes.ENUM(...Object.values(UserRoleEnum)),
      allowNull: false,
      defaultValue: UserRoleEnum.USER,
    },
  },
  {
    sequelize,
    tableName: 'UserRoles',
    timestamps: true,
  }
);

export default UserRole;
