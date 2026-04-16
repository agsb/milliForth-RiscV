
 \ math from eforth

 : * ( x y -- z )
        dup ( Check not zero)
        if over 0< over 0< xor >r ( Calculate sign of result)
        0 rot abs rot abs ( Use absolute values)
        begin
                dup ( While not zero do)
        while
                swap rot over + ( Add to accumulator)
                swap rot 1- ( And decrement counter)
        repeat
        drop drop ( Drop temporary parameters)
        r> if 
                negate then ( Check sign for negate)
        else
                swap drop ( Return zero)
        then ;

 : /mod ( x y -- r q )
        dup ( Check not zero division )
        if 
                over 0< >r ( Save sign of divident )
                over 0< over 0< xor >r ( Calculate sign of result )
                0 rot abs rot abs ( Use the absolute values )
                begin
                        swap over - dup 0< not ( Calculate next remainder )
                while ( Check not negative )
                        swap rot 1+ ( Increment quotient )
                        rot rot ( And go again )
                repeat
        + swap ( Restore after last loop )
        r> if negate then ( Check sign of quotient )
        r> if swap negate swap then ( Check sign of remainder )
        then ;

 : / ( x y -- q ) /mod swap drop ;

 : mod ( x y -- r ) /mod drop ;

 : 2/ ( x -- y ) 2 / ;

 : 2* ( x -- y ) 2 * ;


