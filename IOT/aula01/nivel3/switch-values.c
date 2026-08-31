#include <stdio.h>

void changeByPointers(int *num1, int *num2);

void changeByRefs(int num1, int num2);

int main() {
    int number1 = 20;
    int number2 = 10;
    int *p1 = &number1;
    int *p2 = &number2;

    printf("Valores originais:\n");
    printf(" %d\n",number1);
    printf(" %d\n",number2);

    changeByPointers(p1, p2);

    printf("Valores trocados via ponteiros\n");
    printf(" %d\n",number1);
    printf(" %d\n",number2);

    changeByRefs(number1,number2);

    printf("Valores de referencias funcionam apenas quando envia a outra função");

    return 0;
}


void changeByPointers(int *num1, int *num2){
    *num1 = 40;
    *num2=60;
}

void changeByRefs(int num1, int num2){
    num1= 70;
    num2= 100;

    printf("Valores trocados via referências\n");
    printf(" %d\n",num1);
    printf(" %d\n",num2);
}