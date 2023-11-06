import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsOptional, IsString, Length } from 'class-validator';

export class UserOptionalDto {
  @ApiProperty()
  @IsOptional()
  @IsString()
  @Length(4, 20)
  username?: string;

  @ApiProperty()
  @IsOptional()
  @IsEmail()
  @Length(4, 320)
  email: string;

  @ApiProperty()
  @IsOptional()
  @IsString()
  @Length(1, 32)
  name?: string;

  @ApiProperty()
  @IsOptional()
  @IsString()
  @Length(1, 32)
  surname?: string;

  @ApiProperty()
  @IsOptional()
  @IsString()
  @Length(8, 32)
  password: string;
}
