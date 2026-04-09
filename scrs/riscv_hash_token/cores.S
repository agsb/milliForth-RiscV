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
#       
#       core primitives
#
#---------------------------------------------------------------------

#---------------------------------------------------------------------
#
# djb2 hash cleared of bit 31
#


#---------------------------------------------------------------------

.equ init_extras, last_next

#---------------------------------------------------------------------
# ( -- ) push 0x80000000
def_word "NAN", "nan", hash_NAN, init_extras
by_zero:
by_erro:
        
        lui fst, %hi(0x80000000)

        j push1

#---------------------------------------------------------------------
# ( -- ) execute a jump and link to a reference at IP
def_word ";CODE", "docode", hash_DOCODE, it_nan
        
        jalr ra, 0 (ipt)

        j next

#---------------------------------------------------------------------
# ( -- ) ae abort
def_word "ABORT", "aborts", hash_ABORT, it_docode
        
        j abort

#---------------------------------------------------------------------
# ( -- ) exit forth
def_word "BYE", "byes", hash_BYE, it_aborts
        
        j _exit

#---------------------------------------------------------------------
# ( w -- w*2 ) #; shift left
def_word "2*", "sfl", hash_sfl, it_byes

        call pull2
        
        slli fst, fst, 1
        
        j keep1

#---------------------------------------------------------------------
# ( w -- w/2 ) #; shift right
def_word "2/", "sfr", hash_sfr, it_sfl

        call pull2
        
        srli fst, fst, 1
        
        j keep1

#---------------------------------------------------------------------

.set last_next, it_sfl

#---------------------------------------------------------------------

