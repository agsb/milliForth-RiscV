/*
;----------------------------------------------------------------------
;
; Copyright (c) 2025, Alvaro Gomes Sobral Barcellos
; All rights reserved.
; 
;#   see the disclaimer file in this repository.
;
*/

#---------------------------------------------------------------------
# alias 

.equ FALSE, 0
.equ TRUE, -1

# usefull
.equ ONE, 1
.equ TWO, 2

# cell size, 4 bytes, 32-bit
.equ CELL, 4

.macro spull stack, register
       lw \register, 0 (\stack)
       addi \stack, \stack, +1 * CELL
.endm

.macro spush stack, register
       addi \stack, \stack, -1 * CELL
       sw \register, 0 (\stack)
.endm

# forth struct pointer 
#define usr a1

# instruction pointer
#define ipt a2

# word pointer
#define wrd a3

# some auxiliars
#define fst a4
#define snd a5
#define trd a6
#define fth a7

#----------------------------------------------------------------------
.section .bss
.p2align 2, 0x0

# data stack index
.equ spt, 1 * CELL

# return stack index
.equ rpt, 2 * CELL

# this is it
_user:
.skip 10 * CELL

ps0:    .word
ps1:    .word
ps2:    .word
ps3:    .word

spb:
.skip 36 * CELL
sp0:

rpb:
.skip 36 * CELL
rp0:

#----------------------------------------------------------------------
.text 
.p2align 2, 0x0

       j main

# catch for macros
1: .word 0x0

main:

        la usr, _user

#----------------------------------------------------------------------

# reset data stack
        
        la wrd, sp0 
        
        sw wrd, spt (usr)

# reset return stack
        
        la wrd, rp0 
        
        sw wrd, rpt (usr)

push:
        
        lw wrd, spt (usr)
        
        sw fst, 0 (wrd)

        add wrd, wrd, -1 * CELL

        sw wrd, spt (usr)

pull:
        lw wrd, spt (usr)

        lw fst, 0 (wrd)

        add wrd, wrd, +1 * CELL

        sw wrd, spt (usr)

copy:
        lb wrd, 0 (fst)

        sb wrd, 0 (snd)
        
        add fst, fst, 1
        
        add snd, snd, 1
        


