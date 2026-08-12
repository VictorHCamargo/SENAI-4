import { Module } from '@nestjs/common';
import { Pend2Module } from './pend2/pend2.module';
import { Ppdm2Module } from './ppdm2/ppdm2.module';

@Module({
  imports: [Pend2Module, Ppdm2Module],
})
export class ClassesModule {}
