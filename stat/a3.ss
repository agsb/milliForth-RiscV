   10100:	14440693          	addi	a3,s0,324
   10104:	c454                	sw	a3,12(s0)
   10106:	00002697          	auipc	a3,0x2
   1010a:	ede6a683          	lw	a3,-290(a3) # 11fe4 <_GLOBAL_OFFSET_TABLE_+0x8>
   1010e:	c414                	sw	a3,8(s0)
   10110:	0b040693          	addi	a3,s0,176
   10114:	c014                	sw	a3,0(s0)
   10116:	14040693          	addi	a3,s0,320
   1011a:	c054                	sw	a3,4(s0)
   10126:	86ae                	mv	a3,a1
   10128:	428c                	lw	a1,0(a3)
   1012a:	0691                	addi	a3,a3,4
   1012c:	4290                	lw	a2,0(a3)
   1013a:	0691                	addi	a3,a3,4
   10162:	fed85fe3          	bge	a6,a3,10160 <token+0x10>
   1016c:	8fb5                	xor	a5,a5,a3
   10170:	ff06cfe3          	blt	a3,a6,1016e <token+0x1e>
   10174:	ff0699e3          	bne	a3,a6,10166 <token+0x16>
   10186:	c394                	sw	a3,0(a5)
   101b2:	00058683          	lb	a3,0(a1)
   101ca:	00d58023          	sb	a3,0(a1)
   101e4:	4094                	lw	a3,0(s1)
   101f0:	00f6d463          	bge	a3,a5,101f8 <nest>
   10200:	84b6                	mv	s1,a3
   1020c:	4454                	lw	a3,12(s0)
   1020e:	c854                	sw	a3,20(s0)
   10210:	4685                	li	a3,1
   10212:	c814                	sw	a3,16(s0)
   10214:	4414                	lw	a3,8(s0)
   1021a:	86be                	mv	a3,a5
   10228:	4854                	lw	a3,20(s0)
   1022a:	c414                	sw	a3,8(s0)
   10230:	00002697          	auipc	a3,0x2
   10234:	dc06a683          	lw	a3,-576(a3) # 11ff0 <_GLOBAL_OFFSET_TABLE_+0x14>
   1025e:	c298                	sw	a4,0(a3)
   1026e:	4294                	lw	a3,0(a3)
   1027c:	8ef9                	and	a3,a3,a4
   1027e:	fff6c693          	not	a3,a3
   1028e:	96ba                	add	a3,a3,a4
   1029c:	d6a1                	beqz	a3,101e4 <next>
   1029e:	56fd                	li	a3,-1
   102aa:	86a2                	mv	a3,s0
   102b0:	c394                	sw	a3,0(a5)
   102b8:	4394                	lw	a3,0(a5)
