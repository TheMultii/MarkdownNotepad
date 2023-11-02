import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';

@Injectable()
export class CatalogsService {
  constructor(private prisma: PrismaService) {}
}
