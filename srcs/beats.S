/*
#---------------------------------------------------------------------
 
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

#----------------------------------------------------------------------
*/

#----------------------------------------------------------------------
#
#       beats primitives 
#
#----------------------------------------------------------------------

#---------------------------------------------------------------------
#
# djb2 hash cleared of bit 31
#

.equ hash_ZBEATS,  0x07007B27
.equ hash_TOBEATS, 0x0724DEA9
.equ hash_BEATSTO, 0x0C8269A9

#---------------------------------------------------------------------

.equ init_beats, last_next

#---------------------------------------------------------------------
# ( -- ) ae flush counters to stack
def_word "BEATS>", "beatsto", hash_BEATSTO, init_beats

	# load stack pointer
        lw trd, SPTR (usr)

	# copy compiled counter
        mv fst, t2

        sw fst, -4 (trd)

	# copy primitive counter
        mv fst, t1

        sw fst, -8 (trd)

	# copy total counter
        mv fst, t0

        sw fst, -12 (trd)

	# update offset
	addi trd, trd, -3 * CELL

	# save stack pointer
        sw trd, SPTR (usr)

        j next

#----------------------------------------------------------------------
# ( -- ) ae flash counters to stack
def_word ">BEATS", "tobeats", hash_TOBEATS, it_beatsto

	# load stack pointer
        lw trd, SPTR (usr)

	# save total counter
	lw fst, 0 (trd)

        mv t0, fst

	# save primitive counter
	lw fst, 4 (trd)

        mv t1, fst

	lw fst, 8 (trd)

	# save compiled counter
        mv t2, fst

	# update offset
	addi trd, trd, 3 * CELL

	# save stack pointer
        sw trd, SPTR (usr)

        j next

#----------------------------------------------------------------------
# ( -- ) ae clear counters
# ( -- ) list all words in compiled dictionary, 
def_word "0BEATS", "zbeats", hash_ZBEATS, it_tobeats

	mv t0, zero

	mv t1, zero

	mv t2, zero

        j next

#---------------------------------------------------------------------

.set last_next, it_zbeats

#---------------------------------------------------------------------

