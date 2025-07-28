BEGIN {
}

{
        hsh = 5381 + 0
        split($0, chars, "") 
        for (i=1; i<=length($0); i++) { 
                n = ord(chars[i]) + 0
                print "[" n "] " hsh
                hsh = lshift((hsh), 5) + hsh
                hsh = hsh ^ n + 0
                }
        print " (" $0 ") " hsh 
}

END {
}
