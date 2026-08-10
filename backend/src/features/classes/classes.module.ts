import { Module } from '@nestjs/common';
import { Pend2Module } from './pend2/pend2.module';

@Module({
  imports: [Pend2Module],
})
export class ClassesModule {}
