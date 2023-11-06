import { IsDefined, IsJWT, IsString } from 'class-validator';

export class JwtModel {
  @IsString()
  @IsDefined()
  @IsJWT()
  token: string;

  constructor(token: string) {
    this.token = token;
  }
}
