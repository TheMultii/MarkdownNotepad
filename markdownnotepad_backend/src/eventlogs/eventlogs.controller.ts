import { Controller, Get, Param, Req, Res, UseGuards } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiInternalServerErrorResponse,
  ApiOkResponse,
  ApiOperation,
  ApiParam,
  ApiTags,
} from '@nestjs/swagger';
import { JwtService } from '@nestjs/jwt';
import { EventLogsService } from './eventlogs.service';
import { Request, Response } from 'express';
import { Error400, Error500 } from 'src/http_response_models';
import { EventLogsDto } from './dto/eventlogs.dto';
import { JwtAuthGuard } from 'src/auth/auth.guard';
import { decodeJwt } from 'src/auth/jwt.decode';

@Controller('eventlogs')
@ApiBearerAuth()
@ApiTags('eventlogs')
export class EventLogsController {
  constructor(
    private readonly eventLogsService: EventLogsService,
    private readonly jwtService: JwtService,
  ) {}

  @Get(':page')
  @ApiOperation({ summary: "Get user's events" })
  @UseGuards(JwtAuthGuard)
  @ApiOkResponse({ description: "Get user's events" })
  @ApiBadRequestResponse({ description: 'Bad Request', type: Error400 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  @ApiParam({
    name: 'page',
    type: Number,
    description: 'Page number',
    required: true,
    example: 1,
  })
  async getEventLogs(
    @Req() request: Request,
    @Res() response: Response,
    @Param() page: EventLogsDto,
  ): Promise<Response> {
    try {
      const decodedToken = decodeJwt(
        this.jwtService,
        request.headers.authorization,
      );

      const result = await this.eventLogsService.getUsersEventLogs(
        decodedToken.username,
        page.page,
      );

      return response.status(200).json(result);
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error });
    }
  }
}
