import { ConflictException, Injectable } from '@nestjs/common';
import { User } from '@prisma/client';
import { UserBasic, User as UserModel, UserPasswordless } from './user.model';
import { PrismaService } from 'src/prisma.service';

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) {}

  async getAllUsers(): Promise<UserPasswordless[]> {
    return await this.prisma.user.findMany({
      select: {
        id: true,
        username: true,
        email: true,
        bio: true,
        name: true,
        surname: true,
        createdAt: true,
        updatedAt: true,
        notes: {
          select: {
            id: true,
            title: true,
            createdAt: true,
            updatedAt: true,
            shared: true,
          },
        },
        tags: true,
        catalogs: true,
      },
    });
  }

  async getUserById(id: string): Promise<UserPasswordless | null> {
    return await this.prisma.user.findUnique({
      where: {
        id,
      },
      select: {
        id: true,
        username: true,
        email: true,
        bio: true,
        name: true,
        surname: true,
        createdAt: true,
        updatedAt: true,
        notes: {
          select: {
            id: true,
            title: true,
            createdAt: true,
            updatedAt: true,
            shared: true,
          },
        },
        tags: true,
        catalogs: true,
      },
    });
  }

  async getUserByUsernameBasic(username: string): Promise<UserBasic | null> {
    return await this.prisma.user.findUnique({
      where: {
        username,
      },
      select: {
        id: true,
        username: true,
      },
    });
  }

  async getUserByUsername(username: string): Promise<UserPasswordless> {
    return await this.prisma.user.findUnique({
      where: {
        username,
      },
      select: {
        id: true,
        username: true,
        email: true,
        bio: true,
        name: true,
        surname: true,
        createdAt: true,
        updatedAt: true,
        notes: {
          select: {
            id: true,
            title: true,
            createdAt: true,
            updatedAt: true,
            shared: true,
          },
        },
        tags: true,
        catalogs: true,
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

  async deleteUserByUsername(username: string): Promise<User> {
    await this.prisma.noteTag.deleteMany({
      where: {
        owner: {
          username: username,
        },
      },
    });

    await this.prisma.note.deleteMany({
      where: {
        author: {
          username: username,
        },
      },
    });

    return await this.prisma.user.delete({
      where: {
        username: username,
      },
    });
  }
}
