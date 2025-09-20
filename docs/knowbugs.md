# Bugs

__Any non-trivial program contains at least one bug__

This is a list of bugs in milliforth riscv code.
Some bugs are beyond scope of metrics and learning.

1. The first hash bug.

    The hash of first compiled word changes at dictionary.

    It's have a correct value out of function dbj2 and writed in
    dictionary, then something changes it to a ascii value.
    
    If repeat the first line, all is done correct.

2. The ASCII mask 127

    In function gets, if ommit the mask 127 for valid ascii chars, 
    the word ." does not works.



