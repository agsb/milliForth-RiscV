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

.equ hash_MINUS, 0x0002B588     # - 

.equ hash_EQU, 0x0002B598       # = 
.equ hash_LESS, 0x0002B599      # < 
.equ hash_ULESS, 0x005973CC     # U< 
.equ hash_GTZERO, 0x0059680B    # 0>

.equ hash_CFETCH, 0x005972E6    # C@
.equ hash_CSTORE, 0x00597287    # C!

.equ hash_RAT, 0x00597497       # R@
.equ hash_TOR, 0x005968A9       # >R
.equ hash_RTO, 0x005974E9       # R>

.equ hash_AND, 0x0B87B72E 
.equ hash_OR, 0x00597378 
.equ hash_XOR, 0x0B883040 

.equ hash_NEGATE, 0x26B37A79 	
.equ hash_INVERSE, 0x2D6AA2B5 	

.equ hash_DUP, 0x0B87BC84 
.equ hash_DROP, 0x7C7F5C2C 
.equ hash_OVER, 0x7C84398B 
.equ hash_SWAP, 0x7C8A3910 
.equ hash_ROT, 0x0B8807CC 

.equ hash_RPAT, 0x0B880527      # RP!
.equ hash_RPTO, 0x0B880546      # RP@
.equ hash_RPZO, 0x0B880557      # RP0

.equ hash_SPTO, 0x0B881187      # SP!
.equ hash_SPAT, 0x0B8811E6      # SP@
.equ hash_SPZO, 0x0B881196      # SP0

.equ hash_BRANCH, 0x1E6C4191 
.equ hash_ZBRANCH, 0x7D28616B
.equ hash_GBRANCH, 0x689E2DB6    

.equ hash_EXEC, 0x7C7CC8DE 
.equ hash_ALIGN, 0x0C531CC8 

.equ hash_TRUE, 0x7C879BF3
.equ hash_FALSE, 0x0C3C6778
.equ hash_CELL, 0x07C81B0A3
.equ hash_STATE, 0x0DD1F032
.equ hash_LAST, 0x7C835F2F
.equ hash_HEAP, 0x7C857DF9
.equ hash_PIKE, 0x7C8A12B2 

.equ hash_BYMUL, 0x005972C2     # M*
.equ hash_BYMOD, 0x7C4D1C6C     # /MOD

.equ hash_PERFORM, 0x15EEB854 #; ( PERFORM )

#---------------------------------------------------------------------
#
look0:
        lw trd, SPTR (usr)

        lw fst, 0 (trd)

        ret

drop0:
	addi trd, trd, CELL
	
        sw trd, SPTR (usr)

	ret

keep0:
        sw fst, 0 (trd)

        j next

#---------------------------------------------------------------------
# ( w1 -- w2 ) #; align to cell, word is 4 bytes
def_native "ALIGN", "align", hash_ALIGN 

        call look0

        addi fst, fst,  (CELL-1)

        andi fst, fst, ~(CELL-1)

        j keep0

#---------------------------------------------------------------------
# ( w1 -- w2 ) #; INVERSE w
def_native "INVERSE", "nots", hash_INVERSE 

        call look0

        # xori fst, fst, -1
        not fst, fst

        j keep0

#---------------------------------------------------------------------
# ( w1 -- w2 ) #; NEG w, arithmetic inverse
def_native "NEGATE", "negs", hash_NEGATE 

        call look0

        # sub fst, zero, fst
        neg fst, fst

        j keep0

#---------------------------------------------------------------------
# ( w -- w w ) #; duplicate tos
def_native "DUP", "dups", hash_DUP 

        call look0

        j back1

#---------------------------------------------------------------------
# ( w -- ) #; drop tos
def_native "DROP", "drop", hash_DROP 

        j drop1

#---------------------------------------------------------------------
# ( w1 w2 -- w1 w2 w1 ) #; over tos
def_native "OVER", "over", hash_OVER 

        lw trd, SPTR (usr)

        lw fst, CELL (trd)

        j back1

#---------------------------------------------------------------------
# ( w1 w2 -- w2 w1 ) #; over tos
def_native "SWAP", "swap", hash_SWAP 

        call look0

        lw snd, CELL (trd)

        sw snd, 0 (trd)

        sw fst, CELL (trd)

        j next

#---------------------------------------------------------------------
# ( w1 w2 w3 -- w2 w3 w1 ) #; rot tos
def_native "ROT", "rot", hash_ROT 

        call look0

        lw snd, CELL (trd)
        
        sw fst, CELL (trd)

        lw fst, 2 * CELL (trd)

        sw snd, 2 * CELL (trd)

        sw fst, 0 (trd)

        j next

#---------------------------------------------------------------------
# ( a -- w ), w = [a], one byte
def_native "C@", "cfetch", hash_CFETCH 

         call look0

         lb fst, 0 (fst)

         j keep0

 #---------------------------------------------------------------------
 # ( a w -- ),  [a] = w, one byte
 def_native "C!", "cstore", hash_CSTORE 

         call pull2

         sb snd, 0 (fst)

         j drop1

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 - w2
def_native "-", "minus", hash_MINUS 

        call pull2

        sub fst, snd, fst

        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 AND w2
def_native "AND", "and", hash_AND 

        call pull2

        and fst, snd, fst

        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 OR w2 
def_native "OR", "or", hash_OR 

        call pull2

        or fst, snd, fst

        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 OR w2 
def_native "XOR", "xor", hash_XOR 

        call pull2

        xor fst, snd, fst

        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 = w2 
