import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { IApiResponse } from 'src/shared/interfaces/api-response';
import { AlunoEntity } from './entities/aluno.entity';
import { ICreateAlunoDto } from './dto/create-aluno.dto';

@Injectable()
export class Aula00Service {
  constructor(
    @InjectRepository(AlunoEntity)
    private readonly alunoRepository: Repository<AlunoEntity>,
  ) {}

  async getAlunos(): Promise<IApiResponse> {
    const alunos = await this.alunoRepository.find({ order: { id: 'ASC' } });

    return {
      messages: '',
      data: alunos,
      executed: true,
    };
  }

  async createAluno(dto: ICreateAlunoDto): Promise<IApiResponse> {
    const erro = this.validar(dto);
    if (erro) {
      return {
        messages: erro,
        data: [],
        executed: false,
      };
    }

    const aluno = this.alunoRepository.create({
      nome: dto.nome.trim(),
      idade: Number(dto.idade),
      curso: dto.curso.trim(),
    });
    await this.alunoRepository.save(aluno);

    const alunos = await this.alunoRepository.find({ order: { id: 'ASC' } });

    return {
      messages: 'Aluno cadastrado com sucesso',
      data: alunos,
      executed: true,
    };
  }

  async deleteAluno(id: number): Promise<IApiResponse> {
    const resultado = await this.alunoRepository.delete(id);

    const alunos = await this.alunoRepository.find({ order: { id: 'ASC' } });

    if (!resultado.affected) {
      return {
        messages: 'Aluno não encontrado',
        data: alunos,
        executed: false,
      };
    }

    return {
      messages: 'Aluno removido com sucesso',
      data: alunos,
      executed: true,
    };
  }

  private validar(dto: ICreateAlunoDto): string | null {
    if (!dto.nome || !dto.nome.trim()) {
      return 'Nome é obrigatório';
    }
    if (
      dto.idade === undefined ||
      dto.idade === null ||
      isNaN(Number(dto.idade))
    ) {
      return 'Idade é obrigatória e deve ser um número';
    }
    if (Number(dto.idade) <= 0) {
      return 'Idade deve ser maior que zero';
    }
    if (!dto.curso || !dto.curso.trim()) {
      return 'Curso é obrigatório';
    }
    return null;
  }
}
