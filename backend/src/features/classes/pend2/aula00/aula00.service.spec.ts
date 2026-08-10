import { Test, TestingModule } from '@nestjs/testing';
import { Aula00Service } from './aula00.service';

describe('Aula00Service', () => {
  let service: Aula00Service;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [Aula00Service],
    }).compile();

    service = module.get<Aula00Service>(Aula00Service);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
