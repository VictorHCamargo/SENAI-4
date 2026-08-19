import { Injectable } from '@nestjs/common';

interface FirestoreValue {
  stringValue?: string;
  integerValue?: string;
}

interface FirestoreDocument {
  name?: string;
  fields?: Record<string, FirestoreValue>;
}

@Injectable()
export class FirestoreService {
  private readonly projectId = '';
  private readonly collection = 'alunos';

  async listarAlunos(): Promise<FirestoreDocument[]> {
    const response = await this.request<
      FirestoreDocument[] | { documents?: FirestoreDocument[] }
    >(`/${this.collection}?orderBy=id`, 'GET');

    if (Array.isArray(response)) {
      return response;
    }

    return response.documents ?? [];
  }

  async criarAluno(aluno: {
    id: number;
    nome: string;
    idade: number;
    curso: string;
  }): Promise<void> {
    await this.request(`/${this.collection}?documentId=${aluno.id}`, 'POST', {
      fields: {
        id: { integerValue: String(aluno.id) },
        nome: { stringValue: aluno.nome },
        idade: { integerValue: String(aluno.idade) },
        curso: { stringValue: aluno.curso },
      },
    });
  }

  async removerAluno(id: number): Promise<boolean> {
    const response = await fetch(this.url(`/${this.collection}/${id}`), {
      method: 'DELETE',
    });

    if (response.status === 404) {
      return false;
    }
    await this.ensureSuccess(response);
    return true;
  }

  documentoParaAluno(documento: FirestoreDocument) {
    const fields = documento.fields ?? {};
    const id = Number(
      fields.id?.integerValue ?? documento.name?.split('/').pop(),
    );

    return {
      id,
      nome: fields.nome?.stringValue ?? '',
      idade: Number(fields.idade?.integerValue ?? 0),
      curso: fields.curso?.stringValue ?? '',
    };
  }

  private async request<T = unknown>(
    path: string,
    method: 'GET' | 'POST',
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
