.section ".text.boot"

.global _start
_start:

.global reset
reset:
 	//////////////////////////////////////////////////////////////////////
	// Disable all cores apart from 0 :
 	//////////////////////////////////////////////////////////////////////
	// * move from co-processor 15, command zero, to r1, co-processor register
	//   zero, opcode 5.
	//   co-processor 15 is the control co-processor: http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0360f/CHDGIJFB.html
	//   This means "Read Proc Feature Register 1" into r1 as per http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0360f/CHDGIJFB.html
	//   From http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0360f/CHDGIJFB.html
	//   ...we find that this reads the CPU ID, which is the ID of the core.
	mrc p15, #0, r1, c0, c0, #5
	// * And r1 with 3 = 0b11 -- given that it contains a two-bit number,
	//   this will be zero if r1 is zero, non-zero otherwise.
	and r1, r1, #3
	// * Did we get zero from that?
	cmp r1, #0
	// * If not, hang
	bne hang

 	//////////////////////////////////////////////////////////////////////
	// Now we set up separate stack frames for IRQ mode and svc (supervisor)
	// mode
 	//////////////////////////////////////////////////////////////////////

	// First, we save the current program status register (cpsr).
	// We use mrs because this is not a normal register; it's kept
	// in the system co-processor (which is different to the control
	// co-processor we were looking at above.  So. Many. Co-processors.)
	mrs r0, cpsr

	// Now, we store into r1 the value of the CPSR having and-ed it
	// with the complement of 0x1F, which is 0b1_1111 -- essentially,
	// we've cleared the bottom five bits.
	bic r1, r0, #0x1F

	// Now we or r1 with 0x12, which is 0b1_0010.   The net effect
	// of this and the previous instruction is to put into r1 the
	// contents of cpsr, with the bottom five bits being replaced
	// with 0b1_0010
	orr r1, r1, #0x12

	// The next instruction stores the value we got (cpsr with the
	// bottom five bits changed) into cpsr_c.  As per https://www.heyrick.co.uk/armwiki/The_Status_register
	// cpsr_c isn't a separate register -- rather, it's a way to tell
	// the processor to only write to the *control* bits (0-7) of
	// cspr.   So essentially what we appear to have done is
	// take the bottom seven bits of cpsr, replaced the bottom five
	// of those with 0b1_0010, and then put it back in cpsr.
	// As per http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0290g/I27695.html
	// this puts us into IRQ mode.  Phew!
	msr cpsr_c, r1

	// Now we set the stack pointer to #0x4000.  It appears that this
	// will be stashed away somehow when we switch modes...
	mov sp, #0x4000

	// Which do do now.   We restore the control bits of cpsr from r0
	// where we put it at the start of this mini-odyssey,
	// which means we go back to the mode we were in originally.
	// We start in svc mode, so that's what we're in after doing this
	msr cpsr_c, r0

	// So we set our new stack pointer.
	mov sp, #0x8000

 	//////////////////////////////////////////////////////////////////////
 	// Clear bss
 	//////////////////////////////////////////////////////////////////////

 	// Our bss section is the static variables that are unset in the
 	// code, and it's nice to have them all zeroed out

 	// Put the start and end into r4 and r9 respectively
    ldr r4, =__bss_start
    ldr r9, =__bss_end

    // Because we're going to use a store-multiple command in a
    // moment to efficiently clear the bss four words at a time,
    // we need some zeroed-out registers
    mov r5, #0
    mov r6, #0
    mov r7, #0
    mov r8, #0

    // This is an odd one -- "b" is of course a branch.  The label
    // "2f" is a GNU extension to the standard assembly syntax; it
    // means "search forward in the file for the next label called
    // '2', and use that one".  So what we're doing is immediately
    // branching to our label "2" below in a manner that will allow
    // us to have other labels called "2" later on should we want
    // them.  There's a similar "2b" to mean the same, but searching
    // backwards.  It's a kind of useful thing to allow us to have
    // multiple uses of these kind of throw-away labels in the same
    // assembly file.
    // As to why we branch to "2" before going through the loop --
    // it's to implement a while loop, effectively -- we want to
    // check the termination condition before we start writing stuff
    // to memory, just in case __bss_start >= __bss_end.
    b 2f

1:	// Store our four registers into the locations starting at the address
	// in r4, and increment r4 by 4 afterwards
	stmia r4!, {r5-r8}

2:	// Here's our termination condition (as jumped to previously by the
	// "b 2f" at the start of the loop, and fallen-though-to after
	// storing stuff immediately above)
	// Compare r4 and r9
	cmp r4, r9
	// If the carry flag is set (eg. r4 > r9) then jump to the
	// 1b pseudo-label -- that is, the start of our loop
	blo 1b


 	//////////////////////////////////////////////////////////////////////
 	// Jump to the kernel
 	//////////////////////////////////////////////////////////////////////

    bl kernel_main

.global hang
hang:
    wfe
    b hang


.global io_halt
io_halt:
    wfi
    bx lr
