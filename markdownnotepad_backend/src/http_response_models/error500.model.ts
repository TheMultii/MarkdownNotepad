import { ApiProperty } from '@nestjs/swagger';

export class Error500 {
  @ApiProperty({ example: 'Internal Server Error' })
  message: string;
  @ApiProperty({ example: 'Something went wrong at line #13' })
  error: string;
}
