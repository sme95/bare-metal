
// #include "gpio.h"
// #include <avr/io.h>

// // Constructor
// GPIO::GPIO(volatile uint8_t &port, uint8_t pin, GPIO_Mode mode) : port(port), pin(pin) {
//     if (mode == GPIO_OUTPUT) {
//         DDR(port) |= (1 << pin); // Set pin as output
//     } else {
//         DDR(port) &= ~(1 << pin); // Set pin as input
//         if (mode == GPIO_INPUT_PULLUP) {
//             PORT(port) |= (1 << pin);
//         }
//     }
// }

// // Read the pin state
// GPIO_State GPIO::read() {
//     return (PIN(port) & (1 << pin)) ? GPIO_HIGH : GPIO_LOW;
// }

// //Toggle Pin State
// void GPIO::toggle() {
//     PORT(port) ^= (1 << pin); // XOR toggles the bit
// }

