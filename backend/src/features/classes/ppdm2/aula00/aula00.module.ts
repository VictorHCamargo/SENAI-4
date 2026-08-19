import { Module } from '@nestjs/common';
import { Aula00Controller } from './aula00.controller';
import { Aula00Service } from './aula00.service';
import { FirestoreService } from './firestore.service';

@Module({
  controllers: [Aula00Controller],
  providers: [Aula00Service, FirestoreService],
})
export class Aula00Module {}
