
#----------------------------------------------------------------------
# code a ASCII $0-F(Z) hexadecimal in a value
# $xxxxxxx hexadecimal 
# #nnnnnnn decimal
#
number:

        pushra

        # clear result

        li idx, 0

        # load word separator, BL is space      

        addi trd, zero, BL

        # skip spaces
nskip:
        call _getc
        bleu fst, trd, nskip

ndigit:

        call digit

        lw hsh, BASE (usr)
        mul idx, idx, hsh
        add idx, idx, fst
        
        # scan spaces
nscan:
        call _getc
        bltu fst, trd, nscan

        bne fst, trd, ndigit

nreturn:

        pullra

        ret

# verify valid digit and convert it
digit:

        # minus sign
        li hsh, 45
        bne fst, hsh, 100f
        
        # for future floats
        # dot 
        # li hsh, 46
        #bne fst, hsh, 
        
100:
        #; any valid digit, 0-9 and A-Z,  
        addi fst, fst, -48
        blt fst, zero, 400f

        #; 0-9 ?
        li hsh, 10
        blt fst, hsh, 200f

        #; normalize gap
        addi fst, fst, -7

        # clear 5th bit
        andi fst, fst, 95 

        #; A to Z max base 36
        li hsh, 'Z'
        bgt fst, hsh, 400f

200:
        #; fst [ 0 .. 36 ]

        ret

400:
# is_error, NaN

        lui fst, 0x80000

        ret

#---------------------------------------------------------------------
.endif
#---------------------------------------------------------------------

