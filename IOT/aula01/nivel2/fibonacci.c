#include <stdio.h>

int main() {
    int number;
    int t1 = 0, t2 = 1, nextStep;

    printf("Digite a quantidade de termos: ");
    scanf("%d", &number);

    for (int i = 0; i < number; i++) {

        printf("A casa %d da sequencia de Fibonacci e: %d\n", i, t1);
        
        nextStep = t1 + t2;
        t1 = t2;
        t2 = nextStep;
    }

    return 0;
}