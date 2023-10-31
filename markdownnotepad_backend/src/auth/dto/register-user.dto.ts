import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsString, Length } from '@nestjs/class-validator';

export class RegisterDto {
  @ApiProperty()
  @IsString()
  @Length(4, 20)
  username: string;

  @ApiProperty()
  @IsEmail()
  @Length(4, 320)
  email: string;

  @ApiProperty()
  @IsString()
  @Length(8, 32)
  password: string;
}
