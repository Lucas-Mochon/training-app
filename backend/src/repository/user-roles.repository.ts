import { UserRoleEnum } from "../enum/user-roles-enum";
import UserRole from "../models/userRoles";


export class UserRoleRepository {
  async create(userId: string, role: UserRoleEnum): Promise<UserRole> {
    return UserRole.create({ userId, name: role });
  }

  async findByUserId(userId: string): Promise<UserRole[]> {
    return UserRole.findAll({ where: { userId } });
  }

  async hasRole(userId: string, role: UserRoleEnum): Promise<boolean> {
    const userRole = await this.findByUserIdAndRole(userId, role);
    return !!userRole;
  }

  async findByUserIdAndRole(userId: string, role: UserRoleEnum): Promise<UserRole | null> {
    return UserRole.findOne({ where: { userId, name: role } });
  }

  async deleteByUserId(userId: string): Promise<number> {
    return UserRole.destroy({ where: { userId } });
  }
}
