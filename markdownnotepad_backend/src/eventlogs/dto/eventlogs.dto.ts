import { IsInt, IsNumber, Min } from 'class-validator';
import { Type } from 'class-transformer';

export class EventLogsDto {
  @Type(() => Number)
  @IsNumber()
  @IsInt()
  @Min(1)
  page: number;
}
