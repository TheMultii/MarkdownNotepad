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

  describe('getCatalogs', () => {
    it('should call getCatalogs', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return data;
        },
      } as unknown as Response;
      jest
        .spyOn(controller, 'getCatalogs')
        .mockResolvedValue({ catalogs: [] } as Response & { catalogs: [] });
      const result = await controller.getCatalogs(req, res);

      expect(controller.getCatalogs).toHaveBeenCalled();
      expect(result).toEqual({ catalogs: [] });
    });

    it('catalog should be of CatalogInclude type', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return data;
        },
      } as unknown as Response;

      jest.spyOn(controller, 'getCatalogs').mockResolvedValue({
        catalogs: [sampleCatalog],
      } as Response & {
        catalogs: CatalogInclude[];
      });
      const resposne = (await controller.getCatalogs(req, res)) as Response & {
        catalogs: CatalogInclude[];
      };

      expect(controller.getCatalogs).toHaveBeenCalled();
      expect(resposne.catalogs.length).toEqual(1);
    });

    it("user's catalogs should be returned", async () => {
      const req = {
        headers: {
          authorization: 'Bearer x',
        },
      } as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          this.data = data;
          return data;
        },
      } as unknown as Response;

      const decodeJwtSpy = jest
        .spyOn(decodeJwtModule, 'decodeJwt')
        .mockImplementation(async () => {
          return {
            username: 'sample username',
            iat: 1626775668,
            exp: 1626779268,
          };
        });

      const getUsersCatalogsSpy = jest
        .spyOn(catalogsService, 'getUsersCatalogs')
        .mockResolvedValue([sampleCatalog]);

      await controller.getCatalogs(req, res);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUsersCatalogsSpy).toHaveBeenCalled();
      expect(res.statusCode).toBe(200);
      expect(res['data'].catalogs.length).toEqual(1);
    });

    it('exception is properly handled', async () => {
      const req = {
        headers: {
          authorization: 'Bearer x',
        },
      } as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          this.data = data;
          return data;
        },
      } as unknown as Response;

      const decodeJwtSpy = jest
        .spyOn(decodeJwtModule, 'decodeJwt')
        .mockImplementation(async () => {
          return {
            username: 'sample username',
            iat: 1626775668,
            exp: 1626779268,
          };
        });

      const getUsersCatalogsSpy = jest
        .spyOn(catalogsService, 'getUsersCatalogs')
        .mockImplementation(() => {
          throw new Error('sample error');
        });

      await controller.getCatalogs(req, res);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUsersCatalogsSpy).toHaveBeenCalled();
      expect(res.statusCode).toBe(500);
      expect(res['data'].message).toBe('Internal Server Error');
    });

    it('returned catalogs should be an object', async () => {
      const req = {} as Request;
      const res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this;
        },
        json: function (data) {
          return data;
        },
      } as unknown as Response;

      jest.spyOn(controller, 'getCatalogs').mockResolvedValue({
        catalogs: [sampleCatalog],
      } as Response & {
        catalogs: CatalogInclude[];
      });
      const response = (await controller.getCatalogs(req, res)) as Response & {
        catalogs: CatalogInclude[];
      };

      expect(controller.getCatalogs).toHaveBeenCalled();
      expect(typeof response).toEqual('object');
    });
  });
});
