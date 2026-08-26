import { IAlunoModel } from '../interfaces/aluno-model';

export interface ICreateAlunoDto extends Omit<IAlunoModel, 'id'> {
  nome: string;
  idade: number;
  curso: string;
  email: string;
}

export interface IUpdateAlunoDto extends Omit<IAlunoModel, 'id'> {
  nome: string;
  idade: number;
  curso: string;
  email: string;
}
