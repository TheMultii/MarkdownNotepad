import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { NoteTag as NoteTagModel, NoteTagInclude } from './notetags.model';
import { Note, NoteTag } from '@prisma/client';

@Injectable()
export class NoteTagsService {
  constructor(private prisma: PrismaService) {}

  async getUsersNoteTags(username: string): Promise<NoteTagInclude[]> {
    return await this.prisma.noteTag.findMany({
      where: {
        owner: {
          username,
        },
      },
      include: {
        owner: {
          select: {
            id: true,
            username: true,
            email: true,
          },
        },
        notes: true,
      },
    });
  }

  async getNoteTagById(id: string): Promise<NoteTagInclude> {
    return await this.prisma.noteTag.findUnique({
      where: {
        id,
      },
      include: {
        owner: {
          select: {
            id: true,
            username: true,
            email: true,
          },
        },
        notes: true,
      },
    });
  }

  async createNoteTag(noteTag: NoteTagModel): Promise<NoteTag> {
    return await this.prisma.noteTag.create({
      data: noteTag,
    });
  }

  async updateNoteTagById(id: string, noteTag: NoteTagModel): Promise<NoteTag> {
    return await this.prisma.noteTag.update({
      where: {
        id,
      },
      data: noteTag,
    });
  }

  async deleteNoteTagById(id: string): Promise<NoteTag> {
    const notes: Note[] = await this.prisma.note.findMany({
      where: {
        tags: {
          some: {
            id,
          },
        },
      },
    });

    if (notes.length > 0) {
      for (const note of notes) {
        await this.prisma.note.update({
          where: {
            id: note.id,
          },
          data: {
            tags: {
              disconnect: {
                id,
              },
            },
          },
        });
      }

      await this.prisma.user.update({
        where: {
          id: notes[0].authorId,
        },
        data: {
          tags: {
            disconnect: {
              id,
            },
          },
        },
      });
    }

    return await this.prisma.noteTag.delete({
      where: {
        id,
      },
    });
  }
}
