import { Injectable, NotFoundException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from 'src/prisma.service';
import { UserService } from 'src/user/user.service';
import { LoginDto } from './dto/login-user.dto';
import * as bcrypt from 'bcrypt';
import { User } from 'src/user/user.model';
import { RegisterDto } from './dto/register-user.dto';

@Injectable()
export class AuthService {
  constructor(
    private readonly prismaService: PrismaService,
    private readonly jwtService: JwtService,
    private readonly userService: UserService,
  ) {}

  async login(loginDto: LoginDto): Promise<{ access_token: string }> {
    const { username, password } = loginDto;

    const user = await this.prismaService.user.findUnique({
      where: {
        username: username,
      },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    if (!(await bcrypt.compare(password, user.password))) {
      throw new NotFoundException('Wrong password');
    }

    return {
      access_token: this.jwtService.sign({ username: user.username }),
    };
  }

  async register(registerDto: RegisterDto): Promise<{ access_token: string }> {
    const userToCreate = new User();
    userToCreate.username = registerDto.username;
    userToCreate.email = registerDto.email;
    userToCreate.password = await bcrypt.hash(registerDto.password, 10);

    const user = await this.userService.createUser(userToCreate);

    return {
      access_token: this.jwtService.sign({ username: user.username }),
    };
  }
}
