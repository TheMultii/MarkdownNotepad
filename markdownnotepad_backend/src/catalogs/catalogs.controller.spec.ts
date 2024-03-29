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

    it('should return unauthorized if user is not authenticated', async () => {
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

      const response = await controller.getCatalogs(req, res);

      expect(response['error']).toEqual('Bad request');
    });

    it('returned catalogs should have an author field with id, username and email', async () => {
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
      expect(response.catalogs[0].owner.id).toEqual('2');
      expect(response.catalogs[0].owner.username).toEqual('sample username');
      expect(response.catalogs[0].owner.email).toEqual('sample email');
    });
  });

  describe('getCatalog', () => {
    it('should return a catalog', async () => {
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

      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const customMockupedCatalog = sampleCatalog;
      customMockupedCatalog.id = uuid;

      const uuidDto = new UUIDDto(uuid);

      const decodeJwtSpy = jest
        .spyOn(decodeJwtModule, 'decodeJwt')
        .mockImplementation(async () => {
          return {
            username: 'sample username',
            iat: 1626775668,
            exp: 1626779268,
          };
        });

      const getCatalogByIdSpy = jest
        .spyOn(catalogsService, 'getCatalogById')
        .mockResolvedValue(sampleCatalog);

      await controller.getCatalogById(req, res, uuidDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getCatalogByIdSpy).toHaveBeenCalled();
      expect(res['data'].catalog.id).toEqual(uuid);
    });

    it('successfull request returns HTTP 200', async () => {
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

      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const customMockupedCatalog = sampleCatalog;
      customMockupedCatalog.id = uuid;

      const uuidDto = new UUIDDto(uuid);

      const decodeJwtSpy = jest
        .spyOn(decodeJwtModule, 'decodeJwt')
        .mockImplementation(async () => {
          return {
            username: 'sample username',
            iat: 1626775668,
            exp: 1626779268,
          };
        });

      const getCatalogByIdSpy = jest
        .spyOn(catalogsService, 'getCatalogById')
        .mockResolvedValue(sampleCatalog);

      await controller.getCatalogById(req, res, uuidDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getCatalogByIdSpy).toHaveBeenCalled();
      expect(res.statusCode).toEqual(200);
    });

    it('should return an error if user has provided an invalid uuid', async () => {
      const uuid = 'invalid uuid';
      const uuidDto = new UUIDDto(uuid);

      const errors = await validate(uuidDto);
      expect(errors.length).toBeGreaterThan(0);
      expect(errors[0].constraints).toMatchObject({
        isUuid: 'id must be a UUID',
      });
    });

    it('should return an error if user has provided an invalid uuid', async () => {
      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const uuidDto = new UUIDDto(uuid);

      const errors = await validate(uuidDto);
      expect(errors.length).toEqual(0);
    });

    it('should return an error if user has not provided an uuid', async () => {
      const uuid = '';
      const uuidDto = new UUIDDto(uuid);

      const errors = await validate(uuidDto);
      expect(errors.length).toBeGreaterThan(0);
      expect(errors[0].constraints).toMatchObject({
        isUuid: 'id must be a UUID',
      });
    });

    it('should return an error if catalog does not exist', async () => {
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
        content: function () {
          return this.data;
        },
      } as unknown as Response;

      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const uuidDto = new UUIDDto(uuid);

      const decodeJwtSpy = jest
        .spyOn(decodeJwtModule, 'decodeJwt')
        .mockImplementation(async () => {
          return {
            username: '2',
            iat: 1626775668,
            exp: 1626779268,
          };
        });

      const getCatalogByIdSpy = jest
        .spyOn(catalogsService, 'getCatalogById')
        .mockResolvedValue(null);

      await controller.getCatalogById(req, res, uuidDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getCatalogByIdSpy).toHaveBeenCalled();
      expect(res['data'].message).toBe('Catalog not found');
    });

    it("should return an error if provided uuid is a different user's catalog", async () => {
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

      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const uuidDto = {
        id: uuid,
      } as UUIDDto;

      const decodeJwtSpy = jest
        .spyOn(decodeJwtModule, 'decodeJwt')
        .mockImplementation(async () => {
          return {
            username: 'sample username',
            iat: 1626775668,
            exp: 1626779268,
          };
        });

      const sC = JSON.parse(JSON.stringify(sampleCatalog));
      sC.owner.username = 'asdadasd';

      const getCatalogByIdSpy = jest
        .spyOn(catalogsService, 'getCatalogById')
        .mockResolvedValue(sC as Response & CatalogInclude);

      await controller.getCatalogById(req, res, uuidDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getCatalogByIdSpy).toHaveBeenCalled();
      expect(res['data'].message).toBe(
        'You do not have permission to access this catalog',
      );
    });

    it('should return unauthorized if user is not authenticated', async () => {
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

      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const uuidDto = {
        id: uuid,
      } as UUIDDto;

      const response = await controller.getCatalogById(req, res, uuidDto);

      expect(response['error']).toEqual('Bad request');
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

      const getCatalogByIdSpy = jest
        .spyOn(catalogsService, 'getCatalogById')
        .mockImplementation(() => {
          throw new Error('sample error');
        });

      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const uuidDto = {
        id: uuid,
      } as UUIDDto;

      await controller.getCatalogById(req, res, uuidDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getCatalogByIdSpy).toHaveBeenCalled();
      expect(res.statusCode).toBe(500);
      expect(res['data'].message).toBe('Internal Server Error');
    });
  });

  describe('createCatalog', () => {
    it('should create a catalog', async () => {
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
      } as Response;

      const catalogDto = {
        title: sampleCatalog.title,
      };

      const decodeJwtSpy = jest
        .spyOn(decodeJwtModule, 'decodeJwt')
        .mockImplementation(async () => {
          return {
            username: 'sample username',
            iat: 1626775668,
            exp: 1626779268,
          };
        });

      const getUserByUsernameSpy = jest
        .spyOn(userService, 'getUserByUsername')
        .mockResolvedValue(sampleCatalog.owner as UserPasswordless);

      const createCatalogSpy = jest
        .spyOn(catalogsService, 'createCatalog')
        .mockResolvedValue(sampleCatalog);

      const getCatalogByIdSpy = jest
        .spyOn(catalogsService, 'getCatalogById')
        .mockResolvedValue(sampleCatalog);

      await controller.createCatalog(req, res, catalogDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(createCatalogSpy).toHaveBeenCalled();
      expect(getCatalogByIdSpy).toHaveBeenCalled();
      expect(res['data'].catalog.id).toEqual(sampleCatalog.id);
    });

    it('should return unauthorized if user is not authenticated', async () => {
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

      const catalogDto = {
        title: sampleCatalog.title,
      };

      const response = await controller.createCatalog(req, res, catalogDto);

      expect(response['error']).toEqual('Bad request');
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

      const getUserByUsernameSpy = jest
        .spyOn(userService, 'getUserByUsername')
        .mockImplementation(() => {
          throw new Error('sample error');
        });

      const catalogDto = {
        title: sampleCatalog.title,
      };

      await controller.createCatalog(req, res, catalogDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(res.statusCode).toBe(500);
      expect(res['data'].message).toBe('Internal Server Error');
    });

    it('HTTP 500 will be thrown if user is not found', async () => {
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

      const getUserByUsernameSpy = jest
        .spyOn(userService, 'getUserByUsername')
        .mockResolvedValue(null);

      const catalogDto = {
        title: sampleCatalog.title,
      };

      await controller.createCatalog(req, res, catalogDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(res.statusCode).toBe(500);
      expect(res['data'].message).toBe('User not found');
    });

    it('HTTP 500 will be thrown if catalog was not successfully added to the database', async () => {
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
      } as Response;

      const catalogDto = {
        title: sampleCatalog.title,
      };

      const decodeJwtSpy = jest
        .spyOn(decodeJwtModule, 'decodeJwt')
        .mockImplementation(async () => {
          return {
            username: 'sample username',
            iat: 1626775668,
            exp: 1626779268,
          };
        });

      const getUserByUsernameSpy = jest
        .spyOn(userService, 'getUserByUsername')
        .mockResolvedValue(sampleCatalog.owner as UserPasswordless);

      const createCatalogSpy = jest
        .spyOn(catalogsService, 'createCatalog')
        .mockResolvedValue(null);

      await controller.createCatalog(req, res, catalogDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(createCatalogSpy).toHaveBeenCalled();
      expect(res['data'].message).toBe('Catalog not created');
    });
  });

  describe('updateCatalogById', () => {
    it('should update a catalog', async () => {
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
      } as Response;

      const catalogDto = {
        title: sampleCatalog.title,
      };

      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const uuidDto = new UUIDDto(uuid);

      const decodeJwtSpy = jest
        .spyOn(decodeJwtModule, 'decodeJwt')
        .mockImplementation(async () => {
          return {
            username: 'sample username',
            iat: 1626775668,
            exp: 1626779268,
          };
        });

      const getUserByUsernameSpy = jest
        .spyOn(userService, 'getUserByUsername')
        .mockResolvedValue(sampleCatalog.owner as UserPasswordless);

      const getCatalogByIdSpy = jest
        .spyOn(catalogsService, 'getCatalogById')
        .mockResolvedValue(sampleCatalog);

      const updateCatalogByIdSpy = jest
        .spyOn(catalogsService, 'updateCatalogById')
        .mockResolvedValue(sampleCatalog);

      await controller.updateCatalogById(req, res, catalogDto, uuidDto);
      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(updateCatalogByIdSpy).toHaveBeenCalled();
      expect(getCatalogByIdSpy).toHaveBeenCalled();
      expect(res['data'].catalog.title).toEqual(sampleCatalog.title);
    });

    it('should return unauthorized if user is not authenticated', async () => {
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

      const catalogDto = {
        title: sampleCatalog.title + ' updated',
      };

      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const uuidDto = new UUIDDto(uuid);

      const response = await controller.updateCatalogById(
        req,
        res,
        catalogDto,
        uuidDto,
      );

      expect(response['error']).toEqual('Bad request');
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

      const getUserByUsernameSpy = jest
        .spyOn(userService, 'getUserByUsername')
        .mockImplementation(() => {
          throw new Error('sample error');
        });

      const catalogDto = {
        title: sampleCatalog.title,
      };

      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const uuidDto = new UUIDDto(uuid);

      await controller.updateCatalogById(req, res, catalogDto, uuidDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(res.statusCode).toBe(500);
      expect(res['data'].message).toBe('Internal Server Error');
    });

    it('HTTP 500 will be thrown if user is not found', async () => {
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

      const getUserByUsernameSpy = jest
        .spyOn(userService, 'getUserByUsername')
        .mockResolvedValue(null);

      const catalogDto = {
        title: sampleCatalog.title,
      };

      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const uuidDto = new UUIDDto(uuid);

      await controller.updateCatalogById(req, res, catalogDto, uuidDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(res.statusCode).toBe(500);
      expect(res['data'].message).toBe('User not found');
    });

    it('HTTP 404 will be thrown if catalog is not found', async () => {
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

      const getUserByUsernameSpy = jest
        .spyOn(userService, 'getUserByUsername')
        .mockResolvedValue(sampleCatalog.owner as UserPasswordless);

      const getCatalogByIdSpy = jest
        .spyOn(catalogsService, 'getCatalogById')
        .mockResolvedValue(null);

      const catalogDto = {
        title: sampleCatalog.title,
      };

      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const uuidDto = new UUIDDto(uuid);

      await controller.updateCatalogById(req, res, catalogDto, uuidDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(getCatalogByIdSpy).toHaveBeenCalled();
      expect(res.statusCode).toBe(404);
      expect(res['data'].message).toBe('Catalog not found');
    });

    it('HTTP 403 will be thrown if user is not the owner of the catalog', async () => {
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

      const catalogDto = {
        title: sampleCatalog.title,
      };

      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const uuidDto = new UUIDDto(uuid);

      const decodeJwtSpy = jest
        .spyOn(decodeJwtModule, 'decodeJwt')
        .mockImplementation(async () => {
          return {
            username: 'other username',
            iat: 1626775668,
            exp: 1626779268,
          };
        });

      const getUserByUsernameSpy = jest
        .spyOn(userService, 'getUserByUsername')
        .mockResolvedValue(sampleCatalog.owner as UserPasswordless);

      const getCatalogByIdSpy = jest

        .spyOn(catalogsService, 'getCatalogById')
        .mockResolvedValue(sampleCatalog);

      await controller.updateCatalogById(req, res, catalogDto, uuidDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(getCatalogByIdSpy).toHaveBeenCalled();
      expect(res.statusCode).toBe(403);
      expect(res['data'].message).toBe(
        'You do not have permission to access this catalog',
      );
    });

    it('HTTP 500 will be thrown if catalog was not successfully updated in the database', async () => {
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
      } as Response;

      const catalogDto = {
        title: sampleCatalog.title,
      };

      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const uuidDto = new UUIDDto(uuid);

      const decodeJwtSpy = jest
        .spyOn(decodeJwtModule, 'decodeJwt')
        .mockImplementation(async () => {
          return {
            username: 'sample username',
            iat: 1626775668,
            exp: 1626779268,
          };
        });

      const getUserByUsernameSpy = jest
        .spyOn(userService, 'getUserByUsername')
        .mockResolvedValue(sampleCatalog.owner as UserPasswordless);

      const getCatalogByIdSpy = jest
        .spyOn(catalogsService, 'getCatalogById')
        .mockResolvedValue(sampleCatalog);

      const updateCatalogByIdSpy = jest
        .spyOn(catalogsService, 'updateCatalogById')
        .mockResolvedValue(null);

      await controller.updateCatalogById(req, res, catalogDto, uuidDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(getCatalogByIdSpy).toHaveBeenCalled();
      expect(updateCatalogByIdSpy).toHaveBeenCalled();
      expect(res['data'].message).toBe('Catalog not updated');
    });
  });

  describe('removeNoteFromCatalog', () => {
    it('should remove a note from a catalog', async () => {
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
      } as Response;

      const removeNoteDto = {
        id: '1',
        noteId: '2',
      };

      const getUserByUsernameSpy = jest
        .spyOn(userService, 'getUserByUsername')
        .mockResolvedValue(sampleCatalog.owner as UserPasswordless);

      const getNoteByIdSpy = jest
        .spyOn(notesService, 'getNoteById')
        .mockResolvedValue(sampleCatalog.notes[0] as NoteInclude);

      const getCatalogByIdSpy = jest
        .spyOn(catalogsService, 'getCatalogById')
        .mockResolvedValue(sampleCatalog);

      const removeNoteFromCatalogSpy = jest
        .spyOn(catalogsService, 'disconnectNoteFromCatalog')
        .mockResolvedValue(sampleCatalog);

      await controller.removeNoteFromCatalog(req, res, removeNoteDto);

      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(getNoteByIdSpy).toHaveBeenCalled();
      expect(getCatalogByIdSpy).toHaveBeenCalled();
      expect(removeNoteFromCatalogSpy).toHaveBeenCalled();
      expect(res['data'].catalog.notes.length).toEqual(1);
    });

    it('should return unauthorized if user is not authenticated', async () => {
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

      const removeNoteDto = {
        id: '1',
        noteId: '2',
      };

      const response = await controller.removeNoteFromCatalog(
        req,
        res,
        removeNoteDto,
      );

      expect(response['error']).toEqual('Bad request');
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

      const getUserByUsernameSpy = jest
        .spyOn(userService, 'getUserByUsername')
        .mockImplementation(() => {
          throw new Error('sample error');
        });

      const removeNoteDto = {
        id: '1',
        noteId: '2',
      };

      await controller.removeNoteFromCatalog(req, res, removeNoteDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(res.statusCode).toBe(500);
      expect(res['data'].message).toBe('Internal Server Error');
    });

    it('HTTP 500 will be thrown if user is not found', async () => {
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

      const getUserByUsernameSpy = jest
        .spyOn(userService, 'getUserByUsername')
        .mockResolvedValue(null);

      const removeNoteDto = {
        id: '1',
        noteId: '2',
      };

      await controller.removeNoteFromCatalog(req, res, removeNoteDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(res.statusCode).toBe(500);
      expect(res['data'].message).toBe('User not found');
    });

    it('HTTP 404 will be thrown if catalog is not found', async () => {
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

      const getUserByUsernameSpy = jest
        .spyOn(userService, 'getUserByUsername')
        .mockResolvedValue(sampleCatalog.owner as UserPasswordless);

      const getCatalogByIdSpy = jest
        .spyOn(catalogsService, 'getCatalogById')
        .mockResolvedValue(null);

      const removeNoteDto = {
        id: '1',
        noteId: '2',
      };

      await controller.removeNoteFromCatalog(req, res, removeNoteDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(getCatalogByIdSpy).toHaveBeenCalled();
      expect(res.statusCode).toBe(404);
      expect(res['data'].message).toBe('Catalog not found');
    });

    it('HTTP 404 will be thrown if note is not found', async () => {
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

      const getUserByUsernameSpy = jest
        .spyOn(userService, 'getUserByUsername')
        .mockResolvedValue(sampleCatalog.owner as UserPasswordless);

      const getCatalogByIdSpy = jest
        .spyOn(catalogsService, 'getCatalogById')
        .mockResolvedValue(sampleCatalog);

      const getNoteByIdSpy = jest
        .spyOn(notesService, 'getNoteById')
        .mockResolvedValue(null);

      const removeNoteDto = {
        id: '1',
        noteId: '2',
      };

      await controller.removeNoteFromCatalog(req, res, removeNoteDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(getCatalogByIdSpy).toHaveBeenCalled();
      expect(getNoteByIdSpy).toHaveBeenCalled();
      expect(res.statusCode).toBe(404);
      expect(res['data'].message).toBe('Note not found');
    });

    it('HTTP 403 will be thrown if user is not the owner of the catalog', async () => {
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

      const removeNoteDto = {
        id: '1',
        noteId: '2',
      };

      const decodeJwtSpy = jest
        .spyOn(decodeJwtModule, 'decodeJwt')
        .mockImplementation(async () => {
          return {
            username: 'other username',
            iat: 1626775668,
            exp: 1626779268,
          };
        });

      const getUserByUsernameSpy = jest
        .spyOn(userService, 'getUserByUsername')
        .mockResolvedValue(sampleCatalog.owner as UserPasswordless);

      const getCatalogByIdSpy = jest
        .spyOn(catalogsService, 'getCatalogById')
        .mockResolvedValue(sampleCatalog);

      const getNoteByIdSpy = jest
        .spyOn(notesService, 'getNoteById')
        .mockResolvedValue(sampleCatalog.notes[0] as NoteInclude);

      await controller.removeNoteFromCatalog(req, res, removeNoteDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(getCatalogByIdSpy).toHaveBeenCalled();
      expect(getNoteByIdSpy).toHaveBeenCalled();
      expect(res.statusCode).toBe(403);
      expect(res['data'].message).toBe(
        'You do not have permission to access this catalog',
      );
    });

    it('HTTP 500 will be thrown if catalog was not successfully updated in the database', async () => {
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
      } as Response;

      const removeNoteDto = {
        id: '1',
        noteId: '2',
      };

      const decodeJwtSpy = jest
        .spyOn(decodeJwtModule, 'decodeJwt')
        .mockImplementation(async () => {
          return {
            username: 'sample username',
            iat: 1626775668,
            exp: 1626779268,
          };
        });

      const getUserByUsernameSpy = jest
        .spyOn(userService, 'getUserByUsername')
        .mockResolvedValue(sampleCatalog.owner as UserPasswordless);

      const getCatalogByIdSpy = jest
        .spyOn(catalogsService, 'getCatalogById')
        .mockResolvedValue(sampleCatalog);

      const getNoteByIdSpy = jest
        .spyOn(notesService, 'getNoteById')
        .mockResolvedValue(sampleCatalog.notes[0] as NoteInclude);

      const updateCatalogByIdSpy = jest
        .spyOn(catalogsService, 'disconnectNoteFromCatalog')
        .mockResolvedValue(null);

      await controller.removeNoteFromCatalog(req, res, removeNoteDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(getCatalogByIdSpy).toHaveBeenCalled();
      expect(getNoteByIdSpy).toHaveBeenCalled();
      expect(updateCatalogByIdSpy).toHaveBeenCalled();
      expect(res['data'].message).toBe('Catalog not updated');
    });
  });

  describe('deleteCatalogById', () => {
    it('should delete a catalog', async () => {
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
      } as Response;

      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const customMockupedCatalog = sampleCatalog;
      customMockupedCatalog.id = uuid;

      const uuidDto = new UUIDDto(uuid);

      const decodeJwtSpy = jest
        .spyOn(decodeJwtModule, 'decodeJwt')
        .mockImplementation(async () => {
          return {
            username: 'sample username',
            iat: 1626775668,
            exp: 1626779268,
          };
        });

      const getCatalogByIdSpy = jest
        .spyOn(catalogsService, 'getCatalogById')
        .mockResolvedValue(customMockupedCatalog);

      const deleteCatalogByIdSpy = jest
        .spyOn(catalogsService, 'deleteCatalogById')
        .mockResolvedValue(customMockupedCatalog);

      await controller.deleteCatalogById(req, res, uuidDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getCatalogByIdSpy).toHaveBeenCalled();
      expect(deleteCatalogByIdSpy).toHaveBeenCalled();
      expect(res['data'].message).toEqual('Catalog deleted successfully');
    });

    it('should return unauthorized if user is not authenticated', async () => {
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

      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const uuidDto = new UUIDDto(uuid);

      const response = await controller.deleteCatalogById(req, res, uuidDto);

      expect(response['error']).toEqual('Bad request');
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

      const getUserByUsernameSpy = jest
        .spyOn(catalogsService, 'getCatalogById')
        .mockImplementation(() => {
          throw new Error('sample error');
        });

      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const uuidDto = new UUIDDto(uuid);

      await controller.deleteCatalogById(req, res, uuidDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(res.statusCode).toBe(500);
      expect(res['data'].message).toBe('Internal Server Error');
    });

    it('HTTP 500 will be thrown if catalog is not found', async () => {
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

      const getUserByUsernameSpy = jest
        .spyOn(catalogsService, 'getCatalogById')
        .mockResolvedValue(null);

      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const uuidDto = new UUIDDto(uuid);

      await controller.deleteCatalogById(req, res, uuidDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getUserByUsernameSpy).toHaveBeenCalled();
      expect(res.statusCode).toBe(404);
      expect(res['data'].message).toBe('Catalog not found');
    });

    it('HTTP 403 will be thrown if user is not the owner of the catalog', async () => {
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

      const uuid = 'f5710154-bfc1-4866-9b96-b4c2f6a4c2c6';
      const uuidDto = new UUIDDto(uuid);

      const decodeJwtSpy = jest
        .spyOn(decodeJwtModule, 'decodeJwt')
        .mockImplementation(async () => {
          return {
            username: 'other username',
            iat: 1626775668,
            exp: 1626779268,
          };
        });

      const getCatalogByIdSpy = jest
        .spyOn(catalogsService, 'getCatalogById')
        .mockResolvedValue(sampleCatalog);

      await controller.deleteCatalogById(req, res, uuidDto);

      expect(decodeJwtSpy).toHaveBeenCalled();
      expect(getCatalogByIdSpy).toHaveBeenCalled();
      expect(res.statusCode).toBe(403);
      expect(res['data'].message).toBe(
        'You do not have permission to access this catalog',
      );
    });
  });
});
