#include <stdio.h>

int main() {
    int number;

    printf("Digite um número: ");
    scanf(" %d",&number);

    for(int i = number-1; i > 0; i--) {
        number *= i;
    }

    printf("O fatorial do numero, é igual: %d",number );

    return 0;
}