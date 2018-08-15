.global _start
_start:
    mov sp, #0x0010000
    b kernel_main
