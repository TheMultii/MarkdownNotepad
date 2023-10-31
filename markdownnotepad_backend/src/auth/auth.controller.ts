import { Body, Controller, Post, Req, Res } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login-user.dto';
import { ApiBody, ApiResponse, ApiTags } from '@nestjs/swagger';
import { Request, Response } from 'express';
import { RegisterDto } from './dto/register-user.dto';
import { validate } from '@nestjs/class-validator';

@Controller('auth')
@ApiTags('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  @ApiBody({ type: LoginDto })
  @ApiResponse({ status: 200, description: 'User successfully logged in.' })
  @ApiResponse({ status: 400, description: 'Bad request.' })
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
  @ApiBody({ type: RegisterDto })
  @ApiResponse({ status: 201, description: 'User successfully registered.' })
  @ApiResponse({ status: 400, description: 'Bad request.' })
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
