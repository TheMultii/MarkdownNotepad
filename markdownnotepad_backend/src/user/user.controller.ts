import { User } from '@prisma/client';
import { UserService } from './user.service';
import {
  Controller,
  Delete,
  Get,
  Patch,
  Req,
  Res,
  UseGuards,
} from '@nestjs/common';
import { Request, Response } from 'express';
import {
  ApiBearerAuth,
  ApiInternalServerErrorResponse,
  ApiNotFoundResponse,
  ApiOperation,
  ApiParam,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from 'src/auth/auth.guard';
import { JwtService } from '@nestjs/jwt';
import { Error404, Error500 } from 'src/http_response_models';

@Controller('users')
@ApiBearerAuth()
@ApiTags('user')
export class UserController {
  constructor(
    private readonly userService: UserService,
    private readonly jwtService: JwtService,
  ) {}

  @Get(':id')
  @ApiOperation({ summary: 'Get user by id' })
  @UseGuards(JwtAuthGuard)
  @ApiResponse({ status: 200, description: 'Get user by id' })
  @ApiNotFoundResponse({ description: 'User not found', type: Error404 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
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
  @ApiOperation({ summary: 'Update user' })
  @UseGuards(JwtAuthGuard)
  @ApiResponse({ status: 200, description: 'Update user' })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
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

  @Delete()
  @ApiOperation({ summary: 'Delete account' })
  @UseGuards(JwtAuthGuard)
  @ApiResponse({ status: 200, description: 'Delete account' })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  async deleteUser(
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
