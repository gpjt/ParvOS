#include <serial.h>
#include <interrupts.h>

extern void io_halt(void);


void kernel_main(void)
{
    serial_init();
    serial_puts("Booting ParvOS\n");

    serial_puts("Initializing interrupts... ");
    initialize_interrupts();
    serial_puts("done!\n");

    io_halt();
}
