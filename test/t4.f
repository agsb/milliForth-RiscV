
 variable tape_head

 variable loop_depth
 
 variable parse_index
 
 : runbf 0 parse_index ! 
     begin parse_index @ c@ 
     dup dup dup dup dup dup dup 
     [char] , = if key tape_head @ ! then 
     [char] - = if tape_head @ @ 1 - tape_head @ ! then 
     [char] + = if tape_head @ @ 1 + tape_head @ ! then 
     [char] < = if tape_head @ 2 - tape_head ! then 
     [char] > = if tape_head @ 2 + tape_head ! then 
     [char] . = if tape_head @ @ emit then 
     
     [char] [ = tape_head @ @ 0 = and if 1 loop_depth ! 
     begin parse_index @ 1 + parse_index ! parse_index @ c@ dup 
     [char] [ = if loop_depth @ 1 + loop_depth ! then 
     [char] ] = if loop_depth @ 1 - loop_depth ! then 
     loop_depth @ 0 = until then 
 
     [char] ] = tape_head @ @ 0 <> and if 1 loop_depth ! 
     begin parse_index @ 1 - parse_index ! parse_index @ c@ dup 
     [char] [ = if loop_depth @ 1 - loop_depth ! then 
     [char] ] = if loop_depth @ 1 + loop_depth ! then 
     loop_depth @ 0 = until then 
     
     parse_index @ 1 + parse_index ! 
     
     dup parse_index @ = until drop ;

 : 64 lit [ 16 16 + 16 + 16 + , ] ;
 
 : BF( [char] ) parse runbf ; immediate
 
 here 64 + tape_head !
 
 BF( >++++++++[<+++++++++>-] <.>++++[<+++++++>-] <+.+++++++..+++.>>++++++[<+++++++>-] <++.------------.>++++++[<+++++++++>-] <+.<.+++.------.--------.>>>++++[<++++++++>-] <+. )

