import { Module } from '@nestjs/common';
import { NoteTagsController } from './notetags.controller';
import { NoteTagsService } from './notetags.service';
import { PrismaService } from 'src/prisma.service';
import { JwtModule } from '@nestjs/jwt';
import { UserService } from 'src/user/user.service';

@Module({
  controllers: [NoteTagsController],
  providers: [NoteTagsService, UserService, PrismaService],
  imports: [
    JwtModule.register({
      secret: process.env.JWT_SECRET,
      signOptions: { expiresIn: process.env.JWT_EXPIRES_IN },
    }),
  ],
})
export class NoteTagsModule {}
