   1012e:	440c                	lw	a1,8(s0)
   10130:	d1f5                	beqz	a1,10114 <abort>
   10132:	86ae                	mv	a3,a1
   10134:	428c                	lw	a1,0(a3)
   101b4:	00002597          	auipc	a1,0x2
   101b8:	e385a583          	lw	a1,-456(a1) # 11fec <_GLOBAL_OFFSET_TABLE_+0x1c>
   101d0:	00002597          	auipc	a1,0x2
   101d4:	e1c5a583          	lw	a1,-484(a1) # 11fec <_GLOBAL_OFFSET_TABLE_+0x1c>
