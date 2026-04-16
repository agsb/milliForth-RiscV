   1012c:	4290                	lw	a2,0(a3)
   10132:	8f71                	and	a4,a4,a2
   10134:	8e39                	xor	a2,a2,a4
   10136:	fec797e3          	bne	a5,a2,10124 <find+0x4>
   1013c:	4810                	lw	a2,16(s0)
   1013e:	c601                	beqz	a2,10146 <execute>
   101ac:	4605                	li	a2,1
   101c8:	4605                	li	a2,1
