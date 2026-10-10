   101c4:	02000813          	li	a6,32
   101ca:	fed85fe3          	bge	a6,a3,101c8 <skip>
   101d8:	ff06cfe3          	blt	a3,a6,101d6 <scan>
   101dc:	ff0699e3          	bne	a3,a6,101ce <hash>
   103cc:	02000813          	li	a6,32
   103d2:	fed87fe3          	bgeu	a6,a3,103d0 <nskip>
   103e2:	ff06efe3          	bltu	a3,a6,103e0 <nscan>
   103e6:	ff0698e3          	bne	a3,a6,103d6 <ndigit>
   1066a:	02e69833          	mulh	a6,a3,a4
   10674:	86c2                	mv	a3,a6
   10686:	02e6c833          	div	a6,a3,a4
   1076e:	cc42                	sw	a6,24(sp)
   10780:	4862                	lw	a6,24(sp)
   10798:	00842803          	lw	a6,8(s0)
   107c0:	8862                	mv	a6,s8
   107c2:	00082783          	lw	a5,0(a6)
   107d0:	00002817          	auipc	a6,0x2
   107d4:	81082803          	lw	a6,-2032(a6) # 11fe0 <_GLOBAL_OFFSET_TABLE_+0x10>
   107d8:	faf858e3          	bge	a6,a5,10788 <returns>
   107dc:	00842803          	lw	a6,8(s0)
   10858:	f907c8e3          	blt	a5,a6,107e8 <wordt+0x4>
   108aa:	00001817          	auipc	a6,0x1
   108ae:	72e82803          	lw	a6,1838(a6) # 11fd8 <_GLOBAL_OFFSET_TABLE_+0x8>
   108ec:	00001817          	auipc	a6,0x1
   108f0:	6f082803          	lw	a6,1776(a6) # 11fdc <_GLOBAL_OFFSET_TABLE_+0xc>
   1094a:	86c2                	mv	a3,a6
   10988:	03078d63          	beq	a5,a6,109c2 <stackp+0xca>
   109be:	fd07c7e3          	blt	a5,a6,1098c <stackp+0x94>
   10a00:	883a                	mv	a6,a4
   10a02:	0107c463          	blt	a5,a6,10a0a <dumps+0x12>
   10a08:	8836                	mv	a6,a3
   10a68:	fb07c1e3          	blt	a5,a6,10a0a <dumps+0x12>
