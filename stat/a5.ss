   1015a:	fea797e3          	bne	a5,a0,10148 <find+0x2>
   10170:	000017b7          	lui	a5,0x1
   10174:	50578793          	addi	a5,a5,1285 # 1505 <DJB2>
   10182:	873e                	mv	a4,a5
   10184:	0796                	slli	a5,a5,0x5
   10186:	97ba                	add	a5,a5,a4
   10188:	8fb5                	xor	a5,a5,a3
   10194:	0786                	slli	a5,a5,0x1
   10196:	8385                	srli	a5,a5,0x1
   1019c:	441c                	lw	a5,8(s0)
   1019e:	c394                	sw	a3,0(a5)
   101a0:	0791                	addi	a5,a5,4
   101a2:	c41c                	sw	a5,8(s0)
   101aa:	405c                	lw	a5,4(s0)
   101ac:	4384                	lw	s1,0(a5)
   101ae:	0791                	addi	a5,a5,4
   101b0:	c05c                	sw	a5,4(s0)
   101be:	405c                	lw	a5,4(s0)
   101c0:	17f1                	addi	a5,a5,-4
   101c2:	c384                	sw	s1,0(a5)
   101c4:	c05c                	sw	a5,4(s0)
   1022a:	86be                	mv	a3,a5
   10284:	0791                	addi	a5,a5,4
   102d0:	401c                	lw	a5,0(s0)
   102d2:	17f1                	addi	a5,a5,-4
   102d4:	c394                	sw	a3,0(a5)
   102d6:	c01c                	sw	a5,0(s0)
   102da:	401c                	lw	a5,0(s0)
   102dc:	4394                	lw	a3,0(a5)
   102de:	0791                	addi	a5,a5,4
   102e0:	4398                	lw	a4,0(a5)
   10388:	4781                	li	a5,0
   1039e:	0792                	slli	a5,a5,0x4
   103a0:	97b6                	add	a5,a5,a3
   103ac:	86be                	mv	a3,a5
   1044e:	ca3e                	sw	a5,20(sp)
   10460:	47d2                	lw	a5,20(sp)
   10478:	445c                	lw	a5,12(s0)
   1049a:	fd77c8e3          	blt	a5,s7,1046a <returns>
   1049e:	8c3e                	mv	s8,a5
   104a4:	00082783          	lw	a5,0(a6)
   104b0:	445c                	lw	a5,12(s0)
   104ba:	faf858e3          	bge	a6,a5,1046a <returns>
   104ea:	86be                	mv	a3,a5
   10510:	4398                	lw	a4,0(a5)
   10544:	0791                	addi	a5,a5,4
   10546:	f907c2e3          	blt	a5,a6,104ca <wordt+0x4>
   10594:	401c                	lw	a5,0(s0)
   105d2:	405c                	lw	a5,4(s0)
   10606:	86be                	mv	a3,a5
   10674:	03078f63          	beq	a5,a6,106b2 <stackp+0xd2>
   10678:	4398                	lw	a4,0(a5)
   106ac:	0791                	addi	a5,a5,4
   106ae:	fd07c5e3          	blt	a5,a6,10678 <stackp+0x98>
   106ea:	87b6                	mv	a5,a3
   10710:	86be                	mv	a3,a5
   1074c:	4398                	lw	a4,0(a5)
   1076a:	0791                	addi	a5,a5,4
   10772:	fd07cde3          	blt	a5,a6,1074c <dumps+0x68>
