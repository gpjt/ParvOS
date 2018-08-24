#include <stdint.h>
#include <interrupts.h>
#include <uart.h>

enum
{
    EXCEPTION_TABLE_BASE = 0x00000000,

    EXC_RESET = (EXCEPTION_TABLE_BASE + 0x0),
    EXC_UNDEFINED_INSTRUCTION = (EXCEPTION_TABLE_BASE + 0x4),
    EXC_SOFTWARE_INTERRUPT = (EXCEPTION_TABLE_BASE + 0x8),
    EXC_PREFETCH_ABORT = (EXCEPTION_TABLE_BASE + 0xC),
    EXC_DATA_ABORT = (EXCEPTION_TABLE_BASE + 0x10),
    EXC_RESERVED = (EXCEPTION_TABLE_BASE + 0x14),
    EXC_IRQ = (EXCEPTION_TABLE_BASE + 0x18),
    EXC_FIQ = (EXCEPTION_TABLE_BASE + 0x1C),
};


void __attribute__ ((interrupt ("IRQ"))) irq_handler(void) {
    uart_puts("IRQ!\n");
    while(1);
}


void initialize_exceptions() {
    *((uint32_t*) EXC_IRQ) = (uint32_t) irq_handler;
}


void initialize_interrupts() {
    initialize_exceptions();
}
