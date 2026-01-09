import { UserRepository } from '../repository/user.repository';
import { RegisterDto, LoginDto, EditUserDto } from '../dto/user.dto';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';
import User from '../models/user';
import { Logger } from '../common/logger';

export class UserService {
  private repo = new UserRepository();

  async register(data: RegisterDto) {
    const existing = await this.repo.findByEmail(data.email);
    if (existing) throw new Error('Email already used');
    const user = await this.repo.create(data);
    return this.generateTokens(user);
  }

  async login(data: LoginDto) {
    const user = await this.repo.findByEmail(data.email);
    if (!user) throw new Error('Invalid credentials');
    const match = await bcrypt.compare(data.password, user.password_hash);
    if (!match) throw new Error('Invalid credentials');
    return this.generateTokens(user);
  }

  async refresh(refreshToken: string) {
    const user = await User.findOne({ where: { refreshToken } });
    if (!user) throw new Error('Invalid refresh token');
    return this.generateTokens(user);
  }

  async edit(userId: string, data: EditUserDto) {
    if (data.password) {
      data.password = await bcrypt.hash(data.password, 10);
      delete data.password;
    }
    await this.repo.update(userId, data);
    return this.repo.findById(userId);
  }

  async delete(userId: string) {
    return this.repo.delete(userId);
  }

  async getMe(userId: string) {
    return this.repo.findById(userId);
  }

  private generateTokens(user: User) {
    const payload = { userId: user.get('id') };
    const accessToken = jwt.sign(payload, process.env.JWT_SECRET!, { expiresIn: '15m' });
    const refreshToken = jwt.sign(payload, process.env.JWT_REFRESH_SECRET!, { expiresIn: '7d' });

    user.update({ refreshToken });
    Logger.info(`Generated tokens for user ${user.email}`);

    return { accessToken, user };
  }
}
