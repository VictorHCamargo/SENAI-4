import { expect, test } from "vitest";
import { somar } from "./test.ts";

test("deve somar dois números corretamente", () => {
  expect(somar(1, 1)).toBe(2);
});
