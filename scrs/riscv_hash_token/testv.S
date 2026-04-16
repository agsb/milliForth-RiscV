testrcv:

100:


look0:
        lw idx, SPTR (usr)

        lw fst, 0 (idx)

	ret

pull2:
	call look0

        addi idx, idx, CELL

        lw snd, 0 (idx)

        ret


pull2:

         lw idx, SPTR (usr)

         lw fst, 0 (idx)

         addi idx, idx, CELL

         lw snd, 0 (idx)

         ret

 look0:
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


