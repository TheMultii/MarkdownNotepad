import {
  Prisma,
  User,
  Note as NotePrisma,
  NoteTag,
  Catalog,
} from '@prisma/client';

export class Note implements Prisma.NoteCreateInput {
  id?: string;
  title: string;
  content: string;
  shared: boolean;
  createdAt?: string | Date;
  updatedAt?: string | Date;
  tags?: Prisma.NoteTagCreateNestedManyWithoutNotesInput;
  author: Prisma.UserCreateNestedOneWithoutPostsInput;
  folder?: Prisma.CatalogCreateNestedOneWithoutNotesInput | undefined;
}

export interface NoteInclude extends NotePrisma {
  author: Pick<User, 'id' | 'username' | 'email'>;
  tags: NoteTag[];
  folder: Catalog;
}
