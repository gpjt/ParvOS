MEMORY
{
    ram : ORIGIN = 0x10000, LENGTH = 0x1000
}

SECTIONS
{
    .text : {
        KEEP(*(.text.boot))
        *(.text)
    } > ram

    .rodata : { *(.rodata*) } > ram

    .data : { *(.data*) } > ram

    . = ALIGN(16);
    __bss_start = .;
    .bss : { *(.bss*) } > ram
    . = ALIGN(16);
    __bss_end = .;
}
