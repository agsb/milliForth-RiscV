/* version 1.0

#---------------------------------------------------------------------
load2:
        
        lw idx, SPTR (usr)
        
        lw snd, 0 * CELL (idx)
        
        lw fst, 1 * CELL (idx)

        ret

#---------------------------------------------------------------------
# ( -- c ) 
def_word "key", "key", 0x0, hash_key

        call _getc
        
        j push1

#---------------------------------------------------------------------
# ( c -- ) 
def_word "emit", "emit", h_key, hash_emit
        
        call load2
        
        add fst, zero, snd

        call _putc
        
        j drop1

#---------------------------------------------------------------------
# ( a w -- ),  [a] = w
def_word "!", "store", h_emit, hash_store
        
        call load2
        
        sw fst, 0 (snd)
drop2:
        
        add idx, idx, CELL
drop1:
        
        add idx, idx, CELL
        
        sw idx, SPTR (usr)
        
        j next

#---------------------------------------------------------------------
# ( a -- w ), w = [a]
def_word "@", "fetch", h_store, hash_fetch
        
        call load2
        
        lw fst, 0 (snd)
        
        j save0

#---------------------------------------------------------------------
# ( w1 w2 -- w), NOT(w1 AND w2)
def_word "nand", "nand", h_fetch, hash_nand
        
        call load2
        
        and fst, snd, fst
        
        not fst, fst

save1:
        
        add idx, idx, CELL
        
        sw idx, SPTR (usr)
        
        j save0

#---------------------------------------------------------------------
# ( w1 w2 -- w), w = w1 + w2  
def_word "+", "plus", h_nand, hash_plus
        
        call load2
        
        add fst, fst, snd
        
        j save1

#---------------------------------------------------------------------
# ( 0 -- FALSE) | ( n -- TRUE), not zero at top ?
def_word "0#", "zeroq", h_plus, hash_notzero

        call load2

isfalse:

        beq snd, zero, next

istrue:
        
        addi fst, zero, TRUE
        
        j save0

#---------------------------------------------------------------------
# ( -- state ), return an reference
def_word "s@", "state", h_zeroq, hash_userat
        
        mv fst, usr 

push1:
        
        lw idx, SPTR (usr)
        
        addi idx, idx, -1 * CELL
        
        sw idx, SPTR (usr)

save0:
        
        sw fst, 0 (idx)
        
        j next
*/
