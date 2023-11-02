import { ApiProperty } from '@nestjs/swagger';

export class Error404 {
  @ApiProperty({ example: 'Not found' })
  message: string;
}
