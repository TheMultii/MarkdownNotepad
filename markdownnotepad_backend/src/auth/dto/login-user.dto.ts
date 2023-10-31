import { ApiProperty } from '@nestjs/swagger';
import { IsString, Length } from 'class-validator';

export class LoginDto {
  @ApiProperty()
  @IsString()
  @Length(4, 20)
  username: string;

  @ApiProperty()
  @IsString()
  @Length(8, 32)
  password: string;
}
