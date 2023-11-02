import { ApiProperty } from '@nestjs/swagger';

export class Error401 {
  @ApiProperty({ example: 'Unauthorized' })
  message: string;
  @ApiProperty({ example: '401' })
  statusCode: string;
}
