import { Prisma } from '@prisma/client';

export class EventLog implements Prisma.EventLogsCreateInput {
  id?: string;
  type: string;
  message: string;
  userId?: string;
  noteId?: string;
  tagsId?: string[];
  catalogId?: string;
  ip?: string;
  createdAt?: string | Date;
  updatedAt?: string | Date;
}
