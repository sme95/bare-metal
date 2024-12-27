#ifndef GPIO_H
#define GPIO_H
// Macros to map a port reference to its corresponding DDR, PORT, and PIN registers
#define DDR(x) (*(&x - 1))  // Data Direction Register (DDRx) is at PORTx - 1
#define PIN(x) (*(&x - 2))  // PIN Register (PINx) is at PORTx - 2
#define PORT(x) (x)         // PORT Register (PORTx) is the port itself



#include <avr/io.h>

enum GPIO_Mode {
    GPIO_INPUT,
    GPIO_INPUT_PULLUP,
    GPIO_OUTPUT
};

enum GPIO_State {
    GPIO_LOW = 0,
    GPIO_HIGH = 1
};

class GPIO {
public:
    GPIO(volatile uint8_t &port, uint8_t pin, GPIO_Mode mode);
    GPIO_State read();
    void toggle();

private: 
    volatile uint8_t &port; // Port Register (PORTB, PORTC, etc.)
    uint8_t pin; // Pin number
};

#endif
