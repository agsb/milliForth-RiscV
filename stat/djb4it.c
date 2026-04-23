/*

  Copyright 2025 Alvaro Gomes Sobral Barcellos <@agsb>

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.

	output DJB2 hash of words, from stdin

	catch:
		no ASCII controls 0-31;
		maximum of 80 bytes per line;

*/


#include <stdio.h>
#include <stdlib.h>

#define MAXLINE 80

char word[MAXLINE + 1];

unsigned int hash;

unsigned int hasf;

unsigned int hasg;

void djb2 ( char * string ) {

        int c;

        hash = 5381;

        while ( c = *string++ ) {

		/* no controls */
                if (c < ' ') continue;

		/* do hash */
                hash = (( hash << 5) + hash) ^ c;

                }

        }

int main ( int argc, char * argv[]) {

        int n;

        while ( fgets (word, MAXLINE, stdin) ) {

                n = 0;

                while (word[n] != '\n' && word[n] != '\r' ) n++;

                word[n] = 0;

                djb2 (word);

                hasf = hash & (0x80000000 - 1);

                printf (".equ hash_%s, 0x%08X #; ( %s ) \n", word, hasf, word);

                }

        return (0);

        }

                
