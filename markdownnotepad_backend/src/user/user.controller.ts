import { User } from '@prisma/client';
import { UserService } from './user.service';
import { Controller, Get, Patch, Req, Res, UseGuards } from '@nestjs/common';
import { Request, Response } from 'express';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiParam,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from 'src/auth/auth.guard';
import { JwtService } from '@nestjs/jwt';

@Controller('users')
@ApiBearerAuth()
@ApiTags('user')
export class UserController {
  constructor(
    private readonly userService: UserService,
    private readonly jwtService: JwtService,
  ) {}

  @Get('getAllUsers')
  @ApiOperation({ summary: 'Get all users' })
  @UseGuards(JwtAuthGuard)
  @ApiResponse({ status: 200, description: 'Get all users' })
  @ApiResponse({ status: 500, description: 'Internal Server Error' })
  async getAllUsers(
    @Req() request: Request,
    @Res() response: Response,
  ): Promise<any> {
    try {
      const result: User[] = await this.userService.getAllUsers();
      return response.status(200).json(result);
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get user by id' })
  @UseGuards(JwtAuthGuard)
  @ApiResponse({ status: 200, description: 'Get user by id' })
  @ApiResponse({ status: 404, description: 'User not found' })
  @ApiResponse({ status: 500, description: 'Internal Server Error' })
  @ApiParam({ name: 'id', type: String })
  async getUserById(
    @Req() request: Request,
    @Res() response: Response,
  ): Promise<any> {
    try {
      const result: User = await this.userService.getUserById(
        request.params.id,
      );

      if (!result) {
        return response.status(404).json({ message: 'User not found' });
      }

      return response.status(200).json(result);
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }

  @Patch()
  @UseGuards(JwtAuthGuard)
  @ApiResponse({ status: 200, description: 'Update user' })
  @ApiResponse({ status: 500, description: 'Internal Server Error' })
  async updateUser(
    @Req() request: Request,
    @Res() response: Response,
  ): Promise<any> {
    try {
      const token = request.headers.authorization.split(' ')[1];
      const username = this.jwtService.decode(token);
      return response.status(200).json(username);
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }
}
