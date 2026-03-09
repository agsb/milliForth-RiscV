#!/usr/bin/bash

case $1 in

'-s')
sed -e ' s/  ;/ ;/; s/; /; SEE /; s/; SEE IMMEDIATE /; IMMEDIATE SEE /;'
        ;;
'-u')
sed -e ' s/ SEE *$/ /;'
        ;;
*)
        echo " use: sees -s to see or -u to unsee "
        ;;

esac

