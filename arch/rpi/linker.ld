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

    __bss_start = .;
    .bss : { *(.bss*) } > ram
    __bss_end = .;

    .rodata : { *(.rodata*) } > ram
    .data : { *(.data*) } > ram
}
