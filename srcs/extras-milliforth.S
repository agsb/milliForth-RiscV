
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
        
        jalr zero, 0 (ipt)

#---------------------------------------------------------------------
# ( -- ) execute a jump to next
def_word ";$", "donext", 0 
        
        j next

#---------------------------------------------------------------------
# ( -- ) exit forth
def_word "bye", "bye", 0
        
        j _exit

#---------------------------------------------------------------------
# ( -- ) ae abort
def_word "abort", "abort_", 0
        
        j abort

#---------------------------------------------------------------------
# ( -- ) ae list of data stack
def_word ".S", "splist", 0
        lw fst, SPT (usr)

        putchar 'S' 
        
        call put_spt

        j next

#----------------------------------------------------------------------
# ( -- ) ae list of return stack
def_word ".R", "rplist", 0
        lw fst, RPT (usr)

        putchar 'R' 
        
        call put_rpt

        j next

#----------------------------------------------------------------------
# ( -- ) dumps the user dictionary
def_word "dump", "dump", 0

        lw fst, LAST (usr)

        call put_list

        j next

#----------------------------------------------------------------------
# ( -- ) words in dictionary, 
def_word "words", "words", 0

        la fst, no_words

        call put_strz

        j next

no_words:
.asciiz "There is no WORDS, no more"

#----------------------------------------------------------------------
#  ae see for 'exit to ends a sequence of references
#  max of 254 references in list
#
# ( -- ) words in dictionary, 
def_word "see", "words", 0

seek:
        call load2
        
        lw fst, snd

        la snd, exit

        ble fst, snd, 100f

        call put_seew
100:
        j next

#----------------------------------------------------------------------
# ( u -- u ) print tos in hexadecimal, swaps order
def_word ".", "dot", 0

        call load2

        add fst, zero, snd

        call puthex

        j next

#---------------------------------------------------------------------
#
# Note: 
#       nested user calls must save ra, relies in pushra and pullra
#       these routines uses Sn registers
#
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# code a register (32-bit) word in ASCII hexadecimal 
#
puthex:

        pushra

        add  s2, zero, a3
        
        addi s5, zero, 58

        srli s3, s2, 24
        call 100f
        srli s3, s2, 16
        call 100f
        srli s3, s2, 8
        call 100f
        srli s3, s2, 0
        call 100f

        add  a3, zero, s2

        pullra

        ret

100:
        pushra

        andi s3, s3, 0xFF
        
        srli s4, s3, 4
        call 200f
        
        srli s4, s3, 0
        call 200f

        pullra

        ret

200:
        pushra

        andi s4, s4, 0x0F
        ori  s4, s4, 48
        blt  s4, s5, 300f
        addi s4, s4, 7
300:
        add a3, zero, s4

        call _putc
        
        pullra

        ret


#---------------------------------------------------------------------
# emits a stringz in ASCII 
#
put_strz:
        
        pushra

        call cpys

100:
        lb s4, 0(s3)
        
        beq s4, zero, 900f
        
        call _putc
        
        addi s3, s3, 1

        j 100b

#---------------------------------------------------------------------
800:
        add s2, zero, a3

        add s3, zero, a3

        ret

#---------------------------------------------------------------------
900:

        add a3, zero, s2

        pullra

        ret

#---------------------------------------------------------------------
put_seek:

        pushra

        call 800b

100:

        ld s4, 0 (s3)

        putchar '\n'

        mhex s4
        
        beq s3, a4, 900b

        addi s3, s3, 4

        j 100b
        
#---------------------------------------------------------------------
put_list:

        pushra

        call 800b

100:

        ld s4, 0 (s3)
        ld s5, 4 (s3)

        putchar '\n'

        mhex s3
        
        mhex s4
        
        mhex s5

        beq s4, zero, 900b

        add s3, zero, s4

        j 100b

#---------------------------------------------------------------------
put_sp:

        pushra

        call 800b
                
        add zs5, zero, zero

100:
        beq s3, sp0, 900b

        putchar '\n'

        mhex s5

        addi s5, s5, 1

        lw s4, 0 (s3)

        mhex s4

        addi s3, s3, 4

        j 100b

#---------------------------------------------------------------------
put_rp:

        pushra

        call 800b

        add zs5, zero, zero
                
100:
        beq s3, rp0, 900b

        putchar '\n'

        mhex s5

        addi s5, s5, 1

        lw s4, 0 (s3)

        mhex s4

        addi s3, s3, 4

        j 100b


.ifdef NOTYET

#----------------------------------------------------------------------
# code a ASCII $FFFF hexadecimal in a byte
#  
number:

        ldy #0

        jsr @very
        asl
        asl
        asl
        asl
        sta fst + 1

        iny 
        jsr @very
        ora fst + 1
        sta fst + 1
        
        iny 
        jsr @very
        asl
        asl
        asl
        asl
        sta fst + 0

        iny 
        jsr @very
        ora fst + 0
        sta fst + 0

        clc #; clean
        rts

@very:
        lda (tout), y
        sec
        sbc #$30
        bmi @erro
        cmp #10
        bcc @ends
        sbc #0x07
        #; any valid digit, A-Z, do not care 
@ends:
        rts

@erro:
        pla
        pla
        rts

.endif


