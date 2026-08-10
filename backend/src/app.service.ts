import { Injectable } from '@nestjs/common';
import { IApiResponse } from './shared/interfaces/api-response';

@Injectable()
export class AppService {
  getStatus(): IApiResponse {
    return {
      data: [],
      executed: true,
      messages: 'Server ON',
    };
  }
}
