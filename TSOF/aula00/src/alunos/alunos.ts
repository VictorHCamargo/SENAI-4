import { IAlunosModel, TStatusAluno } from "./interfaces/alunos.model.ts";

export function aprovado(nota: number) {
  if (nota >= 10 || nota <= 0) return { mensagem: "Nota inválida" };
  if (nota > 8) {
    return dto("Excelente", "aprovado");
  } else if (nota >= 5) {
    return dto("Bom", "aprovado");
  } else {
    return dto("Tente novamente", "reprovado");
  }
}

function dto(text: string, status: TStatusAluno): IAlunosModel {
  return {
    mensagem: text,
    status,
  };
}
