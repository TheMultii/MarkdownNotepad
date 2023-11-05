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
import { User } from '@prisma/client';
import { validate } from 'class-validator';
import { JwtPayload, decodeJwt } from 'src/auth/jwt.decode';
import { UUIDDto } from 'src/dto';
import { Request, Response } from 'express';
import * as fs from 'fs';
import * as sharp from 'sharp';

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
    const token = request.headers.authorization;
    const jwtPayload: JwtPayload = decodeJwt(this.jwtService, token);

    const user: User = await this.userService.getUserByUsername(
      jwtPayload.username,
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
}
