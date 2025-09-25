# Changes

    The milliforth uses Minimal Indirect Thread Code, 
    DJB2 hashes instead flag-size-name-pads, in a 
    minimal native code dictionary (primitives)
    with only: + nand ! @ : ; 0# u@ exit key emit 
    and a user structure for main forth variables.

## Done

23/09/2025

    __The "first hash bug", was just a debug error__ but no :(

    Note:  
    There is NO edit capabilities. 
        Do not use tabulations for formating.
        That will create a error impossible see. 
        The token and gets, allow any character, except \n, 
        and the external interpreter only use space as separator.

23/09/2025

    Cast _getc and _putc to use a byte instead of a word,
    solves the "addi 127" bug.

22/09/2025

    Small changes to optimize s0-s1-a0-a1-a2-a3-a4-a5 uses

    Now, 532 bytes with Linux I/O

21/09/2025

    Found another problem: -1 and .R have same hash, also .R is a
    standart core word for pretty print numbers.

    Changed 
        .S to %S, to print data stack, (can make an alias to .S)
        .R to %R, to print return stack
        the % is like a stack :)

20/09/2025

    Rename files and update documents. Another review of code.

18/09/2025

    the ['] word only works with non immediate words, is like COMPILE,

    The colon : always set state to compiling and semis ; always set
    state to interpret.

    While in compile state, immediate words are always executed, so
    how make postpone, that always compile the next word ?

    The outer interpreter uses state to decide what to do, if execute 
    or compile, then can use a new state to force the compilation 
    of next word and go back to compile state. 

    To do this will cost bytes, it will be a option.

    Included code to postpone in eval function

    Note: 
        In FigForth sources ;S was called semis and ; was called 
        semicolon, but in milliforth, ;S is exit and ; is semis. 

    Still the first word bug stays, it corrupts the hash of first word 
    of dictionary.  

16/09/2025

    Note:

    From https://comp.lang.forth.narkive.com/Ie9xB3gq/
        quick-review-of-builds-and-create-history#post3 :

    "The flash memory can be written many times. 
    The problem is that it is only possible to change 1 bits to zero bits. 
    To change zero bits back to ones requires erasing a page."

    Then flash memories, is better make flag bit  
    for immediate words to be 0 and for normal words to be 1.

14/09/2025

    Needs 'create and 'variable. Create replaces <BUILDS

    / create the header and 
    / place the address of cell after 'exit' at TOS
    : create 
        here @ : last !
        ['] lit ,
        here @ cell + cell + ,
        ['] exit ,
        0 state ! ;

    / create and allocate cells after
    : variable create cells allot ;

    How make CONSTANT ? need make DOES>

13/09/2025

    Solved [char] and do overall review of code, tune of extras.

    Changed to **jalr ra, 0 (ipt)** 

    Clean commentaries and use of registers

02/09/2025

 this easy linked-list generator macro does x86, 6502, ARMs, but 
 not works with riscv-chain-gcc.

 #---------------------------------------------------------------------
 # macro to define the header of words in dictionary
 #
 .global def_word
 .set h_last, 0x0
 .macro def_word name, label, hash
 .p2align 4, 0x00
 h_\label:
         .word h_last
         .set  h_last, h_\label
         .word \hash
 \label:
 .endm
 #---------------------------------------------------------------------

 gcc linker does "Error: redefined symbol cannot be used on reloc"

30/08/2025

    Still buged with 0x20 first hash.

    TIB never wraps to between line.

    On rellocable assembler code, the linker could not use relative
    address to make the linked list automatics with insertion order,
    any reference address must be explicit.

    Finaly included 8 cells for locals and temporary user parameters. 
    It could be used instead >r r>, or to pass parameters between words

    What hapen when have a error while compiling a word ?
        a) continue compiling until ends, last word mangled.
        b) wipe all previous compiled, empty heap from trash.
        c) returns to interpret state, leave trash into heap.

27/08/2025

    A phantom from past ages, the hash of the first word of  
    compiled dictionary, goes to be 0x20. All other words hashses
    and linked list does pretty well. Why ?

    Its a problem at first `colon` use and the link, references 
    and exit are all okey. Maybe first use of token inside ?

    Sure both rp@ and sp@ must have a cell offset added.

    The user structure, now composed of 8 words, with 
    SPTR, RPTR, stack pointers
    LAST, HERE, dictionary pointers
    TOIN, STAT, terminal input buffer pointer and state of interpreter
    HEAD, TAIL, keep last here and a free cell

    Next eight cells are free for locals.  
    These free cells could be used instead of >r and r> in words, 
        when only for one level is need and >b b> sequence.
        why ? no overhead on return address stack

25/08/2025

    Rewrite of user block, bring SP and RP to top, for less offset 
        calculations.

22/08/2025

    Solved the stack operations problem. Any operation in data stack 
        using sp becomes self relative and must be offset by one cell. 

    the ( : rp@ rp @ cell + ; ) and ( : sp@ sp @ cell + ; )
    
    the extra cell + is to correct the extra cell in stacks;

