 : >mark HERE 0 , ; 
 : >resolve HERE SWAP ! ;
 : <mark HERE ;
 : <resolve , ;
 : if COMPILE 0BRANCH >mark ; SEE IMMEDIATE
 : else COMPILE BRANCH >mark SWAP >resolve ; SEE IMMEDIATE
 : then >resolve ; SEE IMMEDIATE
 : begin <mark ; SEE IMMEDIATE
 : while COMPILE 0BRANCH >mark ; SEE IMMEDIATE
 : repeat COMPILE BRANCH SWAP <resolve >resolve ; SEE IMMEDIATE

