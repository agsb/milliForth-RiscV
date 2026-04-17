#!/usr/bin/awk
#
#       how deep is your Forth ?
#       evaluate how deep levels the word takes
#       deep find recursion levels
#       agsb@2026
#
# define parameters
#


function deeps( key,  n, m ) {
        
        m = words[key][0]

        print "> " key " " m " "

        for (n=1; n < m; n++) {

                word = words[key][n]

                printf " %s ", word

                }
        print
        return (m);
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
        
        # one word complete by line 
        if ( $1 != colon || $(NF) != semis ) {
                print "? " $0
                next
                }

        words[$2][0] = NF - 3 ;

        for (n = 3; n < NF ; n++) {

                words[$2][n-2] = $n;

                } 
        }


END {
        for (key in words) {

                deeps(key) 

                } 

}

