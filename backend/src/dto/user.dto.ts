import { UserGoal } from "../enum/user-goal.enum";
import { UserLevel } from "../enum/user-level.enum";
import User from "../models/user";

export interface RegisterDto {
  email: string;
  password: string;
  level: UserLevel;
  goal: UserGoal;
}

export interface LoginDto {
  email: string;
  password: string;
}

export interface EditUserDto {
  email?: string;
  password?: string;
  level?: UserLevel;
  goal?: UserGoal;
}

export interface AuthResponse {
  accessToken: string;
  user: User;
}
