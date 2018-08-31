#include <stdint.h>
#include <interrupts.h>

#include <mmio.h>
#include <serial.h>
#include <util.h>

extern void install_exception_vector(void);
extern void enable_irq(void);

// Read the count frequency.  This is annoyingly hard to get
// documentation for.  The docs at
// http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0360f/CHDGIJFB.html
// say that c14 is the "Counter Frequency Register, see the ARM Architecture Reference Manual",
// but the ARM Architecture Reference Manual is only available for download
// to registered ARM customers.
// Anyway, the code below runs the given assembly.  Said assembly says
// * move from co-processor 15, command zero, to %0, co-processor register
//   14, opcode 0.
// Basically, it seems to be reading a value from the co-processor that
// says what the generic system timer's frequency is.
uint32_t read_cntfrq(void)
{
    uint32_t val;
    asm volatile ("mrc p15, 0, %0, c14, c0, 0" : "=r"(val) );
    return val;
}

// Another one it's hard to get docs for.   This looks relevant:
// https://developer.arm.com/docs/ddi0500/e/generic-timer/generic-timer-register-summary/aarch32-generic-timer-register-summary
// I *think* what we're saying is, "generate an IRQ in val time-units",
// where there are cntfrq time units per second.
void write_cntv_tval(uint32_t val)
{
    asm volatile ("mcr p15, 0, %0, c14, c3, 0" :: "r"(val) );
    return;
}

// This mirrors the above, so I'm guessing it's querying the
// timer register we're setting there.  Effectively, "how much
// longer until my next interrupt?"
uint32_t read_cntv_tval(void)
{
    uint32_t val;
    asm volatile ("mrc p15, 0, %0, c14, c3, 0" : "=r"(val) );
    return val;
}

// Switch the system timer on -- I assume...
void enable_cntv(void)
{
    uint32_t cntv_ctl;
    cntv_ctl = 1;
    asm volatile ("mcr p15, 0, %0, c14, c3, 1" :: "r"(cntv_ctl) ); // write CNTV_CTL
}


#define CORE0_TIMER_IRQCNTL 0x40000040
#define CORE0_IRQ_SOURCE 0x40000060

// Route the core0 generic timer to the core 0 IRQ, I think
// https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2836/QA7_rev3.4.pdf
void routing_core0cntv_to_core0irq(void)
{
    mmio_write(CORE0_TIMER_IRQCNTL, 0x08);
}

// Unsure about this one -- something like "is an IRQ pending?"
uint32_t read_core0timer_pending(void)
{
    uint32_t val;
    val = mmio_read(CORE0_IRQ_SOURCE);
    return val;
}

uint32_t count_frequency;


void c_irq_handler(void)
{
    if (read_core0timer_pending() & 0x08) {
        serial_puts("interrupt!\n");
        // Wake me up in a second
        write_cntv_tval(count_frequency);
    }
}


void initialize_interrupts(void)
{
    install_exception_vector();

    // How many time units are there per second?  We
    // stash this in a global because we'll need it in our
    // IRQ handler.
    count_frequency = read_cntfrq();
    serial_puts("generic counter frequency is ");
    char freq_buf[33];
    itoa(count_frequency, freq_buf);
    serial_puts(freq_buf);
    serial_puts("\n");

    // Request an interrupt in count_frequency time units
    write_cntv_tval(count_frequency);

    // See what it is after it's been set.  Running this shows
    // that it does go down a bit:
    // generic counter frequency is 62500000
    // tval after setting is 62499340
    // ...which makes sense.
    uint32_t tval = read_cntv_tval();
    char tval_buf[33];
    itoa(tval, tval_buf);
    serial_puts("tval after setting is ");
    serial_puts(tval_buf);
    serial_puts("\n");

    // Route the core0 generic timer to the core 0 IRQ.
    routing_core0cntv_to_core0irq();

    // Enable the timer
    enable_cntv();

    // Enable IRQs
    enable_irq();
}
