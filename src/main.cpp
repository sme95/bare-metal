#include <avr/io.h>

void delay_ms(unsigned int ms) {
    while (ms--) {
        for (volatile unsigned int i = 0; i < 1000; i++) {

        }
    }
}

int main() {
    PORTB.DIRSET = PIN5_bm; // Set Pin 5 of PORTB as output

    while (1) {
        PORTB.OUTTGL = PIN5_bm; // Toggle Pin 5 of PORTB
        delay_ms(1000);
    }

    return 0;
}