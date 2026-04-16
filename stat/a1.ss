   10122:	440c                	lw	a1,8(s0)
   10124:	d5f5                	beqz	a1,10110 <abort>
   10126:	86ae                	mv	a3,a1
   10128:	428c                	lw	a1,0(a3)
   101a4:	00002597          	auipc	a1,0x2
   101a8:	e485a583          	lw	a1,-440(a1) # 11fec <_GLOBAL_OFFSET_TABLE_+0x10>
   101b2:	00058683          	lb	a3,0(a1)
   101c0:	00002597          	auipc	a1,0x2
   101c4:	e2c5a583          	lw	a1,-468(a1) # 11fec <_GLOBAL_OFFSET_TABLE_+0x10>
   101ca:	00d58023          	sb	a3,0(a1)
