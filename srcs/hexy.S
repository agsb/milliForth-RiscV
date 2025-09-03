#---------------------------------------------------------------------
# easy it
#
.macro mhex rg

        add a3, zero, \rg

        pushra

        call saves
        
        call puthex

        call loads

        pullra 
        
.endm
#---------------------------------------------------------------------
# code a 32-bit word in ASCII hexadecimal
#
puthex:

        pushra

        add  s2, zero, a3
        
        addi s5, zero, ':'

        addi a3, zero, ' '
        
        call _putc

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

