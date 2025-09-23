# Bugs

__Any non-trivial program contains at least one bug__

This is a list of bugs in milliforth riscv code.
Some bugs are beyond scope of metrics and learning.

(Anyone ?)

1. The first hash bug.

    The hash of first compiled word changes after writed at dictionary.

    It's have a correct value at function dbj2 and writed in
    dictionary, then something changes it to a ascii value.
    
    If the first line is repeated, all is done correct.


