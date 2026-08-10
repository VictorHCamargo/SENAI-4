import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import type { IApiResponse } from './shared/interfaces/api-response';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('health')
  getStatus(): IApiResponse {
    return this.appService.getStatus();
  }
}
