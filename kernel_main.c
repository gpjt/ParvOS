#include <uart.h>
#include <interrupts.h>

void kernel_main(void) {
    uart_init();
    uart_puts("Booting ParvOS\n");

    uart_puts("Initializing interrupts... ");
    initialize_interrupts();
    uart_puts("done!");
}
