   1013e:	80000737          	lui	a4,0x80000
   10142:	8f69                	and	a4,a4,a0
   10144:	8d39                	xor	a0,a0,a4
   10150:	e319                	bnez	a4,10156 <execute>
   1016e:	873e                	mv	a4,a5
   10172:	97ba                	add	a5,a5,a4
   1025c:	c298                	sw	a4,0(a3)
   1027a:	8ef9                	and	a3,a3,a4
   1028c:	96ba                	add	a3,a3,a4
   102ba:	4398                	lw	a4,0(a5)
   102d6:	00d716b3          	sll	a3,a4,a3
   102e6:	00d756b3          	srl	a3,a4,a3
   10364:	80000737          	lui	a4,0x80000
   10374:	00e68a63          	beq	a3,a4,10388 <nodigit>
   10416:	43d8                	lw	a4,4(a5)
   10418:	c398                	sw	a4,0(a5)
   10428:	43d8                	lw	a4,4(a5)
   1042e:	c798                	sw	a4,8(a5)
   1044e:	00e68023          	sb	a4,0(a3)
   1045e:	40d706b3          	sub	a3,a4,a3
   1046e:	8ef9                	and	a3,a3,a4
   1047c:	8ed9                	or	a3,a3,a4
   1048a:	8eb9                	xor	a3,a3,a4
   10498:	00e69463          	bne	a3,a4,104a0 <isfalse>
   104ae:	fed747e3          	blt	a4,a3,1049c <istrue>
   104be:	fcd76fe3          	bltu	a4,a3,1049c <istrue>
   104ee:	4398                	lw	a4,0(a5)
   104f2:	c398                	sw	a4,0(a5)
   10504:	4398                	lw	a4,0(a5)
   1050a:	c398                	sw	a4,0(a5)
   105f2:	02e69833          	mulh	a6,a3,a4
   105f6:	02e68733          	mul	a4,a3,a4
   105fa:	c398                	sw	a4,0(a5)
   1060e:	02e6c833          	div	a6,a3,a4
   10612:	02e6e733          	rem	a4,a3,a4
