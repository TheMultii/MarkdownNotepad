import {
  Body,
  Controller,
  Delete,
  Get,
  Patch,
  Post,
  Req,
  Res,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiForbiddenResponse,
  ApiInternalServerErrorResponse,
  ApiNotFoundResponse,
  ApiOperation,
  ApiParam,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { Request, Response } from 'express';
import { JwtService } from '@nestjs/jwt';
import { NoteTagsService } from './notetags.service';
import { JwtAuthGuard } from 'src/auth/auth.guard';
import { NoteTag } from '@prisma/client';
import { NoteTagInclude } from './notetags.model';
import { NoteTagDto } from './dto/notetag.dto';
import { NoteTag as NoteTagModel } from './notetags.model';
import { UserService } from 'src/user/user.service';
import { validate } from 'class-validator';
import { NoteTagOptionalDto } from './dto/notetag.optional.dto';
import {
  Error400,
  Error403,
  Error404,
  Error500,
} from 'src/http_response_models';
import { JwtPayload, decodeJwt } from 'src/auth/jwt.decode';
import { UserPasswordless } from 'src/user/user.model';

@Controller('notetags')
@ApiBearerAuth()
@ApiTags('notetags')
export class NoteTagsController {
  constructor(
    private readonly notetagsService: NoteTagsService,
    private readonly userService: UserService,
    private readonly jwtService: JwtService,
  ) {}

  @Get('getNoteTags')
  @ApiOperation({ summary: "Get all user's notetags" })
  @UseGuards(JwtAuthGuard)
  @ApiResponse({ status: 200, description: "Get all user's notetags" })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  async getNoteTags(
    @Req() request: Request,
    @Res() response: Response,
  ): Promise<Response> {
    try {
      let decodedJWT: JwtPayload;
      try {
        decodedJWT = await decodeJwt(
          this.jwtService,
          request.headers.authorization,
        );
      } catch (error) {
        return response.status(400).json({ error: 'Bad request' });
      }

      const result: NoteTag[] = await this.notetagsService.getUsersNoteTags(
        decodedJWT.username,
      );
      return response.status(200).json({
        noteTags: result,
      });
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get notetag by id' })
  @UseGuards(JwtAuthGuard)
  @ApiResponse({ status: 200, description: 'Get notetag by id' })
  @ApiNotFoundResponse({ description: 'Not found', type: Error404 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  @ApiParam({ name: 'id', type: String, description: 'NoteTag uuid' })
  async getNoteTagById(
    @Req() request: Request,
    @Res() response: Response,
  ): Promise<Response> {
    try {
      let decodedJWT: JwtPayload;
      try {
        decodedJWT = await decodeJwt(
          this.jwtService,
          request.headers.authorization,
        );
      } catch (error) {
        return response.status(400).json({ error: 'Bad request' });
      }

      const result: NoteTagInclude = await this.notetagsService.getNoteTagById(
        request.params.id,
      );

      if (!result) {
        return response.status(404).json({ message: 'Not found' });
      }

      if (result.owner.username !== decodedJWT.username) {
        return response.status(403).json({ message: 'Forbidden' });
      }

      return response.status(200).json({
        noteTag: result,
      });
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }

  @Post()
  @ApiOperation({ summary: 'Create a notetag' })
  @UseGuards(JwtAuthGuard)
  @ApiResponse({ status: 201, description: 'Create a notetag' })
  @ApiBadRequestResponse({ description: 'Bad Request', type: Error400 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  async createNoteTag(
    @Req() request: Request,
    @Res() response: Response,
    @Body() noteTagDto: NoteTagDto,
  ): Promise<Response> {
    try {
      const validationErrors = await validate(noteTagDto);
      if (validationErrors.length > 0) {
        return response.status(400).send({
          message: validationErrors,
        });
      }

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

      const noteTag = new NoteTagModel();
      noteTag.title = noteTagDto.title;
      noteTag.color = noteTagDto.color;
      noteTag.owner = {
        connect: {
          id: user.id,
        },
      };

      const result: NoteTag = await this.notetagsService.createNoteTag(noteTag);

      return response.status(201).json({
        noteTag: result,
      });
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update a notetag' })
  @UseGuards(JwtAuthGuard)
  @ApiResponse({ status: 200, description: 'Update a notetag' })
  @ApiBadRequestResponse({ description: 'Bad Request', type: Error400 })
  @ApiForbiddenResponse({ description: 'Forbidden', type: Error403 })
  @ApiNotFoundResponse({ description: 'Not found', type: Error404 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  @ApiParam({ name: 'id', type: String, description: 'NoteTag uuid' })
  async updateNoteTagById(
    @Req() request: Request,
    @Res() response: Response,
    @Body() noteTagDto: NoteTagOptionalDto,
  ): Promise<Response> {
    try {
      const validationErrors = await validate(noteTagDto);
      if (validationErrors.length > 0) {
        return response.status(400).send({
          message: validationErrors,
        });
      }

      const noteTag = new NoteTagModel();
      if (noteTagDto.title) noteTag.title = noteTagDto.title;
      if (noteTagDto.color) noteTag.color = noteTagDto.color;

      if (!noteTag.title && !noteTag.color) {
        return response.status(400).json({
          message: 'Nothing to update',
        });
      }

      const nTag = await this.notetagsService.getNoteTagById(request.params.id);

      if (!nTag) {
        return response.status(404).json({ message: 'Not found' });
      }

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

      if (nTag.owner.id !== user.id) {
        return response.status(403).json({ message: 'Forbidden' });
      }

      const result: NoteTag = await this.notetagsService.updateNoteTagById(
        request.params.id,
        noteTag,
      );

      if (!result) {
        return response.status(404).json({ message: 'Not found' });
      }

      return response.status(200).json(result);
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete a notetag' })
  @UseGuards(JwtAuthGuard)
  @ApiResponse({ status: 200, description: 'Delete a notetag' })
  @ApiForbiddenResponse({ description: 'Forbidden', type: Error403 })
  @ApiNotFoundResponse({ description: 'Not found', type: Error404 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  @ApiParam({ name: 'id', type: String, description: 'NoteTag uuid' })
  async deleteNoteTagById(
    @Req() request: Request,
    @Res() response: Response,
  ): Promise<Response> {
    try {
      const nTag = await this.notetagsService.getNoteTagById(request.params.id);

      if (!nTag) {
        return response.status(404).json({ message: 'Not found' });
      }

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

      if (nTag.owner.id !== user.id) {
        return response.status(403).json({ message: 'Forbidden' });
      }

      const result: NoteTag = await this.notetagsService.deleteNoteTagById(
        request.params.id,
      );

      if (!result) {
        return response.status(404).json({ message: 'Not found' });
      }

      return response.status(200).json(result);
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }
}
