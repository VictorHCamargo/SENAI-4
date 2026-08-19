import { Test, TestingModule } from '@nestjs/testing';
import { Aula00Controller } from './aula00.controller';
import { Aula00Service } from './aula00.service';
import { FirestoreService } from './firestore.service';

describe('Aula00Controller', () => {
  let controller: Aula00Controller;
  let alunos: Array<{ id: number; nome: string; idade: number; curso: string }>;
  let nextId: number;

  const firestoreMock = {
    listarAlunos: jest.fn(() => Promise.resolve(alunos)),
    documentoParaAluno: jest.fn((aluno) => aluno),
    criarAluno: jest.fn((aluno) => {
      alunos.push({ ...aluno, id: nextId++ });
      return Promise.resolve();
    }),
    removerAluno: jest.fn((id: number) => {
      const tamanhoAnterior = alunos.length;
      alunos = alunos.filter((aluno) => aluno.id !== id);
      return Promise.resolve(tamanhoAnterior !== alunos.length);
    }),
  };

  beforeEach(async () => {
    alunos = [];
    nextId = 1;

    const module: TestingModule = await Test.createTestingModule({
      controllers: [Aula00Controller],
      providers: [
        Aula00Service,
        { provide: FirestoreService, useValue: firestoreMock },
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

    const alunosCadastrados = created.data as typeof alunos;
    const id = alunosCadastrados[0].id;
    const removed = await controller.deleteAluno(id);
    expect(removed.executed).toBe(true);
  });
});
