#/bin/bash

# decompose assembler dumps into groups of intructions
# agsb@ 2025

cp $1 dmp

grep -E ':.[1234567890abcdef]{8,8}' dmp | \
grep -vi -E '\.word|ecall' > 32bits

grep -E '_GLOBAL_' dmp > globals
grep -vi -E 'lui|auipc|_GLOBAL_' dmp > lauis

grep -E ' s0|,s0|s0,' dmp > s0
grep -E ' s1|,s1|s1,' dmp > s1

grep -E ' a0|,a0|a0,' dmp > a0
grep -E ' a1|,a1|a1,' dmp > a1
grep -E ' a2|,a2|a2,' dmp > a2
grep -E ' a3|,a3|a3,' dmp > a3
grep -E ' a4|,a4|a4,' dmp > a4
grep -E ' a5|,a5|a5,' dmp > a5
grep -E ' a6|,a6|a6,' dmp > a6
grep -E ' a7|,a7|a7,' dmp > a7

grep -E ' t0|,t0|t0,' dmp > t0
grep -E ' t1|,t1|t1,' dmp > t1
grep -E ' t2|,t2|t2,' dmp > t2
grep -E ' t3|,t3|t3,' dmp > t3
grep -E ' t4|,t4|t4,' dmp > t4
grep -E ' t5|,t5|t5,' dmp > t5
