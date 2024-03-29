import { ApiProperty } from '@nestjs/swagger';
import { IsHexColor, IsString, Length } from 'class-validator';

export class NoteTagDto {
  @ApiProperty()
  @IsString()
  @Length(2, 10)
  title: string;

  @ApiProperty()
  @IsString()
  @IsHexColor()
  color: string;
}
