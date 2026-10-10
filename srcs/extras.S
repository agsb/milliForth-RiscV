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
# the extras primitives 
# 
#---------------------------------------------------------------------

#---------------------------------------------------------------------
#
#  djb2 hash cleared of bit 31
#
#---------------------------------------------------------------------

.equ hash_DOCODE, 0x0059697A
.equ hash_ABORT, 0x0A1DFF4F
.equ hash_BYE, 0x0B87C61B
.equ hash_DOT, 0x0002B58B
.equ hash_HEX, 0x0002B581
.equ hash_NAN, 0x0B87D404 
.equ hash_LSHIFT, 0x2C5784C9 
.equ hash_RSHIFT, 0x416E6B97
.equ hash_LIT, 0x0B87DB14

#---------------------------------------------------------------------

.set init_extras, last_next

#---------------------------------------------------------------------
# ( -- ) push 0x80000000 #; Not a Number and flag IMMEDIATE and error
def_word "NAN", "nan", hash_NAN, init_extras
by_erro: 
by_zero: 
by_under:         
by_over: 
	# load upper value, lower is auto set to 0x0
        lui fst, 0x80000
        
        j push1

#---------------------------------------------------------------------
# ( w1 w2 -- w1<<w2 ) #; shift left some bits
def_word "LSHIFT", "lshift", hash_LSHIFT, it_nan

        call pull2
        
        sll fst, snd, fst
        
        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w1>>w2 ) #; shift right some bits
def_word "RSHIFT", "rshift", hash_RSHIFT, it_lshift

        call pull2
        
        srl fst, snd, fst
        
        j keep1

#---------------------------------------------------------------------
# ( -- ) #; execute a jump and link
def_word ";$", "docode", hash_DOCODE, it_rshift 

        # jump and link to there 

        jalr ra, 0 (ipt)
        
        # at there, save ra, do whatever, load ra,
        # end with jalr s1, 0 (ra)
        # to return here, with s1 (is IP) to next cell 

        j next

#---------------------------------------------------------------------
# ( -- ) #; abort 
def_word "ABORT", "aborts", hash_ABORT, it_docode

        j abort

#---------------------------------------------------------------------
# ( -- ) #; exit forth
def_word "BYE", "byes", hash_BYE, it_aborts

        j _exit

#---------------------------------------------------------------------
# ( -- w ) #; copy next dictionary cell into TOS
def_word "LIT", "lit", hash_LIT, it_byes
        
        lw fst, 0 (ipt)

        addi ipt, ipt, CELL

        j push1

#---------------------------------------------------------------------
# ( -- w ) #; accept a hexadecimal number into TOS
def_word "$", "hex", hash_HEX, it_byes

        call number

        j push1
        
#---------------------------------------------------------------------
# ( w -- ) #; print a hexadecimal number from TOS
def_word ".", "dot", hash_DOT, it_hex

        call pull2

        call tohex

        j save1
        
#---------------------------------------------------------------------

.equ last_next, it_dot

#---------------------------------------------------------------------
# code a 32-bit word in 0-9A-F ASCII hexadecimal
# safe inside Forth words
# 
tohex:

        save_ra

        mv t3, fst
        
        li t4, 58

        li t5, 32

        # rolls 
100:
        beqz t5, 300f

        addi t5, t5, -4

        srl  a3, t3, t5

        andi a3, a3, 15

        ori  a3, a3, 48

        blt  a3, t4, 200f

        addi a3, a3, 7

200:
        call _putc
        
        j 100b

300:

        load_ra

        ret

#----------------------------------------------------------------------
# code a ASCII $0-9A-F hexadecimal to value
# safe inside Forth words
number:

        save_ra

        # clear result

        li trd, 0

        # load NaN

        lui snd, 0x80000

        # load word separator, BL is space      

        li spc, BL

        # skip spaces 
nskip:

        call _getc

        bleu fst, spc, nskip

ndigit:

        call digit

        beq fst, snd, nodigit

        slli trd, trd, 4

        add trd, trd, fst
        
        # scan spaces 
nscan:

        call _getc

        bltu fst, spc, nscan

        bne fst, spc, ndigit

isdigit:

        mv fst, trd 

nodigit:

        load_ra

        ret

# verify valid digit and convert it
digit:

100:
        #; valid digit, 0-9 and A-F  
        addi fst, fst, -48
        blt fst, zero, 400f

        #; 0-9 ?
        li hsh, 10
        blt fst, hsh, 200f

        #; normalize gap ascii 9 to A
        addi fst, fst, -7

        #; A to F ? No esoteric bases !
        li hsh, 16
        bgt fst, hsh, 400f

200:
# is_digit, okey
        ret

400:
# is_error, NaN

        lui fst, 0x80000

        ret

#---------------------------------------------------------------------

