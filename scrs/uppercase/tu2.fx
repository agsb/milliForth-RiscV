  
 \ use as: TO  
  
 : VALUE CREATE , DOES> @ ; SEE  
  
 : TO  
     ' >BODY  
     STATE @  
     IF ' LIT , , ' ! ,  ELSE !  
     THEN ; SEE  
  
 \ common standart 2012  
 \ http://www.forth200x.org/deferred.fs  
  
 : DEFER CREATE ['] ABORT , DOES> @ EXECUTE ; SEE  
  
 : DEFER@ >BODY @ ; SEE  
  
 : DEFER! >BODY ! ; SEE  
  
 : IS STATE @  
        IF POSTPONE ['] POSTPONE DEFER!  
        ELSE ' DEFER!  
        THEN ; IMMEDIATE SEE  
  
 : ACTION-OF STATE @  
        IF POSTPONE ['] POSTPONE DEFER@  
        ELSE ' DEFER@  
        THEN ; IMMEDIATE SEE  
  
 \ based on reference standart, without ?DO  
  
 0 CONSTANT CASE IMMEDIATE  
  
 : ENDCASE POSTPONE DROP  
        DUP 0 = IF DROP EXIT THEN  
        0 DO POSTPONE THEN LOOP  
        ; IMMEDIATE SEE  
  
 : OF 1 + >R  
        POSTPONE OVER POSTPONE =  
        POSTPONE IF POSTPONE DROP  
        R> ; IMMEDIATE SEE  
  
 : ENDOF POSTPONE ELSE ; IMMEDIATE SEE  
  

