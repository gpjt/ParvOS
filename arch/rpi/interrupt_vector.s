 	//////////////////////////////////////////////////////////////////////
 	// Function to install the exception vector
 	//////////////////////////////////////////////////////////////////////

.global install_exception_vector
install_exception_vector:
    // It appears that the location of the exception vector can be set
    // -- it doesn't have to start at location 0x0000_0000.  We put
    // our chosen location in r0...
    ldr r0, =vector

    // Then move that value to co-processor 15's (the system control
    // co-processor) "vector base" register.
    // See http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0344k/Bahfeedc.html
    mcr p15, 0, r0, c12, c0, 0

    // ...and return.
    bx lr


 	//////////////////////////////////////////////////////////////////////
 	// Our assembly IRQ handler
 	//////////////////////////////////////////////////////////////////////

 irq:
 	// Stash away all of our registers
 	push {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, lr}
 	// Call the C interrupt handler
 	bl c_irq_handler
 	// recover all of our registers
 	push {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, lr}
 	// return from the exception handler.
 	// See http://www.keil.com/support/man/docs/armasm/armasm_dom1361289908769.htm
 	// the last parameter (the #4) is an immediate value (?)
 	// and it "depends on the exception to return from" --
 	// as per http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0460d/BEIDDFBB.html
 	// 4 is the correct value for a return from an IRQ exception.
 	subs pc, lr, #4


 	//////////////////////////////////////////////////////////////////////
 	// Function to enable IRQs.
 	//////////////////////////////////////////////////////////////////////

.global enable_irq
enable_irq:
	// Single instruction to do this:
	// http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0553a/BABHBAAB.html
    cpsie i
    bx lr


.balign 32
vector:
    ldr pc, reset_handler
    ldr pc, undefined_handler
    ldr pc, swi_handler
    ldr pc, prefetch_handler
    ldr pc, data_handler
    ldr pc, unused_handler
    ldr pc, irq_handler
    ldr pc, fiq_handler
reset_handler:      .word reset
undefined_handler:  .word hang
swi_handler:        .word hang
prefetch_handler:   .word hang
data_handler:       .word hang
unused_handler:     .word hang
irq_handler:        .word irq
fiq_handler:        .word hang
