import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Aula00Service } from './aula00.service';
import { AlunoEntity } from './entities/aluno.entity';

describe('Aula00Service', () => {
  let service: Aula00Service;
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
      providers: [
        Aula00Service,
        {
          provide: getRepositoryToken(AlunoEntity),
          useValue: repositoryMock,
        },
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
    const alunosCadastrados = (await service.getAlunos()).data as AlunoEntity[];
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
