#include <stdint.h>
#include <interrupts.h>
#include <uart.h>

extern void move_exception_vector(void);


void __attribute__ ((interrupt ("ABORT"))) reset_handler(void) {
    uart_puts("RESET HANDLER\n");
    while(1);
}

void __attribute__ ((interrupt ("ABORT"))) prefetch_abort_handler(void) {
    uart_puts("PREFETCH ABORT HANDLER\n");
    while(1);
}

void __attribute__ ((interrupt ("ABORT"))) data_abort_handler(void) {
    uart_puts("DATA ABORT HANDLER\n");
    while(1);
}

void __attribute__ ((interrupt ("UNDEF"))) undefined_instruction_handler(void) {
    uart_puts("UNDEFINED INSTRUCTION HANDLER\n");
    while(1);
}

void __attribute__ ((interrupt ("SWI"))) software_interrupt_handler(void) {
    uart_puts("SWI HANDLER\n");
    while(1);
}

void __attribute__ ((interrupt ("FIQ"))) fast_irq_handler(void) {
    uart_puts("FIQ HANDLER\n");
    while(1);
}

void irq_handler(void) {
    uart_puts("IRQ HANDLER\n");
    while(1);
}

#define PERIPHERAL_BASE 0x3F000000
#define INTERRUPTS_OFFSET 0xB000

#define INTERRUPTS_BASE (PERIPHERAL_BASE + INTERRUPTS_OFFSET)
#define INTERRUPTS_PENDING (INTERRUPTS_BASE + 0x200)

typedef struct {
    uint32_t irq_basic_pending;
    uint32_t irq_gpu_pending1;
    uint32_t irq_gpu_pending2;
    uint32_t fiq_control;
    uint32_t irq_gpu_enable1;
    uint32_t irq_gpu_enable2;
    uint32_t irq_basic_enable;
    uint32_t irq_gpu_disable1;
    uint32_t irq_gpu_disable2;
    uint32_t irq_basic_disable;
} interrupt_registers_t;

static interrupt_registers_t * interrupt_regs;

__inline__ int INTERRUPTS_ENABLED(void) {
    int res;
    __asm__ __volatile__("mrs %[res], CPSR": [res] "=r" (res)::);
    return ((res >> 7) & 1) == 0;
}

__inline__ void ENABLE_INTERRUPTS(void) {
    if (!INTERRUPTS_ENABLED()) {
        __asm__ __volatile__("cpsie i");
    }
}

__inline__ void DISABLE_INTERRUPTS(void) {
    if (INTERRUPTS_ENABLED()) {
        __asm__ __volatile__("cpsid i");
    }
}


void initialize_interrupts() {
    interrupt_regs = (interrupt_registers_t *) INTERRUPTS_PENDING;
    interrupt_regs->irq_basic_disable = 0xffffffff; // disable all interrupts
    interrupt_regs->irq_gpu_disable1 = 0xffffffff;
    interrupt_regs->irq_gpu_disable2 = 0xffffffff;

    uart_puts("About to move exception vector...");
    move_exception_vector();
    uart_puts(" done!\n");

    uart_puts("Enabling interrupts...");
    ENABLE_INTERRUPTS();
    uart_puts(" done!\n");
}
