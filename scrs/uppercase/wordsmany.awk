#/usr/bin/awk

# count words

BEGIN {

        }

{
        for (n = 1; n <=NF; n++ ) {

                if ($n == "\\") next
                words[$n]++

                }
        }

END {
        for (n in words) {
                print n " " words[n] " "
                }
        }                
