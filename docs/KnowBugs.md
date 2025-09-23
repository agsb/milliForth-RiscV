# Bugs

__Any non-trivial program contains at least one bug__

This is a list of bugs in milliforth riscv code.
Some bugs are beyond scope of metrics and learning.

1. The first hash bug.

    The hash of first compiled word changes after writed at dictionary.

    It's have a correct value at function dbj2 and writed in
    dictionary, then something changes it to a ascii value.
    
    If the first line is repeated, all is done correct.

2. The ASCII mask 127

    In function gets, if omit the mask 127 for valid ascii chars, 
    
    andi fst, fst, 127

    the word ." does not works.



