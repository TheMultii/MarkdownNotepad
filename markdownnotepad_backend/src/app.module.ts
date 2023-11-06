import { Module } from '@nestjs/common';
import { join } from 'path';
import { ServeStaticModule } from '@nestjs/serve-static';
import { UserModule } from './user/user.module';
import { NotesModule } from './notes/notes.module';
import { NoteTagsModule } from './notetags/notetags.module';
import { CatalogsModule } from './catalogs/catalogs.module';
import { AuthModule } from './auth/auth.module';
import { EventLogsModule } from './eventlogs/eventlogs.module';
import { GatewayModule } from './gatewawy/gateway.module';
import { MiscModule } from './misc/misc.module';

@Module({
  imports: [
    UserModule,
    NotesModule,
    NoteTagsModule,
    CatalogsModule,
    EventLogsModule,
    GatewayModule,
    MiscModule,
    AuthModule,
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..', 'public'),
      serveRoot: '/public',
    }),
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
