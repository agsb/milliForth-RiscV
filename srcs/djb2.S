
# classic djb2 hash algorithm, but with XOR before SHIFTs
djbx2:
        lw fst, zero, 0x1505
        add trd, zero, zero
100:
        lb trd, 0 (idx)
        beq trd, zero, 100f

        xor  fst, fst, trd
        
        slli trd, fst, 5
        add  fst, trd, fst

        j 100b
100:    ret
        
