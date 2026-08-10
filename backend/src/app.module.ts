import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ClassesModule } from './features/classes/classes.module';

@Module({
  controllers: [AppController],
  providers: [AppService],
  imports: [ClassesModule],
})
export class AppModule {}
