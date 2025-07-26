
#---------------------------------------------------------------------
# ( w -- w/2 ) #; shift right
def_word "2/", "shr", 0
        jsr spull1
        lsr fst + 1
        ror fst + 0
        jmp this

#---------------------------------------------------------------------
# ( a -- ) execute a jump to a reference at top of data stack
def_word "exec", "exec", 0 
        jsr spull1
        jmp (fst)

#---------------------------------------------------------------------
# ( -- ) execute a jump to a reference at IP
def_word ":$", "docode", 0 
        jmp (ipt)

#---------------------------------------------------------------------
# ( -- ) execute a jump to next
def_word ";$", "donext", 0 
        jmp next

