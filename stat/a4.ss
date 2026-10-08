   10152:	80000737          	lui	a4,0x80000
   10156:	8f69                	and	a4,a4,a0
   10158:	8d39                	xor	a0,a0,a4
   10164:	e319                	bnez	a4,1016a <execute>
   10182:	873e                	mv	a4,a5
   10186:	97ba                	add	a5,a5,a4
   10282:	c298                	sw	a4,0(a3)
   102a0:	8ef9                	and	a3,a3,a4
   102b2:	96ba                	add	a3,a3,a4
   102e0:	4398                	lw	a4,0(a5)
   102fc:	00d716b3          	sll	a3,a4,a3
   1030c:	00d756b3          	srl	a3,a4,a3
   1035e:	8736                	mv	a4,a3
   1036e:	007756b3          	srl	a3,a4,t2
   1038a:	80000737          	lui	a4,0x80000
   1039a:	00e68a63          	beq	a3,a4,103ae <nodigit>
   1044c:	c83a                	sw	a4,16(sp)
   1045e:	4742                	lw	a4,16(sp)
   10510:	4398                	lw	a4,0(a5)
   1051e:	86ba                	mv	a3,a4
   10678:	4398                	lw	a4,0(a5)
   10686:	86ba                	mv	a3,a4
   106ec:	883a                	mv	a6,a4
   1074c:	4398                	lw	a4,0(a5)
   1075a:	86ba                	mv	a3,a4
