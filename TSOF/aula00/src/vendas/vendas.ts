export function calcularDescontos(value: number, discount: number) {
  const valueDiscountMax: number = 100;

  if (discount >= 100 || discount <= 0) {
    return {
      message:
        "Porcentagem do desconto deve estar em valores inteiros, ex: 0.45 => 45",
    };
  }

  const valueDiscounted = value * (discount / 100);

  if (valueDiscounted >= valueDiscountMax) {
    return value - 100;
  } else {
    return value - valueDiscounted;
  }
}
