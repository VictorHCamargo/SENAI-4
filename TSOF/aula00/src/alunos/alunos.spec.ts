import { describe, expect, it } from "vitest";
import { aprovado } from "./alunos.ts";

describe("alunos", () => {

  it("Se for maior que 10, deve retornar uma mensagem", () => {
    expect(aprovado(11)).toEqual({ mensagem: "Nota inválida" });
  });

  it("Se for menor que 0, deve retornar uma mensagem", () => {
    expect(aprovado(-1)).toEqual({ mensagem: "Nota inválida" });
  });

  it("Se a nota estiver válida e maior que 8, deve retornar uma mensagem e aprovado", () => {
    expect(aprovado(9)).toEqual({ mensagem: "Excelente", status: "aprovado" });
  });

  it("Se a nota estiver válida e maior que 6, deve retornar uma mensagem e aprovado", () => {
    expect(aprovado(6)).toEqual({ mensagem: "Bom", status: "aprovado" });
  });

  it("Se a nota estiver válida e menor que 5, deve retornar uma mensagem e aprovado", () => {
    expect(aprovado(4)).toEqual({
      mensagem: "Tente novamente",
      status: "reprovado",
    });
  });
});
