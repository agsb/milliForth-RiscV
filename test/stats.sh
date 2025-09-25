
grep -E ':.[1234567890abcdef]{8,8}' sector-riscv.dmp | \
grep -vi -E '\.word|ecall' > 32bits

grep -E '_GLOBAL_' sector-riscv.dmp > globals
grep -vi -E 'lui|auipc|_GLOBAL_' sector-riscv.dmp > dmp

cp sector-riscv.dmp dmp

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
