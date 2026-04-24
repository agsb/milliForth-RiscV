#/bin/bash

# decompose assembler dumps into groups of intructions
# agsb@ 2025

cp $1 dmp

grep -E '[0123456789abcdef]{4,8}:' dmp | \
grep -vi -E '\.word' > lins

grep -E ':.[1234567890abcdef]{4,4} ' dmp | \
grep -vi -E '\.word' > 16opc

grep -E ':.[1234567890abcdef]{8,8} ' dmp | \
grep -vi -E '\.word' > 32opc

grep -E 'beq|bne|blt|ble|bgt|bge' dmp > decisions

grep -E ' it_' dmp > hooks

grep -E ' hash_' dmp > hashs

grep -E '_GLOBAL_|auipc' dmp > globals

grep -E 'lui|aui' dmp > lauis

for r in s0 s1 a0 a1 a2 a3 a4 a5 a6 a7 t0 t1 t2 t3 ;
do
        grep -E ",${r}|${r},|\(${r}\)" dmp > ${r}.ss
        # | \
        # grep -v -E ":\s*$r|$r:" > ${r}.ss
done


