   10132:	444c                	lw	a1,12(s0)
   10134:	d5f5                	beqz	a1,10120 <abort>
   10136:	86ae                	mv	a3,a1
   10138:	428c                	lw	a1,0(a3)
   101c8:	00002597          	auipc	a1,0x2
   101cc:	e285a583          	lw	a1,-472(a1) # 11ff0 <_GLOBAL_OFFSET_TABLE_+0x14>
   101d6:	00058683          	lb	a3,0(a1)
   101e4:	00002597          	auipc	a1,0x2
   101e8:	e0c5a583          	lw	a1,-500(a1) # 11ff0 <_GLOBAL_OFFSET_TABLE_+0x14>
   101ee:	00d58023          	sb	a3,0(a1)
