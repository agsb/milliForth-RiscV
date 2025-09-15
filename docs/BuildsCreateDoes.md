# <Builds Create Does>

    One of most powerfull tools of Forth is the 
    <BUILD CREATE :NONAME DOES>
    process to define new words and families of words.

    from old long thread in comp.language.forth [^1]: 

    " DOES> changes the code field, 
    so it does not matter whether CONSTANT
    or VARIABLE is used for defining <BUILDS; "

## Context

    Classic Forths with STC DTC ITC, have this header structure:
    
        link field, link to previous word in dictionary linked list;
    
        name field, with flags and size at first byte;
    
        code field, what is executed -- the Forth interpreter 
            jump to this address, usually with DOCOL or 
            the parameter field address;
    
        parameter field, with native code or a list of references;

    On Fig-Forth:

    : CONSTANT CREATE SMUDGE , ;CODE .. some assembly code
    
    : VARIABLE CONSTANT ;CODE ... some assembly code.

    The COLON (:) word does a dictionary word header with next name,
        toggle smudge the entry, copy LATEST to link field, copy HERE 
        to LATEST and change STATE to compiling (1).
    
    The SEMIS (;) word places a EXIT at end of word definition, 
        toggle smudge the entry and change the STATE 
        to interpreting (0). 

    The ;CODE makes the Forth (interpreter) do a literal jump to 
        native code following it. 

    At CONSTANT follows DOCON, at VARIABLE follows DOVAR, 
        and at DOES> follows DODOES, all in native code.

    What CREATE and :NONAME really does ?
    
    the older <BUILDS just makes a header and leaves the code field 
        address at stack;
    
    DOES> changes the code field of the latest word defined to a code
        field and the defined parameter list the follows DOES> 
        
    CREATE does a header and a well known list (xt), 
        leaves the code address at stack.

    :NONAME does a list (xt) with no header, leaves the start address 
        at stack.
    
    DOCOL (aka nest) does a push into return stack of next cell then 
        jumps to actual cell. 
    
    And EXIT (aka unnest) does a pull from return stack and jumps to 
    that address, when is direct thread, jumps to that address, or 
    when is indirect thread, jumps to the contents of that addres,


## Non Classic

    But MITC, wherever using name or hash, does not have code field.
    
    What defines how to process is the content address at the cells, to 
    determine if is bellow a limit, is a primitive else is a compiled 
    word.

    Milliforth also does not use any flag other than IMMEDIATE, 
    no SMUDGE, no COMPILE-ONLY, none. 

    Also COLON does not update LATEST, SEMIS does. Then if something 
    goes wrong while compiling the new word, that does not broke 
    the dictionary access and when complete the compiling, the 
    new word is pointed by LATEST.

    Using hash version :

    : create 
        here @ : latest ! / create a header and updates latest
        ['] exit dup , ,  / two 'exit, one will be changed by does>
        ;

    : does>
        r> dup >r   / get next cell after does>
        latest @ cell cell + + ! / get latest, pass link and hash
        ;
    
    : variable create , does> ;
    : constant create , does> @ ;

    
## References

[1] https://comp.lang.forth.narkive.com/Ie9xB3gq/quick-review-of-builds-and-create-history


