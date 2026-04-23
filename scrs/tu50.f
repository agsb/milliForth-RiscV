
 \ this is a stub 
 \ test for riscv assembler 

 \       100f8:       0001                    nop
 \       100fa:       401c                    lw      a5,0(s0)
 \       100fc:       4394                    lw      a3,0(a5)
 \       100fe:       8536                    mv      a0,a3
 \       10100:       43d4                    lw      a3,4(a5)
 \       10102:       85b6                    mv      a1,a3
 \       10104:       4794                    lw      a3,8(a5)
 \       10106:       8636                    mv      a2,a3
 \       10108:       4794                    lw      a3,8(a5)
 \       1010a:       07a1                    addi    a5,a5,8
 \       1010c:       c01c                    sw      a5,0(s0)
 \       1010e:       8082                    ret
   


: NOP $ 0001 , ;

: RET $ 8082 , ;
 
 
: CODE :NAME ;$ , [ NOP ; IMMEDIATE

: END-CODE RET ] ; IMMEDIATE


