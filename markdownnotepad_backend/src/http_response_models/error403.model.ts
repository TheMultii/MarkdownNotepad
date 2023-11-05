import { ApiProperty } from '@nestjs/swagger';

export class Error403 {
  @ApiProperty({ example: 'Forbidden' })
  message: string;
}
