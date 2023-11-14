import { ApiProperty } from '@nestjs/swagger';
import {
  IsEmail,
  IsOptional,
  IsString,
  Length,
  MaxLength,
} from 'class-validator';

export class UserOptionalDto {
  @ApiProperty()
  @IsOptional()
  @IsEmail()
  @Length(4, 320)
  email: string;

  @ApiProperty()
  @IsOptional()
  @IsString()
  @MaxLength(100)
  bio?: string;

  @ApiProperty()
  @IsOptional()
  @IsString()
  @MaxLength(32)
  name?: string;

  @ApiProperty()
  @IsOptional()
  @IsString()
  @MaxLength(32)
  surname?: string;

  @ApiProperty()
  @IsOptional()
  @IsString()
  @Length(8, 32)
  password: string;
}
