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
# djb2 hash cleared of bit 31

.equ hash_SUB, 0x0002B588 

.equ hash_PER, 0x0002B580 
.equ hash_DIV, 0x0002B58A 
.equ hash_MUL, 0x0002B58F

.equ hash_EQU, 0x0002B598 
.equ hash_LESS, 0x0002B599 

.equ hash_CTO, 0x00597287 
.equ hash_CAT, 0x005972E6 

.equ hash_RAT, 0x00597497 
.equ hash_TOR, 0x005968A9 
.equ hash_RTO, 0x005974E9 

.equ hash_AND, 0x0B87B72E 
.equ hash_OR, 0x00597378 
.equ hash_XOR, 0x0B883040 
.equ hash_NOT, 0x0B87D3D0 
.equ hash_NEG, 0x0B87D489 

.equ hash_DUP, 0x0B87BC84 
.equ hash_DROP, 0x7C7F5C2C 
.equ hash_OVER, 0x7C84398B 
.equ hash_SWAP, 0x7C8A3910 
.equ hash_ROT, 0x0B8807CC 
.equ hash_NROT, 0x7C4E8CA1 

.equ hash_RPAT, 0x0B880527 
.equ hash_RPTO, 0x0B880546 

.equ hash_SPTO, 0x0B881187 
.equ hash_SPAT, 0x0B8811E6 

.equ hash_BRANCH, 0x1E6C4191 
.equ hash_ZBRANCH, 0x7D28616B

.equ hash_DOT, 0x0002B58B

.equ hash_LIT, 0x0B87DB14 
.equ hash_ALIGN, 0x0C531CC8 

.equ hash_TRUE, 0x7C879BF3
.equ hash_FALSE, 0x0C3C6778

.equ hash_NAN, 0x0B87D404
.equ hash_ONE, 0x00002B594
.equ hash_TWO, 0x00002B597
.equ hash_CELL, 0x07C81B0A3

.equ hash_DOCODE, 0x075D9A73
.equ hash_ABORT, 0x0A1DFF4F
.equ hash_BYE, 0x0B874AFB

.equ hash_sfl, 0x0059685D
.equ hash_sfr, 0x00596858

#define ROS 0(idx)
#define TOS 0(idx)
#define NOS 4(idx)
#define QOS 8(idx)

#---------------------------------------------------------------------

.equ init_cores, last_next

#---------------------------------------------------------------------
look0:
        lw idx, SPTR (usr)
        lw fst, 0 (idx)
        ret

keep0:
        sw fst, 0 (idx)
        j next

#---------------------------------------------------------------------
# ( w1 -- w2 ) #; align to cell, word is 4 bytes
def_word "ALIGN", "align", hash_ALIGN, init_cores

        call look0

        addi fst, fst, 3

        andi fst, fst, ~3

        j keep0

#---------------------------------------------------------------------
# ( w -- w*2 ) #; shift left
def_word "2*", "sfl", hash_sfl, it_align

        call look0
        
        slli fst, fst, 1
        
        j keep0

#---------------------------------------------------------------------
# ( w -- w/2 ) #; shift right
def_word "2/", "sfr", hash_sfr, it_sfl

        call look0
        
        srli fst, fst, 1
        
        j keep0

#---------------------------------------------------------------------
# ( w1 -- w2 ) #; NOT w
def_word "NOT", "nots", hash_NOT, it_sfr

        call look0

        # xori fst, fst, -1
        not fst, fst

        j keep0

#---------------------------------------------------------------------
# ( w1 -- w2 ) #; NEG w
def_word "NEG", "negs", hash_NEG, it_nots

        call look0

        # sub fst, zero, fst
        neg fst, fst

        j keep0

#---------------------------------------------------------------------
# ( w -- w w ) #; duplicate tos
def_word "DUP", "dups", hash_DUP, it_negs

        call look0

        j back1

#---------------------------------------------------------------------
# ( w -- ) #; drop tos
def_word "DROP", "drop", hash_DROP, it_dups

        j drop1

#---------------------------------------------------------------------
# ( w1 w2 -- w1 w2 w1 ) #; over tos
def_word "OVER", "over", hash_OVER, it_drop

        call look0

        lw fst, CELL (idx)

        j push1

#---------------------------------------------------------------------
# ( w1 w2 -- w2 w1 ) #; over tos
def_word "SWAP", "swap", hash_SWAP, it_over

        call look0

        lw snd, CELL (idx)

        sw snd, 0 (idx)

        sw fst, CELL (idx)

        j next

#---------------------------------------------------------------------
# ( w1 w2 w3 -- w2 w3 w1 ) #; rot tos
def_word "ROT", "rot", hash_ROT, it_swap

        call look0

        lw snd, CELL (idx)
        
        lw trd, 2 * CELL (idx)

        sw trd, 0 (idx)

        sw fst, CELL (idx)

        sw snd, 2 * CELL (idx)

        j next

#---------------------------------------------------------------------
# ( w1 w2 w3 -- w3 w1 w2 ) #; rot tos
def_word "-ROT", "nrot", hash_NROT, it_rot

        call look0

        lw snd, CELL (idx)
        
        lw trd, 2 * CELL (idx)

        sw snd, 0 (idx)

        sw trd, CELL (idx)

        sw fst, 2 * CELL (idx)

        j next

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 - w2
def_word "-", "sub", hash_SUB, it_nrot

        call pull2

        sub fst, snd, fst

        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 AND w2
