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
#       tools primitives 
#
#----------------------------------------------------------------------

#---------------------------------------------------------------------
#
# djb2 hash cleared of bit 31
#

.equ hash_twodot, 0x005966C5
.equ hash_splist, 0x005965D3
.equ hash_rplist, 0x005965D2

.equ hash_DUMP, 0x7C6B2FE9 
.equ hash_WORDS, 0x0D9A5B98 
.equ hash_SEE, 0x0B881316 
.equ hash_SHOW, 0x7C8AB346

#---------------------------------------------------------------------

.equ init_debugs, last_next

#---------------------------------------------------------------------
# ( -- ) ae list of data stack
def_word "%S", "splist", hash_splist, init_debugs

        call stackS

        j next

#----------------------------------------------------------------------
# ( -- ) ae list of return stack
def_word "%R", "rplist", hash_rplist, it_splist

        call stackR
        
        j next

#----------------------------------------------------------------------
# ( -- ) list all words in compiled dictionary, 
def_word "WORDS", "words", hash_WORDS, it_rplist

        call wordf

        j next

#----------------------------------------------------------------------
# ( -- ) list last word in dictionary, 
def_word "SEE", "sees", hash_SEE, it_words

        call wordu

        j next

#----------------------------------------------------------------------
# ( -- ) print user variables 
def_word "SHOW", "show", hash_SHOW, it_sees

        call shows
        
        j next

#----------------------------------------------------------------------
# ( a b -- a b ) print TOS and NOS in hexadecimal, keep stack
def_word "..", "twodot", hash_twodot, it_show

        call pull2

        putchr ' '

        puthex fst

        putchr ' '

        puthex snd

        putchr ' '

        j next

#----------------------------------------------------------------------
# ( a b -- a b ) dumps memory between lower to upper, keep stack
def_word "DUMP", "dump", hash_DUMP, it_twodot

        call pull2
        
        call dumps

        j next

#---------------------------------------------------------------------

.set last_next, it_dump

#---------------------------------------------------------------------
#
# Note: 
#       nested calls must save ra, 
#
#---------------------------------------------------------------------

#---------------------------------------------------------------------
saves:
        addi sp, sp, -32

        sw a0,  0 (sp) 
        sw a1,  4 (sp) 
        sw a2,  8 (sp) 
        sw a3, 12 (sp) 
        sw a4, 16 (sp) 
        sw a5, 20 (sp) 
        sw a6, 24 (sp) 
        sw a7, 28 (sp) 
       
        ret

#----------------------------------------------------------------------
loads:
        lw a0,  0 (sp) 
        lw a1,  4 (sp) 
        lw a2,  8 (sp) 
        lw a3, 12 (sp) 
        lw a4, 16 (sp) 
        lw a5, 20 (sp) 
        lw a6, 24 (sp) 
        lw a7, 28 (sp) 
        
        addi sp, sp, +32
       
        ret

# jumps
returns:

        call loads

        pullra 

        ret

#----------------------------------------------------------------------
# shows all compiled words at dictionary
wordf:
        pushra 

        call saves

# get the latest link
        
        lw a5, LAST (usr)
        
        lw a6, HEAP (usr)
        
# init of compiled dictionary

        la s7, h_where 

        putchr '\n'

100:
# verify end of compiled dictionary

        # end of compiled dictionary

        blt a5, s7, returns

        mv  s8, a5

        call wordt

        mv a6, s8

        lw a5, 0 (a6)

        j 100b

#----------------------------------------------------------------------
# shows one compiled word at dictionary
wordu:
        pushra 

        call saves

        lw a5, LAST (usr)

        la a6, h_where

        ble a5, a6, returns

        lw a6, HEAP (usr)

        call wordt

        j returns

#----------------------------------------------------------------------
# show entry in dictionary
wordt:

        pushra

# set the end-of-word as exit address

100:
        putchr '\n'
        
        puthex a5
        
        putchr ' '

        lw a4, 0 (a5)
        
        puthex a4
       
        putchr ' '

        addi a5, a5, CELL

        blt a5, a6, 100b

        putchr '\n'

        pullra

        ret

#----------------------------------------------------------------------
stackS:

        pushra 

        call saves

        putchr '\n'
        putchr 'S'

        lw a5, SPTR (usr)
        la a6, _sp0

        call stackp

        j returns

#----------------------------------------------------------------------
stackR:

        pushra 

        call saves

        putchr '\n'
        putchr 'R'

        lw a5, RPTR (usr)
        la a6, _rp0
        
        call stackp

        j returns

#----------------------------------------------------------------------
stackp:
        
        pushra

        putchr '='

        puthex a5

        putchr ':'

        puthex a6

        putchr '['

        putchr ' '

        beq a5, a6, 200f

100:
        lw a4, 0 (a5)
        
        puthex a4
        
        putchr ' '

        addi a5, a5, CELL
        
        blt a5, a6, 100b

200:
        putchr ']'

        putchr ' '

        pullra 

        ret

#----------------------------------------------------------------------
#  
dumps:
    
        pushra 

        call saves
        
        mv a5, fst
        
        mv a6, snd

	blt a5, a6, 100f

        mv a5, snd
        
        mv a6, fst

100:
        putchr '\n'
        
        puthex a5

        putchr ':'
        
        lw a4, 0 (a5)
        
        puthex a4
        
        addi a5, a5, 4
        
        blt a5, a6, 100b

        j returns

#----------------------------------------------------------------------
# 
shows:
        pushra 

        call saves

# user parameters

        putchr '\n'
        putchr 'U'
        putchr ' '
        
       putchr 'S'
        putchr ' '
        lw fst, STAT (usr)
        puthex fst
        putchr ' '
       
       putchr 'L'
        putchr ' '
        lw fst, LAST (usr)
        puthex fst
        putchr ' '
       
       putchr 'H'
        putchr ' '
        lw fst, HEAP (usr)
        puthex fst
        putchr ' '
       
       putchr 'P'
        putchr ' '
        lw fst, PIKE (usr)
        puthex fst
        putchr ' '
       
       putchr 'S'
        putchr 'P'
        putchr ' '
        lw fst, SPTR (usr)
        puthex fst
        putchr ' '

       putchr 'R'
        putchr 'P'
        putchr ' '
        lw fst, RPTR (usr)
        puthex fst
        putchr ' '
       
        j returns

#---------------------------------------------------------------------

