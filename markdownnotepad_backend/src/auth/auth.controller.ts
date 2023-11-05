import { Body, Controller, Post, Req, Res } from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login-user.dto';
import {
  ApiBadRequestResponse,
  ApiBody,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { Request, Response } from 'express';
import { RegisterDto } from './dto/register-user.dto';
import { validate } from '@nestjs/class-validator';
import { Error400 } from 'src/http_response_models/error400.model';

@Controller('auth')
@ApiTags('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  @Throttle({ default: { limit: 10, ttl: 60000 } })
  @ApiOperation({ summary: 'Login a user' })
  @ApiBody({ type: LoginDto })
  @ApiOkResponse({ description: 'User successfully logged in' })
  @ApiBadRequestResponse({ description: 'Bad Request', type: Error400 })
  async login(
    @Req() request: Request,
    @Res() response: Response,
    @Body() loginDto: LoginDto,
  ) {
    try {
      const validationErrors = await validate(loginDto);
      if (validationErrors.length > 0) {
        return response.status(400).send({
          message: validationErrors,
        });
      }

      return response.status(200).send(await this.authService.login(loginDto));
    } catch (error) {
      return response.status(400).send({
        message: error.message,
      });
    }
  }

  @Post('register')
  @Throttle({ default: { limit: 10, ttl: 60000 } })
  @ApiOperation({ summary: 'Create a new user' })
  @ApiBody({ type: RegisterDto })
  @ApiCreatedResponse({ description: 'User successfully registered' })
  @ApiBadRequestResponse({ description: 'Bad Request', type: Error400 })
  async register(
    @Req() request: Request,
    @Res() response: Response,
    @Body() registerDto: RegisterDto,
  ) {
    try {
      const validationErrors = await validate(registerDto);
      if (validationErrors.length > 0) {
        return response.status(400).send({
          message: validationErrors,
        });
      }

      return response
        .status(201)
        .send(await this.authService.register(registerDto));
    } catch (error) {
      return response.status(400).send({
        message: error.message,
      });
    }
  }
}
