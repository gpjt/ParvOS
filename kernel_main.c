#include <uart.h>

void kernel_main(void) {
    uart_init();
    uart_puts("Booting ParvOS\n");
}
