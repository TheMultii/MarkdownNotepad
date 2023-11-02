import { CatalogsService } from './catalogs.service';
import { Controller } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { JwtService } from '@nestjs/jwt';

@Controller('catalogs')
@ApiBearerAuth()
@ApiTags('catalogs')
export class CatalogsController {
  constructor(
    private readonly catalogsService: CatalogsService,
    private readonly jwtService: JwtService,
  ) {}
}
