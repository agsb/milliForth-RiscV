   10136:	fec797e3          	bne	a5,a2,10124 <find+0x4>
   10154:	000017b7          	lui	a5,0x1
   10158:	50578793          	addi	a5,a5,1285 # 1505 <DJB2>
   10166:	873e                	mv	a4,a5
   10168:	0796                	slli	a5,a5,0x5
   1016a:	97ba                	add	a5,a5,a4
   1016c:	8fb5                	xor	a5,a5,a3
   10178:	0786                	slli	a5,a5,0x1
   1017a:	8385                	srli	a5,a5,0x1
   10184:	445c                	lw	a5,12(s0)
   10186:	c394                	sw	a3,0(a5)
   10188:	0791                	addi	a5,a5,4
   1018a:	c45c                	sw	a5,12(s0)
   101dc:	405c                	lw	a5,4(s0)
   101de:	4384                	lw	s1,0(a5)
   101e0:	0791                	addi	a5,a5,4
   101e2:	c05c                	sw	a5,4(s0)
   101e8:	00002797          	auipc	a5,0x2
   101ec:	e0c7a783          	lw	a5,-500(a5) # 11ff4 <_GLOBAL_OFFSET_TABLE_+0x18>
   101f0:	00f6d463          	bge	a3,a5,101f8 <nest>
   101f8:	405c                	lw	a5,4(s0)
   101fa:	17f1                	addi	a5,a5,-4
   101fc:	c384                	sw	s1,0(a5)
   101fe:	c05c                	sw	a5,4(s0)
   1021a:	86be                	mv	a3,a5
   10260:	0791                	addi	a5,a5,4
   102ac:	401c                	lw	a5,0(s0)
   102ae:	17f1                	addi	a5,a5,-4
   102b0:	c394                	sw	a3,0(a5)
   102b2:	c01c                	sw	a5,0(s0)
   102b6:	401c                	lw	a5,0(s0)
   102b8:	4394                	lw	a3,0(a5)
   102ba:	0791                	addi	a5,a5,4
   102bc:	4398                	lw	a4,0(a5)
