import { Module } from '@nestjs/common';
import { NotesGateway } from './notes.gateway';
import { JwtModule } from '@nestjs/jwt';
import { NotesService } from 'src/notes/notes.service';
import { PrismaService } from 'src/prisma.service';
import { UserService } from 'src/user/user.service';
import { EventLogsService } from 'src/eventlogs/eventlogs.service';

@Module({
  providers: [
    NotesService,
    UserService,
    PrismaService,
    NotesGateway,
    EventLogsService,
  ],
  imports: [
    JwtModule.register({
      secret: process.env.JWT_SECRET,
      signOptions: { expiresIn: process.env.JWT_EXPIRES_IN },
    }),
  ],
})
export class GatewayModule {}
