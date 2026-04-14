_STUB_

# Full version of MTC Forth for RISCV

This full version of MTC Forth, includes:

system dependences:

    _init _putc _getc _fcntl _exit

    main cold warm

outer loop:

    miss abort quit loop find token hash comma

inner loop:

    unnest next pick jump nest move

core:

    DUP DROP SWAP OVER ROT -ROT

    NAND AND OR XOR NOT NEG

    0# = < . LIT ALIGN

    R@ >R R> 

    @ ! C@ C! 

    BRANCH 0BRANCH

    SP@ SP! RP@ RP!

    : ; ;CODE EXIT

    ABORT BYE DEEP

    STATE LATEST DP @SP @RP

    NAN 1 2 CELL

    */MOD M*

## Extras

    Those are selected at compilation

    BEATS   counts next executions
    
    TICKS   counts jump executions
    
    ** DEEPS   counts how deep stack goes

## Model

    No names, no lines. Just hashes and streams.

    No numbers. Make your own.

## Use

    cat t0.f t1.f - | sh doit.sh

    Note: hifen states for /dev/tty


