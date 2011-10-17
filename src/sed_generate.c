/* WMFO Lyrics Flager
 * WMFO - Tufts Freeform Radio
 * Version 2.0
 * Copyright 2010, 2011 Ben Yu, Andy Sayler, Phil Tang
 * Distributed under the terms of the GNU General Public License
 *
 * sed_generate.c - 
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

int main(int argc, char* argv[]) {

	int i;
	for (i=33; i < 127; i++) {
		printf("s/&#%i", i);
		printf(";/");
		putchar(i);
		printf("/g\n");
	}

	return 0;

}
