import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CatalogInclude, Catalog as CatalogModel } from './catalogs.model';
import { Catalog } from '@prisma/client';

@Injectable()
export class CatalogsService {
  constructor(private prisma: PrismaService) {}

  async getUsersCatalogs(username: string): Promise<CatalogInclude[]> {
    return await this.prisma.catalog.findMany({
      where: {
        owner: {
          username,
        },
      },
      include: {
        owner: {
          select: {
            id: true,
            username: true,
            email: true,
          },
        },
        notes: true,
      },
    });
  }

  async getCatalogById(id: string): Promise<CatalogInclude> {
    return await this.prisma.catalog.findUnique({
      where: {
        id,
      },
      include: {
        owner: {
          select: {
            id: true,
            username: true,
            email: true,
          },
        },
        notes: true,
      },
    });
  }

  async createCatalog(catalog: CatalogModel): Promise<Catalog> {
    return await this.prisma.catalog.create({
      data: catalog,
    });
  }

  async updateCatalogById(id: string, catalog: CatalogModel): Promise<Catalog> {
    return await this.prisma.catalog.update({
      where: {
        id,
      },
      data: catalog,
    });
  }

  async disconnectNoteFromCatalog(
    catalogId: string,
    noteId: string,
  ): Promise<Catalog> {
    return await this.prisma.catalog.update({
      where: {
        id: catalogId,
      },
      data: {
        notes: {
          disconnect: {
            id: noteId,
          },
        },
      },
    });
  }

  async deleteCatalogById(id: string): Promise<Catalog> {
    const catalog = await this.prisma.catalog.findUnique({
      where: { id },
      include: { notes: true, owner: true },
    });

    if (!catalog) {
      throw new Error(`Catalog with ID ${id} not found`);
    }

    return await this.prisma.catalog.delete({
      where: {
        id,
      },
    });
  }
}
