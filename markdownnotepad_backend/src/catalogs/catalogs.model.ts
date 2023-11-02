import { Prisma, User, NoteTag as NoteTagPrisma, Note } from '@prisma/client';

export class Catalog implements Prisma.CatalogCreateInput {
  id?: string;
  title: string;
  createdAt?: string | Date;
  updatedAt?: string | Date;
  notes?: Prisma.NoteCreateNestedManyWithoutFolderInput;
  owner: Prisma.UserCreateNestedOneWithoutCatalogInput;
}

export interface CatalogInclude extends NoteTagPrisma {
  notes: Note[];
  owner: Pick<User, 'id' | 'username' | 'email'>;
}
