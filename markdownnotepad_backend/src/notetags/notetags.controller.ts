import { Controller } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { JwtService } from '@nestjs/jwt';
import { NoteTagsService } from './notetags.service';

@Controller('notetags')
@ApiBearerAuth()
@ApiTags('notetags')
export class NoteTagsController {
  constructor(
    private readonly notetagsService: NoteTagsService,
    private readonly jwtService: JwtService,
  ) {}
}
