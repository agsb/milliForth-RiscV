
 \ words like ."

 : COPY" ( c a1 -- c a2 ) \ copy from input to memory till quote
	BEGIN ( c a1 -- 
		>R KEY ( c a -- c k ) ( -- a )
		DUP R@ C!  ( c k -- c k k -- c k k a -- c k )
		OVER = ( c k -- c k c -- c V )
		R> 1 + SWAP ( c V -- c V a+1 -- c a+1 V )
	UNTIL ( c a+1 V -- c a+1 )
	; 

 : TYPE" ( c a1 -- c a2 ) \ dump from memory till quote
	BEGIN
		OVER OVER C@ = DUP 
		IF 
			>R DUP C@ EMIT 1 + R> 
		THEN
	UNTIL
	; 

 zzz

 : ."
 	QU
 	STATE @ 
 	IF \ compiling
 		HERE COPY" 
 		ROUND-UP HEAP !
 	ELSE \ executing
 		R> TYPE" >R DROP
 	THEN
 	; IMMEDIATE 
 
