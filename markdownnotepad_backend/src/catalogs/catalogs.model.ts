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

export interface CatalogInclude extends CatalogPrisma {
  notes: Note[];
  owner: Pick<User, 'id' | 'username' | 'email'>;
}
