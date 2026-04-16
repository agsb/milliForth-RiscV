#
# define parameters
#
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
  
        gsub(/\r/,"", $0)
        gsub(/\s+/," ", $0)
        gsub(/^[ ]+/,"", $0)
        gsub(/[ ]+$/,"", $0)
        gsub(/[ ]+/," ", $0)

        if ( $1 != colon || $(NF) != semis ) {
                print "? " $0
                next
                }

        word = $2 

        qtde[word] = NF - 3 ;
  
        words[word, 0] = $0;

        for (n = 3; n < NF; n++) {
    
                words[word, n - 2] = $(n);

                }

        } 


END {
        for (key in qtde) {

        st = 0

        m = qtde[key] 

        for (n = 1; n <= m; n++ ) {

                wrd = words[key, n];

                if (qtde[wrd]) {

zzz

                        }
                else {
                        print "~ " wrd
                        }
                }


}

