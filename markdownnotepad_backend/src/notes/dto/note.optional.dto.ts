import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsString, Length, IsOptional } from 'class-validator';

export class NoteDto {
  @ApiProperty()
  @IsString()
  @IsOptional()
  @Length(3, 256)
  title: string;

  @ApiProperty()
  @IsString()
  @IsOptional()
  content: string;

  @ApiProperty()
  @IsString()
  @IsOptional()
  folderId?: string;

  @ApiProperty()
  @IsArray()
  @IsOptional()
  @IsString({ each: true })
  tags?: string[];
}
