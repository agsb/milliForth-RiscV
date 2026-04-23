


        nop

        lw idx, SPTR (usr)

        lw fst, 0 (idx)

        mv a0, fst 

        lw fst, CELL (idx)

        mv a1, fst 

        lw fst, 2 * CELL (idx)

        mv a2, fst 

        lw fst, 2 * CELL (idx)

        addi idx, idx, 2 * CELL  

        sw idx, SPTR (usr )

        ret


testrcv:

100:


xlook0:
        lw idx, SPTR (usr)

        lw fst, 0 (idx)

	ret

xpull2:
	call look0

        addi idx, idx, CELL

        lw snd, 0 (idx)

        ret


ypull2:

         lw idx, SPTR (usr)

         lw fst, 0 (idx)

         addi idx, idx, CELL

         lw snd, 0 (idx)

         ret

 ylook0:
         lw idx, SPTR (usr)

         lw fst, 0 (idx)

         ret

isrcv:

        lw a5, 0 ( s0 )
        sw a5, 0 ( s0 )

        lw a5, 124 ( s0 )
        sw a5, 124 ( s0 )

        addi a0, a0, 4
        addi a0, a0, -4

        srli a0, a0, 31
        slli a0, a0, 31

        add  a0, a0, a1

        add  a0, zero, a6

        xor  a0, a0, a5

        and  a0, a0, a5

        or  a0, a0, a5

        beq s0, zero, 100b

        bne s0, zero, 100b


