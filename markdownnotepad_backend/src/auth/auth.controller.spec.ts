import { Test, TestingModule } from '@nestjs/testing';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { JwtService } from '@nestjs/jwt';
import { LoginDto } from './dto/login-user.dto';
import { RegisterDto } from './dto/register-user.dto';
import { ThrottlerModule } from '@nestjs/throttler';
import { Request, Response } from 'express';
import { PrismaService } from 'src/prisma.service';
import { UserService } from 'src/user/user.service';

describe('AuthController', () => {
  let controller: AuthController;
  let authService: AuthService;
  let jwtService: JwtService;
  let userService: UserService;

  beforeAll(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuthController],
      providers: [AuthService, JwtService, UserService, PrismaService],
      imports: [ThrottlerModule.forRoot()],
    }).compile();

    controller = module.get<AuthController>(AuthController);
    authService = module.get<AuthService>(AuthService);
    jwtService = module.get<JwtService>(JwtService);
    userService = module.get<UserService>(UserService);
  });

  describe('login', () => {
    it('should return an access token when login is successful', async () => {
      const mockLoginData = { access_token: 'mock_access_token' };
      jest.spyOn(authService, 'login').mockResolvedValue(mockLoginData);

      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;
      const loginDto: LoginDto = {
        username: 'testuser',
        password: 'password123',
      };

      const result = await controller.login(req, res, loginDto);

      expect(result).toEqual({ status: 200, data: mockLoginData });
    });

    it('should return a 400 error when the username length is less than 4', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const loginDto: LoginDto = new LoginDto();
      loginDto.username = 'abc';
      loginDto.password = 'password123';

      await controller.login(req, res, loginDto);

      expect(res.statusCode).toEqual(400);
    });

    it('should return a 400 error when the username length is more than 20', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const loginDto: LoginDto = new LoginDto();
      loginDto.username = 'abcdefghijklmnopqrstuvwxyz';
      loginDto.password = 'password123';

      await controller.login(req, res, loginDto);

      expect(res.statusCode).toEqual(400);
    });

    it('should return a 400 error when the password length is less than 8', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const loginDto: LoginDto = new LoginDto();
      loginDto.username = 'testuser';
      loginDto.password = 'abc';

      await controller.login(req, res, loginDto);

      expect(res.statusCode).toEqual(400);
    });

    it('should return a 400 error when the password length is more than 32', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const loginDto: LoginDto = new LoginDto();
      loginDto.username = 'testuser';
      loginDto.password = 'abcdefghijklmnopqrstuvwxyz1234567890';

      await controller.login(req, res, loginDto);

      expect(res.statusCode).toEqual(400);
    });

    it('should return a 400 error when the username contains special characters', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const loginDto: LoginDto = new LoginDto();
      loginDto.username = 'testuser!';
      loginDto.password = 'password123';

      await controller.login(req, res, loginDto);

      expect(res.statusCode).toEqual(400);
    });
  });

  describe('register', () => {
    it('should return a newly registered user', async () => {
      const mockUserData = { access_token: 'mock_access_token' };
      jest.spyOn(authService, 'register').mockResolvedValue(mockUserData);

      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;
      const registerDto: RegisterDto = {
        username: 'newuser',
        password: 'password123',
        email: 'newuser@example.com',
      };

      const result = await controller.register(req, res, registerDto);

      // Add your assertions here
      expect(result).toEqual({ status: 201, data: mockUserData });
    });

    it('should return a 400 error when the username length is less than 4', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const registerDto: RegisterDto = new RegisterDto();
      registerDto.username = 'abc';
      registerDto.password = 'password123';
      registerDto.email = 'mail@mail.mail';

      await controller.register(req, res, registerDto);

      expect(res.statusCode).toEqual(400);
    });

    it('should return a 400 error when the username length is more than 20', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const registerDto: RegisterDto = new RegisterDto();
      registerDto.username = 'abcdefghijklmnopqrstuvwxyz';
      registerDto.password = 'password123';
      registerDto.email = 'mail@mail.mail';

      await controller.register(req, res, registerDto);

      expect(res.statusCode).toEqual(400);
    });

    it('should return a 400 error when the password length is less than 8', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return { status: this.statusCode, data };
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const registerDto: RegisterDto = new RegisterDto();
      registerDto.username = 'newuser';
      registerDto.password = 'abc';
      registerDto.email = 'mail@mail.mail';

      await controller.register(req, res, registerDto);

      expect(res.statusCode).toEqual(400);
    });

    it('should return a 400 error when the password length is more than 32', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return { status: this.statusCode, data };
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const registerDto: RegisterDto = new RegisterDto();
      registerDto.username = 'newuser';
      registerDto.password = 'abcdefghijklmnopqrstuvwxyz1234567890';
      registerDto.email = 'mail@mail.mail';

      await controller.register(req, res, registerDto);

      expect(res.statusCode).toEqual(400);
    });

    it('should return a 400 error when the username contains special characters', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return { status: this.statusCode, data };
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const registerDto: RegisterDto = new RegisterDto();
      registerDto.username = 'newuser!';
      registerDto.password = 'password123';
      registerDto.email = 'mail@mail.mail';

      await controller.register(req, res, registerDto);

      expect(res.statusCode).toEqual(400);
    });

    it('should return a 400 error when the email is missing @', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return { status: this.statusCode, data };
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const registerDto: RegisterDto = new RegisterDto();
      registerDto.username = 'newuser';
      registerDto.password = 'password123';
      registerDto.email = 'mail.mail.mail';

      await controller.register(req, res, registerDto);

      expect(res.statusCode).toEqual(400);
    });

    it('should return a 400 error when the email is missing .', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return { status: this.statusCode, data };
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const registerDto: RegisterDto = new RegisterDto();
      registerDto.username = 'newuser';
      registerDto.password = 'password123';
      registerDto.email = 'mail@mailmail';

      await controller.register(req, res, registerDto);

      expect(res.statusCode).toEqual(400);
    });

    it('should return a 400 error when the email is missing domain', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return { status: this.statusCode, data };
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const registerDto: RegisterDto = new RegisterDto();
      registerDto.username = 'newuser';
      registerDto.password = 'password123';
      registerDto.email = 'mail@mail';

      await controller.register(req, res, registerDto);

      expect(res.statusCode).toEqual(400);
    });

    it('should return a 400 error when the email is missing username', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return { status: this.statusCode, data };
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const registerDto: RegisterDto = new RegisterDto();
      registerDto.username = 'newuser';
      registerDto.password = 'password123';
      registerDto.email = '@mail.mail';

      await controller.register(req, res, registerDto);

      expect(res.statusCode).toEqual(400);
    });

    it('should return a 400 error when the email is missing TLD', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return { status: this.statusCode, data };
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const registerDto: RegisterDto = new RegisterDto();
      registerDto.username = 'newuser';
      registerDto.password = 'password123';
      registerDto.email = 'mail@mail.';

      await controller.register(req, res, registerDto);

      expect(res.statusCode).toEqual(400);
    });

    it('should return a 400 error when the email is missing everything', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return { status: this.statusCode, data };
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const registerDto: RegisterDto = new RegisterDto();
      registerDto.username = 'newuser';
      registerDto.password = 'password123';
      registerDto.email = '';

      await controller.register(req, res, registerDto);

      expect(res.statusCode).toEqual(400);
    });

    it('should return a 400 error when the email is missing everything except @', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return { status: this.statusCode, data };
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const registerDto: RegisterDto = new RegisterDto();
      registerDto.username = 'newuser';
      registerDto.password = 'password123';
      registerDto.email = '@';

      await controller.register(req, res, registerDto);

      expect(res.statusCode).toEqual(400);
    });

    it('should return a 400 error when the email is missing everything except .', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return { status: this.statusCode, data };
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const registerDto: RegisterDto = new RegisterDto();
      registerDto.username = 'newuser';
      registerDto.password = 'password123';
      registerDto.email = '.';

      await controller.register(req, res, registerDto);

      expect(res.statusCode).toEqual(400);
    });

    it('should return a 400 error when the email is missing everything except @ and .', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return { status: this.statusCode, data };
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const registerDto: RegisterDto = new RegisterDto();
      registerDto.username = 'newuser';
      registerDto.password = 'password123';
      registerDto.email = '@.';

      await controller.register(req, res, registerDto);

      expect(res.statusCode).toEqual(400);
    });

    it('should return a 400 error when the email is missing everything except @ and domain', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return { status: this.statusCode, data };
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const registerDto: RegisterDto = new RegisterDto();
      registerDto.username = 'newuser';
      registerDto.password = 'password123';
      registerDto.email = '@mail';

      await controller.register(req, res, registerDto);

      expect(res.statusCode).toEqual(400);
    });
  });

  describe('refresh', () => {
    it('should return a new access token when refresh is successful', async () => {
      const mockToken =
        'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJtYXJrZG93bi5ub3RlcGFkIiwiaWF0IjoxNzAyMjEwMDY3LCJleHAiOjE3MzM3NDYwNjcsImF1ZCI6Im1hcmtkb3duLm5vdGVwYWQiLCJzdWIiOiJUaGVyZSdzIG5vdGhpbmcgaGVyZSB3b3J0aCB5b3VyIGF0dGVudGlvbiA7KSJ9.JH54OfwKSLbaAnSlqWde7P-JV-lksppoSy9Stlb4Vhg';

      const mockUsername = 'testuser';
      const mockRefreshData = {
        access_token: mockToken,
      };

      jest
        .spyOn(jwtService, 'decode')
        .mockReturnValue({ username: mockUsername });
      jest
        .spyOn(jwtService, 'sign')
        .mockReturnValue(mockRefreshData.access_token);
      jest.spyOn(userService, 'getUserByUsername').mockResolvedValue({
        id: '0',
        username: mockUsername,
        email: '',
        bio: '',
        name: '',
        surname: '',
        createdAt: '',
        updatedAt: '',
        notes: [],
        tags: [],
        catalogs: [],
      });

      const req = {
        headers: { authorization: mockToken },
      } as unknown as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return { status: this.statusCode, data };
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const result = await controller.refresh(req, res);

      expect(result).toEqual({ status: 200, data: mockRefreshData });
    });

    it('should return a 400 error when the token is invalid', async () => {
      const mockToken = 'Bearer asd';

      const req = {
        headers: { authorization: mockToken },
      } as unknown as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return { status: this.statusCode, data };
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const result = await controller.refresh(req, res);

      expect(result).toEqual({ status: 400, data: { error: 'Bad request' } });
    });

    it('should return a 400 error when the token is missing Bearer', async () => {
      const mockToken = 'asd';

      const req = {
        headers: { authorization: mockToken },
      } as unknown as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return { status: this.statusCode, data };
        },
        send: function (data) {
          return { status: this.statusCode, data };
        },
      } as unknown as Response;

      const result = await controller.refresh(req, res);

      expect(result).toEqual({ status: 400, data: { error: 'Bad request' } });
    });
  });
});
