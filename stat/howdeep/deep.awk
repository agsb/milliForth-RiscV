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

  if ( $1 != colon || $(NF) != semis ) next

  word = $2 

  qtde[word] = NF - 3 ;
  
  for (n = 3; n < NF; n++) {
    
    words[word,n - 3] = $(n);
  
    }

} 


END {


  for (key in qtde) {

      dp = 0

      ep = 0
      
      np = 0

      nc = 0

      print "\n@ " key " " qtde[key] 

      deep(key) 

      print "\n~ " key " " ep " " dp " " np " " nc    

      }


  }

  
function deep( key,     n, m, yek) {

  dp++

  if (dp > ep) ep = dp

  m = qtde[key]

  for (n = 0; n < m; n++) {
    
    yek = words[key,n]

    if ( qtde[yek] > 0) { 
        nc++
        deep( yek ) 
        } 
    else {
        np++
        printf " " yek 
        }

    # escape next ?
    if (yek == "[']") {
        n++
        }

    }

  dp--
}

