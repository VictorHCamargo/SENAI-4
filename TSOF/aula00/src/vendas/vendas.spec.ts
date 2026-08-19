import { describe, expect, it } from "vitest";
import { calcularDescontos } from "./vendas.ts";

describe('calcular desconto', () => {
    it('validação de desconto, se entrar maior que 100, deve retornar uma mensagem',() => {
        expect(calcularDescontos(20, 120)).toEqual({
          message:
            "Porcentagem do desconto deve estar em valores inteiros, ex: 0.45 => 45",
        });
    })

    it("validação de desconto, se entrar menor que 0, deve retornar uma mensagem", () => {
      expect(calcularDescontos(20, -20)).toEqual({
        message:
          "Porcentagem do desconto deve estar em valores inteiros, ex: 0.45 => 45",
      });
    });

    it('Se valor descontado é menor que 100, retornar o valor menos o valor descontado',() => {
        expect(calcularDescontos(400,20)).toBe(320)
    })

    it("Se valor descontado é maior que 100, retornar o valor menos 100", () => {
      expect(calcularDescontos(400, 50)).toBe(300);
    });
})