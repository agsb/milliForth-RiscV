
#----------------------------------------------------------------------
# extras

#----------------------------------------------------------------------
# ( -- ) ae abort
def_word "abort", "abort_", 0
        j abort

#----------------------------------------------------------------------
# ( -- ) ae list of data stack
def_word ".S", "splist", 0
        lda spt + 0
        sta fst + 0
        lda spt + 1
        sta fst + 1
        
        lda #'S'
        jsr putchar
        
        lda #sp0
        jsr list
        
        jmp next

#----------------------------------------------------------------------
# ( -- ) ae list of return stack
def_word ".R", "rplist", 0
        lda rpt + 0
        sta fst + 0
        lda rpt + 1
        sta fst + 1
        
        lda #'R'
        jsr putchar
        
        lda #rp0
        jsr list
        
        jmp next

#----------------------------------------------------------------------
#  ae list a sequence of references
list:

        sec
        sbc fst + 0
        lsr

        tax

        lda fst + 1
        jsr puthex
        lda fst + 0
        jsr puthex

        lda #' '
        jsr putchar

        txa
        jsr puthex

        lda #' '
        jsr putchar

        txa
        beq @ends

        ldy #0
@loop:
        lda #' '
        jsr putchar
        iny
        lda (fst),y 
        jsr puthex
        dey
        lda (fst),y 
        jsr puthex
        iny 
        iny
        dex
        bne @loop
@ends:
        rts
        
#----------------------------------------------------------------------
# ( -- ) dumps the user dictionary
def_word "dump", "dump", 0

        lda #0x0
        sta fst + 0
        lda #>ends + 1
        sta fst + 1

        ldx #(fst)
        ldy #0

@loop:
        
        lda (fst),y
        jsr putchar
        jsr incwx

        lda fst + 0
        cmp here + 0
        bne @loop

        lda fst + 1
        cmp here + 1
        bne @loop

        clc  #; clean
        jmp next 

#----------------------------------------------------------------------
# ( -- ) words in dictionary, 
def_word "words", "words", 0

# load lastest
        lda last + 1
        sta snd + 1
        lda last + 0
        sta snd + 0

# load here
        lda here + 1
        sta trd + 1
        lda here + 0
        sta trd + 0
        
@loop:
# lsb linked list
        lda snd + 0
        sta fst + 0

# verify \0x0
        ora snd + 1
        beq @ends

# msb linked list
        lda snd + 1
        sta fst + 1

@each:       

        lda #10
        jsr putchar

# put address
        lda #' '
        jsr putchar

        lda fst + 1
        jsr puthex
        lda fst + 0
        jsr puthex

# put link
        lda #' '
        jsr putchar

        ldy #1
        lda (fst), y
        jsr puthex
        dey 
        lda (fst), y
        jsr puthex

        ldx #(fst)
        lda #2
        jsr addwx

# put size + flag, name
        ldy #0
        jsr show_name

# update
        iny
        tya
        ldx #(fst)
        jsr addwx

# show CFA

        lda #' '
        jsr putchar
        
        lda fst + 1
        jsr puthex
        lda fst + 0
        jsr puthex

# check if is a primitive
        lda fst + 1
        cmp #>ends + 1
        bmi @continue

# list references
        ldy #0
        jsr show_refer

@continue:
        
        lda snd + 0
        sta trd + 0
        lda snd + 1
        sta trd + 1

        ldy #0
        lda (trd), y
        sta snd + 0
        iny
        lda (trd), y
        sta snd + 1

        ldx #(trd)
        lda #2
        jsr addwx

        jmp @loop 

@ends:
        clc  #; clean
        jmp next

#----------------------------------------------------------------------
# ae put size and name 
show_name:
        lda #' '
        jsr putchar

        lda (fst), y
        jsr puthex
        
        lda #' '
        jsr putchar

        lda (fst), y
        and #$7F
        tax

 @loop:
        iny
        lda (fst), y
        jsr putchar
        dex
        bne @loop

@ends:
        rts

#----------------------------------------------------------------------
show_refer:
# ae put references PFA ... 

        ldx #(fst)

@loop:
        lda #' '
        jsr putchar

        lda fst + 1
        jsr puthex
        lda fst + 0
        jsr puthex

        lda #':'
        jsr putchar
        
        iny 
        lda (fst), y
        jsr puthex
        dey
        lda (fst), y
        jsr puthex

        lda #2
        jsr addwx

# check if ends

        lda fst + 0
        cmp trd + 0
        bne @loop
        lda fst + 1
        cmp trd + 1
        bne @loop

@ends:
        rts

#----------------------------------------------------------------------
#  ae seek for 'exit to ends a sequence of references
#  max of 254 references in list
#
seek:
        ldy #0
@loop1:
        iny
        beq @ends

        lda (fst), y
        cmp #>exit
        bne @loop1

        dey 
        lda (fst), y
        cmp #<exit
        beq @ends
        
        iny
        bne @loop1

@ends:
        tya
        lsr
        clc  #; clean
        rts

#----------------------------------------------------------------------
# ( u -- u ) print tos in hexadecimal, swaps order
def_word ".", "dot", 0
        lda #' '
        jsr putchar
        jsr spull1
        lda fst + 1
        jsr puthex
        lda fst + 0
        jsr puthex
        jsr spush1
        jmp next

#----------------------------------------------------------------------
# code a byte in ASCII hexadecimal 
puthex:
        pha
        lsr
        ror
        ror
        ror
        jsr @conv
        pla
@conv:
        and #0x0F
        ora #$30
        cmp #$3A
        bcc @ends
        adc #0x06
@ends:
        clc  #; clean
        jmp putchar

.endif


.ifdef numbers
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

