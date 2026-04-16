   1012e:	80000737          	lui	a4,0x80000
   10132:	8f71                	and	a4,a4,a2
   10134:	8e39                	xor	a2,a2,a4
   10140:	e319                	bnez	a4,10146 <execute>
   10166:	873e                	mv	a4,a5
   1016a:	97ba                	add	a5,a5,a4
   1025e:	c298                	sw	a4,0(a3)
   1027c:	8ef9                	and	a3,a3,a4
   1028e:	96ba                	add	a3,a3,a4
   102bc:	4398                	lw	a4,0(a5)
