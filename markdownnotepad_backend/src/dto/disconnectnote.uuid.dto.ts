import { IsNotEmpty, IsString, IsUUID } from 'class-validator';

export class DisconnectNoteUUIDDto {
  @IsString()
  @IsNotEmpty()
  @IsUUID()
  id: string;

  @IsString()
  @IsNotEmpty()
  @IsUUID()
  noteId: string;

  constructor(id: string, noteId: string) {
    this.id = id;
    this.noteId = noteId;
  }
}
