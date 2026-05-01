   1013c:	4290                	lw	a2,0(a3)
   10142:	8f71                	and	a4,a4,a2
   10144:	8e39                	xor	a2,a2,a4
   10146:	fec797e3          	bne	a5,a2,10134 <find+0x2>
   1014c:	4810                	lw	a2,16(s0)
   1014e:	c601                	beqz	a2,10156 <execute>
   101d0:	4605                	li	a2,1
   101ec:	4605                	li	a2,1
