
# classic djb2 hash algorithm, but with XOR before SHIFTs
# adapted for
# idx pointer to str
# fth hold the end of word character ( \0 or spc)
djbx2:
        lw snd, zero, 0x1505
        
100:
        lb fst, 0 (idx)
        beq fst, fth, 100f
        xor  snd, snd, fst
        slli trd, snd, 5
        add  snd, trd, snd
        addi idx, idx, 1
        j 100b
100:    ret
        
