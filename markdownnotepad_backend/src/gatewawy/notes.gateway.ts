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

@Injectable()
@WebSocketGateway({ namespace: 'notes' })
export class NotesGateway
  implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect
{
  constructor(
    private readonly notesService: NotesService,
    private readonly jwtService: JwtService,
  ) {}

  @WebSocketServer()
  private server: Server;

  private connectedClients: Map<string, Set<Socket>> = new Map();
  private readonly logger = new Logger(NotesGateway.name);

  afterInit() {
    this.logger.log('Initialized notes gateway.');
  }

  async handleConnection(@ConnectedSocket() client: Socket) {
    const dynamicParam = client.handshake.query.id as string;

    const authToken: string | null = client.handshake.headers.authorization;
    this.logger.debug(`received token: ${authToken}`);
    if (!authToken) {
      client.disconnect();
      return;
    }
    const decodedToken = await this.jwtService.verifyAsync(
      client.handshake.headers.authorization,
    );
    this.logger.debug(`decoded token: ${JSON.stringify(decodedToken)}`);

    if (dynamicParam) {
      if (!this.connectedClients.has(dynamicParam)) {
        this.connectedClients.set(dynamicParam, new Set());
      }
      client.join(`notes-${dynamicParam}`);
      this.connectedClients.get(dynamicParam).add(client);

      this.logger.debug(
        `Client connected to /notes/${dynamicParam}. Total connected clients for /notes/${dynamicParam}: ${
          this.connectedClients.get(dynamicParam).size
        }`,
      );

      // setTimeout(() => {
      //   client.disconnect();
      // }, 10000);
    } else {
      client.disconnect();
    }
  }

  @SubscribeMessage('message')
  handleMessage(
    @MessageBody() data: any,
    @ConnectedSocket() client: Socket,
  ): void {
    const dynamicParam = client.handshake.query.id as string;
    if (!dynamicParam) return;

    this.server
      .to(`notes-${dynamicParam}`)
      .emit(
        'message',
        `Hello world from ${client.id} to "note ${dynamicParam}" with data: "${data}"!`,
      );
  }

  handleDisconnect(@ConnectedSocket() client: Socket) {
    const dynamicParam = client.handshake.query.id as string;

    if (dynamicParam) {
      this.connectedClients.get(dynamicParam).delete(client);

      this.logger.debug(
        `Client disconnected from /notes/${dynamicParam}. Total connected clients for /notes/${dynamicParam}: ${
          this.connectedClients.get(dynamicParam).size
        }`,
      );

      this.notifyClientsAboutConnectedClientsChange(dynamicParam, client.id);
    }
  }

  notifyClientsAboutConnectedClientsChange = (
    dynamicParam: string,
    clientId: string,
  ): void => {
    this.server
      .to(`notes-${dynamicParam}`)
      .emit(
        'message',
        `${clientId} has disconnected. Total connected clients for /notes/${dynamicParam}: ${
          this.connectedClients.get(dynamicParam).size
        }`,
      );
  };
}
