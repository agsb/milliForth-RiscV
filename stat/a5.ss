   10136:	fec797e3          	bne	a5,a2,10124 <find+0x2>
   10152:	000017b7          	lui	a5,0x1
   10156:	50578793          	addi	a5,a5,1285 # 1505 <DJB2>
   10164:	873e                	mv	a4,a5
   10166:	0796                	slli	a5,a5,0x5
   10168:	97ba                	add	a5,a5,a4
   1016a:	8fb5                	xor	a5,a5,a3
   10176:	0786                	slli	a5,a5,0x1
   10178:	8385                	srli	a5,a5,0x1
   1017e:	445c                	lw	a5,12(s0)
   10180:	c394                	sw	a3,0(a5)
   10182:	0791                	addi	a5,a5,4
   10184:	c45c                	sw	a5,12(s0)
   1018c:	405c                	lw	a5,4(s0)
   1018e:	4384                	lw	s1,0(a5)
   10190:	0791                	addi	a5,a5,4
   10192:	c05c                	sw	a5,4(s0)
   10198:	00002797          	auipc	a5,0x2
   1019c:	e547a783          	lw	a5,-428(a5) # 11fec <_GLOBAL_OFFSET_TABLE_+0x10>
   101a0:	00f6d463          	bge	a3,a5,101a8 <nest>
   101a8:	405c                	lw	a5,4(s0)
   101aa:	17f1                	addi	a5,a5,-4
   101ac:	c384                	sw	s1,0(a5)
   101ae:	c05c                	sw	a5,4(s0)
   10216:	86be                	mv	a3,a5
   1025c:	0791                	addi	a5,a5,4
   102a8:	401c                	lw	a5,0(s0)
   102aa:	17f1                	addi	a5,a5,-4
   102ac:	c394                	sw	a3,0(a5)
   102ae:	c01c                	sw	a5,0(s0)
   102b2:	401c                	lw	a5,0(s0)
   102b4:	4394                	lw	a3,0(a5)
   102b6:	0791                	addi	a5,a5,4
   102b8:	4398                	lw	a4,0(a5)
