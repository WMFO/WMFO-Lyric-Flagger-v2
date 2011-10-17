/* WMFO Lyrics Flagger
 * WMFO - Tufts Freeform Radio
 * Version 2.0
 * Copyright 2010, 2011 Ben Yu, Andy Sayler, Phil Tang
 * Distributed under the terms of the GNU General Public License
 *
 * urlencode.c - 
 *
 * Please maintain attribution/contribution list where praticle
 *
 * ---Contributors---
 * Ben Yu
 * ops@wmfo.org
 * Andy Sayler
 * andy@wmfo.org
 * Phil Tang
 * ops@wmfo.org
 *
 * ---File History---
 * 10/16/11 - Place under git VCS and added to github repo 
 */


#include <stdlib.h>
#include <stdio.h>

void process_char(char a);

int main(int argc, char* argv[]) {
	char buf;
	while ( (buf=getchar()) != EOF) {
		process_char(buf);
	}

	return 0;
}

void process_char(char a) {
	if (a == 32) {
		putchar('+');
		return;
	}

	if (a > 47 && a < 58) {
		putchar(a);
		return;
	}

	if (a > 64 && a < 91) {
		putchar(a);
		return;
	}

	if (a > 96 && a < 123) {
		putchar(a);
		return;
	}

	putchar('%');
	printf("%02X", (unsigned int)a);

	return;

}
