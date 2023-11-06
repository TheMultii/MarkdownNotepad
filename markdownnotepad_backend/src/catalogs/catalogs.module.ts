import { Module } from '@nestjs/common';
import { CatalogsService } from './catalogs.service';
import { PrismaService } from 'src/prisma.service';
import { JwtModule } from '@nestjs/jwt';
import { CatalogsController } from './catalogs.controller';
import { UserService } from 'src/user/user.service';

@Module({
  controllers: [CatalogsController],
  providers: [CatalogsService, UserService, PrismaService],
  imports: [
    JwtModule.register({
      secret: process.env.JWT_SECRET,
      signOptions: { expiresIn: process.env.JWT_EXPIRES_IN },
    }),
  ],
})
export class CatalogsModule {}
