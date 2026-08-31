#include <stdio.h>

int main() {
    int notes[4] = {7,10,4,4};
    int allNote = 0;

    for(int i = 0; i< 4; i++ ) {
        allNote += notes[i];
    }

    float average = allNote / 4;

    if(average >= 7.0) {
        printf("Aprovado, com média: %.2f\n",average);
    } else if (5.0 <= average < 7.0)
    {
        printf("Em recuperação, com média: %.2f\n",average);
    } else if (average < 5.0)
    {
        printf("Reprovado com média: %.2f\n",average);
    }


    return 0;
}