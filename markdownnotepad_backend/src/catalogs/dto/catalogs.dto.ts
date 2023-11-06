import { ApiProperty } from '@nestjs/swagger';
import { IsString, Length } from 'class-validator';

export class CatalogDto {
  @ApiProperty()
  @IsString()
  @Length(3, 256)
  title: string;
}
