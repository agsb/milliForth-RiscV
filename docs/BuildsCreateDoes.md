# <Builds Create Does>

    One of most powerfull tools of forth is the 

    from [^1]

    " DOES> changes the code field, 
    so it does not matter whether CONSTANT
    or VARIABLE is used for defining <BUILDS; "

    : CONSTANT CREATE SMUDGE , ;CODE .. some assembly code
    : VARIABLE CONSTANT ;CODE ... some assembly code.

    What CREATE and :NONAME really does ?
    
    CREATE does a header without a list.

    :NONAME does a list without a header.

    Classic Forth with STC DTC ITC, have this header structure:
    
        link field, link to previous word in dictionary linked list
    
        name field, with flags and size at first byte
    
        code field, what is executed -- jump to this address, 
                usually DOCOL or para field address
    
        para field, native code or list of references

    But MITC, using name or hash, does not have distincts 
        code and para fields, what defines how to process is the
        address inside the sequent cells. 
        If is a primitive or a compiled word.

    What ;CODE does ?


## References

[1] https://comp.lang.forth.narkive.com/Ie9xB3gq/quick-review-of-builds-and-create-history


