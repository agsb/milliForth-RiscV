#/usr/bin/awk

# count Forth words
# need be recursive


function extend ( word ) {
       
        print "____THEN____"
        
        counts[word]++

        if (words[word] == "") {
                print "___PRIMITIVE___"
                return (0)
                }

        $0 = words[word]

        print $0

        for (w = 3; w < NF; w++) {
                print "> " NF " " w " " $w
                print "____WHEN____"
                return (extend ( $w ))
                # print "____THEN____"
                }
        
        print "___COMPILED___"
        return (NF)
        }

BEGIN {

        counts[""]  = 0
        words[""] = ""

        }

{
        if (NF != 0) words[$2] = $0
        }

END {
        for (w in words) {
                # only used to compile words
                counts[":"]++
                counts[";"]++
                print ""

                # deep into 
                extend ( w )
                }

        for (n in words) {
                print n " " counts[n]
                }                
        }
