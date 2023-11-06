import { ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsString, Length } from 'class-validator';

export class CatalogDtoOptional {
  @ApiProperty()
  @IsString()
  @IsOptional()
  @Length(3, 256)
  title: string;
}
