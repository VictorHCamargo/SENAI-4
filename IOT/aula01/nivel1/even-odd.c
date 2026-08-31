#include <stdio.h>

int main() {
    int number = 1;

    bool isEven = (number % 2) == 0;

    printf(isEven ? "É par" : "É impar");

    return 0;
}