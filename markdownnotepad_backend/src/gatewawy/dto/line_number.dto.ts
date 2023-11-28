import { ApiProperty } from '@nestjs/swagger';
import { IsInt, IsNumber, Min } from 'class-validator';

export class LineNumberDto {
  @ApiProperty()
  @IsNumber()
  @IsInt()
  @Min(0)
  lineNumber: number;
}
