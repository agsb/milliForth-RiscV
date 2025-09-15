# <Builds Create Does>

    One of most powerfull tools of forth is the 
    <BUILD CREATE :NONAME DOES>
    process to define new words and families of words.

    from [^1], 

    " DOES> changes the code field, 
    so it does not matter whether CONSTANT
    or VARIABLE is used for defining <BUILDS; "

    : CONSTANT CREATE SMUDGE , ;CODE .. some assembly code
    : VARIABLE CONSTANT ;CODE ... some assembly code.

    What CREATE and :NONAME really does ?
    
    CREATE does a header and no list (xt), leaves a address at stack.

    :NONAME does a list (xt) and no header, leaves a address at stack.

    Classic Forth with STC DTC ITC, have this header structure:
    
        link field, link to previous word in dictionary linked list;
    
        name field, with flags and size at first byte;
    
        code field, what is executed -- jump to this address, 
                usually DOCOL or parameter field address
    
        parameter field, with native code or a list of references

    But MITC, wherever using name or hash, does not have code field.
    What defines how to process is the address at the cells, to 
    determine if is a primitive or a compiled word.

    Milliforth also does not use any flag other than IMMEDIATE, 
    no SMUDGE, no COMPILE-ONLY, none.

    What ;CODE does ?



## References

[1] https://comp.lang.forth.narkive.com/Ie9xB3gq/quick-review-of-builds-and-create-history


