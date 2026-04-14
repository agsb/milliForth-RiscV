   10142:	fec797e3          	bne	a5,a2,10130 <find+0x4>
   10160:	000017b7          	lui	a5,0x1
   10164:	50578793          	addi	a5,a5,1285 # 1505 <DJB2>
   10176:	873e                	mv	a4,a5
   10178:	0796                	slli	a5,a5,0x5
   1017a:	97ba                	add	a5,a5,a4
   1017c:	8fb5                	xor	a5,a5,a3
   10188:	0786                	slli	a5,a5,0x1
   1018a:	8385                	srli	a5,a5,0x1
   10194:	445c                	lw	a5,12(s0)
   10198:	0791                	addi	a5,a5,4
   1019a:	c45c                	sw	a5,12(s0)
   101ec:	405c                	lw	a5,4(s0)
   101f0:	0791                	addi	a5,a5,4
   101f2:	c05c                	sw	a5,4(s0)
   101f8:	00002797          	auipc	a5,0x2
   101fc:	dfc7a783          	lw	a5,-516(a5) # 11ff4 <_GLOBAL_OFFSET_TABLE_+0x24>
   10200:	00f6d463          	bge	a3,a5,10208 <nest>
   10208:	405c                	lw	a5,4(s0)
   1020a:	17f1                	addi	a5,a5,-4
   1020e:	c05c                	sw	a5,4(s0)
   1022a:	86be                	mv	a3,a5
   10270:	0791                	addi	a5,a5,4
   102bc:	401c                	lw	a5,0(s0)
   102be:	17f1                	addi	a5,a5,-4
   102c2:	c01c                	sw	a5,0(s0)
   102c6:	401c                	lw	a5,0(s0)
   102ca:	0791                	addi	a5,a5,4
