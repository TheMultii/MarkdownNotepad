import {
  Controller,
  Delete,
  FileTypeValidator,
  Get,
  MaxFileSizeValidator,
  Param,
  ParseFilePipe,
  Post,
  Req,
  Res,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiBody,
  ApiConsumes,
  ApiInternalServerErrorResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiParam,
  ApiTags,
} from '@nestjs/swagger';
import { UserService } from './user.service';
import { JwtService } from '@nestjs/jwt';
import { JwtAuthGuard } from 'src/auth/auth.guard';
import { Error400, Error404, Error500 } from 'src/http_response_models';
import { FileInterceptor } from '@nestjs/platform-express';
import { validate } from 'class-validator';
import { JwtPayload, decodeJwt } from 'src/auth/jwt.decode';
import { UUIDDto } from 'src/dto';
import { Request, Response } from 'express';
import * as fs from 'fs';
import * as sharp from 'sharp';
import { UserPasswordless } from './user.model';

@Controller('avatar')
@ApiTags('avatar')
export class AvatarController {
  constructor(
    private readonly userService: UserService,
    private readonly jwtService: JwtService,
  ) {}

  @Post()
  @ApiOperation({ summary: "Change user's avatar" })
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @ApiOkResponse({ description: "Change user's avatar" })
  @ApiBadRequestResponse({ description: 'Bad request', type: Error400 })
  @ApiNotFoundResponse({ description: 'User not found', type: Error404 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        avatar: {
          type: 'string',
          format: 'binary',
        },
      },
    },
  })
  @UseInterceptors(FileInterceptor('avatar'))
  async changeAvatar(
    @Req() request: Request,
    @Res() response: Response,
    @UploadedFile(
      new ParseFilePipe({
        validators: [
          new MaxFileSizeValidator({ maxSize: 5 * 1024 * 1024 }),
          new FileTypeValidator({ fileType: /image\/(jpg|jpeg|png)/ }),
        ],
      }),
    )
    avatar: Express.Multer.File,
  ): Promise<any> {
    let decodedJWT: JwtPayload;
    try {
      decodedJWT = await decodeJwt(
        this.jwtService,
        request.headers.authorization,
      );
    } catch (error) {
      return response.status(400).json({ error: 'Bad request' });
    }

    const user: UserPasswordless = await this.userService.getUserByUsername(
      decodedJWT.username,
    );

    if (!user) {
      return response.status(404).json({ error: 'User not found' });
    }

    const avatarPath = `public/avatars/${user.id}.jpg`;
    if (!fs.existsSync('public/avatars')) {
      fs.mkdirSync('public/avatars');
    }

    sharp(avatar.buffer)
      .resize(512, 512, { fit: 'fill' })
      .toFile(avatarPath, (err) => {
        if (err) {
          return response.status(500).json({ error: 'Image handling error' });
        }

        return response.status(200).json({ message: 'Avatar changed' });
      });
  }

  @Get(':id')
  @ApiOperation({ summary: "Get user's avatar" })
  @ApiOkResponse({ description: "Change user's avatar" })
  @ApiBadRequestResponse({ description: 'Bad request', type: Error400 })
  @ApiNotFoundResponse({ description: 'User not found', type: Error404 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  @ApiParam({ name: 'id', type: String })
  async getAvatar(
    @Res() response: Response,
    @Param('id') id: string,
  ): Promise<any> {
    const uuidDto = new UUIDDto(id);
    const errors = await validate(uuidDto);
    if (errors.length > 0) {
      return response.status(400).json({ error: 'Bad request' });
    }

    const user: UserPasswordless = await this.userService.getUserById(id);

    if (!user) {
      return response.status(404).json({ error: 'User not found' });
    }

    const avatarPath = `public/avatars/${user.id}.jpg`;
    if (!fs.existsSync(avatarPath)) {
      const defaultAvatarPath = `public/default_avatar.jpg`;

      if (!fs.existsSync(defaultAvatarPath))
        return response.status(500).json({ error: 'Avatar not found' });

      return response.sendFile(`public/default_avatar.jpg`, {
        root: './',
      });
    }

    return response.sendFile(avatarPath, {
      root: './',
    });
  }

  @Delete()
  @ApiOperation({ summary: 'Delete avatar' })
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @ApiOkResponse({ description: 'Delete avatar' })
  @ApiBadRequestResponse({ description: 'Bad request', type: Error400 })
  @ApiNotFoundResponse({ description: 'User not found', type: Error404 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  async deleteAvatar(
    @Req() request: Request,
    @Res() response: Response,
  ): Promise<any> {
    let decodedJWT: JwtPayload;
    try {
      decodedJWT = await decodeJwt(
        this.jwtService,
        request.headers.authorization,
      );
    } catch (error) {
      return response.status(400).json({ error: 'Bad request' });
    }

    const user: UserPasswordless = await this.userService.getUserByUsername(
      decodedJWT.username,
    );

    if (!user) {
      return response.status(404).json({ error: 'User not found' });
    }

    const avatarPath = `public/avatars/${user.id}.jpg`;
    if (!fs.existsSync(avatarPath)) {
      return response.status(404).json({ error: 'Avatar not found' });
    }

    fs.unlinkSync(avatarPath);

    return response.status(200).json({ message: 'Avatar deleted' });
  }
}
