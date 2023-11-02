import { Module } from '@nestjs/common';
import { join } from 'path';
import { ServeStaticModule } from '@nestjs/serve-static';
import { UserModule } from './user/user.module';
import { CatalogsModule } from './catalogs/catalogs.module';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [
    UserModule,
    CatalogsModule,
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
