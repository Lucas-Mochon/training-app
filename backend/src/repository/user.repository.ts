import User from '../models/user';
import bcrypt from 'bcrypt';

export class UserRepository {
  async create(userData: any) {
    const hashedPassword = await bcrypt.hash(userData.password, 10);
    return User.create({ ...userData, password_hash: hashedPassword });
  }

  async findByEmail(email: string) {
    return User.findOne({ where: { email } });
  }

  async findById(id: string) {
    return User.findByPk(id);
  }

  async update(id: string, data: any) {
    return User.update(data, { where: { id } });
  }

  async delete(id: string) {
    return User.destroy({ where: { id } });
  }
}
