import { Injectable } from '@nestjs/common';
import { IApiResponse } from 'src/shared/interfaces/api-response';
import { ICreateAlunoDto } from './dto/create-aluno.dto';
import { FirestoreService } from './firestore.service';

@Injectable()
export class Aula00Service {
  constructor(private readonly firestoreService: FirestoreService) {}

  async getAlunos(): Promise<IApiResponse> {
    const documentos = await this.firestoreService.listarAlunos();
    const alunos = documentos.map((documento) =>
      this.firestoreService.documentoParaAluno(documento),
    );

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

    const aluno = {
      id: Date.now(),
      nome: dto.nome.trim(),
      idade: Number(dto.idade),
      curso: dto.curso.trim(),
    };
    await this.firestoreService.criarAluno(aluno);

    const alunos = (await this.getAlunos()).data;

    return {
      messages: 'Aluno cadastrado com sucesso',
      data: alunos,
      executed: true,
    };
  }

  async deleteAluno(id: number): Promise<IApiResponse> {
    const removido = await this.firestoreService.removerAluno(id);

    const alunos = (await this.getAlunos()).data;

    if (!removido) {
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
