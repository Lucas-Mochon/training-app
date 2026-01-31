import User from '../models/user';
import bcrypt from 'bcrypt';
import UserRole from '../models/userRoles';

export class UserRepository {
  
  async create(userData: any): Promise<User> {
    const hashedPassword = await bcrypt.hash(userData.password, 10);
    return User.create({ ...userData, password_hash: hashedPassword });
  }

  private async attachRole(user: User): Promise<User> {
    const userRole = await UserRole.findOne({ where: { userId: user.id } });
    if (userRole) {
      // @ts-ignore
      user.dataValues.role = userRole.get('name');
    }
    return user;
  }

  async findByEmail(email: string): Promise<User | null> {
    const user = await User.findOne({ where: { email } });
    if (!user) return null;
    return this.attachRole(user);
  }

  async findById(id: string): Promise<User | null> {
    const user = await User.findByPk(id);
    if (!user) return null;
    return this.attachRole(user);
  }

  async update(id: string, data: any): Promise<User | null> {
    await User.update(data, { where: { id } });
    const user = await User.findByPk(id);
    if (!user) return null;
    return this.attachRole(user);
  }

  async updateRefreshToken(id: string, refreshToken: string | null): Promise<User | null> {
    await User.update({ refreshToken }, { where: { id } });
    const user = await User.findByPk(id);
    if (!user) return null;
    return this.attachRole(user);
  }

  async delete(id: string): Promise<number> {
    return User.destroy({ where: { id } });
  }
}
