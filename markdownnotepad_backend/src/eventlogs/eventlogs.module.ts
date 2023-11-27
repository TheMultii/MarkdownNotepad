import { Module } from '@nestjs/common';
import { EventLogsService } from './eventlogs.service';
import { PrismaService } from 'src/prisma.service';
import { JwtModule } from '@nestjs/jwt';
import { EventLogsController } from './eventlogs.controller';
import { UserService } from 'src/user/user.service';

@Module({
  controllers: [EventLogsController],
  providers: [EventLogsService, UserService, PrismaService],
  imports: [
    JwtModule.register({
      secret: process.env.JWT_SECRET,
      signOptions: { expiresIn: process.env.JWT_EXPIRES_IN },
    }),
  ],
})
export class EventLogsModule {}
