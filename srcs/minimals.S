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

#
# this trick allow easy changes order of word
#
#	.word 9999b - 8
#	.word HASH
# 9999:
#
# name, real forth word name
# label, internal used for label 
# hash, hash djb2 of name
#

#---------------------------------------------------------------------
# the last of linked list marked with 0x0
.macro def_native_end name label hash
# head
it_\label:
    .word 0x0
    .word \hash
9999:
# code
is_\label:
.endm

#---------------------------------------------------------------------
# the linked list of header 
.global def_native

.macro def_native name label hash
# head
it_\label:
    .word 9999b - 8
    .word \hash
9999:
# code
is_\label:
.endm

#---------------------------------------------------------------------
#
# the minimal primitives 
# 
#---------------------------------------------------------------------

#---------------------------------------------------------------------
#
#  djb2 hash cleared of bit 31
#
#  all uppercase
#

#---------------------------------------------------------------------
# symbols ! @ + 0# : ;
.equ hash_store, 0x0002B584 
.equ hash_fetch, 0x0002B5E5 
.equ hash_plus,  0x0002B58E 
.equ hash_zeroq, 0x00596816 
.equ hash_colon, 0x0002B59F 

.equ hash_semis, 0x8002B59E # unique with FLAG_IMM 

#---------------------------------------------------------------------
# uppercase KEY EMIT EXIT NAND U@
.equ hash_KEY,   0x0B87F112
.equ hash_EMIT,  0x7C7C87D0
.equ hash_NAND,  0x7C8254C0
.equ hash_USERAT, 0x005973B0
.equ hash_EXIT,  0x7C7CC745


#---------------------------------------------------------------------
# ( -- ) ; aka figforth semis
# all compiled words must end with exit
def_native_end "EXIT", "exit", hash_EXIT
        j unnest

#---------------------------------------------------------------------
# ( -- ), ; aka figforth colon 
def_native ":", "colon", hash_colon 
# save here, panic if semis not follow elsewhere
        
        lw fst, HEAP (usr)
        
        sw fst, PIKE (usr)

# stat is 'compile' == 1
        
        li fst, COMPILE
        
        sw fst, STAT (usr)

# make a header

header:

# copy last into (here)
        
        lw fst, LAST (usr)
        
        call comma

# get a hash of the next token
        
        call token

# copy hash into (here)

        mv fst, trd

docomma:

        call comma

        j next 

#---------------------------------------------------------------------
# ( -- ) ; aka figforth semicolon
def_native ";", "semis", hash_semis 
# update last, panic if colon not lead elsewhere 
        
        lw fst, PIKE (usr)
        
        sw fst, LAST (usr)

# stat is 'execute' == 0
        
        li fst, EXECUTE

        sw fst, STAT (usr)

# compound words must ends with exit
        
        la fst, is_exit

        j docomma

#---------------------------------------------------------------------
# ( -- c ) 
def_native "KEY", "key", hash_KEY 

        call _getc

        j push1

#---------------------------------------------------------------------
# ( c -- ) 
def_native "EMIT", "emit", hash_EMIT 
        
        call pull2

        call _putc

        j save1

#---------------------------------------------------------------------
# ( a w -- ),  [a] = w
def_native "!", "store", hash_store 
        
        call pull2

        sw snd, 0 (fst)

drop1:
        addi trd, trd, CELL

        j save1

#---------------------------------------------------------------------
# ( a -- w ), w = [a]
def_native "@", "fetch", hash_fetch 
        
        call pull2
        
        lw fst, 0 (fst)
        
        j back1

#---------------------------------------------------------------------
# ( w1 w2 -- w), NOT(w1 AND w2)
def_native "NAND", "nand", hash_NAND 

        call pull2

        and fst, snd, fst
        
        not fst, fst

        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w), w = w1 + w2  
def_native "+", "plus", hash_plus 
        
        call pull2

        add fst, snd, fst

        j keep1

#---------------------------------------------------------------------
# ( 0 -- FALSE) | ( n -- TRUE), not zero at top ?
def_native "0#", "zeroq", hash_zeroq 

        call pull2
        
        beqz fst, back1

	# TRUE as -1 costs extra 4 bytes
        li fst, TRUE
        
        j back1

#---------------------------------------------------------------------
# ( -- _user ) return an reference to _user structure
def_native "U@", "userat", hash_USERAT 

user1:
        mv fst, usr 

push1:
        lw trd, SPTR (usr)
        
back1:
        addi trd, trd, -1 * CELL

keep1:
        sw fst, 0 (trd)

save1:
        sw trd, SPTR (usr)
        
        j next

pull2:
        
        lw trd, SPTR (usr)
        
        lw fst, 0 (trd)
        
        addi trd, trd, CELL

        lw snd, 0 (trd)

        ret

#---------------------------------------------------------------------

