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

  ep = 0;

  nc = 0;

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

        if ( $1 != colon || $(NF) != semis ) next

        word = $2 

        qtde[word] = NF - 3 ;

        used[word] = 0 ;
  
        for (n = 3; n < NF; n++) {
    
                words[word,n - 3] = $(n);
  
                }

        } 


END {


        for (key in qtde) {

                # words
                nw = qtde[key]
                # deep
                dp = 0
                # max deep
                ep = 0
                # primitives
                np = 0
                # compiled
                nc = 0

                printf "^ %s [ ", key 
        
                deep(key) 

                printf " ]\n" 

                print "~ " key " " nw " " ep " " nc " " np " " int(np/ep + 1)    
          
                }


        for (key in used) {
                nu = used[key]
                print "= " key " " nu
                }

        }

  
function deep( key,     n, m, yek) {

        dp++

        if (dp > ep) ep = dp

        m = qtde[key]

        used[key] = used[key] + 1

        for (n = 0; n < m; n++) {
    
                yek = words[key,n]

                used[yek] = used[yek] + 1

                if ( qtde[yek] > 0) { 
                        nc++
                        deep( yek ) 
                        } 
                else {
                        np++
                        printf " " yek 
                        }

                # escape next ?
                if (    (yek == "[']") ||
                        (yek == "LIT") ||
                        (yek == "COMP") ||
                        (yek == "COMPILE") ||
                        (yek == "[COMPILE]") ||
                        (yek == "POSTPONE")     ) {
                        n++
                        yek = words[key,n]
                        used[yek] = used[yek] + 1
                        }

                }

                dp--

        }

