   100fc:	8e36                	mv	t3,a3
   1010c:	01ee56b3          	srl	a3,t3,t5
   10110:	8abd                	andi	a3,a3,15
   10112:	0306e693          	ori	a3,a3,48
   10116:	01d6c363          	blt	a3,t4,1011c <bin2hex+0x24>
   1011a:	069d                	addi	a3,a3,7
   10144:	00002697          	auipc	a3,0x2
   10148:	ea86a683          	lw	a3,-344(a3) # 11fec <_GLOBAL_OFFSET_TABLE_+0x1c>
   1014c:	c454                	sw	a3,12(s0)
   1014e:	16840693          	addi	a3,s0,360
   10152:	c414                	sw	a3,8(s0)
   10154:	46a9                	li	a3,10
   10158:	03f00693          	li	a3,63
   1015e:	03f00693          	li	a3,63
   10164:	46a9                	li	a3,10
   10168:	0d040693          	addi	a3,s0,208
   1016c:	c014                	sw	a3,0(s0)
   1016e:	16440693          	addi	a3,s0,356
   10172:	c054                	sw	a3,4(s0)
   10174:	4681                	li	a3,0
   10176:	c814                	sw	a3,16(s0)
   1017a:	4814                	lw	a3,16(s0)
   1017c:	ea99                	bnez	a3,10192 <find>
   1017e:	46a9                	li	a3,10
   10182:	04f00693          	li	a3,79
   10188:	04b00693          	li	a3,75
   1018e:	46a9                	li	a3,10
   10196:	86ae                	mv	a3,a1
   10198:	428c                	lw	a1,0(a3)
   1019a:	0691                	addi	a3,a3,4
   1019c:	4288                	lw	a0,0(a3)
   101aa:	0691                	addi	a3,a3,4
   101ca:	fed85fe3          	bge	a6,a3,101c8 <skip>
   101d4:	8fb5                	xor	a5,a5,a3
   101d8:	ff06cfe3          	blt	a3,a6,101d6 <scan>
   101dc:	ff0699e3          	bne	a3,a6,101ce <hash>
   101ea:	c394                	sw	a3,0(a5)
   10200:	4094                	lw	a3,0(s1)
   10204:	0136d563          	bge	a3,s3,1020e <nest>
   10218:	84b6                	mv	s1,a3
   1023c:	00058683          	lb	a3,0(a1)
   10252:	00d58023          	sb	a3,0(a1)
   1026e:	4414                	lw	a3,8(s0)
   10270:	cc14                	sw	a3,24(s0)
   10272:	4685                	li	a3,1
   10274:	c814                	sw	a3,16(s0)
   10276:	4454                	lw	a3,12(s0)
   1027c:	86be                	mv	a3,a5
   1028a:	4c14                	lw	a3,24(s0)
   1028c:	c454                	sw	a3,12(s0)
   1028e:	4681                	li	a3,0
   10290:	c814                	sw	a3,16(s0)
   10292:	00002697          	auipc	a3,0x2
   10296:	d626a683          	lw	a3,-670(a3) # 11ff4 <_GLOBAL_OFFSET_TABLE_+0x24>
   102c0:	c298                	sw	a4,0(a3)
   102d0:	4294                	lw	a3,0(a3)
   102de:	8ef9                	and	a3,a3,a4
   102e0:	fff6c693          	not	a3,a3
   102f0:	96ba                	add	a3,a3,a4
   102fe:	ca89                	beqz	a3,10310 <back1>
   10300:	56fd                	li	a3,-1
   1030c:	86a2                	mv	a3,s0
   10312:	c394                	sw	a3,0(a5)
   1031a:	4394                	lw	a3,0(a5)
   1032a:	800006b7          	lui	a3,0x80000
   1033a:	00d716b3          	sll	a3,a4,a3
   1034a:	00d756b3          	srl	a3,a4,a3
   1037a:	4094                	lw	a3,0(s1)
   1039c:	8e36                	mv	t3,a3
   103ac:	01ee56b3          	srl	a3,t3,t5
   103b0:	8abd                	andi	a3,a3,15
   103b2:	0306e693          	ori	a3,a3,48
   103b6:	01d6c363          	blt	a3,t4,103bc <tohex+0x22>
   103ba:	069d                	addi	a3,a3,7 # 80000007 <FLAG_IMM+0x7>
   103d2:	fed87fe3          	bgeu	a6,a3,103d0 <nskip>
   103d8:	00e68a63          	beq	a3,a4,103ec <nodigit>
   103de:	97b6                	add	a5,a5,a3
   103e2:	ff06efe3          	bltu	a3,a6,103e0 <nscan>
   103e6:	ff0698e3          	bne	a3,a6,103d6 <ndigit>
   103ea:	86be                	mv	a3,a5
   103f0:	fd068693          	addi	a3,a3,-48
   103f4:	0006ca63          	bltz	a3,10408 <digit+0x18>
   103fa:	00a6c663          	blt	a3,a0,10406 <digit+0x16>
   103fe:	16e5                	addi	a3,a3,-7
   10402:	00d54363          	blt	a0,a3,10408 <digit+0x18>
   10408:	800006b7          	lui	a3,0x80000
   10410:	4394                	lw	a3,0(a5)
   1041a:	c394                	sw	a3,0(a5)
   1042c:	068d                	addi	a3,a3,3 # 80000003 <FLAG_IMM+0x3>
   1042e:	9af1                	andi	a3,a3,-4
   1043c:	fff6c693          	not	a3,a3
   1044c:	40d006b3          	neg	a3,a3
   10472:	43d4                	lw	a3,4(a5)
   10484:	c3d4                	sw	a3,4(a5)
   10494:	c3d4                	sw	a3,4(a5)
   10496:	4794                	lw	a3,8(a5)
   1049a:	c394                	sw	a3,0(a5)
   104a8:	00068683          	lb	a3,0(a3)
   104b8:	00e68023          	sb	a4,0(a3)
   104c8:	40d706b3          	sub	a3,a4,a3
   104d8:	8ef9                	and	a3,a3,a4
   104e6:	8ed9                	or	a3,a3,a4
   104f4:	8eb9                	xor	a3,a3,a4
   10502:	00e69463          	bne	a3,a4,1050a <isfalse>
   10506:	56fd                	li	a3,-1
   1050a:	4681                	li	a3,0
   10518:	fed747e3          	blt	a4,a3,10506 <istrue>
   10528:	fcd76fe3          	bltu	a4,a3,10506 <istrue>
   10538:	fcd047e3          	bgtz	a3,10506 <istrue>
   10548:	43d4                	lw	a3,4(a5)
   10556:	43d4                	lw	a3,4(a5)
   10570:	c394                	sw	a3,0(a5)
   10582:	4054                	lw	a3,4(s0)
   10590:	c054                	sw	a3,4(s0)
   1059c:	4014                	lw	a3,0(s0)
   105aa:	c014                	sw	a3,0(s0)
   105b6:	4094                	lw	a3,0(s1)
   105b8:	94b6                	add	s1,s1,a3
   105c6:	dae5                	beqz	a3,105b6 <branch>
   105d4:	fed041e3          	bgtz	a3,105b6 <branch>
   105f0:	56fd                	li	a3,-1
   105fc:	4681                	li	a3,0
   10608:	4691                	li	a3,4
   10614:	00002697          	auipc	a3,0x2
   10618:	9c86a683          	lw	a3,-1592(a3) # 11fdc <_GLOBAL_OFFSET_TABLE_+0xc>
   10626:	00002697          	auipc	a3,0x2
   1062a:	9b26a683          	lw	a3,-1614(a3) # 11fd8 <_GLOBAL_OFFSET_TABLE_+0x8>
   10638:	4814                	lw	a3,16(s0)
   10644:	4454                	lw	a3,12(s0)
   10650:	4414                	lw	a3,8(s0)
   1065c:	4c14                	lw	a3,24(s0)
   1066a:	02e69833          	mulh	a6,a3,a4
   1066e:	02e68733          	mul	a4,a3,a4
   10674:	86c2                	mv	a3,a6
   10682:	ca0684e3          	beqz	a3,1032a <by_erro>
   10686:	02e6c833          	div	a6,a3,a4
   1068a:	02e6e733          	rem	a4,a3,a4
   106ee:	02000693          	li	a3,32
   10704:	86b6                	mv	a3,a3
   10718:	02000693          	li	a3,32
   1072e:	86ba                	mv	a3,a4
   10742:	02000693          	li	a3,32
   10768:	c636                	sw	a3,12(sp)
   1077a:	46b2                	lw	a3,12(sp)
   107ac:	46a9                	li	a3,10
   107f0:	46a9                	li	a3,10
   10804:	86be                	mv	a3,a5
   1081a:	02000693          	li	a3,32
   10832:	86ba                	mv	a3,a4
   10848:	02000693          	li	a3,32
   10864:	46a9                	li	a3,10
   10884:	46a9                	li	a3,10
   10898:	05300693          	li	a3,83
   108c4:	46a9                	li	a3,10
   108da:	05200693          	li	a3,82
   10904:	03d00693          	li	a3,61
   1091c:	86be                	mv	a3,a5
   10932:	03a00693          	li	a3,58
   1094a:	86c2                	mv	a3,a6
   10960:	05b00693          	li	a3,91
   10978:	02000693          	li	a3,32
   10996:	86ba                	mv	a3,a4
   109ac:	02000693          	li	a3,32
   109ca:	05d00693          	li	a3,93
   109e2:	02000693          	li	a3,32
   109fe:	87b6                	mv	a5,a3
   10a08:	8836                	mv	a6,a3
   10a12:	46a9                	li	a3,10
   10a28:	86be                	mv	a3,a5
   10a3e:	03a00693          	li	a3,58
   10a58:	86ba                	mv	a3,a4
   10a7c:	46a9                	li	a3,10
   10a92:	05500693          	li	a3,85
   10aaa:	02000693          	li	a3,32
   10ac2:	05300693          	li	a3,83
   10ada:	02000693          	li	a3,32
   10aea:	4814                	lw	a3,16(s0)
   10af4:	86b6                	mv	a3,a3
   10b0a:	02000693          	li	a3,32
   10b22:	04c00693          	li	a3,76
   10b3a:	02000693          	li	a3,32
   10b4a:	4454                	lw	a3,12(s0)
   10b54:	86b6                	mv	a3,a3
   10b6a:	02000693          	li	a3,32
   10b82:	04800693          	li	a3,72
   10b9a:	02000693          	li	a3,32
   10baa:	4414                	lw	a3,8(s0)
   10bb4:	86b6                	mv	a3,a3
   10bca:	02000693          	li	a3,32
   10be2:	05000693          	li	a3,80
   10bfa:	02000693          	li	a3,32
   10c0a:	4c14                	lw	a3,24(s0)
   10c14:	86b6                	mv	a3,a3
   10c2a:	02000693          	li	a3,32
   10c42:	05300693          	li	a3,83
   10c5a:	05000693          	li	a3,80
   10c72:	02000693          	li	a3,32
   10c82:	4014                	lw	a3,0(s0)
   10c8c:	86b6                	mv	a3,a3
   10ca2:	02000693          	li	a3,32
   10cba:	05200693          	li	a3,82
   10cd2:	05000693          	li	a3,80
   10cea:	02000693          	li	a3,32
   10cfa:	4054                	lw	a3,4(s0)
   10d04:	86b6                	mv	a3,a3
   10d1a:	02000693          	li	a3,32
   10d36:	869e                	mv	a3,t2
   10d38:	fed7ae23          	sw	a3,-4(a5)
   10d3c:	869a                	mv	a3,t1
   10d3e:	fed7ac23          	sw	a3,-8(a5)
   10d42:	8696                	mv	a3,t0
   10d44:	fed7aa23          	sw	a3,-12(a5)
   10d5a:	4394                	lw	a3,0(a5)
   10d5c:	82b6                	mv	t0,a3
   10d5e:	43d4                	lw	a3,4(a5)
   10d60:	8336                	mv	t1,a3
   10d62:	4794                	lw	a3,8(a5)
   10d64:	83b6                	mv	t2,a3
