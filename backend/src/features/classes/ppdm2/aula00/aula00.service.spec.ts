import { Test, TestingModule } from '@nestjs/testing';
import { Aula00Service } from './aula00.service';
import { FirestoreService } from './firestore.service';

describe('Aula00Service', () => {
  let service: Aula00Service;
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
      providers: [
        Aula00Service,
        { provide: FirestoreService, useValue: firestoreMock },
      ],
    }).compile();

    service = module.get<Aula00Service>(Aula00Service);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('deve iniciar sem alunos cadastrados', async () => {
    const response = await service.getAlunos();
    expect(response.executed).toBe(true);
    expect(response.data).toEqual([]);
  });

  it('deve cadastrar um aluno válido', async () => {
    const response = await service.createAluno({
      nome: 'Maria',
      idade: 20,
      curso: 'ADS',
    });

    expect(response.executed).toBe(true);
    expect(response.data).toHaveLength(1);
    expect(response.data[0]).toMatchObject({
      nome: 'Maria',
      idade: 20,
      curso: 'ADS',
    });
  });

  it('não deve cadastrar aluno sem nome', async () => {
    const response = await service.createAluno({
      nome: '',
      idade: 20,
      curso: 'ADS',
    });

    expect(response.executed).toBe(false);
    expect(response.data).toEqual([]);
  });

  it('deve remover um aluno existente', async () => {
    await service.createAluno({ nome: 'João', idade: 22, curso: 'PPDM' });
    const alunosCadastrados = (await service.getAlunos()).data as typeof alunos;
    const alunoId = alunosCadastrados[0].id;

    const response = await service.deleteAluno(alunoId);

    expect(response.executed).toBe(true);
    expect(response.data).toEqual([]);
  });

  it('deve retornar erro ao remover aluno inexistente', async () => {
    const response = await service.deleteAluno(999);
    expect(response.executed).toBe(false);
  });
});
