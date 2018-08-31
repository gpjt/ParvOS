#include <stdint.h>
#include <stddef.h>

#include <serial.h>

void serial_puts(const char* str)
{
    for (size_t i = 0; str[i] != '\0'; i ++) {
        serial_putc((unsigned char) str[i]);
    }
}
