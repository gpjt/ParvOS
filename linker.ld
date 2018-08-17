MEMORY
{
    ram : ORIGIN = 0x10000, LENGTH = 0x1000
}

SECTIONS
{
    .text : { bootstrap.o } > ram
    .text : { *(.text*) } > ram
    .bss : { *(.bss*) } > ram
    .rodata : { *(.rodata*) } > ram
    .data : { *(.data*) } > ram
}
