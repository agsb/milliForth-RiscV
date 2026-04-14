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
  
  print "0 " $0

	
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

  print word

  qtde[word] = NF - 3 ;
  
  for (n = 3; n < NF; n++) {
    
    words[word,n - 3] = $(n);

    print " " word " " n - 3 " " words[word,n-3]
  
    }

} 


END {


  for (key in qtde) {

      dp = 0 
      
      np = 0

      print ">> " key

      deep(key) 

      print " ~ " key " " np " " qtde[key]   

      }


  }

  
function deep( key ) {

print "> " key

  dp++

  if (dp > np) np = dp

  m = qtde[key]

  for (n = 0; n < m; n++) {
    
    yek = words[key,n]

    if ( qtde[yek] > 1) { deep( yek ) } 
    
    }
    
  dp--
}

