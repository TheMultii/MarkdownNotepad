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

  async deleteCatalogById(id: string): Promise<Catalog> {
    const catalog = await this.prisma.catalog.findUnique({
      where: { id },
      include: { notes: true, owner: true },
    });

    if (!catalog) {
      throw new Error(`Catalog with ID ${id} not found`);
    }

    for (const note of catalog.notes) {
      await this.prisma.note.update({
        where: { id: note.id },
        data: {
          folder: { disconnect: true },
        },
      });
    }

    await this.prisma.user.update({
      where: { id: catalog.owner.id },
      data: {
        catalog: { disconnect: { id: catalog.id } },
      },
    });

    return await this.prisma.catalog.delete({
      where: {
        id,
      },
    });
  }
}
