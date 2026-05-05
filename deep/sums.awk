#
# define parameters
#
BEGIN {

  FS = " ";

  RS = "\n";

  SUBSEP = " ";

#       ~ TO 17 16 18038 31066 1942
        words = 0
        deeps = 0
        compileds = 0
        primitives = 0
        cnt = 0

}

#
# loop 
#
{
        
        words = words + $3 + 0
        deeps = deeps + $4 + 0
        compileds = compileds + $5 + 0
        primitives = primitives + $6 + 0
        cnt = cnt + 1
        
        }

END {
        print "+ " int(words/cnt + 1) " " int(deeps/cnt + 1) " " int(compileds/cnt + 1) " " int(primitives/cnt) " " int(compileds/deeps + 1) " " int(primitives/deeps + 1)

        }

