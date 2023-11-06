import { Controller, Get, Res } from '@nestjs/common';
import { ApiOkResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Response } from 'express';
import { ApiBasicInfoModel } from './misc.model';

@Controller()
@ApiTags('misc')
export class MiscController {
  constructor() {}

  @Get()
  @ApiOperation({ summary: 'Get basic information about the server' })
  @ApiOkResponse({
    description: 'Basic information about the server',
    type: ApiBasicInfoModel,
  })
  async getMisc(@Res() response: Response): Promise<Response> {
    return response
      .status(200)
      .json(
        new ApiBasicInfoModel('MarkdownNotepad API', new Date().toISOString()),
      );
  }
}