def_word "AND", "and", hash_AND, it_sub

        call pull2

        and fst, fst, snd

        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 OR w2 
def_word "OR", "or", hash_OR, it_and

        call pull2

        or fst, fst, snd

        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 OR w2 
def_word "XOR", "xor", hash_XOR, it_or

        call pull2

        xor fst, fst, snd

        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 = w2 
def_word "=", "equ", hash_EQU, it_false

        call pull2

        bne fst, snd, isfalse

istrue:
        addi fst, zero, TRUE

        j keep0

isfalse:
        addi fst, zero, FALSE

        j keep0

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 < w2 
def_word "<", "less", hash_LESS, it_equ

        call pull2

        blt snd, fst, istrue

        j isfalse

#---------------------------------------------------------------------
# ( -- w ) #; @
def_word "R@", "rat", hash_RAT, it_less

rlook0:
        lw idx, RPTR (usr)

        lw fst, 0 (idx)

        j push1

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; the value is at second cell
def_word "R>", "rto", hash_RTO, it_rat

rpull1:
        lw idx, RPTR (usr)

        # load value

        lw fst, CELL (idx)

        # load return

        lw snd, 0 (idx)

        addi idx, idx, +1 * CELL

        # save return 

        sw snd, 0 (idx) 

        sw idx, RPTR (usr)

        j push1

#---------------------------------------------------------------------
# ( w --  ; -- w ) #; @
def_word ">R", "tor", hash_TOR, it_rto

        call pull2 

        lw idx, RPTR (usr)

        # load return

        lw snd, 0 (idx) 

        # save value

        sw fst, 0 (idx) 

        addi idx, idx, -1 * CELL

        # save return

        sw snd, 0 (idx)

        sw idx, RPTR (usr)

        j next

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_word "RP@", "rpat", hash_RPAT, it_tor

        lw fst, RPTR (usr)

        j push1

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_word "RP!", "rpto", hash_RPTO, it_rpat

        call pull2

        sw fst, RPTR (usr)

        j next

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_word "SP@", "spat", hash_SPAT, it_rpto

        lw fst, SPTR (usr)

        j push1

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_word "SP!", "spto", hash_SPTO, it_spat

        call pull2

        sw fst, SPTR (usr)

        j next

#---------------------------------------------------------------------
# ( -- ; -- ) #; @
def_word "BRANCH", "branch", hash_BRANCH, it_spto

branch:
        lw idx, RPTR (usr)

        lw fst, 0 (idx)

        lw snd, 0 (fst)

        add fst, fst, snd

        sw fst, 0 (idx)

        j next

#---------------------------------------------------------------------
# ( -- ; -- ) #; @
def_word "0BRANCH", "branchz", hash_ZBRANCH, it_branch
        
        call pull2

        beq fst, zero, branch

rdrop1:
        lw idx, RPTR (usr)

        addi idx, idx, +1 * CELL

        sw idx, RPTR (usr)

        j next

#---------------------------------------------------------------------
# ( -- w ) #; @
def_word "LIT", "lit", hash_LIT, it_branchz

        lw idx, RPTR (usr)

        lw fst, 0 (idx)

        addi idx, idx, +1 * CELL

        sw idx, RPTR (usr)

        j push1

#---------------------------------------------------------------------
# ( -- TRUE ) #; push 0xFFFFFFFF 
def_word "TRUE", "true", hash_TRUE, it_lit
        
        addi fst, zero, TRUE 

        j push1

#---------------------------------------------------------------------
# ( -- FALSE ) #; push 0x00000000
def_word "FALSE", "false", hash_FALSE, it_true

        addi fst, zero, FALSE 

        j push1

#---------------------------------------------------------------------
# ( -- 1 ) #; push 0x00000001
def_word "1", "one", hash_ONE, it_false

        addi fst, zero, ONE

        j push1

#---------------------------------------------------------------------
# ( -- 2 ) #; push 0x00000002
def_word "2", "two", hash_TWO, it_one

        addi fst, zero, TWO

        j push1

#---------------------------------------------------------------------
# ( -- 4 ) #; push 0x00000004
def_word "CELL", "cell", hash_CELL, it_two

        addi fst, zero, CELL

        j push1

#---------------------------------------------------------------------
# ( -- ) push 0x80000000
def_word "NAN", "nan", hash_NAN, it_cell
by_zero:
by_erro:
        
        lui fst, 0x80000
        
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
# ( w -- ) #; @
def_word ".", "dot", hash_DOT, it_byes

        call pull2

        call tohex

        j next
        
#---------------------------------------------------------------------
# ( w -- ) #; @
def_word "+!", "plusto", hash_PLUSTO, it_dot

        call pull2

        lw idx, 0 (fst)

        add snd, snd, idx

        sw snd, 0 (fst)

        j drop1
        
#---------------------------------------------------------------------

.set last_next, it_plusto

#---------------------------------------------------------------------
# code a 32-bit word in ASCII hexadecimal
#
.global tohex
tohex:

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

/*

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_word "RP0", "rptop", hash_RPTOP, it_rpto

        la fst, rp0

        j push1

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_word "SP0", "sptop", hash_SPTOP, it_rptop

        la fst, rp0

        j push1

*/


