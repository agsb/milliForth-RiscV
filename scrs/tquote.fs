
 \  words like ."

	: COPY" ( c addr -- c addr2 ) \ copy from input to memory
		BEGIN
			>R  ( c a -- c ) ( -- a )
			KEY ( c -- c k )
			OVER OVER ( c k -- c k c k )
			= ( c k c k -- c k T|F )
		WHILE \ not false
			R@ ( c k -- c k a ) ( a -- a )
			C! ( c k a -- c )
			R> 1 + ( c -- c a+1 )
		REPEAT
		DROP  ( c a -- c )
		;

	: TYPE" ( c addr -- c addr2 ) \ dump from memory till quote
		BEGIN
			OVER OVER C@ =
		WHILE
			DUP C@ EMIT
			1 +
		REPEAT
		1 +
		;
 
		
	: ."
		QU
		STATE @ 
		IF \ compiling
			HERE COPY" 
			ROUND-UP HEAP !
		ELSE \ executing
			R> TYPE" >R DROP
		THEN
		;		
			
