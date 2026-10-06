
 \  words like ."

	: COPY" ( c addr -- c addr2 ) \ copy from input to memory
	    DUP >R
		BEGIN
			>R  ( c a -- c ) ( -- a )
			KEY ( c -- c k )
			OVER OVER ( c k -- c k a k )
			= 
		WHILE \ not false
			R@ ( c k -- c k a ) ( a -- a )
			C! ( c k a -- c )
			R> 1 + ( c -- c a+1 )
		REPEAT
		DROP  ( c k -- c )
		R>   ( c -- c a )
	\	CELL_UP ( c a -- c a )
		;

	DEFER TYPE"

	: ."
		STATE @ 
		IF \ compiling
			QU HERE COPY" 
			ROUND-UP HEAP !
		ELSE
			QU R> DUP 1 + R> 
			BEGIN ....
			zzzzzz 
		THEN
		;		
			