21/08/2025

    The first word always take a bad hash.
        Workaround by now, using a dummy word (: void ;) first.

    Small changes in Minimal.S, to allow _getc detect EOF

    store (!) and fetch (@) are working as intent.

    DUP is not working as (sp @ @) need (sp @ cell + @).
        Why ? This will break all other SP access offsets !

20/08/2025

    review and remake of primitives, with better jumps :)

    djb2, nand, plus, state, zeroq, key, emit, working

    including bytwo, as shift right to primitives

    some weird bug in fetch (@) routine

    drop ONCE and MORE offsets, using HEAD and TAIL instead

    How know total memory free and upper limit ?

15/08/2025

    Need install qemu-system AND qemu-user !

14/08/2025

    Done djb2 hashes for extras.

    Compiling without extras, no errors, but still does no work.
    With extras, comes strange linker errors. 

    routine djb2 tested and okey

12/08/2025

    included extras-milliforth for support and debug
    
    still in debugs

09/08/2025

    Risc-V does not handle stack push and pull. The ISA allow any 
    register acts as stack, but by convention x2 is SP and the linux 
    loader sets SP to a default memory space.

    MilliFort does not use the SP as language stack, only for internal
    calls to hold the return address.

    The dictionary grows from the end of .bss and don't know where the 
    idefault elf SP points. 

    Usually push, decrements SP and store, and pull, fetch
    and increments SP. Better keep it around.

    Defined _pushra_ and _pullra_ using the default elf stack pointer
    
04/08/2025

    Using a QEMU Virtual Machine 

    1. At https://bellard.org/jslinux/, with linux Fedora 33 Console, 
    got a "Hello!" from sector-riscv.elf, 
    cross compiled in a x86-64 notebook with riscv64-linux-gnu suite; 

    Also followed by a "Segmentation Fault" of course.

    But this solves the VM for tests.

    the ecalls code for _putc and _getc is ok.

    2. local, 

    From https://gist.github.com/Frank-Buss/aa6aa7d4907335e4a529e8cf3e82f47e

    Installing QEMU: 
    sudo apt-get install qemu qemu-system-misc qemu-user 
    
    Installing GCC:
    sudo gcc-riscv64-unknown-elf

    the helloworldriscv.S compiles to a.out and "qemu-riscv a.out"
    does "HeloWorld!".

    Now go to debug.

03/08/2025

    Doing tests with djb2 hash and bit-0 for flag immediate, 
    the use of bit-0 grows the collisions too much.
    Return the flag to bit-31.

.equ hash_key, 0B876D32 
.equ hash_emit, 7C6B87D0 
.equ hash_store, 0002B584 
.equ hash_fetch, 0002B5E5 
.equ hash_add, 0002B58E 
.equ hash_colon, 0002B59F 
.equ hash_semis, 8002B59E   # with FLAG_IMMEDIATE 
.equ hash_nand, 7C727500 
.equ hash_exit, 7C6BBE85 
.equ hash_bye, 0B874AFB 
.equ hash_notequal, 00596816 
.equ hash_userat, 005970D6 

01/08/2025

Using GCCFLAGS = -nostartfiles -nodefaultlibs \
                 -march=rv32ic -mabi=ilp32 -static -Os
No errors. 

Size of .text is 0x26C bytes, including 0x34 of ecalls, using s2-s7 and t3-t6, mix 32-bit (101) and 16-bit (63) opcodes.
    
Now try optimize for use more 16-bit opcodes:

        Use zero (x0), ra (x1), sp (x2), s0 (x8), s1 (x9), a1-a5 (x10-x15)

        Keep just one level of call, no need backup for ra

        ecall is always a 32-bit size opcode

        no (s0) frame pointer used
        Use sp as reference pointer of user struct with offset

        Use s0 as forth instruction pointer

        keep a0, a1, a2, in memory while ecalls

consider:

        r0 is zero, ever
        ra is the return address for jal, do not touch :)
        ecall uses a0, a1, a2, (a7), must be saved 
        sp is free for use
        s0 s1 a3 a4 a5 is free for use
        
       
31/07/2025

_"From a 6502 64k memory to a Risc-V 4GB memory, Mind the Gap."_

Moved .ends: to end of .bss, so dictionary starts at .heap 

(relies in .dat, .text, .rodata, .bss linker order) 

    
30/07/2025

1. hashes in dictionary

_" there is no spoon "_

Going to use DJB2 hash for represent the words at dictionary.
    
With the immediate flag (FLAG_IMM) is the bit 0, could use _ori|andi|xori rd, rs, 0x1_ to test, set and flip the flag
    
To clear the bit 0 use a _andi rd, hsh, 0x1_ then _or hsh, hash, rd_ after hash calculation.
        
All valid hashes will be even. 
        
Can not calculate the hash within a macro, need a program to calculate the hashes for primitives and make the headers by hand.

2. To load memory address
    
Using _la rf, address_ one or two instructions, and _addi rd, rf, offset * CELL_, one instruction. 

29/07/2025

Almost done the code from 6502 to Riscv.

Still testing line parameters to gcc.

Need change the defword macro. 

25/07/2025

_A hell of Makefiles_

How define options to riscv-gnu-tools (cpp,gcc,as,ld,strip,objdump) and keep name as .S .lst .out .elf .dmp

For convenience, use CPP to name alias to registers.



