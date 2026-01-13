import User from '../models/user';
import bcrypt from 'bcrypt';

export class UserRepository {
  async create(userData: any): Promise<User> {
    const hashedPassword = await bcrypt.hash(userData.password, 10);
    return User.create({ ...userData, password_hash: hashedPassword });
  }

  async findByEmail(email: string): Promise<User | null> {
    return User.findOne({ where: { email } });
  }

  async findById(id: string): Promise<User | null> {
    return User.findByPk(id);
  }

  async update(id: string, data: any): Promise<User | null> {
    User.update(data, { where: { id } });
    return User.findByPk(id);
  }

  async updateRefreshToken(id: string, refreshToken: string | null): Promise<[number]> {
    return User.update({ refreshToken }, { where: { id } });
  }

  async delete(id: string): Promise<number> {
    return User.destroy({ where: { id } });
  }
}
