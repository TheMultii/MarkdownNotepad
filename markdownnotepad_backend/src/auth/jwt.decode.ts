import { JwtService } from '@nestjs/jwt';

export type JwtPayload = {
  username: string;
  iat: number;
  exp: number;
};

export const decodeJwt = (jwtService: JwtService, token: string): JwtPayload =>
  jwtService.decode(token.split(' ')[1]) as JwtPayload;
