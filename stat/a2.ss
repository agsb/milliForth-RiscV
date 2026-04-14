   10138:	4290                	lw	a2,0(a3)
   1013e:	8f71                	and	a4,a4,a2
   10140:	8e39                	xor	a2,a2,a4
   10142:	fec797e3          	bne	a5,a2,10130 <find+0x4>
   10148:	4810                	lw	a2,16(s0)
   1014a:	c601                	beqz	a2,10152 <execute>
   101bc:	4605                	li	a2,1
   101d8:	4605                	li	a2,1
