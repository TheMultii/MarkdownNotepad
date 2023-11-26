import { ApiProperty } from '@nestjs/swagger';
import { IsHexColor, IsOptional, IsString, Length } from 'class-validator';

export class NoteTagOptionalDto {
  @ApiProperty()
  @IsString()
  @IsOptional()
  @Length(2, 10)
  title: string;

  @ApiProperty()
  @IsString()
  @IsOptional()
  @IsHexColor()
  color: string;
}
