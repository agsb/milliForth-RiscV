   10100:	00002697          	auipc	a3,0x2
   10104:	ee46a683          	lw	a3,-284(a3) # 11fe4 <_GLOBAL_OFFSET_TABLE_+0x8>
   10108:	c414                	sw	a3,8(s0)
   1010a:	16440693          	addi	a3,s0,356
   1010e:	c454                	sw	a3,12(s0)
   10110:	0d040693          	addi	a3,s0,208
   10114:	c014                	sw	a3,0(s0)
   10116:	16040693          	addi	a3,s0,352
   1011a:	c054                	sw	a3,4(s0)
   1011c:	4681                	li	a3,0
   1011e:	c814                	sw	a3,16(s0)
   10126:	86ae                	mv	a3,a1
   10128:	428c                	lw	a1,0(a3)
   1012a:	0691                	addi	a3,a3,4
   1012c:	4290                	lw	a2,0(a3)
   1013a:	0691                	addi	a3,a3,4
   10160:	fed87fe3          	bgeu	a6,a3,1015e <skip>
   1016a:	8fb5                	xor	a5,a5,a3
   1016e:	ff06efe3          	bltu	a3,a6,1016c <scan>
   10172:	ff0699e3          	bne	a3,a6,10164 <hash>
   10180:	c394                	sw	a3,0(a5)
   10194:	4094                	lw	a3,0(s1)
   101a0:	00f6d463          	bge	a3,a5,101a8 <nest>
   101b0:	84b6                	mv	s1,a3
   101d4:	00058683          	lb	a3,0(a1)
   101ec:	00d58023          	sb	a3,0(a1)
   10208:	4454                	lw	a3,12(s0)
   1020a:	cc14                	sw	a3,24(s0)
   1020c:	4685                	li	a3,1
   1020e:	c814                	sw	a3,16(s0)
   10210:	4414                	lw	a3,8(s0)
   10216:	86be                	mv	a3,a5
   10224:	4c14                	lw	a3,24(s0)
   10226:	c414                	sw	a3,8(s0)
   1022c:	00002697          	auipc	a3,0x2
   10230:	dc86a683          	lw	a3,-568(a3) # 11ff4 <_GLOBAL_OFFSET_TABLE_+0x18>
   1025a:	c298                	sw	a4,0(a3)
   1026a:	4294                	lw	a3,0(a3)
   10278:	8ef9                	and	a3,a3,a4
   1027a:	fff6c693          	not	a3,a3
   1028a:	96ba                	add	a3,a3,a4
   10298:	ca89                	beqz	a3,102aa <back1>
   1029a:	56fd                	li	a3,-1
   102a6:	86a2                	mv	a3,s0
   102ac:	c394                	sw	a3,0(a5)
   102b4:	4394                	lw	a3,0(a5)
