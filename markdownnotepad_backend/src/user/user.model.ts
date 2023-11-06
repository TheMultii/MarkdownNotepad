import { ApiProperty } from '@nestjs/swagger';
import { Catalog, Note, NoteTag, Prisma } from '@prisma/client';

export class User implements Prisma.UserCreateInput {
  @ApiProperty()
  id?: string;
  @ApiProperty({ example: 'username' })
  username: string;
  @ApiProperty({ example: 'mail@mail.com' })
  email: string;
  @ApiProperty({ example: 'John' })
  name?: string;
  @ApiProperty({ example: 'Doe' })
  surname?: string;
  password: string;
  @ApiProperty({ example: '2023-11-02T00:00:00.000Z' })
  createdAt?: string | Date;
  @ApiProperty({ example: '2023-11-02T00:00:00.000Z' })
  updatedAt?: string | Date;
  notes?: Prisma.NoteCreateNestedManyWithoutAuthorInput;
  tags?: Prisma.NoteTagCreateNestedManyWithoutOwnerInput;
  catalogs?: Prisma.CatalogCreateNestedManyWithoutOwnerInput;
}

export class UserShort implements Prisma.UserCreateInput {
  @ApiProperty()
  id?: string;
  @ApiProperty({ example: 'username' })
  username: string;
  @ApiProperty({ example: 'mail@mail.com' })
  email: string;
  name?: string;
  surname?: string;
  password: string;
  createdAt?: string | Date;
  updatedAt?: string | Date;
  notes?: Prisma.NoteCreateNestedManyWithoutAuthorInput;
  tags?: Prisma.NoteTagCreateNestedManyWithoutOwnerInput;
  catalogs?: Prisma.CatalogCreateNestedManyWithoutOwnerInput;
}

export class UserBasic {
  @ApiProperty()
  id?: string;
  @ApiProperty({ example: 'username' })
  username: string;
}

export class UserPasswordless {
  id: string;
  username: string;
  email: string;
  name?: string;
  surname?: string;
  createdAt: string | Date;
  updatedAt: string | Date;
  notes: Pick<Note, 'id' | 'title' | 'createdAt' | 'updatedAt' | 'shared'>[];
  tags: NoteTag[];
  catalogs: Catalog[];
}
