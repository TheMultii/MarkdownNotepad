import { IsNotEmpty, IsString, IsUUID } from 'class-validator';

export class UUIDDto {
  @IsString()
  @IsNotEmpty()
  @IsUUID()
  id: string;
}
