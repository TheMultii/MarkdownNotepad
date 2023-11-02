import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsString, Length, IsOptional } from 'class-validator';

export class NoteDto {
  @ApiProperty()
  @IsString()
  @Length(3, 256)
  title: string;

  @ApiProperty()
  @IsString()
  content: string;

  @ApiProperty()
  @IsString()
  @IsOptional()
  folderId?: string;

  @ApiProperty()
  @IsArray()
  @IsString({ each: true })
  tags?: string[];
}
