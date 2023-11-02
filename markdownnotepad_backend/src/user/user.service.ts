import { ConflictException, Injectable } from '@nestjs/common';
import { User } from '@prisma/client';
import { User as UserModel } from './user.model';
import { PrismaService } from 'src/prisma.service';

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) {}

  async getAllUsers(): Promise<User[]> {
    return await this.prisma.user.findMany({
      include: {
        posts: true,
        tags: true,
      },
    });
  }

  async getUserById(id: string): Promise<User> {
    return await this.prisma.user.findUnique({
      where: {
        id,
      },
      include: {
        posts: true,
        tags: true,
      },
    });
  }

  async getUserByUsername(username: string): Promise<User> {
    return await this.prisma.user.findUnique({
      where: {
        username,
      },
      include: {
        posts: true,
        tags: true,
      },
    });
  }

  async createUser(user: UserModel): Promise<User> {
    const { username, email } = user;

    const userExists = await this.prisma.user.findFirst({
      where: {
        OR: [{ username }, { email }],
      },
    });

    if (userExists) {
      throw new ConflictException('User already exists');
    }

    return await this.prisma.user.create({
      data: user,
    });
  }
}
