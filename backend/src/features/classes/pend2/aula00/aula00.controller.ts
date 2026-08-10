import { Controller, Get, Patch } from '@nestjs/common';
import { Aula00Service } from './aula00.service';

@Controller('aula00')
export class Aula00Controller {
  constructor(private readonly aulaService: Aula00Service) {}

  @Get('sensors')
  getSensors(): any {
    return this.aulaService.getSensors();
  }

  @Patch('sensors')
  updateSensors(): any {
    return this.aulaService.updateSensors();
  }
}
