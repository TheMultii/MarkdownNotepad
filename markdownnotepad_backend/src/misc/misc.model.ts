import { ApiProperty } from '@nestjs/swagger';

export class ApiBasicInfoModel {
  @ApiProperty()
  name: string;
  @ApiProperty()
  time: string;

  constructor(name: string, time: string) {
    this.name = name;
    this.time = time;
  }
}
