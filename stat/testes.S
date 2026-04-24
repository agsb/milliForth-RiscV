# generic riscv tests

_start:

## full compressed registers

full:
# look 
        lw a3, 0 (a0)
        ret

# pull2
        lw a3, 0 (a0)
        addi a0, a0, +4
        ret

# push 
        addi a0, a0, -4
        sw a3, 0 (a0)
        ret

half0:
## one  compressed registers
# look 
        lw a6, 0 (a0)
        ret

# pull2
        lw a6, 0 (a0)
        addi a0, a0, +4
        ret

# push 
        addi a0, a0, -4
        sw a6, 0 (a0)
        ret

half1:
## one  compressed registers
# look 
        lw a3, 0 (a6)
        ret

# pull2
        lw a3, 0 (a6)
        addi a6, a6, +4
        ret

# push 
        addi a6, a6, -4
        sw a3, 0 (a6)
        ret

half2:
## one  compressed registers
# look 
        lw a7, 0 (a6)
        ret

# pull2
        lw a7, 0 (a6)
        addi a6, a6, +4
        ret

# push 
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

adds:

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

logical:

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

        j jumps
        call jumps
        ret 

# using offsets

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

