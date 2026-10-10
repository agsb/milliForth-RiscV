   10164:	02000813          	li	a6,32
   1016a:	fed85fe3          	bge	a6,a3,10168 <skip>
   10178:	ff06cfe3          	blt	a3,a6,10176 <scan>
   1017c:	ff0699e3          	bne	a3,a6,1016e <hash>
   10368:	02000813          	li	a6,32
   1036e:	fed87fe3          	bgeu	a6,a3,1036c <nskip>
   1037e:	ff06efe3          	bltu	a3,a6,1037c <nscan>
   10382:	ff0698e3          	bne	a3,a6,10372 <ndigit>
