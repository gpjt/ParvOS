#ifndef SERIAL_H
#define SERIAL_H

void serial_init(void);

void serial_putc(unsigned char c);

void serial_puts(const char* str);

#endif
