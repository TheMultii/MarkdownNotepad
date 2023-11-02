import { Note, User } from '@prisma/client';
import { NotesService } from './notes.service';
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
import { Request, Response } from 'express';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiForbiddenResponse,
  ApiInternalServerErrorResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiParam,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from 'src/auth/auth.guard';
import { JwtService } from '@nestjs/jwt';
import {
  Note as NoteResponse,
  NoteInclude,
  Note as NoteModel,
} from './notes.model';
import { UserService } from 'src/user/user.service';
import { NoteDto } from './dto/note.dto';
import { validate } from 'class-validator';
import { Error500 } from 'src/http_response_models/error500.model';
import { Error400 } from 'src/http_response_models/error400.model';
import { Error404 } from 'src/http_response_models/error404.model';

@Controller('notes')
@ApiBearerAuth()
@ApiTags('notes')
export class NotesController {
  constructor(
    private readonly notesService: NotesService,
    private readonly userService: UserService,
    private readonly jwtService: JwtService,
  ) {}

  @Get('getNotes')
  @ApiOperation({ summary: "Get all user's notes" })
  @UseGuards(JwtAuthGuard)
  @ApiResponse({ status: 200, description: "Get all user's notes" })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  async getNotes(
    @Req() request: Request,
    @Res() response: Response,
  ): Promise<any> {
    try {
      const token = request.headers.authorization.split(' ')[1];
      const username: any = this.jwtService.decode(token);

      const result: Note[] = await this.notesService.getUsersNotes(
        username.username,
      );
      return response.status(200).json(result);
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get note by id' })
  @UseGuards(JwtAuthGuard)
  @ApiResponse({ status: 200, description: 'Get note by id' })
  @ApiForbiddenResponse({ description: 'Missing permissions', type: Error400 })
  @ApiNotFoundResponse({ description: 'Not found', type: Error404 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  @ApiParam({ name: 'id', type: String })
  async getNoteById(
    @Req() request: Request,
    @Res() response: Response,
  ): Promise<any> {
    try {
      const token = request.headers.authorization.split(' ')[1];
      const username: any = this.jwtService.decode(token);

      const result: NoteInclude = await this.notesService.getNoteById(
        request.params.id,
      );

      if (!result) {
        return response.status(404).json({ message: 'Note not found' });
      }

      if (!result.shared && result.author.username !== username.username) {
        return response
          .status(403)
          .json({ message: 'You do not have permission to access this note' });
      }

      return response.status(200).json(result);
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }

  @Post()
  @ApiOperation({ summary: 'Create a note' })
  @UseGuards(JwtAuthGuard)
  @ApiResponse({ status: 201, description: 'Create a note' })
  @ApiBadRequestResponse({ description: 'Bad Request', type: Error400 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  async createNote(
    @Req() request: Request,
    @Res() response: Response,
    @Body() noteDto: NoteDto,
  ): Promise<any> {
    try {
      const token = request.headers.authorization.split(' ')[1];
      const username: any = this.jwtService.decode(token);

      const validationErrors = await validate(noteDto);
      if (validationErrors.length > 0) {
        return response.status(400).send({
          message: validationErrors,
        });
      }

      const user: User = await this.userService.getUserByUsername(
        username.username,
      );

      if (!user) {
        return response.status(500).json({ message: 'User not found' });
      }

      const note = new NoteModel();
      note.title = noteDto.title;
      note.content = noteDto.content;
      note.author = {
        connect: {
          id: user.id,
        },
      };
      if (noteDto.folderId) {
        note.folder = {
          connect: {
            id: noteDto.folderId,
          },
        };
      }
      note.tags = {
        connect: noteDto.tags.map((tag) => {
          return { id: tag };
        }),
      };

      const noteCheck: Note = await this.notesService.createNote(note);

      if (!noteCheck) {
        return response.status(500).json({ message: 'Note not created' });
      }

      return response.status(201).json({ message: 'Note created', noteCheck });
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update a note' })
  @UseGuards(JwtAuthGuard)
  @ApiOkResponse({ description: 'Update a note', type: NoteResponse })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  @ApiParam({ name: 'id', type: String })
  async updateNote(
    @Req() request: Request,
    @Res() response: Response,
    @Body() noteDto: NoteDto,
  ): Promise<any> {
    try {
      const token = request.headers.authorization.split(' ')[1];
      const username: any = this.jwtService.decode(token);

      const validationErrors = await validate(noteDto);
      if (validationErrors.length > 0) {
        return response.status(400).send({
          message: validationErrors,
        });
      }

      const user: User = await this.userService.getUserByUsername(
        username.username,
      );

      if (!user) {
        return response.status(500).json({ message: 'User not found' });
      }

      const noteincludeCheck: NoteInclude = await this.notesService.getNoteById(
        request.params.id,
      );

      if (!noteincludeCheck) {
        return response.status(404).json({ message: 'Note not found' });
      }

      const note = new NoteModel();
      note.title = noteDto.title;
      note.content = noteDto.content;
      note.author = {
        connect: {
          id: user.id,
        },
      };
      if (noteDto.folderId) {
        note.folder = {
          connect: {
            id: noteDto.folderId,
          },
        };
      }
      if (noteDto.tags) {
        note.tags = {
          connect: noteDto.tags.map((tag) => {
            return { id: tag };
          }),
        };
      }

      const noteCheck: Note = await this.notesService.updateNoteById(
        request.params.id,
        note,
      );

      if (!noteCheck) {
        return response.status(500).json({ message: 'Note not updated' });
      }

      return response.status(200).json({ message: 'Note updated', noteCheck });
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete a note' })
  @UseGuards(JwtAuthGuard)
  @ApiResponse({ status: 200, description: 'Delete a note' })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  @ApiParam({ name: 'id', type: String })
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
