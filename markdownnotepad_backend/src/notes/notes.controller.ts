import { Note } from '@prisma/client';
import { NotesService } from './notes.service';
import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
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
  ApiCreatedResponse,
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
import {
  Error400,
  Error403,
  Error404,
  Error500,
} from 'src/http_response_models';
import { JwtPayload, decodeJwt } from 'src/auth/jwt.decode';
import { UserPasswordless } from 'src/user/user.model';
import { PrismaService } from 'src/prisma.service';
import { NoteDtoOptional } from './dto/note.optional.dto';
import { UUIDDto } from 'src/dto';
import { EventLogsService } from 'src/eventlogs/eventlogs.service';
import { EventLog } from 'src/eventlogs/eventlogs.model';
import { NoteTagsService } from 'src/notetags/notetags.service';

@Controller('notes')
@ApiBearerAuth()
@ApiTags('notes')
export class NotesController {
  constructor(
    private readonly notesService: NotesService,
    private readonly userService: UserService,
    private readonly eventLogsService: EventLogsService,
    private readonly noteTagsService: NoteTagsService,
    private readonly prismaService: PrismaService,
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
      let decodedJWT: JwtPayload;
      try {
        decodedJWT = await decodeJwt(
          this.jwtService,
          request.headers.authorization,
        );
      } catch (error) {
        return response.status(400).json({ error: 'Bad request' });
      }

      const result: Note[] = await this.notesService.getUsersNotes(
        decodedJWT.username,
      );
      return response.status(200).json({
        notes: result,
      });
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
  @ApiParam({ name: 'id', type: String, description: 'Note uuid' })
  async getNoteById(
    @Req() request: Request,
    @Res() response: Response,
  ): Promise<any> {
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

      const result: NoteInclude = await this.notesService.getNoteById(
        request.params.id,
      );

      if (!result) {
        return response.status(404).json({ message: 'Note not found' });
      }

      if (!result.shared && result.author.username !== decodedJWT.username) {
        return response
          .status(403)
          .json({ message: 'You do not have permission to access this note' });
      }

      return response.status(200).json({
        note: result,
      });
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }

  @Post()
  @ApiOperation({ summary: 'Create a note' })
  @UseGuards(JwtAuthGuard)
  @ApiCreatedResponse({ status: 201, description: 'Create a note' })
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
      let decodedJWT: JwtPayload;
      try {
        decodedJWT = await decodeJwt(
          this.jwtService,
          request.headers.authorization,
        );
      } catch (error) {
        return response.status(400).json({ error: 'Bad request' });
      }

      const validationErrors = await validate(noteDto);
      if (validationErrors.length > 0) {
        return response.status(400).send({
          message: validationErrors,
        });
      }

      const user: UserPasswordless = await this.userService.getUserByUsername(
        decodedJWT.username,
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

      const requestIP =
        request.ip ??
        request.headers['x-forwarded-for']?.toString() ??
        request.socket.remoteAddress ??
        'unknown';

      await this.eventLogsService.addEventLog({
        userId: user.id,
        type: 'create_note',
        noteId: noteCheck.id,
        noteTitle: noteCheck.title,
        message: `User created note ${noteCheck.title}`,
        ip: requestIP,
      });

      return response
        .status(201)
        .json({ message: 'Note created', note: noteCheck });
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
  @ApiBadRequestResponse({ description: 'Bad request', type: Error400 })
  @ApiForbiddenResponse({ description: 'Missing permissions', type: Error403 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  @ApiParam({ name: 'id', type: String })
  async updateNote(
    @Req() request: Request,
    @Res() response: Response,
    @Body() noteDto: NoteDtoOptional,
  ): Promise<any> {
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

      const validationErrors = await validate(noteDto);
      if (validationErrors.length > 0) {
        return response.status(400).send({
          message: validationErrors,
        });
      }

      const user: UserPasswordless = await this.userService.getUserByUsername(
        decodedJWT.username,
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

      if (noteincludeCheck.author.username !== decodedJWT.username) {
        return response.status(403).json({
          message: 'You do not have permission to access this note',
        });
      }

      const note = new NoteModel();
      if (noteDto.title) note.title = noteDto.title;
      if (noteDto.content) note.content = noteDto.content;
      if (noteDto.folderId != null) {
        if (noteDto.folderId.length > 0) {
          const f = await this.prismaService.catalog.findUnique({
            where: {
              id: noteDto.folderId,
            },
          });
          if (!f) {
            return response.status(404).json({ message: 'Folder not found' });
          }

          note.folder = {
            connect: {
              id: noteDto.folderId,
            },
          };
        } else {
          await this.notesService.disconnectFolder(request.params.id);
        }
      }

      const requestIP =
        request.ip ??
        request.headers['x-forwarded-for']?.toString() ??
        request.socket.remoteAddress ??
        'unknown';
      const tagsEditedMaps: EventLog[] = [];
      if (noteDto.tags) {
        for (const tag of noteDto.tags) {
          const t = await this.prismaService.noteTag.findUnique({
            where: {
              id: tag,
            },
          });
          if (!t) {
            return response.status(404).json({ message: 'Tag not found' });
          }
        }

        const removed = noteincludeCheck.tags
          .filter((x) => !noteDto.tags.includes(x.id))
          .map((x) => x.id);
        const removedString = removed.join(', ');

        const added = noteDto.tags.filter(
          (x) => !noteincludeCheck.tags.map((y) => y.id).includes(x),
        );
        const addedString = added.join(', ');

        if (added.length > 0) {
          const addedTitles = [];
          for (const tag of added) {
            addedTitles.push(
              (await this.noteTagsService.getNoteTagById(tag)).title,
            );
          }

          tagsEditedMaps.push({
            userId: user.id,
            type: 'add_notetags',
            noteId: noteincludeCheck.id,
            noteTitle: noteincludeCheck.title,
            tagsId: added,
            tagsTitles: addedTitles,
            message: `User added ${addedString} tags to the ${noteincludeCheck.title} note`,
            ip: requestIP,
          });
        }

        if (removed.length > 0) {
          const removedTitles = [];
          for (const tag of removed) {
            removedTitles.push(
              (await this.noteTagsService.getNoteTagById(tag)).title,
            );
          }

          tagsEditedMaps.push({
            userId: user.id,
            type: 'remove_notetags',
            noteId: noteincludeCheck.id,
            noteTitle: noteincludeCheck.title,
            tagsId: removed,
            tagsTitles: removedTitles,
            message: `User removed ${removedString} tags from the ${noteincludeCheck.title} note`,
            ip: requestIP,
          });
        }

        note.tags = {
          connect: noteDto.tags.map((tag) => {
            return { id: tag };
          }),
        };
      }

      if (noteincludeCheck.author.username !== decodedJWT.username) {
        return response.status(403).json({
          message: 'You do not have permission to access this note',
        });
      }

      const noteCheck: Note = await this.notesService.updateNoteById(
        request.params.id,
        note,
      );

      if (!noteCheck) {
        return response.status(500).json({ message: 'Note not updated' });
      }

      const nel = await this.eventLogsService.getNewestUsersEventLog(
        user.username,
      );

      let addEventLog = false;
      if (!nel) addEventLog = true;
      else if (nel.noteId !== noteCheck.id || nel.type !== 'update_note')
        addEventLog = true;
      else if (nel.createdAt.getTime() + 300000 <= Date.now())
        addEventLog = true;

      if (!noteDto.content && !noteDto.title && !noteDto.folderId)
        addEventLog = false;

      if (addEventLog) {
        await this.eventLogsService.addEventLog({
          userId: user.id,
          type: 'update_note',
          noteId: noteCheck.id,
          noteTitle: noteCheck.title,
          message: `User updated note ${noteCheck.title}`,
          ip: requestIP,
        });
      }

      for (const el of tagsEditedMaps)
        await this.eventLogsService.addEventLog(el);

      return response
        .status(200)
        .json({ message: 'Note updated', note: noteCheck });
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
  @ApiBadRequestResponse({ description: 'Bad request', type: Error400 })
  @ApiForbiddenResponse({ description: 'Missing permissions', type: Error403 })
  @ApiNotFoundResponse({ description: 'Not found', type: Error404 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  @ApiParam({ name: 'id', type: String })
  async deleteUser(
    @Req() request: Request,
    @Res() response: Response,
    @Param() params: UUIDDto,
  ): Promise<any> {
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

      const errors = await validate(params);
      if (errors.length > 0) {
        return response.status(400).send({
          message: errors,
        });
      }

      const noteToRemove: NoteInclude = await this.notesService.getNoteById(
        params.id,
      );

      if (!noteToRemove) {
        return response.status(404).json({ message: 'Note not found' });
      }

      const user: UserPasswordless = await this.userService.getUserByUsername(
        decodedJWT.username,
      );

      if (!user) {
        return response.status(500).json({ message: 'User not found' });
      }

      if (noteToRemove.author.username !== decodedJWT.username) {
        return response
          .status(403)
          .json({ message: 'You do not have permission to delete this note' });
      }

      this.notesService.deleteNoteById(params.id);

      const requestIP =
        request.ip ??
        request.headers['x-forwarded-for']?.toString() ??
        request.socket.remoteAddress ??
        'unknown';

      await this.eventLogsService.addEventLog({
        userId: user.id,
        type: 'delete_note',
        noteId: noteToRemove.id,
        message: `User deleted note ${noteToRemove.title}`,
        ip: requestIP,
      });

      return response.status(200).json({
        message: 'Note deleted successfully',
      });
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }
}
