#include <stdio.h>

int main() {
    int numbers[5];

    for(int i = 0; i < 5; i++) {
        printf("Digite um numero: ");
        scanf("%d", &numbers[i]);
    }

    printf("A array invertida fica: ");
    for(int i = 4; i >= 0; i--) {
        printf("%d ", numbers[i]);
    }

    return 0;
}