_STUB_

# Full version of MTC Forth for RISCV

This full version of MTC Forth, includes:

system dependences:

    _init _putc _getc _fcntl _exit

    main cold warm

outer loop:

    abort quit loop find token hash docomma miss

inner loop:

    unnest next pick jump next move

core:

    DUP DROP SWAP OVER ROT -ROT

    NAND AND OR XOR NOT NEG

    = < . LIT ALIGN

    R@ >R R> 

    @ ! C@ C! 

    BRANCH 0BRANCH

    SP@ SP! RP@ RP!

    : ; ;CODE EXIT

    ABORT BYE 

    STATE LATEST DP @SP @RP

    NAN 1 2 CELL

## Extras

    Those are selected at compilation

    BEATS   counts next executions
    
    TICKS   counts jump executions
    
    DEEPS   counts how deep stack goes

## Model

    No names, no lines. Just hashes and streams.

## Use

    cat t0.f t1.f - | sh doit.sh

    Note: the hifen states for /dev/tty


