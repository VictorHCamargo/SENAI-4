#include <stdio.h>

int main() {
    int numbers[10];
    int numberSearch;
    bool getNumberForSearch = false;
    bool endGetNumbers = false;
    printf("Digite 10 numeros para continuar\n");
    for(int i = 0; i<11; i++) {
        if(i == 10 || endGetNumbers) {
            if(!endGetNumbers) {
                i=0;
                printf("Digite um valor que deseja procurar nesse vetor: ");
                scanf(" %d",&numberSearch);
            }

            if(numberSearch == numbers[i]) {
                getNumberForSearch = true;
            }

            endGetNumbers = true;
        } else {
            printf("Digite um numero: ");
            scanf(" %d",&numbers[i]);
        }
    }

    if(getNumberForSearch) {
        printf("Esse numero existe em seu vetor!");
    } else {
        printf("Esse numero nao existe em seu vetor!");
    }

    return 0;
}