   1019e:	80000737          	lui	a4,0x80000
   101a2:	8f69                	and	a4,a4,a0
   101a4:	8d39                	xor	a0,a0,a4
   101b0:	e319                	bnez	a4,101b6 <execute>
   101ce:	873e                	mv	a4,a5
   101d2:	97ba                	add	a5,a5,a4
   102c0:	c298                	sw	a4,0(a3)
   102de:	8ef9                	and	a3,a3,a4
   102f0:	96ba                	add	a3,a3,a4
   1031e:	4398                	lw	a4,0(a5)
   1033a:	00d716b3          	sll	a3,a4,a3
   1034a:	00d756b3          	srl	a3,a4,a3
   103c8:	80000737          	lui	a4,0x80000
   103d8:	00e68a63          	beq	a3,a4,103ec <nodigit>
   10480:	43d8                	lw	a4,4(a5)
   10482:	c398                	sw	a4,0(a5)
   10492:	43d8                	lw	a4,4(a5)
   10498:	c798                	sw	a4,8(a5)
   104b8:	00e68023          	sb	a4,0(a3)
   104c8:	40d706b3          	sub	a3,a4,a3
   104d8:	8ef9                	and	a3,a3,a4
   104e6:	8ed9                	or	a3,a3,a4
   104f4:	8eb9                	xor	a3,a3,a4
   10502:	00e69463          	bne	a3,a4,1050a <isfalse>
   10518:	fed747e3          	blt	a4,a3,10506 <istrue>
   10528:	fcd76fe3          	bltu	a4,a3,10506 <istrue>
   10558:	4398                	lw	a4,0(a5)
   1055c:	c398                	sw	a4,0(a5)
   1056e:	4398                	lw	a4,0(a5)
   10574:	c398                	sw	a4,0(a5)
   1066a:	02e69833          	mulh	a6,a3,a4
   1066e:	02e68733          	mul	a4,a3,a4
   10672:	c398                	sw	a4,0(a5)
   10686:	02e6c833          	div	a6,a3,a4
   1068a:	02e6e733          	rem	a4,a3,a4
   1072e:	86ba                	mv	a3,a4
   1076a:	c83a                	sw	a4,16(sp)
   1077c:	4742                	lw	a4,16(sp)
   10828:	4398                	lw	a4,0(a5)
   10832:	86ba                	mv	a3,a4
   1098c:	4398                	lw	a4,0(a5)
   10996:	86ba                	mv	a3,a4
   10a00:	883a                	mv	a6,a4
   10a06:	87ba                	mv	a5,a4
   10a4e:	4398                	lw	a4,0(a5)
   10a58:	86ba                	mv	a3,a4
