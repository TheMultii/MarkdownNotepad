import { Prisma, User, Catalog as CatalogPrisma, Note } from '@prisma/client';

export class Catalog implements Prisma.CatalogCreateInput {
  id?: string;
  title: string;
  createdAt?: string | Date;
  updatedAt?: string | Date;
  notes?: Prisma.NoteCreateNestedManyWithoutFolderInput;
  owner: Prisma.UserCreateNestedOneWithoutCatalogsInput;
}

export interface CatalogInclude extends CatalogPrisma {
  notes: Note[];
  owner: Pick<User, 'id' | 'username' | 'email'>;
}
