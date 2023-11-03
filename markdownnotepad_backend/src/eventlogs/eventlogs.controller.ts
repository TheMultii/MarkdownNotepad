import { Controller } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { JwtService } from '@nestjs/jwt';
import { EventLogsService } from './eventlogs.service';

@Controller('eventlogs')
@ApiBearerAuth()
@ApiTags('eventlogs')
export class EventLogsController {
  constructor(
    private readonly eventLogsService: EventLogsService,
    private readonly jwtService: JwtService,
  ) {}
}
