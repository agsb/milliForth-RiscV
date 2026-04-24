   10122:	440c                	lw	a1,8(s0)
   10124:	d5f5                	beqz	a1,10110 <abort>
   10126:	86ae                	mv	a3,a1
   10128:	428c                	lw	a1,0(a3)
   101c6:	00002597          	auipc	a1,0x2
   101ca:	e2a5a583          	lw	a1,-470(a1) # 11ff0 <_GLOBAL_OFFSET_TABLE_+0x14>
   101d4:	00058683          	lb	a3,0(a1)
   101e2:	00002597          	auipc	a1,0x2
   101e6:	e0e5a583          	lw	a1,-498(a1) # 11ff0 <_GLOBAL_OFFSET_TABLE_+0x14>
   101ec:	00d58023          	sb	a3,0(a1)
