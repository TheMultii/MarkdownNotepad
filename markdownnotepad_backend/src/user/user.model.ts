import { Prisma } from '@prisma/client';

export class User implements Prisma.UserCreateInput {
  id?: string;
  username: string;
  email: string;
  name?: string;
  surname?: string;
  password: string;
  createdAt?: string | Date;
  updatedAt?: string | Date;
  posts?: Prisma.NoteCreateNestedManyWithoutAuthorInput;
  tags?: Prisma.NoteTagCreateNestedManyWithoutOwnerInput;
}
