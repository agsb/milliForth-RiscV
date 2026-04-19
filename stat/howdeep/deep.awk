#!/usr/bin/awk
#
#       how deep is your Forth ?
#       evaluate how deep levels the word takes
#       deep find recursion levels
#       agsb@2026
#
# define parameters
#


function deeps( key,    words, n, m, p ) {
        
        m = split(lines[key], words, " ")

        print "> " key " (" lines[key] ") " m

        for (n = 3; n < m ; n++) {

                w = words[n]

                if (lines[w] == "") {
                        print "p " w
                        }
                else {        
                        deeps( w )
                        dp++;
                        }
                }
        
        print "d " dp        

        }        

BEGIN {

  FS = " ";

  RS = "\n";

  SUBSEP = " ";

  colon = ":";
  
  semis = ";";

  dp = 0;

  np = 0;

}

#
# loop 
#
{
        # clean line 
        gsub(/\r/,"", $0)
        gsub(/\s+/," ", $0)
        gsub(/^ +/,"", $0)
        gsub(/ +$/,"", $0)
        
        # one complete word by line 
        if ( $1 != colon || $(NF) != semis ) {
                print "? " $0
                next
                }

        lines[$2] = $0

        }


END {
        for (key in lines) {

                dp = 0;
                deeps(key) 
                
                print "> " key " " dp

                } 

}

