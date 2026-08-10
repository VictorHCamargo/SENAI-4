import { Injectable } from '@nestjs/common';
import { IApiResponse } from 'src/shared/interfaces/api-response';
import { ISensorsModel } from './interfaces/sensors-model';

@Injectable()
export class Aula00Service {
  private sensors: ISensorsModel[] = [
    {
      id: 1,
      nome: 'Sensor Galpão A',
      tipo: 'Temperatura',
      valor: 24.5,
      unidade: '°C',
      status: 'normal',
    },
    {
      id: 2,
      nome: 'Sensor Estufa 02',
      tipo: 'Umidade',
      valor: 88.0,
      unidade: '%',
      status: 'critico',
    },
    {
      id: 3,
      nome: 'Sensor Compressor',
      tipo: 'Pressão',
      valor: 6.2,
      unidade: 'bar',
      status: 'normal',
    },
    {
      id: 4,
      nome: 'Sensor Câmara Fria',
      tipo: 'Temperatura',
      valor: -2.1,
      unidade: '°C',
      status: 'normal',
    },
    {
      id: 5,
      nome: 'Sensor Almoxarifado',
      tipo: 'Umidade',
      valor: 45.5,
      unidade: '%',
      status: 'normal',
    },
    {
      id: 6,
      nome: 'Sensor Caldeira',
      tipo: 'Temperatura',
      valor: 98.4,
      unidade: '°C',
      status: 'critico',
    },
  ];

  getSensors(): IApiResponse {
    return {
      messages: '',
      data: this.sensors,
      executed: true,
    };
  }

  updateSensors(): IApiResponse {
    this.sensors.forEach((sensor) => {
      const variacao = Number((Math.random() * 9 - 4.5).toFixed(1));
      sensor.valor = Number((sensor.valor + variacao).toFixed(1));
      this.applyLimits(sensor);
      this.checkCritical(sensor);
    });

    return {
      messages: '',
      data: this.sensors,
      executed: true,
    };
  }

  private checkCritical(sensor: ISensorsModel): void {
    if (sensor.tipo === 'Temperatura' && sensor.valor > 35) {
      sensor.status = 'critico';
    } else if (sensor.tipo === 'Umidade' && sensor.valor > 80) {
      sensor.status = 'critico';
    } else if (sensor.tipo === 'Pressão' && sensor.valor > 8) {
      sensor.status = 'critico';
    } else {
      sensor.status = 'normal';
    }
  }

  private applyLimits(sensor: ISensorsModel): void {
    if (sensor.tipo === 'Pressão' && sensor.valor < 0) {
      sensor.valor = 0;
    }
    if (sensor.tipo === 'Umidade') {
      sensor.valor = Math.min(100, Math.max(0, sensor.valor));
    }
  }
}
