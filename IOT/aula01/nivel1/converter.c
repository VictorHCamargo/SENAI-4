#include <stdio.h>

int main() {
    float tempInCelsius = 30;

    float tempInKelvin = tempInCelsius + 273.15;

    float tempInFahrenheit = (tempInCelsius * 9/5) + 32;


    printf("Temperatura em Fahrenheit: %.2f\n", tempInFahrenheit);

    printf("Temperatura em Kelvin: %.2f\n", tempInKelvin);

    return 0;
}