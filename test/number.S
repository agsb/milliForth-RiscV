
#----------------------------------------------------------------------
# ( u -- u ) print tos in hexadecimal, swaps order
def_word ".", "dot", 0
        call putchar
        call spull1
        lda fst + 1
        call puthex
        lda fst + 0
        call puthex
        call spush1
        jmp next

/*

the register
MSB 0x80000000 LSB

*/
#----------------------------------------------------------------------
# code a register (32-bit) word in ASCII hexadecimal 
puthex:
        addi t3, zero, #' '
        addi t4, zero, 32
        add  t5, zero, fst

        srli t6, t5, #24
        call 100f
        srli t6, t5, #16
        call 100f
        srli t6, t5, #8
        call 100f
        srli t6, t5, #0
100:
        andi t6, t6, #0xFF
        srli t7, t6, 0x4
        call 200f
        srli t7, t6, 0x0
200:
        andi t7, t7, #0x0F
        orai t7, t7, #0x30
        blt  t7, t4, 300f
        addi t7, t7, #0x06
300:
        li a3, t7
        call _putc
        ret


.ifdef numbers
#----------------------------------------------------------------------
# code a ASCII $FFFF hexadecimal in a byte
#  
number:

        ldy #0

        call @very
        asl
        asl
        asl
        asl
        sta fst + 1

        iny 
        call @very
        ora fst + 1
        sta fst + 1
        
        iny 
        call @very
        asl
        asl
        asl
        asl
        sta fst + 0

        iny 
        call @very
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

