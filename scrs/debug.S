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
#       debug primitives 
#
#----------------------------------------------------------------------

#---------------------------------------------------------------------
#
# djb2 hash cleared of bit 31
#

.equ hash_tdot, 0x005966C5
.equ hash_splist, 0x005965D3
.equ hash_rplist, 0x005965D2

.equ hash_DUMP, 0x7C6B2FE9 
.equ hash_WORDS, 0x0D9A5B98 
.equ hash_SEE, 0x0B881316 
.equ hash_SHOW, 0x7C8AB346

#---------------------------------------------------------------------

.equ init_debug, last_next

#---------------------------------------------------------------------
# ( -- ) ae list of data stack
def_word "%S", "splist", hash_splist, init_debug

        call stackS

        j next

#----------------------------------------------------------------------
# ( -- ) ae list of return stack
def_word "%R", "rplist", hash_rplist, it_splist

        call stackR
        
        j next

#----------------------------------------------------------------------
# ( a b -- a b ) dumps memory between a and b
def_word "DUMP", "dump", hash_DUMP, it_rplist

        call pull2
        
        call dumps

        j drop1

#----------------------------------------------------------------------
# ( -- ) list all words in compiled dictionary, 
def_word "WORDS", "words", hash_WORDS, it_dump

        call wordf

        j next

#----------------------------------------------------------------------
# ( -- ) list last word in dictionary, 
def_word "SEE", "sees", hash_SEE, it_words

        call wordu

        j next

#----------------------------------------------------------------------
# ( u -- u ) print all in hexadecimal
def_word "SHOW", "show", hash_SHOW, it_sees

        call shows
        
        call stackS
        
        call stackR
        
        j next

#----------------------------------------------------------------------
# ( u -- u ) print tos in hexadecimal
def_word "..", "tdot", hash_tdot, it_show

        call pull2

        call to2hex

        putchar ' '

        j next

#---------------------------------------------------------------------

.set last_next, it_tdot

#---------------------------------------------------------------------
#
# Note: 
#       nested user calls must save ra, 
#       relies in pushra and pullra
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
        
        la a6, h_here

        blt a5, a6, returns

        lw a6, HEAP (usr)
        
# init of compiled dictionary

        la s7, h_here 

        putchar '\n'

100:
# verify end of compiled dictionary

        blt a5, zero, returns

        blt a5, s7, returns

        add s8, zero, a5

        call wordt

        add a6, zero, s8

        lw a5, 0 (a6)

        j 100b

#----------------------------------------------------------------------
# shows one compiled word at dictionary
wordu:
        pushra 

        call saves

        lw a5, LAST (usr)

        la a6, h_here

        blt a5, a6, returns

        lw a6, HEAP (usr)

        call wordt

        j returns

#----------------------------------------------------------------------
# show entry in dictionary
wordt:

        pushra

# set the end-of-word as exit address

100:
        putchar '\n'
        
        mhex a5
        
        putchar ' '

        lw a4, 0 (a5)
        
        mhex a4
       
        putchar ' '

        addi a5, a5, CELL

        bne a5, a6, 100b

        putchar '\n'

        pullra

        ret

#----------------------------------------------------------------------
stackS:

        pushra 

        call saves

        putchar '\n'
        putchar 'S'

        lw a5, SPTR (usr)
        la a6, sp0

        call stackp

        j returns

#----------------------------------------------------------------------
stackR:

        pushra 

        call saves

        putchar '\n'
        putchar 'R'

        lw a5, RPTR (usr)
        la a6, rp0
        
        call stackp

        j returns

#----------------------------------------------------------------------
stackp:
        
        pushra

        putchar '='

        mhex a5

        putchar ':'

        mhex a6

        putchar '['

        putchar ' '

        beq a5, a6, 200f

100:
        lw a4, 0 (a5)
        
        mhex a4
        
        putchar ' '

        addi a5, a5, CELL
        
        blt a5, a6, 100b

200:
        putchar ']'

        putchar ' '

        pullra 

        ret

#----------------------------------------------------------------------
# 
dumps:
    
        pushra 

        call saves
        
        add a5, zero, a3
        
        add a6, zero, a4

100:
        addi t4, zero, 8
        
        putchar '\n'
        
        mhex a5

        putchar ':'
        
        putchar ' '

200:
        lw a4, 0 (a5)
        
        mhex a4
        
        addi a5, a5, 4
        
        addi t4, t4, -1
        
        beq t4, zero, 100b
        
        blt a5, a6, 200b

        j returns

#----------------------------------------------------------------------
# 
shows:
        pushra 

        call saves

# user parameters

        putchar '\n'
        putchar 'U'
        putchar ' '
        
       putchar 'S'
        putchar ' '
        lw fst, STAT (usr)
        mhex fst
        putchar ' '
       
       putchar 'L'
        putchar ' '
        lw fst, LAST (usr)
        mhex fst
        putchar ' '
       
       putchar 'H'
        putchar ' '
        lw fst, HEAP (usr)
        mhex fst
        putchar ' '
       
       putchar 'D'
        putchar ' '
        lw fst, HEAD (usr)
        mhex fst
        putchar ' '
       
       putchar 'S'
        putchar 'P'
        putchar ' '
        lw fst, SPTR (usr)
        mhex fst
        putchar ' '

       putchar 'R'
        putchar 'P'
        putchar ' '
        lw fst, RPTR (usr)
        mhex fst
        putchar ' '
       
        j returns

#----------------------------------------------------------------------
# code a ASCII $0-F(Z) hexadecimal in a value
#  
number:

        pushra

        call saves

        add wrd, zero, zero
        add lnk, zero, 8
100:
        lw fst, 0 (idx)
        beq fst, trd, 200f
        call digit
        slli wrd, wrd, 4
        or wrd, wrd, fst
        addi lnk, lnk, -1
        bne lnk, zero, 100b
200:
        j returns

digit:
        #; any valid digit, 0-9 and A-Z, do not care 
        addi fst, fst, -48
        blt fst, zero, 200f
        addi snd, zero, 'Z'
        bgt fst, snd, 200f
        addi snd, zero, 10
        blt fst, snd, 100f
        addi fst, fst, 7 
100:
# is_okey
        ret

200:
# is_error

        lui fst, 0x80000

        ret

#---------------------------------------------------------------------
# code a 32-bit word in ASCII hexadecimal
#
.global tohex
to2hex:
puthex:
        pushra

        add  snd, zero, fst
        
        addi trd, zero, 58

        addi t0, zero, 32

        # rolls 
100:
        beq t0, zero, 300f

        addi t0, t0, -4

        srl  fst, snd, t0

        andi fst, fst, 15

        ori  fst, fst, 48
        
        blt  fst, trd, 200f
        
        addi fst, fst, 7

200:
        call _putc
        
        j 100b

300:

        pullra

        ret

#---------------------------------------------------------------------

