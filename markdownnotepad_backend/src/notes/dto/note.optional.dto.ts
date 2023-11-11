import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsString, Length, IsOptional } from 'class-validator';

export class NoteDtoOptional {
  @ApiProperty()
  @IsString()
  @IsOptional()
  @Length(3, 256)
  title?: string;

  @ApiProperty()
  @IsString()
  @IsOptional()
  content?: string;

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
