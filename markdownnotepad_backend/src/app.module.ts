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

@Module({
  imports: [
    UserModule,
    NotesModule,
    NoteTagsModule,
    CatalogsModule,
    EventLogsModule,
    GatewayModule,
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
