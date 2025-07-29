
#---------------------------------------------------------------------
# ( w -- w/2 ) #; shift right
def_word "2/", "shr", 0
        call load2
        srli fst, snd, 1
        j save0

#---------------------------------------------------------------------
# ( a -- ) execute a jump to a address at top of data stack
# not change the stack
def_word "exec", "exec", 0 
        call load2
        jalr zero, 0 (snd)

#---------------------------------------------------------------------
# ( -- ) execute a jump to a reference at IP
def_word ":$", "docode", 0 
        jmp (ipt)

#---------------------------------------------------------------------
# ( -- ) execute a jump to next
def_word ";$", "donext", 0 
        jmp next

#---------------------------------------------------------------------
# ( -- ) exit forth
def_word "bye", "bye", 0
        call _exit

