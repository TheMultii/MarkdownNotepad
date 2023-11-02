import { ApiProperty } from '@nestjs/swagger';
import {
  Prisma,
  User,
  Note as NotePrisma,
  NoteTag,
  Catalog,
} from '@prisma/client';
import { UserShort as UserShortResponse } from '../user/user.model';

export class Note implements Prisma.NoteCreateInput {
  @ApiProperty()
  id?: string;
  @ApiProperty({ example: 'Note title' })
  title: string;
  @ApiProperty({ example: 'Note content' })
  content: string;
  @ApiProperty({ example: 'false' })
  shared: boolean;
  @ApiProperty({ example: '2023-11-02T00:00:00.000Z' })
  createdAt?: string | Date;
  @ApiProperty({ example: '2023-11-02T00:00:00.000Z' })
  updatedAt?: string | Date;
  @ApiProperty({ required: false })
  tags?: Prisma.NoteTagCreateNestedManyWithoutNotesInput;
  @ApiProperty({ type: UserShortResponse })
  author: Prisma.UserCreateNestedOneWithoutPostsInput;
  @ApiProperty({ required: false })
  folder?: Prisma.CatalogCreateNestedOneWithoutNotesInput | undefined;
}

export interface NoteInclude extends NotePrisma {
  author: Pick<User, 'id' | 'username' | 'email'>;
  tags: NoteTag[];
  folder: Catalog;
}
