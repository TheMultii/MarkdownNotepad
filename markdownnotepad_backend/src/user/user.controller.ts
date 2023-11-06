import { User } from '@prisma/client';
import { UserService } from './user.service';
import {
  Controller,
  Delete,
  Get,
  Param,
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
import { decodeJwt } from 'src/auth/jwt.decode';
import { UUIDDto } from 'src/dto';
import { validate } from 'class-validator';

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
    @Param('id') id: string,
  ): Promise<any> {
    try {
      const uuidDTO = new UUIDDto(id);
      const errors = await validate(uuidDTO);
      if (errors.length > 0) {
        return response.status(400).json({ message: 'Bad Request' });
      }

      const result: User = await this.userService.getUserById(uuidDTO.id);

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
      const decodedJWT = await decodeJwt(
        this.jwtService,
        request.headers.authorization,
      );

      // TODO: complete the request
      return response.status(200).json(decodedJWT);
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
      const decodedJWT = await decodeJwt(
        this.jwtService,
        request.headers.authorization,
      );

      // TODO: complete the request
      return response.status(200).json(decodedJWT);
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }
}
