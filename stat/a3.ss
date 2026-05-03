   10110:	00002697          	auipc	a3,0x2
   10114:	edc6a683          	lw	a3,-292(a3) # 11fec <_GLOBAL_OFFSET_TABLE_+0x10>
   10118:	c454                	sw	a3,12(s0)
   1011a:	16840693          	addi	a3,s0,360
   1011e:	c414                	sw	a3,8(s0)
   10120:	0d040693          	addi	a3,s0,208
   10124:	c014                	sw	a3,0(s0)
   10126:	16440693          	addi	a3,s0,356
   1012a:	c054                	sw	a3,4(s0)
   1012c:	4681                	li	a3,0
   1012e:	c814                	sw	a3,16(s0)
   10136:	86ae                	mv	a3,a1
   10138:	428c                	lw	a1,0(a3)
   1013a:	0691                	addi	a3,a3,4
   1013c:	4290                	lw	a2,0(a3)
   1014a:	0691                	addi	a3,a3,4
   1016a:	fed87fe3          	bgeu	a6,a3,10168 <skip>
   10174:	8fb5                	xor	a5,a5,a3
   10178:	ff06efe3          	bltu	a3,a6,10176 <scan>
   1017c:	ff0699e3          	bne	a3,a6,1016e <hash>
   1018a:	c394                	sw	a3,0(a5)
   1019e:	4094                	lw	a3,0(s1)
   101a2:	0136d463          	bge	a3,s3,101aa <nest>
   101b2:	84b6                	mv	s1,a3
   101d6:	00058683          	lb	a3,0(a1)
   101ee:	00d58023          	sb	a3,0(a1)
   1020a:	4414                	lw	a3,8(s0)
   1020c:	c854                	sw	a3,20(s0)
   1020e:	4685                	li	a3,1
   10210:	c814                	sw	a3,16(s0)
   10212:	4454                	lw	a3,12(s0)
   10218:	86be                	mv	a3,a5
   10226:	4854                	lw	a3,20(s0)
   10228:	c454                	sw	a3,12(s0)
   1022a:	4681                	li	a3,0
   1022c:	c814                	sw	a3,16(s0)
   1022e:	00002697          	auipc	a3,0x2
   10232:	dc66a683          	lw	a3,-570(a3) # 11ff4 <_GLOBAL_OFFSET_TABLE_+0x18>
   1025c:	c298                	sw	a4,0(a3)
   1026c:	4294                	lw	a3,0(a3)
   1027a:	8ef9                	and	a3,a3,a4
   1027c:	fff6c693          	not	a3,a3
   1028c:	96ba                	add	a3,a3,a4
   1029a:	ca89                	beqz	a3,102ac <back1>
   1029c:	56fd                	li	a3,-1
   102a8:	86a2                	mv	a3,s0
   102ae:	c394                	sw	a3,0(a5)
   102b6:	4394                	lw	a3,0(a5)