def_native "=", "equ", hash_EQU 

        call pull2

        bne fst, snd, isfalse

istrue:
        li fst, TRUE

        j keep0

isfalse:
        li fst, FALSE

        j keep0

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 < w2 
def_native "<", "less", hash_LESS 

        call pull2

        blt snd, fst, istrue

        j isfalse

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 < w2 unsigned
def_native "U<", "uless", hash_ULESS 

        call pull2

        bltu snd, fst, istrue

        j isfalse

#---------------------------------------------------------------------
# ( w1 -- w2 ) #; w1 > 0 greater than zero #; WTF why not 0< ?
def_native "0>", "gtzero", hash_GTZERO 

        call look0

        bgt fst, zero, istrue

        j isfalse

#---------------------------------------------------------------------
# ( -- w ) #; the value is at second cell
def_native "R@", "rat", hash_RAT 

        lw trd, RPTR (usr)

        lw fst, CELL (trd)

        j back1

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; the value is at second cell
def_native "R>", "rto", hash_RTO 

        # load pointer

        lw trd, RPTR (usr)

        # load value

        lw fst, CELL (trd)

        # load return

        lw snd, 0 (trd)

        # update pointer 

        addi trd, trd, +1 * CELL

        # save return 

        sw snd, 0 (trd) 

        # save pointer

        sw trd, RPTR (usr)

        # save value

        j push1

#---------------------------------------------------------------------
# ( w --  ; -- w ) #; the value is at second cell
def_native ">R", "tor", hash_TOR 

        # load value

        call pull2 

        # load pointer

        lw trd, RPTR (usr)

        # load return

        lw snd, 0 (trd) 

        # save value

        sw fst, 0 (trd) 

        # update pointer 

        addi trd, trd, -1 * CELL

        # save return

        sw snd, 0 (trd)

        # save pointer

        sw trd, RPTR (usr)

        j next

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_native "RP@", "rpat", hash_RPAT 

        lw fst, RPTR (usr)

        j push1

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_native "RP!", "rpto", hash_RPTO 

        call pull2

        sw fst, RPTR (usr)

        j next

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_native "SP@", "spat", hash_SPAT 

        lw fst, SPTR (usr)

        j push1

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_native "SP!", "spto", hash_SPTO 

        call pull2

        sw fst, SPTR (usr)

        j next

#---------------------------------------------------------------------
# ( -- ; -- ) #; branch is relative, not absolute
def_native "BRANCH", "branch", hash_BRANCH 
branch:

        lw fst, 0 (ipt)
        
        # when absolute
        # mv ipt, fst

        # when relative
        add ipt, ipt, fst

        j next

#---------------------------------------------------------------------
# ( -- ; -- ) #; branch if zero
def_native "0BRANCH", "zbranch", hash_ZBRANCH 
        
        call pull2

        beq fst, zero, branch

pass0:
        addi ipt, ipt, CELL

        j next

#---------------------------------------------------------------------
# ( -- ; -- ) #; branch if greater than zero
def_native "GBRANCH", "gbranch", hash_GBRANCH 
        
        call pull2

        bgt fst, zero, branch

        j pass0

#---------------------------------------------------------------------
# ( a -- ) #; execute s reference in TOS zzzz
def_native "EXEC", "exec", hash_EXEC 
        
        call look0
	
	call drop0
	
        j pick

#---------------------------------------------------------------------
# ( -- TRUE ) #; push 0xFFFFFFFF 
def_native "TRUE", "true", hash_TRUE 
        
        li fst, TRUE 

        j push1

#---------------------------------------------------------------------
# ( -- FALSE ) #; push 0x00000000
def_native "FALSE", "false", hash_FALSE 

        li fst, FALSE 

        j push1

#---------------------------------------------------------------------
# ( -- 4 ) #; push 0x00000004
def_native "CELL", "cell", hash_CELL 

        li fst, CELL

        j push1

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; constant
def_native "RP0", "rpzo", hash_RPZO 

        la fst, _rp0

        j push1

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; constant
def_native "SP0", "spzo", hash_SPZO 

        la fst, _sp0

        j push1

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_native "STATE", "state", hash_STATE 

        lw fst, STAT (usr)

        j push1

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @ last in dictionary
def_native "LAST", "last", hash_LAST 

        lw fst, LAST (usr)

        j push1

#---------------------------------------------------------------------
# ( -- w ; -- ) #; @ heap in memory
def_native "HEAP", "heap", hash_HEAP 

        lw fst, HEAP (usr)

        j push1

#---------------------------------------------------------------------
# ( -- w ; -- ) #; @ heap in memory
def_native "PIKE", "pike", hash_PIKE 

        lw fst, PIKE (usr)

        j push1

#---------------------------------------------------------------------
# ( w1 w2 -- w3 w4 ) double multiply,  
def_native "M*", "bymul", hash_BYMUL 
        
        call pull2
        mulh spc, fst, snd
        mul snd, fst, snd

push2:
        sw snd, 0 (trd)
        mv fst, spc
	j push1

#---------------------------------------------------------------------
# ( w1 w2 -- w3 w4 ) divide
def_native "/MOD", "bymod", hash_BYMOD 
        
        call pull2
	beqz fst, by_zero

        div spc, fst, snd
        rem snd, fst, snd
	j push2

#---------------------------------------------------------------------
# ( w -- ) #; @
def_native "PERFORM", "perform", hash_PERFORM 

        call pull2

        jalr ra, 0 (fst)

        j next
        
#---------------------------------------------------------------------

