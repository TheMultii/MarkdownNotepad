import { Injectable } from '@nestjs/common';
import { Note } from '@prisma/client';
import { PrismaService } from 'src/prisma.service';
import { Note as NoteModel, NoteInclude } from './notes.model';

@Injectable()
export class NotesService {
  constructor(private prisma: PrismaService) {}

  async getUsersNotes(username: string): Promise<NoteInclude[]> {
    return await this.prisma.note.findMany({
      where: {
        author: {
          username,
        },
      },
      include: {
        author: {
          select: {
            id: true,
            username: true,
            email: true,
          },
        },
        tags: true,
        folder: true,
      },
    });
  }

  async getNoteById(id: string): Promise<NoteInclude> {
    return await this.prisma.note.findUnique({
      where: {
        id,
      },
      include: {
        author: {
          select: {
            id: true,
            username: true,
            email: true,
          },
        },
        tags: true,
        folder: true,
      },
    });
  }

  async createNote(note: NoteModel): Promise<Note> {
    return await this.prisma.note.create({
      data: note,
    });
  }

  async updateNoteById(id: string, note: NoteModel): Promise<Note> {
    if (note.tags != null) {
      await this.prisma.note.update({
        where: {
          id,
        },
        data: {
          tags: {
            set: [],
          },
        },
      });
    }
    return await this.prisma.note.update({
      where: {
        id,
      },
      data: note,
    });
  }

  async deleteNoteById(id: string): Promise<Note> {
    return await this.prisma.note.delete({
      where: {
        id,
      },
    });
  }

  async disconnectFolder(id: string): Promise<Note> {
    return await this.prisma.note.update({
      where: {
        id,
      },
      data: {
        folderId: null,
      },
    });
  }
}
