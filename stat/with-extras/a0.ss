   1013c:	4288                	lw	a0,0(a3)
   10142:	8f69                	and	a4,a4,a0
   10144:	8d39                	xor	a0,a0,a4
   10146:	fea797e3          	bne	a5,a0,10134 <find+0x2>
   101ba:	4501                	li	a0,0
   101c6:	4501                	li	a0,0
   101da:	dd71                	beqz	a0,101b6 <_exit>
   101e2:	4505                	li	a0,1
   10394:	4529                	li	a0,10
   10396:	00a6c663          	blt	a3,a0,103a2 <digit+0x16>
   1039c:	4541                	li	a0,16
   1039e:	00d54363          	blt	a0,a3,103a4 <digit+0x18>
