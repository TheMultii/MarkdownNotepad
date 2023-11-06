import { UserService } from './user.service';
import {
  Body,
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
  ApiBadRequestResponse,
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
import { Error400, Error404, Error500 } from 'src/http_response_models';
import { JwtPayload, decodeJwt } from 'src/auth/jwt.decode';
import { UUIDDto } from 'src/dto';
import { validate } from 'class-validator';
import { PrismaService } from 'src/prisma.service';
import { User, UserBasic, UserPasswordless } from './user.model';
import { UserOptionalDto } from './dto/user.optional.dto';

@Controller('users')
@ApiBearerAuth()
@ApiTags('user')
export class UserController {
  constructor(
    private readonly userService: UserService,
    private readonly prismaService: PrismaService,
    private readonly jwtService: JwtService,
  ) {}

  @Get('me')
  @ApiOperation({ summary: 'Get user by token' })
  @UseGuards(JwtAuthGuard)
  @ApiResponse({
    status: 200,
    description: 'Get user by token',
    type: UserPasswordless,
  })
  @ApiBadRequestResponse({ description: 'Bad Request', type: Error400 })
  @ApiNotFoundResponse({ description: 'User not found', type: Error404 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  async getUserByToken(
    @Req() request: Request,
    @Res() response: Response,
  ): Promise<any> {
    try {
      const decodedJWT = await decodeJwt(
        this.jwtService,
        request.headers.authorization,
      );

      const result: UserPasswordless = await this.userService.getUserByUsername(
        decodedJWT.username,
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

  @Get(':id')
  @ApiOperation({ summary: 'Get user by id' })
  @UseGuards(JwtAuthGuard)
  @ApiResponse({
    status: 200,
    description: 'Get user by id',
    type: UserPasswordless,
  })
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

      const result: UserPasswordless = await this.userService.getUserById(
        uuidDTO.id,
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
  @ApiResponse({
    status: 200,
    description: 'Update user',
    type: UserPasswordless,
  })
  @ApiBadRequestResponse({ description: 'Bad Request', type: Error400 })
  @ApiNotFoundResponse({ description: 'User not found', type: Error404 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  async updateUser(
    @Req() request: Request,
    @Res() response: Response,
    @Body() updateUserDTO: UserOptionalDto,
  ): Promise<any> {
    try {
      let decodedJWT: JwtPayload;
      try {
        decodedJWT = await decodeJwt(
          this.jwtService,
          request.headers.authorization,
        );
      } catch (error) {
        return response.status(400).json({ message: 'Bad Request' });
      }

      const user: UserBasic = await this.userService.getUserByUsernameBasic(
        decodedJWT.username,
      );

      if (!user) {
        return response.status(404).json({ message: 'User not found' });
      }

      if (Object.keys(updateUserDTO).length === 0) {
        return response.status(400).json({ message: 'Bad Request' });
      }

      const errors = await validate(updateUserDTO);
      if (errors.length > 0) {
        return response.status(400).json({ message: 'Bad Request' });
      }

      const userEditModel = new User();
      if (updateUserDTO.username) {
        userEditModel.username = updateUserDTO.username;
      }
      if (updateUserDTO.email) {
        userEditModel.email = updateUserDTO.email;
      }
      if (updateUserDTO.name) {
        userEditModel.name = updateUserDTO.name;
      }
      if (updateUserDTO.surname) {
        userEditModel.surname = updateUserDTO.surname;
      }
      if (updateUserDTO.password) {
        userEditModel.password = updateUserDTO.password;
      }

      const result = this.prismaService.user.update({
        where: {
          username: decodedJWT.username,
        },
        data: userEditModel,
      });

      if (!result) {
        return response
          .status(400)
          .json({ message: 'Error while updating the user' });
      }

      return response.status(200).json({
        message: 'User updated successfully',
      });
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
  @ApiNotFoundResponse({ description: 'User not found', type: Error404 })
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

      const user: UserBasic = await this.userService.getUserByUsernameBasic(
        decodedJWT.username,
      );

      if (!user) {
        return response.status(404).json({ message: 'User not found' });
      }

      if (user.username !== decodedJWT.username) {
        return response
          .status(403)
          .json({ message: "You cannot remove someone else's account" });
      }

      const del = this.userService.deleteUserByUsername(decodedJWT.username);

      if (!del) {
        return response
          .status(400)
          .json({ message: 'Error while deleting the user' });
      }

      return response.status(200).json({
        message: 'Account deleted successfully',
      });
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }
}
