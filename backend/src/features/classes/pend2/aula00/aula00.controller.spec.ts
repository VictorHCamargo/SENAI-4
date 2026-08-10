import { Test, TestingModule } from '@nestjs/testing';
import { Aula00Controller } from './aula00.controller';

describe('Aula00Controller', () => {
  let controller: Aula00Controller;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [Aula00Controller],
    }).compile();

    controller = module.get<Aula00Controller>(Aula00Controller);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
