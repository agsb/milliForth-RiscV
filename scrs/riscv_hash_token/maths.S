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
#       math primitives
#
#---------------------------------------------------------------------

#---------------------------------------------------------------------
#
# djb2 hash cleared of bit 31
#

.equ hash_BYMOD, 0x7C4D1C6C  
.equ hash_BYMUL, 0x7C4FB089

.equ hash_MUL, 0x0002B58F  
.equ hash_DIV, 0x0002B58A  
.equ hash_MSTAR, 0x005972C2  
.equ hash_UMSTAR, 0x0B87EB77  
.equ hash_FMBYMOD, 0x14CB69A7  
.equ hash_SMBYMOD, 0x49BE2C12  

#---------------------------------------------------------------------
# math primitives

.equ init_math, last_next

#---------------------------------------------------------------------
# ( w1 w2 -- w3 w4 ) double multiply,  
def_word "*MOD", "bymul", hash_BYMUL, init_math
        
        call pull2
        mulh trd, fst, snd
        mul snd, fst, snd

push2:
        sw snd, 0 (idx)
        add fst, trd, zero
	j back1

#---------------------------------------------------------------------
# ( w1 w2 -- w3 w4 ) divide
def_word "/MOD", "bymod", hash_BYMOD, it_mul
        
        call pull2
	beqz snd, by_zero
        div trd, fst, snd
        rem snd, fst, snd
	j push2

#---------------------------------------------------------------------

.set last_next, it_div

#---------------------------------------------------------------------

