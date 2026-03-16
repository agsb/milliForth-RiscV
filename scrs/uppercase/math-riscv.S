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

/*

        extra words and routines for milliforth-riscv

*/

#---------------------------------------------------------------------
#
# djb2 hash cleared of bit 31
#

.equ hash_NAN, 0x0B87D404
.equ hash_DOCODE, 0x075D9A73
.equ hash_ABORT, 0x0A1DFF4F 
.equ hash_BYE, 0x0B874AFB 

.equ hash_sfl, 0x0059685D
.equ hash_sfr, 0x00596858

.equ hash_dot, 0x0002B58B
.equ hash_splist, 0x005965D3
.equ hash_rplist, 0x005965D2

.equ hash_DUMP, 0x7C6B2FE9 
.equ hash_WORDS, 0x0B6953F8 
.equ hash_WORDS, 0x0D9A5B98 
.equ hash_SEE, 0x0B881316 
.equ hash_CELL, 0x7C70B163 

#---------------------------------------------------------------------
# extra primitives

#---------------------------------------------------------------------
# ( -- ) push 0x80000000
def_word "NAN", "nan", hash_NAN, into_extras
        
        lui fst, %hi(0x80000000)

        j push1

#---------------------------------------------------------------------
# ( -- ) execute a jump and link to a reference at IP
def_word ";CODE", "docode", hash_DOCODE, h_nan
        
        jalr ra, 0 (ipt)

        j next

#---------------------------------------------------------------------
# ( -- ) ae abort
def_word "ABORT", "aborts", hash_ABORT, h_docode
        
        j abort

#---------------------------------------------------------------------
# ( -- ) exit forth
def_word "BYE", "byes", hash_BYE, h_aborts
        
        j _exit


#---------------------------------------------------------------------

#---------------------------------------------------------------------
# ( w -- w*2 ) #; shift left
def_word "2*", "sfl", hash_sfl, h_byes

        call pull2
        
        slli fst, fst, 1
        
        j keep1

#---------------------------------------------------------------------
# ( w -- w/2 ) #; shift right
def_word "2/", "sfr", hash_sfr, h_sfl

        call pull2
        
        srli fst, fst, 1
        
        j keep1

#---------------------------------------------------------------------
