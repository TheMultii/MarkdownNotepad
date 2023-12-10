import { ApiProperty } from '@nestjs/swagger';
import { IsString, Length, Matches } from 'class-validator';

export class LoginDto {
  @ApiProperty()
  @IsString()
  @Matches(/^[a-zA-Z0-9]+$/, {
    message: 'Username must contain only letters and numbers',
  })
  @Length(4, 20)
  username: string;

  @ApiProperty()
  @IsString()
  @Length(8, 32)
  password: string;
}
