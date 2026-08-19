export interface IAlunosModel {
    status: TStatusAluno;
    mensagem: string;
}
export type TStatusAluno = 'aprovado' | 'reprovado';