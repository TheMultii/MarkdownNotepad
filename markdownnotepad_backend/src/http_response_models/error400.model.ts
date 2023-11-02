import { ApiProperty } from '@nestjs/swagger';

export class Error400 {
  @ApiProperty({ example: 'Bad request' })
  message: string;
}
