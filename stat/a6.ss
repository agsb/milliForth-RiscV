   10178:	02000813          	li	a6,32
   1017e:	fed85fe3          	bge	a6,a3,1017c <skip>
   1018c:	ff06cfe3          	blt	a3,a6,1018a <scan>
   10190:	ff0699e3          	bne	a3,a6,10182 <hash>
   1038e:	02000813          	li	a6,32
   10394:	fed87fe3          	bgeu	a6,a3,10392 <nskip>
   103a4:	ff06efe3          	bltu	a3,a6,103a2 <nscan>
   103a8:	ff0698e3          	bne	a3,a6,10398 <ndigit>
   10450:	cc42                	sw	a6,24(sp)
   10462:	4862                	lw	a6,24(sp)
   1047a:	00842803          	lw	a6,8(s0)
   104a2:	8862                	mv	a6,s8
   104a4:	00082783          	lw	a5,0(a6)
   104b2:	00002817          	auipc	a6,0x2
   104b6:	b2e82803          	lw	a6,-1234(a6) # 11fe0 <_GLOBAL_OFFSET_TABLE_+0x10>
   104ba:	faf858e3          	bge	a6,a5,1046a <returns>
   104be:	00842803          	lw	a6,8(s0)
   10546:	f907c2e3          	blt	a5,a6,104ca <wordt+0x4>
   10596:	00002817          	auipc	a6,0x2
   1059a:	a4282803          	lw	a6,-1470(a6) # 11fd8 <_GLOBAL_OFFSET_TABLE_+0x8>
   105d4:	00002817          	auipc	a6,0x2
   105d8:	a0882803          	lw	a6,-1528(a6) # 11fdc <_GLOBAL_OFFSET_TABLE_+0xc>
   10638:	86c2                	mv	a3,a6
   10674:	03078f63          	beq	a5,a6,106b2 <stackp+0xd2>
   106ae:	fd07c5e3          	blt	a5,a6,10678 <stackp+0x98>
   106ec:	883a                	mv	a6,a4
   10772:	fd07cde3          	blt	a5,a6,1074c <dumps+0x68>
