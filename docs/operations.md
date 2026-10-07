
# Cost of words

	Supose only have T, S, R,
	S and R are stack pointers, grows forward

	UP operations
	
	T>[S], T>[R], [S]>T, [R]>T, 

	S++, S--, R++, R--, 

	T++, T--, [[S]]>T, T>[[S]]


## Operations Forth

	DROP, 	( a -- )
		S--

	DUP,  	( a -- a a )
		S>T, S++, T>S

	>R,   	S>T, S--, R++, T>R

	R>,	R>T, R--, S++, T>S

	OVER, 	( a b -- a b a )
		S--, S>T, S++, S++, T>S

	SWAP,	( a b -- b a )
		S>T, S++, T>S, S--, S--, 
		S>T, S++, T>S, S++, S>T, 
		S--, S--, T>S, S++
		
	ROT,	( a b c -- c a b )
		S>T, S++, T>S
		S--, S--, 
		S>T, S++, T>S
		S--, S--, 
		S>T, S++, T>S
		S++, S++, S>T,
		S--, S--, S--, T>S
		S++, S++

		S--, S--, S--, S--, T>S
		S++, S++,
