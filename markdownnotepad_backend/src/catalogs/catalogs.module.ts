import { Module } from '@nestjs/common';
import { CatalogsService } from './catalogs.service';
import { PrismaService } from 'src/prisma.service';
import { JwtModule } from '@nestjs/jwt';
import { CatalogsController } from './catalogs.controller';

@Module({
  controllers: [CatalogsController],
  providers: [CatalogsService, PrismaService],
  imports: [
    JwtModule.register({
      secret: process.env.JWT_SECRET,
      signOptions: { expiresIn: process.env.JWT_EXPIRES_IN },
    }),
  ],
})
export class CatalogsModule {}
