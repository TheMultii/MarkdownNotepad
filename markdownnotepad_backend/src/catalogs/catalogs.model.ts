import { ApiProperty } from '@nestjs/swagger';
import { Prisma, User, Catalog as CatalogPrisma, Note } from '@prisma/client';

export class Catalog implements Prisma.CatalogCreateInput {
  @ApiProperty()
  id?: string;
  @ApiProperty()
  title: string;
  @ApiProperty()
  createdAt?: string | Date;
  @ApiProperty()
  updatedAt?: string | Date;
  @ApiProperty()
  notes?: Prisma.NoteCreateNestedManyWithoutFolderInput;
  @ApiProperty()
  owner: Prisma.UserCreateNestedOneWithoutCatalogsInput;
}

export class CatalogInclude implements CatalogPrisma {
  @ApiProperty()
  id: string;
  @ApiProperty()
  title: string;
  @ApiProperty()
  ownerId: string;
  @ApiProperty()
  createdAt: Date;
  @ApiProperty()
  updatedAt: Date;
  @ApiProperty()
  notes: Note[];
  @ApiProperty()
  owner: Pick<User, 'id' | 'username' | 'email'>;
}
