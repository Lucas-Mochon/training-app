import { UserRepository } from '../repository/user.repository';
import { RegisterDto, LoginDto, EditUserDto, AuthResponse } from '../dto/user.dto';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';
import User from '../models/user';
import { Logger } from '../common/logger';
import { UserRoleRepository } from '../repository/user-roles.repository';
import { UserRoleEnum } from '../enum/user-roles-enum';

export class UserService {
  private repo = new UserRepository();
  private roleRepo = new UserRoleRepository();

  async register(data: RegisterDto): Promise<AuthResponse> {
    const existing = await this.repo.findByEmail(data.email);
    if (existing) throw new Error('Email already used');
    const user = await this.repo.create(data);
    await this.roleRepo.create(user.get('id'), UserRoleEnum.USER);
    return this.generateTokens(user);
  }

  async login(data: LoginDto): Promise <AuthResponse> {
    const user = await this.repo.findByEmail(data.email);
    if (!user) throw new Error('Invalid credentials');
    const match = await bcrypt.compare(data.password, user.get('password_hash'));
    if (!match) throw new Error('Invalid credentials');
    return this.generateTokens(user);
  }

  async refresh(refreshToken: string): Promise<AuthResponse> {
    const user = await User.findOne({ where: { refreshToken } });
    if (!user) throw new Error('Invalid refresh token');
    return this.generateTokens(user);
  }

  async edit(userId: string, data: EditUserDto): Promise<User | null> {
    if (data.password) {
      data.password = await bcrypt.hash(data.password, 10);
      delete data.password;
    }
    await this.repo.update(userId, data);
    return this.repo.findById(userId);
  }

  async delete(userId: string): Promise<number> {
    await this.roleRepo.deleteByUserId(userId);
    return this.repo.delete(userId);
  }

  async getMe(userId: string): Promise<User | null> {
    return this.repo.findById(userId);
  }

  async assignRole(userId: string, role: UserRoleEnum): Promise<void> {
    const hasRole = await this.roleRepo.hasRole(userId, role);
    if (!hasRole) {
      await this.roleRepo.deleteByUserId(userId);
      await this.roleRepo.create(userId, role);
      Logger.info(`Assigned role ${role} to user ${userId}`);
    }
  }

  async isAdmin(userId: string): Promise<boolean> {
    return this.roleRepo.hasRole(userId, UserRoleEnum.ADMIN);
  }

  async generateTokens(user: User) {
    const roles = await this.roleRepo.findByUserId(user.get('id'));
    const roleNames = roles.map(r => r.get('name'));

    const payload = { 
      userId: user.get('id'),
      roles: roleNames 
    };
    
    const accessToken = jwt.sign(payload, process.env.JWT_SECRET!, { expiresIn: '30m' });
    const refreshToken = jwt.sign(payload, process.env.JWT_REFRESH_SECRET!, { expiresIn: '7d' });

    const userRefresh = await this.repo.updateRefreshToken(user.get('id'), refreshToken);
    if (userRefresh != null) user = userRefresh;
    
    Logger.info(`Generated tokens for user ${user.get('email')} with roles: ${roleNames.join(', ')}`);

    return { accessToken, user };
  }
}
