import { JwtService } from '@nestjs/jwt';
import { TestingModule, Test } from '@nestjs/testing';
import { ThrottlerModule } from '@nestjs/throttler';
import { AuthService } from 'src/auth/auth.service';
import { PrismaService } from 'src/prisma.service';
import { UserService } from 'src/user/user.service';
import { CatalogsController } from './catalogs.controller';
import { Request, Response } from 'express';
import { CatalogsService } from './catalogs.service';
import { NotesService } from 'src/notes/notes.service';
import { CatalogInclude } from './catalogs.model';
import { UUIDDto } from 'src/dto';
import { validate } from 'class-validator';
import * as decodeJwtModule from 'src/auth/jwt.decode';
import { UserPasswordless } from 'src/user/user.model';
import { Note } from '@prisma/client';
import { NoteInclude } from 'src/notes/notes.model';

const sampleCatalog = {
  id: '1',
  title: 'sample title',
  ownerId: '2',
  content: 'sample content',
  createdAt: new Date(),
  updatedAt: new Date(),
  notes: [
    {
      id: '1',
      title: 'sample title',
      content: 'sample content',
      createdAt: new Date(),
      updatedAt: new Date(),
    } as Note,
  ],
  owner: {
    id: '2',
    username: 'sample username',
    email: 'sample email',
  },
} as CatalogInclude;

describe('CatalogsController', () => {
  let controller: CatalogsController;
  let catalogsService: CatalogsService;
  let userService: UserService;
  let notesService: NotesService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [CatalogsController],
      providers: [
        AuthService,
        JwtService,
        UserService,
        NotesService,
        CatalogsService,
        PrismaService,
      ],
      imports: [ThrottlerModule.forRoot()],
    }).compile();

    controller = module.get<CatalogsController>(CatalogsController);
    catalogsService = module.get<CatalogsService>(CatalogsService);
    userService = module.get<UserService>(UserService);
    notesService = module.get<NotesService>(NotesService);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
