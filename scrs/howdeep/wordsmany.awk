#/usr/bin/awk

# count Forth words from words to compile
# need be recursive


function extend( w,     n, m, u,list ) {
        
        # count it ;

        dp++

        counts[w]++

        # if not in words list
        if (words[w] == "") {
                dp--;
                print "___PRIMITIVE___" dp " " w
                return (0)
                }
        
#        print "___COMPILED___" word

        m = split (words[w],list," ")

        # discard : and ; also self word

        for (n = 1; n <= m; n++) {
                u = list[n]
                print "= " dp " " n " " m " " u " " w 
                extend( u )
                }
        dp--;        
        return (0)
        }

BEGIN {

        counts[""]  = ""
        
        words[""] = ""
        
        dp = 0; 

        }

{
        if (NF > 3) words[$2] = $0
        }

END {
        for (w in words) {
                print "> " w 
                # only used to compile words
                # deep into each
                extend( w )
                print " done "
                }

        for (n in words) {
                print "# " n " " counts[n]
                }                
        }
