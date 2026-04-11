

 \ https://stackoverflow.com/questions/78708194/
 \ logical-shift-right-without-dedicated-shift-instruction

 : 2/   0 32 2 DO
        OVER ISNEGATIVE AND IF 1 + THEN  
        DUP + SWAP
        DUP + SWAP
        LOOP
        OVER ISNEGATIVE AND IF 1 + THEN  
        SWAP DROP
        ;

 \ crude math

 : <  - 0< ;

 : > SWAP < ;

 : * DUP IF >R DUP R> 1 DO OVER + LOOP SWAP DROP THEN ;

 \ SHOW HEXADECIMAL

 : 7 LIT [ 4 2 + 1 + , ] ; \ to escape : thru @

 : 48 LIT [ 32 16 + , ] ;  \ to compare '0'

 : 57 LIT [ 48 10 + 1 - , ] ;  \ to compare '9' 

 : HEX_NIBB
        0fh AND 48 OR DUP 
        57 > IF 7 + THEN  
        EMIT
        ;

 : HEX_BYTE
        ffh AND 
        DUP
        2/ 2/ 2/ 2/
        HEX_NIBB
        HEX_NIBB
        ;
        
 : HEX_WORD
        DUP 
        2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ 
        2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ 
        2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ 
        HEX_BYTE
        DUP
        2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ 
        2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ 
        HEX_BYTE
        DUP
        2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ 
        HEX_BYTE
        HEX_BYTE
        ;

 : . HEX_WORD ;

 : ? @ . ;


