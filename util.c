#include <util.h>

uint32_t strlen(char s[]) {
	uint32_t i;
	for (i=0; s[i]; i++)
		;
	return i;
}

void reverse(char s[]) {
	char c;
	for (int i=0, j = strlen(s) - 1; i < j; i++, j--) {
		c  = s[i];
		s[i] = s[j];
		s[j] = c;
	}
}

void itoa(int n, char s[]) {
	int sign = n;
	if ((sign = n) < 0) {
		n = -n;
	}

	int i=0;
	do {
		s[i++] = n % 10 + '0';
	} while ((n /= 10) > 0);

	if (sign < 0) {
		s[i++] = '-';
	}

	s[i] = '\0';
	reverse(s);
}