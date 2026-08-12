import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Aula00Controller } from './aula00.controller';
import { Aula00Service } from './aula00.service';
import { AlunoEntity } from './entities/aluno.entity';

@Module({
  imports: [TypeOrmModule.forFeature([AlunoEntity])],
  controllers: [Aula00Controller],
  providers: [Aula00Service],
})
export class Aula00Module {}
