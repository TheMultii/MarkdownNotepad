import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';

@Injectable()
export class EventLogsService {
  constructor(private prisma: PrismaService) {}
}
