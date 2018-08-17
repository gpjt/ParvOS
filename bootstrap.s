.global _start
_start:
    mov sp, #0x0010000
    bl kernel_main
hang:
    wfe
    b hang
