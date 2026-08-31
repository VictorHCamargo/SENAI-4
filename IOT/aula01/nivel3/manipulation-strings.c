#include <stdio.h>

void convertToUppercase(char text[]) {
    for (int i = 0; text[i] != '\0'; i++) {
        if (text[i] >= 'a' && text[i] <= 'z') {
            text[i] = text[i] - 32;
        }
    }
}

int main() {
    char text[] = "hello";
    convertToUppercase(text);
    printf("%s\n", text);

    return 0;
}