import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsString, Length, Matches } from '@nestjs/class-validator';

export class RegisterDto {
  @ApiProperty()
  @IsString()
  @Matches(/^[a-zA-Z0-9]+$/, {
    message: 'Username must contain only letters and numbers',
  })
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
