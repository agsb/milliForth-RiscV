
#---------------------------------------------------------------------
# using pre-processor CPP (GNU GCC)
# for alias register names 
# beware about changes
# a0, a1, a2, a3, a7 are used by ecalls in _putc and _getc
# a4, a5, a6 are generics
#---------------------------------------------------------------------

# forth struct pointer, constant 
#define usr s0

# forth instruction pointer, preserved
#define ipt s1

# hash value
#define hsh a0

# link pointer
#define lnk a1

# word pointer
#define wrd a2

# generic
#define fst a3

# generic
#define snd a4

# index 
#define idx a5

# generic
#define trd a6

# generic
#define ops a7

