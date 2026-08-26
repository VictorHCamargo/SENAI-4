import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ClassesModule } from './features/classes/classes.module';
import { ConfigModule } from '@nestjs/config';

@Module({
  controllers: [AppController],
  providers: [AppService],
  imports: [
    ClassesModule,
    ConfigModule.forRoot({
      isGlobal: true,
    }),
  ],
})
export class AppModule {}
