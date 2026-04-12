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
# the primitives 
# 
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# primitives djb2 hash cleared of bit 31
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
# lowercase key emit exit nand u@
.equ hash_key,   0x0B876D32 
.equ hash_emit,  0x7C6B87D0 
.equ hash_nand,  0x7C727500 
.equ hash_userat, 0x00596F90
.equ hash_exit,  0x7C6BBE85 

#---------------------------------------------------------------------
# uppercase KEY EMIT EXIT NAND U@
.equ hash_KEY,   0x0B87F112
.equ hash_EMIT,  0x7C7C87D0
.equ hash_NAND,  0x7C8254C0
.equ hash_USERAT, 0x005973B0
.equ hash_EXIT,  0x7C7CC745

#---------------------------------------------------------------------

.equ init_primitives, last_next

#---------------------------------------------------------------------
# Minimal Indirect Thread Code Engine
#
# this is the Forth heart beat.
#
#       nest aka enter or docol, 
# 
#       unnest aka exit or semis
#
#       ipt must stay preserved outside, ever.
#
#       "why there is no 'docol at start of words ?"
#
#---------------------------------------------------------------------
# ( -- ) ; aka figforth semis
def_word "EXIT", "exit", hash_EXIT, init_primitives
unnest: 
# return pull 
        
        lw idx, RPTR (usr)
        
        lw ipt, 0 (idx)
        
        addi idx, idx, CELL
        
        sw idx, RPTR (usr)

next:

# xxx
# count beats as next executions
.ifdef beatme
        lw idx, BEAT (usr)

        addi idx, idx, 1
        
        sw idx, BEAT (usr)
.endif

        lw fst, 0 (ipt)
        
        addi ipt, ipt, CELL

pick:
# compare address, if is a primitive then jumps, MITC 
        
        la idx, ends
        
        bge fst, idx, nest

jump: 
# jump to primitive
        
# xxx
# count ticks as primitive executions
.ifdef tickme
        lw idx, TICK (usr)

        addi idx, idx, 1
        
        sw idx, TICK (usr)
.endif

        # really jump and link 
        jalr ra, 0 (fst)

nest:   
# return push
        
        lw idx, RPTR (usr)
        
        addi idx, idx, -1 * CELL
        
        sw ipt, 0 (idx)
        
        sw idx, RPTR (usr)

move: 
# indirect access 
        
        mv ipt, fst
        
        j next

#---------------------------------------------------------------------
# ( -- ), ; aka figforth colon 
def_word ":", "colon", hash_colon, it_exit
# save here, panic if semis not follow elsewhere
        
        lw fst, HEAP (usr)
        
        sw fst, HEAD (usr)

# stat is 'compile' == 1
        
        addi fst, zero, ONE
        
        sw fst, STAT (usr)

# make a header

create:

# copy last into (here)
        
        lw fst, LAST (usr)
        
        call docomma

# get a hash of the next token
        
        call token

# copy hash into (here)

        mv fst, idx

comma:

        call docomma

        j next 

#---------------------------------------------------------------------
# ( -- ) ; aka figforth semicolon
def_word ";", "semis", hash_semis, it_colon 
# update last, panic if colon not lead elsewhere 
        
        lw fst, HEAD (usr)
        
        sw fst, LAST (usr)

# stat is 'interpret' == 0
        
        sw zero, STAT (usr)

finish:
# compound words must ends with exit
        
        la fst, is_exit

        j comma

#---------------------------------------------------------------------
# ( -- c ) 
def_word "KEY", "key", hash_KEY, it_semis 

        call _getc

        j push1

#---------------------------------------------------------------------
# ( c -- ) 
def_word "EMIT", "emit", hash_EMIT, it_key
        
        call pull2

        call _putc

        j save1

#---------------------------------------------------------------------
# ( a w -- ),  [a] = w
def_word "!", "store", hash_store, it_emit
        
        call pull2

        sw snd, 0 (fst)

drop1:
        addi idx, idx, CELL

        j save1

#---------------------------------------------------------------------
# ( a -- w ), w = [a]
def_word "@", "fetch", hash_fetch, it_store
        
        call pull2
        
        lw fst, 0 (fst)
        
        j back1

#---------------------------------------------------------------------
# ( w1 w2 -- w), NOT(w1 AND w2)
def_word "NAND", "nand", hash_NAND, it_fetch
        
        call pull2

        and fst, fst, snd
        
        not fst, fst

        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w), w = w1 + w2  
def_word "+", "plus", hash_plus, it_nand
        
        call pull2

        add fst, fst, snd
        
        j keep1

#---------------------------------------------------------------------
# ( 0 -- FALSE) | ( n -- TRUE), not zero at top ?
def_word "0#", "zeroq", hash_zeroq, it_plus

        call pull2
        
        beq fst, zero, next

        addi fst, zero, TRUE
        
        j back1

#---------------------------------------------------------------------
# beware variables order
# ( -- _user ) return an reference to _user structure
def_word "U@", "userat", hash_USERAT, it_zeroq
        
        mv fst, usr 

push1:
        lw idx, SPTR (usr)
        
back1:
        addi idx, idx, -1 * CELL

keep1:
        sw fst, 0 (idx)

save1:
        sw idx, SPTR (usr)
        
        j next

#---------------------------------------------------------------------
pull2:
        
        lw idx, SPTR (usr)
        
        lw fst, 0 (idx)
        
        addi idx, idx, CELL

        lw snd, 0 (idx)

        ret

#---------------------------------------------------------------------

.equ last_next, it_userat

#---------------------------------------------------------------------

