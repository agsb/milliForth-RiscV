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

#---------------------------------------------------------------------
# using pre-processor CPP (GNU GCC)
# for alias register names 
# beware about changes
#
# sp not used
#
# jalr/jal using ra
#
# s0,s1,a0,a1,a2,a3,a4,a5 (x8-x15) used for compact instruction
#
# a0,a1,a2,a3,a7 used by ecalls in _putc, _getc, _exit, etc
#
# a0,a1,a2 used in no ecalls
#
# a4,a5,a6 used as ecall safe
#
# t0,t1,t2 used as counters
#
# t3,t4,t5,t6 used as holders for a0,a1,a2,a3 for ecalls
#
# s2 used to keep ra
#
# a3 used as joker :)
#
#---------------------------------------------------------------------
/*

        Compressed code for Riscv, enabled (--march rv32gc):

        401c                    lw      a5,0(s0)
        0791                    addi    a5,a5,4
        c01c                    sw      a5,0(s0)

        00042803                lw      a6,0(s0)
        00478813                addi    a6,a5,4
        01042023                sw      a6,0(s0)

	Use only with s0,s1,a0,a1,a2,a3,a4,a5.

*/

# forth user struct pointer, constant 
#define usr s0

# forth instruction pointer, preserved
#define ipt s1

# hash value
#define hsh a0

# link pointer
#define lnk a1

# word pointer
#define wrd a2

# generic
#define fst a3

# generic
#define snd a4

# index 
#define idx a5

# not for compressed code

# generic
#define trd a6

# generic
#define ops a7

