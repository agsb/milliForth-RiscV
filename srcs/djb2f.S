
/*

 Copyright (c) 2025, Alvaro Gomes Sobral Barcellos
 All rights reserved.

 see the disclaimer file in this repository.

*/

# for reference, agsb@2025, milliforth-riscv
# classic djb2 hash algorithm, but with XOR
# idx pointer to str
# fth hold the end of word character ( \0 or spc)
# snd returns the hash 
djb2f:
        addi hsh, zero, 2000
        addi hsh, hsh,  1581
100:
        lb fst, 0 (idx)
        beq fst, fth, 100f
        mv snd, hsh
        slli hsh, hsh, 5
        add hsh, hsh, snd
        xor hsh, hsh, fst
        addi idx, idx, 1
        j 100b
100:    ret
        
