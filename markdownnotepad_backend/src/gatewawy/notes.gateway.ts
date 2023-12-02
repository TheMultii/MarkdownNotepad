import { JwtService } from '@nestjs/jwt';
import {
  ConnectedSocket,
  MessageBody,
  OnGatewayConnection,
  OnGatewayDisconnect,
  OnGatewayInit,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { NotesService } from 'src/notes/notes.service';
import { Logger, Injectable } from '@nestjs/common';
import { UUIDDto } from 'src/dto';
import { validate } from 'class-validator';
import { Note as NoteModel, NoteInclude } from 'src/notes/notes.model';
import { JwtPayload, decodeJwt } from 'src/auth/jwt.decode';
import { UserService } from 'src/user/user.service';
import { NoteDtoOptional } from 'src/notes/dto/note.optional.dto';
import { UserBasicWithCurrentLine } from './userbasic.model';
import { LineNumberDto } from './dto/line_number.dto';
import { EventLogsService } from 'src/eventlogs/eventlogs.service';

@Injectable()
@WebSocketGateway({ namespace: 'notes' })
export class NotesGateway
  implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect
{
  constructor(
    private readonly notesService: NotesService,
    private readonly userService: UserService,
    private readonly eventLogsService: EventLogsService,
    private readonly jwtService: JwtService,
  ) {}

  @WebSocketServer()
  private server: Server;

  private connectedUsers: Map<string, Set<UserBasicWithCurrentLine>> =
    new Map();
  private readonly logger = new Logger(NotesGateway.name);

  private noteMutex: Map<string, boolean> = new Map();

  afterInit() {
    this.logger.log('Initialized notes gateway.');
  }

  async handleConnection(@ConnectedSocket() client: Socket) {
    const authToken: string | null = client.handshake.headers.authorization;
    if (!authToken) {
      this.sendErrorToClient(client, 'Missing authorization header');
      return;
    }

    let decodedJWT: JwtPayload;
    try {
      decodedJWT = await decodeJwt(
        this.jwtService,
        client.handshake.headers.authorization,
      );
    } catch (error) {
      this.sendErrorToClient(client, 'Invalid token');
      return;
    }

    if (!client.handshake.query?.id) {
      this.sendErrorToClient(client, 'Missing ID');
      return;
    }

    const uuidDto = new UUIDDto(client.handshake.query?.id as string);

    const errors = await validate(uuidDto);
    if (errors.length > 0) {
      this.sendErrorToClient(client, 'Invalid ID');
      return;
    }

    const note: NoteInclude = await this.notesService.getNoteById(uuidDto.id);
    if (!note) {
      this.sendErrorToClient(client, 'Note not found');
      return;
    }

    if (note.author.username !== decodedJWT.username && !note.shared) {
      this.sendErrorToClient(client, 'Missing permissions');
      return;
    } else if (note.author.username === decodedJWT.username) {
      const note = new NoteModel();
      note.shared = true;
      await this.notesService.updateNoteById(uuidDto.id, note);
    }

    if (!this.connectedUsers.has(uuidDto.id)) {
      if (note.shared && note.author.username !== decodedJWT.username) {
        const note = new NoteModel();
        note.shared = false;
        await this.notesService.updateNoteById(uuidDto.id, note);
        this.sendErrorToClient(client, 'Note author is not connected.');
        return;
      }
      this.connectedUsers.set(uuidDto.id, new Set());
    }

    const user: UserBasicWithCurrentLine =
      await this.userService.getUserByUsernameBasic(decodedJWT.username);

    user.currentLine = 0;

    if (!user) {
      this.sendErrorToClient(client, 'User not found');
      return;
    }

    if (this.checkIfUserIsConnected(uuidDto.id, user)) {
      this.sendErrorToClient(client, 'User already connected');
      return;
    }

    client.join(`notes-${uuidDto.id}`);
    this.connectedUsers.get(uuidDto.id).add(user);

    this.logger.debug(
      `Client connected to /notes/${
        uuidDto.id
      }. Total connected clients for /notes/${uuidDto.id}: ${
        this.connectedUsers.get(uuidDto.id).size
      }`,
    );

    this.notifyClientsAboutConnectedClientsChange(uuidDto.id, user);
    this.notifyClientsAboutNoteChange(note, user);
  }

  @SubscribeMessage('lineChange')
  async handleLineChange(
    @MessageBody() data: LineNumberDto,
    @ConnectedSocket() client: Socket,
  ): Promise<void> {
    const authToken: string | null = client.handshake.headers.authorization;
    if (!authToken) {
      this.sendErrorToClient(client, 'Missing authorization header');
      return;
    }

    let decodedJWT: JwtPayload;
    try {
      decodedJWT = await decodeJwt(
        this.jwtService,
        client.handshake.headers.authorization,
      );
    } catch (error) {
      this.sendErrorToClient(client, 'Invalid token');
      return;
    }

    if (!client.handshake.query?.id) {
      this.sendErrorToClient(client, 'Missing ID');
      return;
    }

    const uuidDto = new UUIDDto(client.handshake.query?.id as string);

    let errors = await validate(uuidDto);
    if (errors.length > 0) {
      this.sendErrorToClient(client, 'Invalid ID');
      return;
    }

    if (typeof data !== 'object') {
      data = JSON.parse(data);
    }
    data = data as LineNumberDto;
    errors = await validate(data);
    if (errors.length > 0) {
      this.sendErrorToClient(client, 'Invalid data');
      return;
    }

    const note: NoteInclude = await this.notesService.getNoteById(uuidDto.id);
    if (!note) {
      this.sendErrorToClient(client, 'Note not found');
      return;
    }

    const user: UserBasicWithCurrentLine =
      await this.userService.getUserByUsernameBasic(decodedJWT.username);

    if (!user) {
      this.sendErrorToClient(client, 'User not found');
      return;
    }

    if (note.author.username !== decodedJWT.username && !note.shared) {
      this.sendErrorToClient(client, 'Missing permissions');
      return;
    }

    this.connectedUsers.get(uuidDto.id).forEach((u) => {
      if (u.username === user.username) {
        u.currentLine = data.lineNumber;
      }
    });

    this.notifyClientsAboutConnectedClientsChange(uuidDto.id, user);
  }

  @SubscribeMessage('noteUpdate')
  async handleMessage(
    @MessageBody() data: NoteDtoOptional,
    @ConnectedSocket() client: Socket,
  ): Promise<void> {
    const authToken: string | null = client.handshake.headers.authorization;
    if (!authToken) {
      this.sendErrorToClient(client, 'Missing authorization header');
      return;
    }

    let decodedJWT: JwtPayload;
    try {
      decodedJWT = await decodeJwt(
        this.jwtService,
        client.handshake.headers.authorization,
      );
    } catch (error) {
      this.sendErrorToClient(client, 'Invalid token');
      return;
    }

    if (!client.handshake.query?.id) {
      this.sendErrorToClient(client, 'Missing ID');
      return;
    }

    const uuidDto = new UUIDDto(client.handshake.query?.id as string);

    let errors = await validate(uuidDto);
    if (errors.length > 0) {
      this.sendErrorToClient(client, 'Invalid ID');
      return;
    }

    if (typeof data !== 'object') {
      data = JSON.parse(data);
    }
    data = data as NoteDtoOptional;
    errors = await validate(data);
    if (errors.length > 0) {
      this.sendErrorToClient(client, 'Invalid data');
      return;
    }
    if (!data.title && !data.content) {
      this.sendErrorToClient(client, 'Missing title or content');
      return;
    }

    const note: NoteInclude = await this.notesService.getNoteById(uuidDto.id);
    if (!note) {
      this.sendErrorToClient(client, 'Note not found');
      return;
    }

    const user: UserBasicWithCurrentLine =
      await this.userService.getUserByUsernameBasic(decodedJWT.username);

    if (!user) {
      this.sendErrorToClient(client, 'User not found');
      return;
    }

    user.currentLine = 0;

    const connectedUsersArray = Array.from(
      this.connectedUsers.get(uuidDto.id) || [],
    );
    const userToFind = connectedUsersArray.find(
      (u) => u.username === user.username,
    );
    if (userToFind) {
      user.currentLine = userToFind.currentLine;
    }

    if (note.author.username !== decodedJWT.username && !note.shared) {
      this.sendErrorToClient(client, 'Missing permissions');
      return;
    }

    const noteModel = new NoteModel();
    if (data.title != null) noteModel.title = data.title;
    if (data.content != null) noteModel.content = data.content;

    if (this.noteMutex.get(note.id)) {
      this.sendErrorToClient(client, 'Note is being edited');
      return;
    } else {
      this.noteMutex.set(note.id, true);
    }

    await this.notesService.updateNoteById(note.id, noteModel);
    this.notifyClientsAboutNoteChange(note, user);
    this.noteMutex.set(note.id, false);

    if (note.author.username !== decodedJWT.username) {
      const nel = await this.eventLogsService.getNewestUsersEventLog(
        user.username,
      );

      let addEventLog = false;
      if (!nel) addEventLog = true;
      else if (nel.noteId !== note.id || nel.type !== 'update_note')
        addEventLog = true;
      else if (nel.createdAt.getTime() + 300000 <= Date.now())
        addEventLog = true;

      const requestIP = client.handshake.address || '';

      if (addEventLog) {
        await this.eventLogsService.addEventLog({
          userId: user.id,
          type: 'update_note',
          noteId: note.id,
          noteTitle: note.title,
          message: `User updated note ${data.title ?? note.title}`,
          ip: requestIP,
        });
      }
    }
  }

  async handleDisconnect(@ConnectedSocket() client: Socket) {
    const noteID = client.handshake.query.id as string;

    if (noteID) {
      const authToken: string | null = client.handshake.headers.authorization;
      let decodedJWT: JwtPayload;

      try {
        decodedJWT = await decodeJwt(this.jwtService, authToken);
      } catch (error) {
        return;
      }

      const user: UserBasicWithCurrentLine =
        await this.userService.getUserByUsernameBasic(decodedJWT.username);

      if (!user) {
        return;
      }

      user.currentLine = 0;

      const connectedUsersArray = Array.from(
        this.connectedUsers.get(noteID) || [],
      );
      const userToFind = connectedUsersArray.find(
        (u) => u.username === user.username,
      );

      if (userToFind) {
        user.currentLine = userToFind.currentLine;
      }

      this.removeUserFromConnectedUsers(noteID, user);

      const newSize = this.connectedUsers.get(noteID)?.size;
      if (newSize > 0)
        this.logger.debug(
          `Client disconnected from /notes/${noteID}. Total connected clients for /notes/${noteID}: ${newSize}`,
        );

      const note: NoteInclude = await this.notesService.getNoteById(noteID);
      if (!note) {
        return;
      }

      if (note.author.username === decodedJWT.username) {
        /*
          if the author of the note is the one who disconnected,
          notify all client and disconnect them.
          also update the note and set shared to false
        */
        this.server
          .to(`notes-${noteID}`)
          .emit('message', JSON.stringify({ noteID, disconnect: true }));
        this.connectedUsers.get(noteID)?.clear();
        this.connectedUsers.delete(noteID);
        this.server.to(`notes-${noteID}`).emit('error', 'Author disconnected');
        this.server.to(`notes-${noteID}`).disconnectSockets(true);

        const note = new NoteModel();
        note.shared = false;
        await this.notesService.updateNoteById(noteID, note);
        this.logger.debug(
          `Author of note /notes/${noteID} disconnected. Note set to private.`,
        );
        return;
      }

      this.notifyClientsAboutConnectedClientsChange(noteID, user);
    }
  }

  notifyClientsAboutConnectedClientsChange = (
    noteID: string,
    user: UserBasicWithCurrentLine,
  ): void => {
    if (!this.connectedUsers.get(noteID)?.size) return;

    const message = {
      noteID,
      connectedUsers: [...this.connectedUsers.get(noteID)],
      user,
    };
    this.server
      .to(`notes-${noteID}`)
      .emit('user-list', JSON.stringify(message));
  };

  notifyClientsAboutNoteChange = (
    note: NoteInclude,
    user: UserBasicWithCurrentLine,
  ): void => {
    const message = {
      note,
      user,
    };
    this.server
      .to(`notes-${note.id}`)
      .emit('note-change', JSON.stringify(message));
  };

  sendErrorToClient = (client: Socket, error: string): void => {
    client.emit('error', `{"error": "${error}"}`);
    client.disconnect();
  };

  removeUserFromConnectedUsers = (
    noteID: string,
    user: UserBasicWithCurrentLine,
  ): void => {
    this.connectedUsers.get(noteID)?.forEach((u) => {
      if (u.username === user.username) {
        this.connectedUsers.get(noteID).delete(u);
      }
    });
  };

  checkIfUserIsConnected = (
    noteID: string,
    user: UserBasicWithCurrentLine,
  ): boolean => {
    let alreadyConnected = false;
    this.connectedUsers.get(noteID)?.forEach((u) => {
      if (u.username === user.username) {
        alreadyConnected = true;
      }
    });
    return alreadyConnected;
  };
}
