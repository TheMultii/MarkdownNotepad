import { ApiProperty } from '@nestjs/swagger';

export class Error400 {
  @ApiProperty({ example: 'Forbidden' })
  message: string;
}
