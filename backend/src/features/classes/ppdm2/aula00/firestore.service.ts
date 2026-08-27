import { Injectable } from '@nestjs/common';
import { IAlunoModel } from './interfaces/aluno-model';
import { IFirestoreDocument } from './interfaces/firestore';

@Injectable()
export class FirestoreService {
  private readonly projectId = process.env.FIREBASE_PROJECT_ID;
  private readonly collection = 'alunos';

  async readStudents(): Promise<IFirestoreDocument[]> {
    const response = await this.request<
      IFirestoreDocument[] | { documents?: IFirestoreDocument[] }
    >(`/${this.collection}?orderBy=id`, 'GET');

    if (Array.isArray(response)) {
      return response;
    }

    return response.documents ?? [];
  }

  async createStudent(aluno: IAlunoModel): Promise<void> {
    await this.request(`/${this.collection}?documentId=${aluno.id}`, 'POST', {
      fields: {
        id: { integerValue: String(aluno.id) },
        nome: { stringValue: aluno.nome },
        idade: { integerValue: String(aluno.idade) },
        curso: { stringValue: aluno.curso },
        email: { stringValue: aluno.email },
      },
    });
  }

  async removeStudent(id: number): Promise<boolean> {
    const response = await fetch(this.url(`/${this.collection}/${id}`), {
      method: 'DELETE',
    });

    if (response.status === 404) {
      return false;
    }
    await this.ensureSuccess(response);
    return true;
  }

  async updateStudent(aluno: IAlunoModel): Promise<void> {
    await this.request(`/${this.collection}/${aluno.id}`, 'PATCH', {
      fields: {
        id: { integerValue: String(aluno.id) },
        nome: { stringValue: aluno.nome },
        idade: { integerValue: String(aluno.idade) },
        curso: { stringValue: aluno.curso },
        email: { stringValue: aluno.email },
      },
    });
  }

  documentToStudent(document: IFirestoreDocument): IAlunoModel {
    const fields = document.fields ?? {};
    const id = Number(
      fields.id?.integerValue ?? document.name?.split('/').pop(),
    );

    return {
      id,
      nome: fields.nome?.stringValue ?? '',
      idade: Number(fields.idade?.integerValue ?? 0),
      curso: fields.curso?.stringValue ?? '',
      email: fields.email?.stringValue ?? '',
    };
  }

  private async request<T = unknown>(
    path: string,
    method: 'GET' | 'POST' | 'PATCH',
    body?: object,
  ): Promise<T> {
    const response = await fetch(this.url(path), {
      method,
      headers: body ? { 'Content-Type': 'application/json' } : undefined,
      body: body ? JSON.stringify(body) : undefined,
    });

    await this.ensureSuccess(response);
    return (await response.json()) as T;
  }

  private url(path: string): string {
    if (!this.projectId) {
      throw new Error(
        'FIREBASE_PROJECT_ID não foi configurado no ambiente do backend',
      );
    }

    return `https://firestore.googleapis.com/v1/projects/${this.projectId}/databases/(default)/documents${path}`;
  }

  private async ensureSuccess(response: Response): Promise<void> {
    if (response.ok) {
      return;
    }

    const details = await response.text();
    throw new Error(`Firestore retornou ${response.status}: ${details}`);
  }
}
