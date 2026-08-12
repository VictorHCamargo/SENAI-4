import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Aula00Controller } from './aula00.controller';
import { Aula00Service } from './aula00.service';
import { AlunoEntity } from './entities/aluno.entity';

describe('Aula00Controller', () => {
  let controller: Aula00Controller;
  let alunos: AlunoEntity[];
  let nextId: number;

  const repositoryMock = {
    find: jest.fn(() => Promise.resolve([...alunos])),
    create: jest.fn((dto: Partial<AlunoEntity>) => ({ ...dto }) as AlunoEntity),
    save: jest.fn((aluno: AlunoEntity) => {
      const salvo = { ...aluno, id: nextId++ };
      alunos.push(salvo);
      return Promise.resolve(salvo);
    }),
    delete: jest.fn((id: number) => {
      const tamanhoAnterior = alunos.length;
      alunos = alunos.filter((aluno) => aluno.id !== id);
      return Promise.resolve({ affected: tamanhoAnterior - alunos.length });
    }),
  };

  beforeEach(async () => {
    alunos = [];
    nextId = 1;

    const module: TestingModule = await Test.createTestingModule({
      controllers: [Aula00Controller],
      providers: [
        Aula00Service,
        {
          provide: getRepositoryToken(AlunoEntity),
          useValue: repositoryMock,
        },
      ],
    }).compile();

    controller = module.get<Aula00Controller>(Aula00Controller);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('deve listar alunos cadastrados', async () => {
    const response = await controller.getAlunos();
    expect(response.executed).toBe(true);
    expect(response.data).toEqual([]);
  });

  it('deve cadastrar e depois remover um aluno', async () => {
    const created = await controller.createAluno({
      nome: 'Ana',
      idade: 19,
      curso: 'PPDM2',
    });
    expect(created.executed).toBe(true);

    const alunosCadastrados = created.data as AlunoEntity[];
    const id = alunosCadastrados[0].id;
    const removed = await controller.deleteAluno(id);
    expect(removed.executed).toBe(true);
  });
});
