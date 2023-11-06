import { Module } from '@nestjs/common';
import { MiscController } from './misc.controller';

@Module({
  controllers: [MiscController],
  providers: [],
  imports: [],
})
export class MiscModule {}
