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
import { JwtPayload } from 'src/auth/jwt.decode';
import { UserService } from 'src/user/user.service';
import { UserBasic } from 'src/user/user.model';
import { NoteDtoOptional } from 'src/notes/dto/note.optional.dto';

@Injectable()
@WebSocketGateway({ namespace: 'notes' })
export class NotesGateway
  implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect
{
  constructor(
    private readonly notesService: NotesService,
    private readonly userService: UserService,
    private readonly jwtService: JwtService,
  ) {}

  @WebSocketServer()
  private server: Server;

  private connectedUsers: Map<string, Set<UserBasic>> = new Map();
  private readonly logger = new Logger(NotesGateway.name);

  afterInit() {
    this.logger.log('Initialized notes gateway.');
  }

  async handleConnection(@ConnectedSocket() client: Socket) {
    const authToken: string | null = client.handshake.headers.authorization;
    if (!authToken) {
      this.sendErrorToClient(client, 'Missing authorization header');
      return;
    }

    let decodedJWT: JwtPayload | null;
    try {
      decodedJWT = await this.jwtService.verifyAsync(
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

    const uuidDto = new UUIDDto();
    uuidDto.id = client.handshake.query?.id as string;

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
    }

    if (!this.connectedUsers.has(uuidDto.id)) {
      this.connectedUsers.set(uuidDto.id, new Set());
    }

    const user: UserBasic = await this.userService.getUserByUsernameBasic(
      decodedJWT.username,
    );

    if (!user) {
      this.sendErrorToClient(client, 'User not found');
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

    let decodedJWT: JwtPayload | null;
    try {
      decodedJWT = await this.jwtService.verifyAsync(
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

    const uuidDto = new UUIDDto();
    uuidDto.id = client.handshake.query?.id as string;

    const errors = await validate(uuidDto);
    if (errors.length > 0) {
      this.sendErrorToClient(client, 'Invalid ID');
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

    const user: UserBasic = await this.userService.getUserByUsernameBasic(
      decodedJWT.username,
    );

    if (!user) {
      this.sendErrorToClient(client, 'User not found');
      return;
    }

    if (note.author.username !== decodedJWT.username && !note.shared) {
      this.sendErrorToClient(client, 'Missing permissions');
      return;
    }

    const noteModel = new NoteModel();
    if (data.title) {
      note.title = data.title;
    }
    if (data.content) {
      note.content = data.content;
    }

    await this.notesService.updateNoteById(note.id, noteModel);
    this.notifyClientsAboutNoteChange(note, user);
  }

  async handleDisconnect(@ConnectedSocket() client: Socket) {
    const noteID = client.handshake.query.id as string;

    if (noteID) {
      const authToken: string | null = client.handshake.headers.authorization;
      let decodedJWT: JwtPayload | null;

      try {
        decodedJWT = this.jwtService.verify(authToken);
      } catch (error) {
        return;
      }

      const user: UserBasic = await this.userService.getUserByUsernameBasic(
        decodedJWT.username,
      );

      if (!user) {
        return;
      }

      this.connectedUsers.get(noteID).delete(user);

      this.logger.debug(
        `Client disconnected from /notes/${noteID}. Total connected clients for /notes/${noteID}: ${
          this.connectedUsers.get(noteID).size
        }`,
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
        this.connectedUsers.get(noteID).clear();
        this.connectedUsers.delete(noteID);
        this.server.to(`notes-${noteID}`).disconnectSockets(true);

        const note = new NoteModel();
        note.shared = false;
        await this.notesService.updateNoteById(noteID, note);
        return;
      }

      this.notifyClientsAboutConnectedClientsChange(noteID, user);
    }
  }

  notifyClientsAboutConnectedClientsChange = (
    noteID: string,
    user: UserBasic,
  ): void => {
    const message = {
      noteID,
      connectedUsers: [...this.connectedUsers.get(noteID)],
      user,
    };
    this.server
      .to(`notes-${noteID}`)
      .emit('user-list', JSON.stringify(message));
  };

  notifyClientsAboutNoteChange = (note: NoteInclude, user: UserBasic): void => {
    const message = {
      note,
      user,
    };
    this.server
      .to(`notes-${note.id}`)
      .emit('note-change', JSON.stringify(message));
  };

  sendErrorToClient = (client: Socket, error: string): void => {
    client.emit('message', `{"error": "${error}"}`);
    client.disconnect();
  };
}
