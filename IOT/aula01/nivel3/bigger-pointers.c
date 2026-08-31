#include <stdio.h>

void findMinMax(int array[], int size, int *max, int *min) {
    *max = array[0];
    *min = array[0];

    for (int i = 0; i < size; i++) {
        if (array[i] > *max) {
            *max = array[i];
        }
        if (array[i] < *min) {
            *min = array[i];
        }
    }
}

int main() {
    int my_array[] = {10, 20, 5, 40, 30};
    int size = 5;
    
    int high = 0;
    int low = 0;

    findMinMax(my_array, size, &high, &low);

    printf("Max: %d\n", high);
    printf("Min: %d\n", low);

    return 0;
}