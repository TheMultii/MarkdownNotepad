import { JwtService } from '@nestjs/jwt';
import { JwtModel } from './jwt.model';
import { validate } from 'class-validator';

export type JwtPayload = {
  username: string;
  iat: number;
  exp: number;
};

export const decodeJwt = async (
  jwtService: JwtService,
  token: string,
): Promise<JwtPayload> => {
  if (!token) throw new Error('Missing authorization header');
  if (!token?.split(' ')?.[1]) throw new Error('Missing token');

  const tokenObj = new JwtModel(token?.split(' ')?.[1]);
  const errors = await validate(tokenObj);
  if (errors.length > 0) throw new Error('Invalid token');

  return jwtService.decode(tokenObj.token) as JwtPayload;
};
