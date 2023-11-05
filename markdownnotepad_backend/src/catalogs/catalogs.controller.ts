/* eslint-disable @typescript-eslint/no-unused-vars */
import { CatalogsService } from './catalogs.service';
import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Req,
  Res,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiForbiddenResponse,
  ApiInternalServerErrorResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { JwtService } from '@nestjs/jwt';
import { Request, Response } from 'express';
import { JwtAuthGuard } from 'src/auth/auth.guard';
import {
  Error400,
  Error403,
  Error404,
  Error500,
} from 'src/http_response_models';
import { UUIDDto } from 'src/dto';

@Controller('catalogs')
@ApiBearerAuth()
@ApiTags('catalogs')
export class CatalogsController {
  constructor(
    private readonly catalogsService: CatalogsService,
    private readonly jwtService: JwtService,
  ) {}

  @Get('getCatalogs')
  @ApiOperation({ summary: "Get all user's catalogs" })
  @UseGuards(JwtAuthGuard)
  @ApiOkResponse({ description: "Get all user's catalogs" })
  async getCatalogs(
    @Req() request: Request,
    @Res() response: Response,
  ): Promise<Response> {
    throw new Error('Method not implemented.');
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get catalog by id' })
  @UseGuards(JwtAuthGuard)
  @ApiOkResponse({ description: 'Get catalog by id' })
  @ApiBadRequestResponse({ description: 'Bad Request', type: Error400 })
  @ApiNotFoundResponse({ description: 'Not found', type: Error404 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  async getCatalogById(
    @Req() request: Request,
    @Res() response: Response,
    @Param() params: UUIDDto,
  ): Promise<Response> {
    throw new Error('Method not implemented.');
  }

  @Post()
  @ApiOperation({ summary: 'Create new catalog' })
  @UseGuards(JwtAuthGuard)
  @ApiCreatedResponse({ description: 'Create new catalog' })
  @ApiBadRequestResponse({ description: 'Bad Request', type: Error400 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  async createCatalog(
    @Req() request: Request,
    @Res() response: Response,
    @Body() catalog: any,
  ): Promise<Response> {
    throw new Error('Method not implemented.');
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update catalog by id' })
  @UseGuards(JwtAuthGuard)
  @ApiOkResponse({ description: 'Update catalog by id' })
  @ApiBadRequestResponse({ description: 'Bad Request', type: Error400 })
  @ApiForbiddenResponse({ description: 'Forbidden', type: Error403 })
  @ApiNotFoundResponse({ description: 'Not found', type: Error404 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  async updateCatalogById(
    @Req() request: Request,
    @Res() response: Response,
    @Body() catalog: any,
    @Param() params: UUIDDto,
  ): Promise<Response> {
    throw new Error('Method not implemented.');
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete catalog by id' })
  @UseGuards(JwtAuthGuard)
  @ApiOkResponse({ description: 'Delete catalog by id' })
  @ApiForbiddenResponse({ description: 'Forbidden', type: Error403 })
  @ApiNotFoundResponse({ description: 'Not found', type: Error404 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  async deleteCatalogById(
    @Req() request: Request,
    @Res() response: Response,
    @Param() params: UUIDDto,
  ): Promise<Response> {
    throw new Error('Method not implemented.');
  }
}
