   10100:	00002697          	auipc	a3,0x2
   10104:	ee46a683          	lw	a3,-284(a3) # 11fe4 <_GLOBAL_OFFSET_TABLE_+0x14>
   10108:	c414                	sw	a3,8(s0)
   1010a:	00002697          	auipc	a3,0x2
   1010e:	ed66a683          	lw	a3,-298(a3) # 11fe0 <_GLOBAL_OFFSET_TABLE_+0x10>
   10112:	c454                	sw	a3,12(s0)
   10114:	00002697          	auipc	a3,0x2
   10118:	ec46a683          	lw	a3,-316(a3) # 11fd8 <_GLOBAL_OFFSET_TABLE_+0x8>
   1011c:	c014                	sw	a3,0(s0)
   1011e:	00002697          	auipc	a3,0x2
   10122:	ebe6a683          	lw	a3,-322(a3) # 11fdc <_GLOBAL_OFFSET_TABLE_+0xc>
   10126:	c054                	sw	a3,4(s0)
   10132:	86ae                	mv	a3,a1
   10136:	0691                	addi	a3,a3,4
   10146:	0691                	addi	a3,a3,4
   1016e:	ff06cfe3          	blt	a3,a6,1016c <token+0x10>
   10172:	ff068de3          	beq	a3,a6,1016c <token+0x10>
   1017c:	8fb5                	xor	a5,a5,a3
   10180:	ff06cfe3          	blt	a3,a6,1017e <token+0x22>
   10184:	ff0699e3          	bne	a3,a6,10176 <token+0x1a>
   10196:	c394                	sw	a3,0(a5)
   101c2:	00058683          	lb	a3,0(a1)
   101da:	00d58023          	sb	a3,0(a1)
   101f4:	4094                	lw	a3,0(s1)
   10200:	00f6d463          	bge	a3,a5,10208 <nest>
   10204:	000680e7          	jalr	a3
   10210:	84b6                	mv	s1,a3
   1021c:	4454                	lw	a3,12(s0)
   1021e:	c854                	sw	a3,20(s0)
   10220:	4685                	li	a3,1
   10222:	c814                	sw	a3,16(s0)
   10224:	4414                	lw	a3,8(s0)
   1022a:	86be                	mv	a3,a5
   10238:	4854                	lw	a3,20(s0)
   1023a:	c414                	sw	a3,8(s0)
   10240:	00002697          	auipc	a3,0x2
   10244:	db06a683          	lw	a3,-592(a3) # 11ff0 <_GLOBAL_OFFSET_TABLE_+0x20>
   1027e:	4294                	lw	a3,0(a3)
   1028c:	8ef9                	and	a3,a3,a4
   1028e:	fff6c693          	not	a3,a3
   1029e:	96ba                	add	a3,a3,a4
   102ac:	d6a1                	beqz	a3,101f4 <next>
   102ae:	56fd                	li	a3,-1
   102ba:	86a2                	mv	a3,s0
   102c0:	c394                	sw	a3,0(a5)
   102c8:	4394                	lw	a3,0(a5)
