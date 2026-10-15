# generic riscv tests

_start:

## full compressed registers

wami:
        # :$ jmps here, R@ points to wami: 
        # mostly native code included with $ CAFECAFE ,
        # $; include this code with $ BEEFBEEF ,
        # 
        jal here        #; where am I ?

here:
        addi a0, ra, 12  #;  offset, address just after: j moves 
        sw a0, 0 ( s0 ) #;  update R@, could be 8
        j moves         #;  j unnest, need +2 bytes 
        nop
moves:

        mv a0, a1
        mv a0, a7
        mv a6, a1
        mv a6, a7
        mv a0, zero
        mv a6, zero

look1: 
        lw a3, 0 (a0)
        ret

pull1:
        lw a3, 0 (a0)
        addi a0, a0, +4
        ret

push1: 
        addi a0, a0, -4
        sw a3, 0 (a0)
        ret

look2:
        lw a6, 0 (a0)
        ret

pull2:
        lw a6, 0 (a0)
        addi a0, a0, +4
        ret

push2: 
        addi a0, a0, -4
        sw a6, 0 (a0)
        ret

look3: 
        lw a3, 0 (a6)
        ret

pull3:
        lw a3, 0 (a6)
        addi a6, a6, +4
        ret

push3: 
        addi a6, a6, -4
        sw a3, 0 (a6)
        ret

look4: 
        lw a7, 0 (a6)
        ret

pull4:
        lw a7, 0 (a6)
        addi a6, a6, +4
        ret

push4: 
        addi a6, a6, -4
        sw a7, 0 (a6)
        ret

branchs:

        beq a0, zero, branchs
        bne a0, zero, branchs

        beq a6, zero, branchs
        bne a6, zero, branchs

        blt a0, zero, branchs
        bgt a0, zero, branchs

        beq a0, a1, branchs
        bne a0, a1, branchs
        blt a0, a1, branchs
        bgt a0, a1, branchs

        bltu a0, a1, branchs
        bgtu a0, a1, branchs
        bleu a0, a1, branchs
        bgeu a0, a1, branchs

loadimm:

        lui a0, 0x1
        li  a0, 0x1

        lui a6, 0x1
        li  a6, 0x1

        lui a0, 0x0
        li  a0, 0x0

        lui a6, 0x0
        li  a6, 0x0
        
adds:

        add a0, zero, zero
        add a6, zero, zero

        add a0, a1, zero
        add a0, a7, zero
        add a6, a1, zero
        add a6, a7, zero

        add a0, a0, a1
        add a0, a0, a6
        add a6, a6, a0
        add a6, a6, a7

        addi a0, a0, 1
        addi a0, a6, 1
        addi a6, a0, 1
        addi a6, a6, 1

shifts:

        sll a0, a0, a1
        sll a0, a0, a6
        sll a6, a6, a0
        sll a6, a6, a7
        
        srl a0, a0, a1
        srl a0, a0, a6
        srl a6, a6, a0
        srl a6, a6, a7
        
        sra a0, a0, a1
        sra a0, a0, a6
        sra a6, a6, a0
        sra a6, a6, a7
        
        slli a0, a0, 0
        slli a0, a6, 0
        slli a6, a0, 0
        slli a6, a6, 0
        
        srli a0, a0, 0
        srli a0, a6, 0
        srli a6, a0, 0
        srli a6, a6, 0
        
        srai a0, a0, 0
        srai a0, a6, 0
        srai a6, a0, 0
        srai a6, a6, 0

        slli a0, a0, 1
        slli a0, a6, 1
        slli a6, a0, 1
        slli a6, a6, 1
        
        srli a0, a0, 1
        srli a0, a6, 1
        srli a6, a0, 1
        srli a6, a6, 1
        
        srai a0, a0, 1
        srai a0, a6, 1
        srai a6, a0, 1
        srai a6, a6, 1

        slli a0, a0, 31
        slli a0, a6, 31
        slli a6, a0, 31
        slli a6, a6, 31
        
        srli a0, a0, 31
        srli a0, a6, 31
        srli a6, a0, 31
        srli a6, a6, 31
        
        srai a0, a0, 31
        srai a0, a6, 31
        srai a6, a0, 31
        srai a6, a6, 31

logical:

        xor a0, a0, a0
        xor a6, a6, a6

        and a0, a0, a1
        or a0, a0, a1
        xor a0, a0, a1

        and a0, a0, a6
        or a0, a0, a6
        xor a0, a0, a6

        and a6, a6, a0
        or a6, a6, a0
        xor a6, a6, a0

        not a0, a0
        neg a0, a0

        not a6, a6
        neg a6, a6

jumps:

# using ra

jumpra:
        j jumps
        call jumps
        ret 

# using offsets
jumprn:

        jal zero, 1024
        jal ra, 1024
        jal a0, 1024
        jal a6, 1024

        jalr a0, zero, 1024
        jalr a6, zero, 1024

        jalr a0, ra, 1024
        jalr a6, ra, 1024

        jalr zero, a0, 1024
        jalr ra, a0, 1024
        jalr zero, a6, 1024
        jalr ra, a6, 1024

        jalr a0, a0, 1024
        jalr a0, a6, 1024
        jalr a6, a0, 1024
        jalr a6, a6, 1024

        jalr zero, 0 (ra)
        jalr zero, 0 (a0)
        jalr zero, 0 (a6)

