   1013e:	80000737          	lui	a4,0x80000
   10142:	8f71                	and	a4,a4,a2
   10144:	8e39                	xor	a2,a2,a4
   10150:	e319                	bnez	a4,10156 <execute>
   1016e:	873e                	mv	a4,a5
   10172:	97ba                	add	a5,a5,a4
   1025c:	c298                	sw	a4,0(a3)
   1027a:	8ef9                	and	a3,a3,a4
   1028c:	96ba                	add	a3,a3,a4
   102ba:	4398                	lw	a4,0(a5)
