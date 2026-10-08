
 \ words like ."

 : COPY" ( c a1 -- c a2 ) \ copy from input to memory till quote
	>R
    BEGIN 
        KEY DUP R@ C! 
        OVER = 
        R> 1 + >R 
    UNTIL 
	R>
    ; 

 : TYPE" ( c a1 -- c a2 ) \ dump from memory till quote
	>R
    BEGIN
        R@ C@ OVER =  
    WHILE
        R@ C@ EMIT
	    R> 1 + >R> 
    REPEAT
	R> 1 +   
    ; 

 : ."
     QU
     STATE @ 
     IF     \ compiling
         HERE COPY" CELL-UP HEAP !
     ELSE   \ executing
         R> TYPE" >R 
     THEN
	 DROP
     ; IMMEDIATE 
 
