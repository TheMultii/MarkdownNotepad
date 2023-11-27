import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { EventLog as EventLogModel } from './eventlogs.model';

@Injectable()
export class EventLogsService {
  constructor(private prisma: PrismaService) {}

  async getUsersEventLogs(username: string, page: number) {
    const skip = (page - 1) * 10;

    const userId = await this.prisma.user.findUnique({
      where: {
        username,
      },
      select: {
        id: true,
      },
    });

    if (!userId) {
      return [];
    }

    return await this.prisma.eventLogs.findMany({
      where: {
        userId: userId.id,
      },
      skip,
      take: 10,
    });
  }

  async getNewestUsersEventLog(username: string) {
    const userId = await this.prisma.user.findUnique({
      where: {
        username,
      },
      select: {
        id: true,
      },
    });

    if (!userId) {
      return null;
    }

    return await this.prisma.eventLogs.findFirst({
      where: {
        userId: userId.id,
      },
      orderBy: {
        createdAt: 'desc',
      },
    });
  }

  async addEventLog(eventLog: EventLogModel) {
    return await this.prisma.eventLogs.create({
      data: eventLog,
    });
  }

  async getEventLogsPageCount(userId: string, perPage: number) {
    const count = await this.prisma.eventLogs.count({
      where: {
        userId,
      },
    });

    return Math.ceil(count / perPage);
  }
}
