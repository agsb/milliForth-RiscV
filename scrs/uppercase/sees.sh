#!/use/bin/bash

cat $1 | sed -e ' s/  ;/ ;/; s/; /; SEE /; s/; SEE IMMEDIATE /; IMMEDIATE SEE /;'


