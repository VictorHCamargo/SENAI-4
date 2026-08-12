import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { mkdirSync } from 'fs';
import { join } from 'path';

const dataDir = join(process.cwd(), 'data');
mkdirSync(dataDir, { recursive: true });

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'sqljs',
      autoSave: true,
      location: join(dataDir, 'ppdm2.sqlite'),
      entities: [join(__dirname, '..', '**', '*.entity{.ts,.js}')],
      synchronize: true,
    }),
  ],
})
export class DatabaseModule {}
