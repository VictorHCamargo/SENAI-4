#include <stdio.h>

int main() {
    int numbers[3];
    int big;
    int small;
    for(int i = 0; i < 3; i++){
        printf("Digite o %d numero: ", i+ 1);
        
        scanf(" %d", &numbers[i]);

        if(i == 0) {
            big = numbers[0];
            small = numbers[0];
        }

        if(numbers[i] > big) {
            big = numbers[i];
        }

        if(numbers[i] < small) {
            small = numbers[i];
        }
    }

    printf("\nO maior numero e: %d\n", big);
    printf("O menor numero e: %d\n", small);

    return 0;
}