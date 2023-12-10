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
import { DisconnectNoteUUIDDto, UUIDDto } from 'src/dto';
import { UserService } from 'src/user/user.service';
import { Catalog as CatalogModel, CatalogInclude } from './catalogs.model';
import { CatalogDto } from './dto/catalogs.dto';
import { CatalogDtoOptional } from './dto/catalogs.optional.dto';
import { JwtPayload, decodeJwt } from 'src/auth/jwt.decode';
import { UserPasswordless } from 'src/user/user.model';
import { Catalog } from '@prisma/client';
import { NoteInclude } from 'src/notes/notes.model';
import { NotesService } from 'src/notes/notes.service';

@Controller('catalogs')
@ApiBearerAuth()
@ApiTags('catalogs')
export class CatalogsController {
  constructor(
    private readonly catalogsService: CatalogsService,
    private readonly notesService: NotesService,
    private readonly userService: UserService,
    private readonly jwtService: JwtService,
  ) {}

  @Get('getCatalogs')
  @ApiOperation({ summary: "Get all user's catalogs" })
  @UseGuards(JwtAuthGuard)
  @ApiOkResponse({
    description: "Get all user's catalogs",
    type: CatalogInclude,
    isArray: true,
  })
  async getCatalogs(
    @Req() request: Request,
    @Res() response: Response,
  ): Promise<Response> {
    try {
      let decodedJWT: JwtPayload;
      try {
        decodedJWT = await decodeJwt(
          this.jwtService,
          request.headers.authorization,
        );
      } catch (error) {
        return response.status(400).json({ error: 'Bad request' });
      }

      const result: CatalogInclude[] =
        await this.catalogsService.getUsersCatalogs(decodedJWT.username);
      return response.status(200).json({
        catalogs: result,
      });
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get catalog by id' })
  @UseGuards(JwtAuthGuard)
  @ApiOkResponse({ description: 'Get catalog by id', type: CatalogInclude })
  @ApiBadRequestResponse({ description: 'Bad Request', type: Error400 })
  @ApiForbiddenResponse({ description: 'Forbidden', type: Error403 })
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
    try {
      let decodedJWT: JwtPayload;
      try {
        decodedJWT = await decodeJwt(
          this.jwtService,
          request.headers.authorization,
        );
      } catch (error) {
        return response.status(400).json({ error: 'Bad request' });
      }

      const result: CatalogInclude = await this.catalogsService.getCatalogById(
        params.id,
      );

      if (!result) {
        return response.status(404).json({ message: 'Catalog not found' });
      }

      if (result.owner.username !== decodedJWT.username) {
        return response.status(403).json({
          message: 'You do not have permission to access this catalog',
        });
      }

      return response.status(200).json({
        catalog: result,
      });
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }

  @Post()
  @ApiOperation({ summary: 'Create new catalog' })
  @UseGuards(JwtAuthGuard)
  @ApiCreatedResponse({
    description: 'Create new catalog',
    type: CatalogInclude,
  })
  @ApiBadRequestResponse({ description: 'Bad Request', type: Error400 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  async createCatalog(
    @Req() request: Request,
    @Res() response: Response,
    @Body() catalogDto: CatalogDto,
  ): Promise<Response> {
    try {
      let decodedJWT: JwtPayload;
      try {
        decodedJWT = await decodeJwt(
          this.jwtService,
          request.headers.authorization,
        );
      } catch (error) {
        return response.status(400).json({ error: 'Bad request' });
      }

      const user: UserPasswordless = await this.userService.getUserByUsername(
        decodedJWT.username,
      );

      if (!user) {
        return response.status(500).json({ message: 'User not found' });
      }

      const catalog = new CatalogModel();
      catalog.title = catalogDto.title;
      catalog.owner = {
        connect: {
          id: user.id,
        },
      };

      const catalogCheck: Catalog =
        await this.catalogsService.createCatalog(catalog);

      if (!catalogCheck) {
        return response.status(500).json({ message: 'Catalog not created' });
      }

      const result: CatalogInclude = await this.catalogsService.getCatalogById(
        catalogCheck.id,
      );

      return response
        .status(201)
        .json({ message: 'Catalog created', catalog: result });
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update catalog by id' })
  @UseGuards(JwtAuthGuard)
  @ApiOkResponse({ description: 'Update catalog by id', type: CatalogInclude })
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
    @Body() catalogDto: CatalogDtoOptional,
    @Param() params: UUIDDto,
  ): Promise<Response> {
    try {
      let decodedJWT: JwtPayload;
      try {
        decodedJWT = await decodeJwt(
          this.jwtService,
          request.headers.authorization,
        );
      } catch (error) {
        return response.status(400).json({ error: 'Bad request' });
      }

      const user: UserPasswordless = await this.userService.getUserByUsername(
        decodedJWT.username,
      );

      if (!user) {
        return response.status(500).json({ message: 'User not found' });
      }

      const catalogIncludeCheck: CatalogInclude =
        await this.catalogsService.getCatalogById(params.id);

      if (!catalogIncludeCheck) {
        return response.status(404).json({ message: 'Catalog not found' });
      }

      const catalog = new CatalogModel();
      if (catalogDto.title) catalog.title = catalogDto.title;
      else {
        return response.status(400).json({ message: 'Bad request' });
      }

      if (catalogIncludeCheck.owner.username !== decodedJWT.username) {
        return response.status(403).json({
          message: 'You do not have permission to access this catalog',
        });
      }

      const catalogCheck: Catalog =
        await this.catalogsService.updateCatalogById(params.id, catalog);

      if (!catalogCheck) {
        return response.status(500).json({ message: 'Catalog not updated' });
      }

      const result: CatalogInclude = await this.catalogsService.getCatalogById(
        catalogCheck.id,
      );

      return response
        .status(200)
        .json({ message: 'Catalog updated', catalog: result });
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }

  @Patch(':id/disconnect/:noteId')
  @ApiOperation({ summary: 'Remove a note from catalog' })
  @UseGuards(JwtAuthGuard)
  @ApiOkResponse({
    description: 'Remove a note from catalog',
    type: CatalogInclude,
  })
  @ApiBadRequestResponse({ description: 'Bad Request', type: Error400 })
  @ApiForbiddenResponse({ description: 'Forbidden', type: Error403 })
  @ApiNotFoundResponse({ description: 'Not found', type: Error404 })
  @ApiInternalServerErrorResponse({
    description: 'Internal Server Error',
    type: Error500,
  })
  async removeNoteFromCatalog(
    @Req() request: Request,
    @Res() response: Response,
    @Param() params: DisconnectNoteUUIDDto,
  ): Promise<Response> {
    try {
      let decodedJWT: JwtPayload;
      try {
        decodedJWT = await decodeJwt(
          this.jwtService,
          request.headers.authorization,
        );
      } catch (error) {
        return response.status(400).json({ error: 'Bad request' });
      }

      const user: UserPasswordless = await this.userService.getUserByUsername(
        decodedJWT.username,
      );

      if (!user) {
        return response.status(500).json({ message: 'User not found' });
      }

      const catalogIncludeCheck: CatalogInclude =
        await this.catalogsService.getCatalogById(params.id);

      if (!catalogIncludeCheck) {
        return response.status(404).json({ message: 'Catalog not found' });
      }

      const noteInclude: NoteInclude = await this.notesService.getNoteById(
        params.noteId,
      );

      if (!noteInclude) {
        return response.status(404).json({ message: 'Note not found' });
      }

      if (catalogIncludeCheck.owner.username !== decodedJWT.username) {
        return response.status(403).json({
          message: 'You do not have permission to access this catalog',
        });
      }

      const catalogCheck: Catalog =
        await this.catalogsService.disconnectNoteFromCatalog(
          params.id,
          params.noteId,
        );

      if (!catalogCheck) {
        return response.status(500).json({ message: 'Catalog not updated' });
      }

      const result: CatalogInclude = await this.catalogsService.getCatalogById(
        catalogCheck.id,
      );

      return response
        .status(200)
        .json({ message: 'Catalog updated', catalog: result });
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
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
    try {
      let decodedJWT: JwtPayload;
      try {
        decodedJWT = await decodeJwt(
          this.jwtService,
          request.headers.authorization,
        );
      } catch (error) {
        return response.status(400).json({ error: 'Bad request' });
      }

      const catalogToRemove = await this.catalogsService.getCatalogById(
        params.id,
      );

      if (!catalogToRemove) {
        return response.status(404).json({ message: 'Catalog not found' });
      }

      if (catalogToRemove.owner.username !== decodedJWT.username) {
        return response.status(403).json({
          message: 'You do not have permission to access this catalog',
        });
      }

      this.catalogsService.deleteCatalogById(params.id);

      return response.status(200).json({
        message: 'Catalog deleted successfully',
      });
    } catch (error) {
      return response
        .status(500)
        .json({ message: 'Internal Server Error', error: error.message });
    }
  }
}
