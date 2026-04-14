   1013a:	80000737          	lui	a4,0x80000
   1013e:	8f71                	and	a4,a4,a2
   10140:	8e39                	xor	a2,a2,a4
   1014c:	e319                	bnez	a4,10152 <execute>
   10176:	873e                	mv	a4,a5
   1017a:	97ba                	add	a5,a5,a4
   1026e:	c298                	sw	a4,0(a3)
   1028c:	8ef9                	and	a3,a3,a4
   1029e:	96ba                	add	a3,a3,a4
   102cc:	4398                	lw	a4,0(a5)
