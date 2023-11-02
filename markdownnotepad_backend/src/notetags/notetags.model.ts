import { Prisma, User, NoteTag as NoteTagPrisma, Note } from '@prisma/client';

export class NoteTag implements Prisma.NoteTagCreateInput {
  id?: string;
  title: string;
  color: string;
  createdAt?: string | Date;
  updatedAt?: string | Date;
  owner: Prisma.UserCreateNestedOneWithoutTagsInput;
  notes?: Prisma.NoteCreateNestedManyWithoutTagsInput;
}

export interface NoteTagInclude extends NoteTagPrisma {
  owner: Pick<User, 'id' | 'username' | 'email'>;
  notes: Note[];
}
