import { Module } from '@nestjs/common';
import { Aula00Module } from './aula00/aula00.module';
import { RouterModule } from '@nestjs/core';

@Module({
  imports: [
    Aula00Module,
    RouterModule.register([
      {
        path: 'aulas/ppdm2',
        module: Aula00Module,
      },
    ]),
  ],
})
export class Ppdm2Module {}
