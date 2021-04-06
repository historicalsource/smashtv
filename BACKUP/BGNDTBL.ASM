	.OPTION	B,D,L,T
	.include	"BGNDTBL.GLO"
	.DATA

L7HDRS:
	.word	24,96	;x size, y size
	.long	>25A20C0	;address
	.word	24,60
	.long	>25A68C0
	.word	24,76
	.long	>25A95C0
	.word	196,12
	.long	>25ACEC0
	.word	52,56
	.long	>25B1840
	.word	12,70
	.long	>25B7340
	.word	12,59
	.long	>25B8D80
	.word	16,54
	.long	>25BA3A0
	.word	112,14
	.long	>25BBEA0
	.word	16,17
	.long	>25BEFA0
	.word	112,33
	.long	>25BF820
	.word	20,46
	.long	>25C6BA0
	.word	20,46
	.long	>25C6BA0
	.word	32,7
	.long	>25C8860
	.word	84,7
	.long	>25C8F60
	.word	108,17
	.long	>25CA1C0
	.word	36,23
	.long	>25CDB20
	.word	104,50
	.long	>25CF500
	.word	20,11
	.long	>25D9780
	.word	24,14
	.long	>25D9E60
	.word	24,14
	.long	>25D9E60
	.word	24,24
	.long	>25DA8E0
	.word	28,17
	.long	>25DBAE0
	.word	32,30
	.long	>25DC9C0
	.word	64,18
	.long	>25DE7C0
	.word	64,43
	.long	>25E0BC0
	.word	40,18
	.long	>25E61C0
	.word	40,30
	.long	>25E7840
	.word	32,30
	.long	>25E9DC0
	.word	32,30
	.long	>25E9DC0
	.word	20,61
	.long	>25EBBC0
	.word	64,43
	.long	>25E0BC0
	.word	64,18
	.long	>25DE7C0
	.word	32,30
	.long	>25E9DC0
	.word	32,30
	.long	>25E9DC0
	.word	40,30
	.long	>25E7840
	.word	20,61
	.long	>25EBBC0
	.word	12,14
	.long	>25EE1E0
	.word	112,14
	.long	>25BBEA0
	.word	112,33
	.long	>25BF820
	.word	20,11
	.long	>25D9780
	.word	24,14
	.long	>25D9E60
	.word	24,14
	.long	>25D9E60
	.word	32,7
	.long	>25C8860
	.word	16,54
	.long	>25BA3A0
	.word	16,17
	.long	>25EE720
	.word	12,59
	.long	>25B8D80
	.word	24,60
	.long	>25A68C0
	.word	24,76
	.long	>25A95C0
	.word	12,70
	.long	>25B7340
	.word	56,8
	.long	>25EEFA0
	.word	104,46
	.long	>25EFDA0
	.word	56,8
	.long	>25EEFA0
	.word	60,12
	.long	>25F9320
	.word	40,15
	.long	>25FA9A0
	.word	40,25
	.long	>25FBC60
	.word	40,25
	.long	>25FBC60
	.word	40,15
	.long	>25FA9A0
	.word	60,12
	.long	>25F9320
	.word	104,46
	.long	>25EFDA0
	.word	56,8
	.long	>25EEFA0
	.word	56,8
	.long	>25EEFA0
	.word	16,17
	.long	>25FDBA0
	.word	104,49
	.long	>25FE420


ARENA3BLKS:
	.word	>7F40	;flags
	.word	0,241 ;x,y
	.word	>6	;pal5,pal4,hdr13-0
	.word	>4040,0,178,>4
	.word	>4140,0,55,>2
	.word	>7E40,0,82,>0
	.word	>7340,1,0,>8
	.word	>7A40,11,95,>A
	.word	>4040,14,115,>C
	.word	>4040,23,190,>E
	.word	>4040,23,79,>10
	.word	>4040,24,93,>1A
	.word	>4040,24,100,>18
	.word	>4060,24,144,>16
	.word	>4140,24,46,>14
	.word	>7440,24,10,>12
	.word	>7640,29,65,>1C
	.word	>4040,42,128,>1E
	.word	>4060,42,145,>1E
	.word	>4240,53,0,>7E
	.word	>4050,60,118,>24
	.word	>4050,83,192,>28
	.word	>4040,132,87,>2E
	.word	>4040,133,45,>30
	.word	>4040,135,63,>32
	.word	>4050,149,174,>2A
	.word	>4040,156,15,>36
	.word	>7C40,156,0,>6C
	.word	>7840,158,15,>6E
	.word	>4040,164,113,>3A
	.word	>4060,164,143,>38
	.word	>4040,178,180,>3C
	.word	>4050,193,63,>3E
	.word	>7950,194,15,>70
	.word	>7F50,195,241,>6
	.word	>4050,195,45,>40
	.word	>7C50,195,0,>72
	.word	>4050,196,113,>44
	.word	>4070,196,143,>42
	.word	>4050,196,15,>46
	.word	>4050,197,180,>48
	.word	>4040,233,218,>4A
	.word	>4150,234,0,>76
	.word	>4050,242,128,>1E
	.word	>4070,242,145,>1E
	.word	>4060,250,88,>4A
	.word	>4050,256,79,>4C
	.word	>4150,257,46,>4E
	.word	>4040,266,118,>50
	.word	>7740,266,65,>1C
	.word	>4040,277,192,>54
	.word	>4040,335,93,>56
	.word	>7350,338,0,>8
	.word	>4050,348,100,>18
	.word	>4070,348,144,>16
	.word	>4050,352,190,>58
	.word	>7540,355,10,>5A
	.word	>4050,366,115,>5C
	.word	>4050,367,178,>60
	.word	>4150,367,55,>5E
	.word	>7E50,367,82,>0
	.word	>7B50,368,95,>62
	.word	0FFFFH	;End Marker

ARENA2BLKS:
	.word	>7E41	;flags
	.word	0,82 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4141,0,55,>2
	.word	>4041,0,178,>4
	.word	>7F41,0,241,>6
	.word	>7341,1,0,>8
	.word	>7A40,11,95,>A
	.word	>4040,14,115,>C
	.word	>4040,23,79,>10
	.word	>4040,23,190,>E
	.word	>7440,24,10,>12
	.word	>4140,24,46,>14
	.word	>4060,24,144,>16
	.word	>4040,24,100,>18
	.word	>4040,24,93,>1A
	.word	>7640,29,65,>1C
	.word	>4060,42,145,>1E
	.word	>4040,42,128,>1E
	.word	>4241,53,0,>7E
	.word	>4050,60,118,>24
	.word	>4050,83,192,>28
	.word	>4040,132,87,>2E
	.word	>4040,133,45,>30
	.word	>4040,135,63,>32
	.word	>4050,149,174,>2A
	.word	>7C41,156,0,>6C
	.word	>4040,156,15,>36
	.word	>7840,158,15,>6E
	.word	>4060,164,143,>38
	.word	>4040,164,113,>3A
	.word	>4040,178,180,>3C
	.word	>4050,193,63,>3E
	.word	>7950,194,15,>70
	.word	>7C51,195,0,>72
	.word	>4050,195,45,>40
	.word	>7F51,195,241,>6
	.word	>4050,196,15,>46
	.word	>4070,196,143,>42
	.word	>4050,196,113,>44
	.word	>4050,197,180,>48
	.word	>4040,233,218,>4A
	.word	>4251,234,0,>7E
	.word	>4070,242,145,>1E
	.word	>4050,242,128,>1E
	.word	>4060,250,88,>4A
	.word	>4050,256,79,>4C
	.word	>4150,257,46,>4E
	.word	>7740,266,65,>1C
	.word	>4040,266,118,>50
	.word	>4040,277,192,>54
	.word	>4040,335,93,>56
	.word	>7351,338,0,>8
	.word	>4070,348,144,>16
	.word	>4050,348,100,>18
	.word	>4050,352,190,>58
	.word	>7540,355,10,>5A
	.word	>4050,366,115,>5C
	.word	>7E51,367,82,>0
	.word	>4151,367,55,>5E
	.word	>4051,367,178,>60
	.word	>7B50,368,95,>62
	.word	0FFFFH	;End Marker

ARENABLKS:
	.word	>4040	;flags
	.word	0,178 ;x,y
	.word	>4	;pal5,pal4,hdr13-0
	.word	>4140,0,55,>2
	.word	>7E40,0,82,>0
	.word	>7F40,0,241,>6
	.word	>7340,1,0,>8
	.word	>7A40,11,95,>A
	.word	>4040,14,115,>C
	.word	>4040,23,190,>E
	.word	>4040,23,80,>10
	.word	>4040,24,93,>1A
	.word	>4040,24,100,>18
	.word	>4060,24,144,>16
	.word	>4140,24,46,>14
	.word	>7440,24,10,>12
	.word	>7640,29,65,>1C
	.word	>4040,42,128,>1E
	.word	>4060,42,145,>1E
	.word	>4060,48,216,>20
	.word	>4140,53,0,>66
	.word	>4050,60,118,>24
	.word	>4040,82,95,>26
	.word	>4050,83,192,>28
	.word	>4040,93,168,>2A
	.word	>4040,132,88,>2E
	.word	>4040,133,45,>30
	.word	>4040,135,63,>32
	.word	>4050,149,174,>2A
	.word	>4040,156,15,>36
	.word	>7C40,156,0,>6C
	.word	>7840,158,15,>6E
	.word	>4040,164,113,>3A
	.word	>4060,164,143,>38
	.word	>4040,178,180,>3C
	.word	>4050,193,63,>3E
	.word	>7950,194,15,>70
	.word	>4050,195,45,>40
	.word	>7C50,195,0,>72
	.word	>7F50,195,241,>6
	.word	>4050,196,113,>44
	.word	>4070,196,143,>42
	.word	>4050,196,15,>46
	.word	>4050,197,180,>48
	.word	>4040,233,218,>4A
	.word	>4150,234,0,>76
	.word	>4050,242,128,>1E
	.word	>4070,242,145,>1E
	.word	>4060,250,88,>4A
	.word	>4050,256,80,>4C
	.word	>4150,257,46,>4E
	.word	>4040,266,118,>50
	.word	>7740,266,65,>1C
	.word	>4050,275,95,>52
	.word	>4040,277,192,>54
	.word	>4050,284,203,>20
	.word	>4040,298,97,>20
	.word	>4040,335,93,>56
	.word	>7350,338,0,>8
	.word	>4050,348,100,>18
	.word	>4070,348,144,>16
	.word	>4050,352,190,>58
	.word	>7540,355,10,>5A
	.word	>4050,366,115,>5C
	.word	>4050,367,178,>60
	.word	>4150,367,55,>5E
	.word	>7E50,367,82,>0
	.word	>7B50,368,95,>62
	.word	0FFFFH	;End Marker

BROKENBLKS:
	.word	>7E40	;flags
	.word	0,82 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4140,0,55,>2
	.word	>4040,0,178,>4
	.word	>7F40,0,241,>6
	.word	>7340,1,0,>8
	.word	>7A40,11,95,>A
	.word	>4040,14,115,>C
	.word	>4040,23,190,>E
	.word	>4040,23,79,>10
	.word	>7440,24,10,>12
	.word	>4140,24,46,>14
	.word	>4060,24,144,>16
	.word	>4040,24,100,>18
	.word	>4040,24,93,>1A
	.word	>7640,29,65,>1C
	.word	>4060,42,145,>1E
	.word	>4040,42,128,>1E
	.word	>4060,48,216,>20
	.word	>4040,53,0,>22
	.word	>4050,60,118,>24
	.word	>4040,82,95,>26
	.word	>4050,83,192,>28
	.word	>4040,93,168,>2A
	.word	>4040,127,76,>2C
	.word	>4040,132,87,>2E
	.word	>4040,133,46,>30
	.word	>4040,135,63,>32
	.word	>4050,149,174,>2A
	.word	>4040,154,0,>34
	.word	>4040,156,16,>36
	.word	>4060,164,143,>38
	.word	>4040,164,113,>3A
	.word	>4040,178,180,>3C
	.word	>4050,193,63,>3E
	.word	>4040,194,0,>34
	.word	>7F50,195,241,>6
	.word	>4050,195,46,>40
	.word	>4070,196,143,>42
	.word	>4050,196,113,>44
	.word	>4050,196,16,>46
	.word	>4050,197,180,>48
	.word	>4040,233,218,>4A
	.word	>4050,234,0,>22
	.word	>4070,242,145,>1E
	.word	>4050,242,128,>1E
	.word	>4060,250,88,>4A
	.word	>550,255,79,>4C
	.word	>4150,257,46,>4E
	.word	>7740,266,65,>1C
	.word	>4040,266,118,>50
	.word	>4050,275,95,>52
	.word	>4040,277,192,>54
	.word	>4050,284,203,>20
	.word	>4040,298,97,>20
	.word	>4040,335,93,>56
	.word	>7350,338,0,>8
	.word	>4070,348,144,>16
	.word	>4050,348,100,>18
	.word	>4050,352,190,>58
	.word	>7540,355,10,>5A
	.word	>4050,366,115,>5C
	.word	>7E50,367,82,>0
	.word	>4150,367,55,>5E
	.word	>4050,367,178,>60
	.word	>7B50,368,95,>62
	.word	0FFFFH	;End Marker

L7MOD0BLKS:
	.word	>7F40	;flags
	.word	864,1062 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4140,864,1035,>2
	.word	>4040,864,1158,>4
	.word	>7C40,865,980,>8
	.word	>7A40,875,1075,>A
	.word	>4040,878,1095,>C
	.word	>4040,887,1170,>E
	.word	>4040,887,1059,>10
	.word	>4140,888,1026,>14
	.word	>4060,888,1124,>16
	.word	>4040,888,1080,>18
	.word	>4040,888,1073,>1A
	.word	>7F40,888,1225,>64
	.word	>7D40,888,990,>12
	.word	>7640,893,1045,>1C
	.word	>4060,906,1125,>1E
	.word	>4040,906,1108,>1E
	.word	>4060,912,1196,>20
	.word	>4140,917,980,>66
	.word	>4050,924,1098,>24
	.word	>7F40,944,1225,>68
	.word	>4040,946,1075,>26
	.word	>4050,947,1172,>28
	.word	>4040,957,1148,>2A
	.word	>4040,996,1067,>2E
	.word	>4040,997,1025,>30
	.word	>4040,999,1043,>32
	.word	>7F40,1000,1221,>6A
	.word	>4050,1013,1154,>2A
	.word	>4040,1020,995,>36
	.word	>7F40,1020,980,>6C
	.word	>7840,1022,995,>6E
	.word	>4060,1028,1123,>38
	.word	>4040,1028,1093,>3A
	.word	>4040,1042,1160,>3C
	.word	>4050,1057,1043,>3E
	.word	>7950,1058,995,>70
	.word	>4050,1059,1025,>40
	.word	>7F50,1059,980,>72
	.word	>4050,1060,995,>46
	.word	>7F50,1060,1221,>74
	.word	>4070,1060,1123,>42
	.word	>4050,1060,1093,>44
	.word	>4050,1061,1160,>48
	.word	>4040,1097,1198,>4A
	.word	>4150,1098,980,>76
	.word	>4070,1106,1125,>1E
	.word	>4050,1106,1108,>1E
	.word	>4060,1114,1068,>4A
	.word	>7F40,1119,1225,>78
	.word	>4050,1120,1059,>4C
	.word	>4150,1121,1026,>4E
	.word	>4040,1130,1098,>50
	.word	>4050,1139,1075,>52
	.word	>4040,1141,1172,>54
	.word	>7740,1148,1045,>1C
	.word	>4050,1148,1183,>20
	.word	>4040,1162,1077,>20
	.word	>7F40,1175,1225,>7A
	.word	>4040,1199,1073,>56
	.word	>7C50,1202,980,>8
	.word	>4070,1212,1124,>16
	.word	>4050,1212,1080,>18
	.word	>4050,1216,1170,>58
	.word	>7E40,1219,990,>7C
	.word	>4050,1230,1095,>5C
	.word	>7F50,1231,1062,>0
	.word	>4150,1231,1035,>5E
	.word	>4050,1231,1158,>60
	.word	>7B50,1232,1075,>62
	.word	0FFFFH		;End Marker
ARENA3BMOD:
	.word	391,254,60	;x size, y size, #blocks
	.long	ARENA3BLKS, L7HDRS, L7PALS
ARENA2BMOD:
	.word	391,254,60	;x size, y size, #blocks
	.long	ARENA2BLKS, L7HDRS, L7PALS
ARENABMOD:
	.word	391,254,66	;x size, y size, #blocks
	.long	ARENABLKS, L7HDRS, L7PALS
BROKENBMOD:
	.word	391,254,65	;x size, y size, #blocks
	.long	BROKENBLKS, L7HDRS, L7PALS

T7HDRS:
	.word	12,28	;x size, y size
	.long	>2608360	;address
	.word	12,16
	.long	>2608DE0
	.word	72,69
	.long	>26093E0
	.word	204,44
	.long	>2612F20
	.word	24,10
	.long	>26247A0
	.word	8,78
	.long	>2624F20
	.word	28,32
	.long	>26262A0
	.word	152,106
	.long	>2627EA0
	.word	12,70
	.long	>2647620
	.word	36,62
	.long	>2649060
	.word	16,22
	.long	>264D620
	.word	20,59
	.long	>264E120
	.word	68,37
	.long	>2650600
	.word	24,26
	.long	>26554A0
	.word	12,14
	.long	>2656820
	.word	16,15
	.long	>2656D60
	.word	16,15
	.long	>26574E0
	.word	32,39
	.long	>2657C60
	.word	12,12
	.long	>265A360
	.word	12,15
	.long	>265A7E0
	.word	20,57
	.long	>265AD80
	.word	20,21
	.long	>265D120
	.word	76,17
	.long	>265DE40
	.word	12,27
	.long	>26606A0
	.word	36,45
	.long	>26610C0
	.word	32,26
	.long	>2664360
	.word	32,39
	.long	>2665D60
	.word	12,96
	.long	>2668460
	.word	28,27
	.long	>266A860
	.word	20,27
	.long	>266C000
	.word	12,11
	.long	>266D0E0
	.word	12,15
	.long	>265A7E0
	.word	60,27
	.long	>266D500
	.word	84,33
	.long	>26707A0
	.word	84,33
	.long	>26707A0
	.word	84,50
	.long	>2675E40
	.word	44,24
	.long	>267E180
	.word	44,24
	.long	>2680280
	.word	44,24
	.long	>2682380
	.word	12,15
	.long	>265A7E0
	.word	12,15
	.long	>2684480
	.word	48,22
	.long	>2684A20
	.word	28,46
	.long	>2686B20
	.word	56,39
	.long	>2689360
	.word	40,21
	.long	>268D7A0
	.word	24,22
	.long	>268F1E0
	.word	12,12
	.long	>265A360
	.word	20,22
	.long	>2690260
	.word	16,22
	.long	>264D620
	.word	40,24
	.long	>2691020
	.word	12,74
	.long	>2692E20
	.word	20,22
	.long	>2690260
	.word	16,47
	.long	>26949E0
	.word	16,15
	.long	>26574E0
	.word	32,39
	.long	>2657C60
	.word	20,21
	.long	>265D120
	.word	12,89
	.long	>2696160
	.word	44,37
	.long	>26982C0
	.word	8,37
	.long	>269B5A0
	.word	40,30
	.long	>25E7840
	.word	40,9
	.long	>269BEE0
	.word	8,24
	.long	>269CA20
	.word	20,61
	.long	>25EBBC0
	.word	20,61
	.long	>25EBBC0
	.word	8,24
	.long	>269D020
	.word	196,10
	.long	>269D620
	.word	196,14
	.long	>26A1360
	.word	200,10
	.long	>26A6920
	.word	8,192
	.long	>26AA7A0
	.word	20,191
	.long	>26AD7A0


VWLKYCBLKS:
	.word	>7E42	;flags
	.word	0,238 ;x,y
	.word	>48	;pal5,pal4,hdr13-0
	.word	>7F52,0,203,>40
	.word	>7E42,0,205,>42
	.word	>7E42,0,0,>44
	.word	>7E42,0,33,>46
	.word	>7E42,0,83,>48
	.word	>7E42,0,107,>4A
	.word	>7E42,0,131,>4C
	.word	>7E42,0,155,>46
	.word	>7F53,0,70,>88
	.word	>7F41,4,106,>4E
	.word	>7F41,5,127,>50
	.word	>7F41,10,0,>5A
	.word	>7F41,11,121,>5C
	.word	>7F41,12,141,>5C
	.word	>7F41,24,58,>60
	.word	>7F42,25,0,>40
	.word	>7E52,37,131,>4C
	.word	>7E52,37,83,>48
	.word	>7E52,37,107,>4A
	.word	>7E52,37,238,>48
	.word	>7F51,47,204,>5A
	.word	>7F41,47,48,>5E
	.word	>7F41,47,171,>5E
	.word	>7F51,55,249,>5C
	.word	>7F51,57,94,>5C
	.word	>7F51,58,140,>5C
	.word	>7F51,62,235,>50
	.word	>7F63,63,71,>8A
	.word	>7F51,64,126,>50
	.word	>7F51,64,79,>4E
	.word	0FFFFH	;End Marker

VWLKWYBBLKS:
	.word	>7F42	;flags
	.word	0,187 ;x,y
	.word	>58	;pal5,pal4,hdr13-0
	.word	>7E62,0,155,>44
	.word	>7E42,0,131,>4C
	.word	>7E42,0,107,>4A
	.word	>7E42,0,83,>48
	.word	>7E42,0,33,>46
	.word	>7E42,0,0,>44
	.word	>7F41,3,64,>50
	.word	>7F41,4,79,>50
	.word	>7F51,4,135,>5E
	.word	>7F41,5,105,>4E
	.word	>4042,12,208,>54
	.word	>7F41,12,93,>5C
	.word	>7F41,12,119,>5C
	.word	>7F41,12,153,>5A
	.word	>7F41,12,1,>5A
	.word	>7F42,25,151,>40
	.word	>7F42,25,1,>40
	.word	>7E52,37,131,>4C
	.word	>7E52,37,107,>4A
	.word	>7E52,37,83,>48
	.word	>4042,38,208,>54
	.word	>4052,40,187,>62
	.word	>7F51,49,55,>5C
	.word	>7F51,56,41,>4E
	.word	>7F41,57,122,>66
	.word	>7F63,63,67,>8A
	.word	>4052,64,211,>68
	.word	0FFFFH	;End Marker

VWLKWYABLKS:
	.word	>7E42	;flags
	.word	0,155 ;x,y
	.word	>46	;pal5,pal4,hdr13-0
	.word	>7E42,0,131,>4C
	.word	>7E42,0,107,>4A
	.word	>7E42,0,83,>48
	.word	>7E42,0,33,>46
	.word	>7E42,0,0,>44
	.word	>7E42,0,205,>42
	.word	>7F52,0,203,>40
	.word	>7E42,0,238,>48
	.word	>7F53,0,70,>88
	.word	>7F41,4,106,>4E
	.word	>7F41,5,127,>50
	.word	>7F41,10,0,>5A
	.word	>7F41,11,121,>5C
	.word	>7F41,12,141,>5C
	.word	>7F41,24,58,>60
	.word	>7F42,25,0,>40
	.word	>7E52,37,238,>48
	.word	>7E52,37,107,>4A
	.word	>7E52,37,83,>48
	.word	>7E52,37,131,>4C
	.word	>7F41,47,171,>5E
	.word	>7F41,47,48,>5E
	.word	>7F51,47,204,>5A
	.word	>7F51,55,249,>5C
	.word	>7F51,57,94,>5C
	.word	>7F51,58,140,>5C
	.word	>7F51,62,235,>50
	.word	>7F51,64,79,>4E
	.word	>7F51,64,126,>50
	.word	>7F43,73,70,>88
	.word	0FFFFH	;End Marker

HWLKWYABLKS:
	.word	>4052	;flags
	.word	0,1 ;x,y
	.word	>56	;pal5,pal4,hdr13-0
	.word	>7F43,2,76,>82
	.word	>7F43,4,0,>86
	.word	>4052,54,1,>56
	.word	>4051,54,48,>60
	.word	>3F51,70,66,>6A
	.word	>3F42,77,40,>6C
	.word	>3E42,80,67,>6E
	.word	>3F51,89,69,>1E
	.word	>4042,109,1,>70
	.word	>4052,120,54,>74
	.word	>4042,120,0,>72
	.word	>4052,120,37,>74
	.word	>4140,160,8,>76
	.word	>7F40,161,10,>7A
	.word	>7E42,161,0,>78
	.word	>3F40,181,41,>7C
	.word	>4040,181,25,>7C
	.word	>7F53,196,0,>86
	.word	>3F50,199,41,>7E
	.word	>4050,199,25,>7E
	.word	>7E52,199,0,>78
	.word	>4150,200,8,>76
	.word	>7F53,202,76,>82
	.word	>7F40,232,10,>80
	.word	>4052,236,0,>72
	.word	>4062,272,56,>74
	.word	>4062,272,37,>74
	.word	>4052,279,1,>70
	.word	>4042,290,1,>56
	.word	>4042,344,1,>56
	.word	0FFFFH	;End Marker

HWLKWYBLKS:
	.word	>4052	;flags
	.word	0,1 ;x,y
	.word	>56	;pal5,pal4,hdr13-0
	.word	>4051,54,48,>60
	.word	>4052,54,1,>56
	.word	>3F51,70,66,>6A
	.word	>3F42,77,40,>6C
	.word	>3E42,80,67,>6E
	.word	>3F51,89,69,>1E
	.word	>4042,109,1,>70
	.word	>4052,120,37,>74
	.word	>4042,120,0,>72
	.word	>4052,120,54,>74
	.word	>4140,160,8,>76
	.word	>7F40,161,10,>7A
	.word	>7F42,161,0,>78
	.word	>4040,181,25,>7C
	.word	>3F40,181,41,>7C
	.word	>4050,199,25,>7E
	.word	>3F50,199,41,>7E
	.word	>7F52,199,0,>78
	.word	>4150,200,8,>76
	.word	>7F40,232,10,>80
	.word	>4052,236,0,>72
	.word	>4062,272,37,>74
	.word	>4062,272,56,>74
	.word	>4052,279,1,>70
	.word	>4042,290,1,>56
	.word	>4042,344,1,>56
	.word	0FFFFH	;End Marker

VWLKWYBLKS:
	.word	>7F52	;flags
	.word	0,203 ;x,y
	.word	>40	;pal5,pal4,hdr13-0
	.word	>7E42,0,205,>42
	.word	>7E42,0,0,>44
	.word	>7E42,0,33,>46
	.word	>7E42,0,83,>48
	.word	>7E42,0,107,>4A
	.word	>7E42,0,131,>4C
	.word	>7E42,0,155,>46
	.word	>7E42,0,238,>48
	.word	>7F41,4,106,>4E
	.word	>7F41,5,127,>50
	.word	>7F41,10,0,>5A
	.word	>7F41,11,121,>5C
	.word	>7F41,12,141,>5C
	.word	>7F41,24,58,>60
	.word	>7F42,25,0,>40
	.word	>7E52,37,131,>4C
	.word	>7E52,37,83,>48
	.word	>7E52,37,107,>4A
	.word	>7E52,37,238,>48
	.word	>7F51,47,204,>5A
	.word	>7F41,47,48,>5E
	.word	>7F41,47,171,>5E
	.word	>7F51,55,249,>5C
	.word	>7F51,57,94,>5C
	.word	>7F51,58,140,>5C
	.word	>7F51,62,235,>50
	.word	>7F51,64,126,>50
	.word	>7F51,64,79,>4E
	.word	0FFFFH	;End Marker

WLKRGTBLKS:
	.word	>4051	;flags
	.word	0,231 ;x,y
	.word	>52	;pal5,pal4,hdr13-0
	.word	>4042,1,208,>54
	.word	>7E42,4,0,>44
	.word	>7E42,4,33,>46
	.word	>7E42,4,83,>48
	.word	>7E42,4,107,>4A
	.word	>7E42,4,131,>4C
	.word	>7E62,4,155,>44
	.word	>7F42,4,187,>58
	.word	>7F41,7,64,>50
	.word	>7F51,8,135,>5E
	.word	>7F41,8,79,>50
	.word	>7F41,9,105,>4E
	.word	>7F41,16,1,>5A
	.word	>7F41,16,153,>5A
	.word	>7F41,16,119,>5C
	.word	>7F41,16,93,>5C
	.word	>4042,16,208,>54
	.word	>7F42,29,1,>40
	.word	>7F42,29,151,>40
	.word	>7E52,41,83,>48
	.word	>7E52,41,107,>4A
	.word	>7E52,41,131,>4C
	.word	>4042,42,208,>54
	.word	>4052,44,187,>62
	.word	>7F51,53,55,>5C
	.word	>7F51,60,41,>4E
	.word	>7F41,61,122,>66
	.word	>4052,68,211,>68
	.word	0FFFFH	;End Marker

TVSETBLKS:
	.word	>7F52	;flags
	.word	0,88 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>7F52,0,143,>0
	.word	>7F52,0,116,>0
	.word	>4052,0,10,>0
	.word	>4052,0,38,>0
	.word	>4052,0,63,>0
	.word	>4052,0,166,>0
	.word	>4042,0,194,>2
	.word	>2C42,1,173,>4
	.word	>4041,1,210,>6
	.word	>4042,2,0,>8
	.word	>7E42,10,100,>A
	.word	>4042,11,178,>C
	.word	>4042,12,10,>E
	.word	>7A40,13,101,>10
	.word	>3C42,18,116,>12
	.word	>4042,21,0,>8
	.word	>5251,34,177,>14
	.word	>4042,44,0,>8
	.word	>2C42,53,172,>4
	.word	>4042,54,116,>16
	.word	>5251,56,90,>14
	.word	>4144,61,18,>18
	.word	>4042,68,0,>8
	.word	>4042,73,116,>16
	.word	>7F42,83,75,>1A
	.word	>5151,91,188,>1C
	.word	>4042,91,116,>16
	.word	>4051,92,174,>1E
	.word	>4042,92,0,>8
	.word	>3C51,107,217,>1C
	.word	>5151,109,203,>20
	.word	>4042,110,116,>16
	.word	>7F52,112,78,>22
	.word	>4042,116,0,>8
	.word	>2C42,124,173,>4
	.word	>4042,128,116,>16
	.word	>4051,129,205,>24
	.word	>5051,136,191,>26
	.word	>5041,138,101,>26
	.word	>4042,140,0,>8
	.word	>5142,145,173,>22
	.word	>4042,145,116,>28
	.word	>5042,148,197,>2A
	.word	>7C42,157,1,>2C
	.word	>6441,162,27,>2E
	.word	>4142,163,149,>30
	.word	>7840,164,19,>32
	.word	>3C42,164,17,>34
	.word	>4042,164,56,>36
	.word	>4052,176,56,>36
	.word	>6641,185,138,>38
	.word	>4042,188,56,>36
	.word	>4051,188,210,>6
	.word	>2C42,196,173,>4
	.word	>7950,196,19,>32
	.word	>3C52,196,17,>34
	.word	>4152,199,149,>30
	.word	>4042,200,56,>36
	.word	>5141,203,198,>20
	.word	>4042,203,56,>36
	.word	>5141,209,212,>1C
	.word	>6551,210,28,>3A
	.word	>4042,213,56,>36
	.word	>3C42,221,55,>36
	.word	>4052,228,10,>E
	.word	>4152,229,111,>3C
	.word	>4052,233,116,>28
	.word	>4042,233,0,>8
	.word	>4042,249,116,>16
	.word	>2C42,252,172,>4
	.word	>4042,257,0,>8
	.word	>5152,259,153,>22
	.word	>4144,264,18,>18
	.word	>4042,266,116,>16
	.word	>5042,267,179,>2A
	.word	>5141,280,180,>20
	.word	>4042,281,0,>8
	.word	>7F52,285,75,>1A
	.word	>4052,285,116,>16
	.word	>5141,286,194,>1C
	.word	>5041,289,171,>26
	.word	>4041,296,185,>24
	.word	>4041,304,160,>14
	.word	>4052,304,116,>16
	.word	>4042,305,0,>8
	.word	>5152,312,78,>22
	.word	>2C42,320,173,>4
	.word	>4052,323,116,>16
	.word	>4042,329,0,>8
	.word	>5141,336,101,>20
	.word	>4052,338,116,>12
	.word	>4052,353,178,>C
	.word	>4042,353,0,>8
	.word	>4041,365,195,>3E
	.word	>7B50,367,101,>10
	.word	>7C42,367,0,>8
	.word	>4041,372,209,>24
	.word	>7C52,374,100,>A
	.word	>7C62,379,84,>0
	.word	>7C62,379,139,>0
	.word	>7C62,379,111,>0
	.word	>4062,379,167,>0
	.word	>4162,379,1,>0
	.word	>4062,379,57,>0
	.word	>4062,379,29,>0
	.word	>4052,380,194,>2
	.word	0FFFFH	;End Marker

HWLKWYBBLKS:
	.word	>4052	;flags
	.word	0,1 ;x,y
	.word	>56	;pal5,pal4,hdr13-0
	.word	>4043,2,72,>84
	.word	>7F43,4,0,>86
	.word	>4051,54,48,>60
	.word	>4052,54,1,>56
	.word	>3F51,70,66,>6A
	.word	>3F42,77,40,>6C
	.word	>3E42,80,67,>6E
	.word	>3F51,89,69,>1E
	.word	>4042,109,1,>70
	.word	>4052,120,37,>74
	.word	>4042,120,0,>72
	.word	>4052,120,54,>74
	.word	>4140,160,8,>76
	.word	>7E42,161,0,>78
	.word	>7F40,161,10,>7A
	.word	>4040,181,25,>7C
	.word	>3F40,181,41,>7C
	.word	>7F53,196,0,>86
	.word	>7E52,199,0,>78
	.word	>4050,199,25,>7E
	.word	>3F50,199,41,>7E
	.word	>4150,200,8,>76
	.word	>7F53,202,76,>82
	.word	>7F40,232,10,>80
	.word	>4052,236,0,>72
	.word	>4062,272,37,>74
	.word	>4062,272,56,>74
	.word	>4052,279,1,>70
	.word	>4042,290,1,>56
	.word	>4042,344,1,>56
	.word	0FFFFH	;End Marker

T7MOD0BLKS:
	.word	>4042	;flags
	.word	202,372 ;x,y
	.word	>2	;pal5,pal4,hdr13-0
	.word	>4052,202,344,>0
	.word	>4052,202,241,>0
	.word	>4052,202,216,>0
	.word	>4052,202,188,>0
	.word	>7F52,202,294,>0
	.word	>7F52,202,321,>0
	.word	>7F52,202,266,>0
	.word	>2C42,203,351,>4
	.word	>5041,203,388,>6
	.word	>4042,204,178,>8
	.word	>7E42,212,278,>A
	.word	>4042,213,356,>C
	.word	>7A40,215,279,>10
	.word	>3C42,220,294,>12
	.word	>4042,223,178,>8
	.word	>5251,236,355,>14
	.word	>4042,246,178,>8
	.word	>2C42,255,350,>4
	.word	>4042,256,294,>16
	.word	>5251,258,268,>14
	.word	>4042,270,178,>8
	.word	>4042,275,294,>16
	.word	>7F42,285,253,>1A
	.word	>4042,293,294,>16
	.word	>5151,293,366,>1C
	.word	>4042,294,178,>8
	.word	>4051,294,352,>1E
	.word	>3F51,309,395,>1C
	.word	>3F51,311,381,>20
	.word	>4042,312,294,>16
	.word	>7F52,314,256,>22
	.word	>4042,318,178,>8
	.word	>2C42,326,351,>4
	.word	>4042,330,294,>16
	.word	>4051,331,383,>24
	.word	>5051,338,369,>26
	.word	>5041,340,279,>26
	.word	>4042,342,178,>8
	.word	>4042,347,294,>28
	.word	>5142,347,351,>22
	.word	>5042,350,375,>2A
	.word	>7C42,359,179,>2C
	.word	>6441,364,205,>2E
	.word	>4142,365,327,>30
	.word	>4042,366,234,>36
	.word	>3C42,366,195,>34
	.word	>7840,366,197,>32
	.word	>4052,378,234,>36
	.word	>6641,387,316,>38
	.word	>4051,390,388,>6
	.word	>4042,390,234,>36
	.word	>3C52,398,195,>34
	.word	>7950,398,197,>32
	.word	>2C42,398,351,>4
	.word	>4152,401,327,>30
	.word	>4042,402,234,>36
	.word	>4042,405,234,>36
	.word	>5141,405,376,>20
	.word	>5141,411,390,>1C
	.word	>6551,412,206,>3A
	.word	>4042,415,234,>36
	.word	>3C42,423,233,>36
	.word	>4052,430,188,>E
	.word	>4152,431,289,>3C
	.word	>4042,435,178,>8
	.word	>4052,435,294,>28
	.word	>4042,451,294,>16
	.word	>2C42,454,350,>4
	.word	>4042,459,178,>8
	.word	>5152,461,331,>22
	.word	>4042,468,294,>16
	.word	>5042,469,357,>2A
	.word	>5141,482,358,>20
	.word	>4042,483,178,>8
	.word	>4052,487,294,>16
	.word	>7F52,487,253,>1A
	.word	>5141,488,372,>1C
	.word	>5041,491,349,>26
	.word	>4052,492,481,>56
	.word	>4041,498,363,>24
	.word	>4052,506,294,>16
	.word	>4041,506,338,>14
	.word	>4042,507,178,>8
	.word	>5152,514,256,>22
	.word	>2C42,522,351,>4
	.word	>4052,525,294,>16
	.word	>4042,531,178,>8
	.word	>4042,534,627,>64
	.word	>5141,538,279,>20
	.word	>4052,540,294,>12
	.word	>4052,546,481,>56
	.word	>4051,546,528,>60
	.word	>4042,555,178,>8
	.word	>4052,555,356,>C
	.word	>3F51,562,546,>6A
	.word	>4042,565,629,>64
	.word	>4041,567,373,>3E
	.word	>7C42,569,178,>8
	.word	>7B50,569,279,>10
	.word	>3F42,569,520,>6C
	.word	>3E42,572,547,>6E
	.word	>4041,574,387,>24
	.word	>7C52,576,278,>A
	.word	>4062,581,207,>0
	.word	>4062,581,235,>0
	.word	>4162,581,179,>0
	.word	>4062,581,345,>0
	.word	>7C62,581,289,>0
	.word	>7C62,581,317,>0
	.word	>7C62,581,262,>0
	.word	>3F51,581,549,>1E
	.word	>4052,582,372,>2
	.word	>4052,583,629,>64
	.word	>4042,601,481,>70
	.word	>4052,611,629,>64
	.word	>4042,612,480,>72
	.word	>4052,612,534,>74
	.word	>4052,612,517,>74
	.word	>4051,626,411,>52
	.word	>4042,627,388,>54
	.word	>7F42,630,367,>58
	.word	>7E62,630,335,>44
	.word	>7E42,630,311,>4C
	.word	>7E42,630,287,>4A
	.word	>7E42,630,263,>48
	.word	>7E42,630,213,>46
	.word	>7E42,630,180,>44
	.word	>7F41,633,244,>50
	.word	>7F41,634,259,>50
	.word	>7F51,634,315,>5E
	.word	>7F41,635,285,>4E
	.word	>4042,642,388,>54
	.word	>7F41,642,273,>5C
	.word	>7F41,642,299,>5C
	.word	>7F41,642,333,>5A
	.word	>7F41,642,181,>5A
	.word	>4140,652,488,>76
	.word	>7F42,653,480,>78
	.word	>7F40,653,490,>7A
	.word	>7F42,655,331,>40
	.word	>7F42,655,181,>40
	.word	>7E52,667,311,>4C
	.word	>7E52,667,287,>4A
	.word	>7E52,667,263,>48
	.word	>4042,668,388,>54
	.word	>4052,670,367,>62
	.word	>3F40,673,521,>7C
	.word	>4040,673,505,>7C
	.word	>7F51,679,235,>5C
	.word	>7F51,686,221,>4E
	.word	>7F41,687,302,>66
	.word	>7F52,691,480,>78
	.word	>3F50,691,521,>7E
	.word	>4050,691,505,>7E
	.word	>4150,692,488,>76
	.word	>4052,694,391,>68
	.word	>4042,702,631,>70
	.word	>7F40,724,490,>80
	.word	>4052,728,480,>72
	.word	>4042,737,1727,>64
	.word	>7E42,757,418,>48
	.word	>7E42,757,335,>46
	.word	>7E42,757,311,>4C
	.word	>7E42,757,287,>4A
	.word	>7E42,757,263,>48
	.word	>7E42,757,213,>46
	.word	>7E42,757,180,>44
	.word	>7E42,757,385,>42
	.word	>7F52,757,383,>40
	.word	>7F41,761,286,>4E
	.word	>7F41,762,307,>50
	.word	>4062,764,517,>74
	.word	>4062,764,535,>74
	.word	>7F41,767,180,>5A
	.word	>7F41,768,301,>5C
	.word	>7F41,769,321,>5C
	.word	>4052,771,481,>70
	.word	>4042,776,1780,>64
	.word	>7F41,781,238,>60
	.word	>4042,782,481,>56
	.word	>7F42,782,180,>40
	.word	>7E52,794,418,>48
	.word	>7E52,794,287,>4A
	.word	>7E52,794,263,>48
	.word	>7E52,794,311,>4C
	.word	>7F41,804,351,>5E
	.word	>7F41,804,228,>5E
	.word	>7F51,804,384,>5A
	.word	>7F51,812,429,>5C
	.word	>7F51,814,274,>5C
	.word	>7F51,815,320,>5C
	.word	>7F51,819,415,>50
	.word	>7F51,821,259,>4E
	.word	>7F51,821,306,>50
	.word	>4042,836,481,>56
	.word	>4051,1507,411,>52
	.word	>4042,1508,388,>54
	.word	0FFFFH		;End Marker
VWLKYCBMOD:
	.word	85,262,31	;x size, y size, #blocks
	.long	VWLKYCBLKS, T7HDRS, T7PALS
VWLKWYBBMOD:
	.word	85,258,28	;x size, y size, #blocks
	.long	VWLKWYBBLKS, T7HDRS, T7PALS
VWLKWYABMOD:
	.word	85,262,31	;x size, y size, #blocks
	.long	VWLKWYABLKS, T7HDRS, T7PALS
HWLKWYABMOD:
	.word	400,102,31	;x size, y size, #blocks
	.long	HWLKWYABLKS, T7HDRS, T7PALS
HWLKWYBMOD:
	.word	400,102,27	;x size, y size, #blocks
	.long	HWLKWYBLKS, T7HDRS, T7PALS
VWLKWYBMOD:
	.word	85,262,29	;x size, y size, #blocks
	.long	VWLKWYBLKS, T7HDRS, T7PALS
WLKRGTBMOD:
	.word	89,258,29	;x size, y size, #blocks
	.long	WLKRGTBLKS, T7HDRS, T7PALS
TVSETBMOD:
	.word	392,254,107	;x size, y size, #blocks
	.long	TVSETBLKS, T7HDRS, T7PALS
HWLKWYBBMOD:
	.word	400,102,31	;x size, y size, #blocks
	.long	HWLKWYBBLKS, T7HDRS, T7PALS

NHDRS:
	.word	212,20	;x size, y size
	.long	>26B4F00	;address
	.word	76,252
	.long	>26BD380
	.word	64,40
	.long	>26E2A00
	.word	112,132
	.long	>26E7A00
	.word	120,139
	.long	>2704800
	.word	160,147
	.long	>2725140
	.word	20,25
	.long	>2753040
	.word	108,23
	.long	>2753FE0
	.word	164,21
	.long	>2758D80
	.word	160,103
	.long	>275F920
	.word	160,147
	.long	>277FC20
	.word	16,14
	.long	>27ADB20
	.word	56,36
	.long	>27AE220
	.word	12,20
	.long	>27B2120
	.word	152,25
	.long	>27B28A0
	.word	12,10
	.long	>27B9F60
	.word	116,117
	.long	>27BA320
	.word	76,252
	.long	>27D4B40


TITPGBLKS:
	.word	>4044	;flags
	.word	0,0 ;x,y
	.word	>2	;pal5,pal4,hdr13-0
	.word	>4646,36,227,>4
	.word	>4445,53,103,>6
	.word	>4441,53,31,>8
	.word	>4346,57,122,>A
	.word	>4556,85,158,>4
	.word	>4646,117,175,>4
	.word	>4442,138,223,>E
	.word	>4042,162,7,>12
	.word	>4246,188,136,>14
	.word	>4043,196,20,>18
	.word	>4340,203,98,>20
	.word	>4646,275,190,>4
	.word	>4044,311,0,>22
	.word	0FFFFH	;End Marker

FBIBLKS:
	.word	>4047	;flags
	.word	0,181 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4047,111,0,>C
	.word	>4047,111,24,>C
	.word	>4047,111,49,>C
	.word	>4047,111,74,>C
	.word	>4047,111,99,>C
	.word	>4047,111,124,>C
	.word	>4047,111,138,>C
	.word	>4047,129,0,>C
	.word	>4047,129,58,>C
	.word	>4047,145,58,>C
	.word	>4047,146,0,>C
	.word	>4047,166,206,>10
	.word	>4047,174,0,>C
	.word	>4047,174,25,>C
	.word	>4047,174,50,>C
	.word	>4047,174,75,>C
	.word	>4047,174,100,>C
	.word	>4047,174,125,>C
	.word	>4047,174,138,>C
	.word	>4047,192,0,>C
	.word	>4047,192,138,>C
	.word	>4047,192,58,>C
	.word	>4047,206,138,>C
	.word	>4047,206,58,>C
	.word	>4047,207,0,>C
	.word	>4047,216,125,>C
	.word	>4047,216,10,>C
	.word	>4047,216,35,>C
	.word	>4047,216,80,>C
	.word	>4047,216,100,>C
	.word	>4047,221,149,>16
	.word	>4047,224,60,>1A
	.word	>4047,225,181,>1C
	.word	>4047,226,0,>1E
	.word	>4047,248,0,>C
	.word	>4047,248,25,>C
	.word	>4047,248,50,>C
	.word	>4047,248,74,>C
	.word	>4047,248,99,>C
	.word	>4047,248,124,>C
	.word	>4047,248,140,>C
	.word	0FFFFH	;End Marker

NMOD0BLKS:
	.word	0FFFFH		;End Marker
TITPGBMOD:
	.word	387,283,14	;x size, y size, #blocks
	.long	TITPGBLKS, NHDRS, NPALS
FBIBMOD:
	.word	377,227,42	;x size, y size, #blocks
	.long	FBIBLKS, NHDRS, NPALS

LTPGHDRS:
	.word	128,51	;x size, y size
	.long	>27FA1C0	;address
	.word	40,76
	.long	>2806DC0
	.word	40,6
	.long	>280CCC0
	.word	80,136
	.long	>280D440
	.word	112,6
	.long	>2822840
	.word	112,6
	.long	>2822840


logo2BLKS:
	.word	>4040	;flags
	.word	0,131 ;x,y
	.word	>2	;pal5,pal4,hdr13-0
	.word	>4060,0,51,>2
	.word	>4060,0,0,>0
	.word	>4040,0,199,>2
	.word	>4040,1,126,>4
	.word	>4070,268,0,>0
	.word	>4050,356,127,>4
	.word	>4050,357,131,>2
	.word	>4070,357,51,>2
	.word	>4050,357,200,>2
	.word	0FFFFH	;End Marker

LOGOBLKS:
	.word	>4060	;flags
	.word	0,0 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4060,0,51,>2
	.word	>4040,0,207,>0
	.word	>4040,0,131,>2
	.word	>4040,1,126,>4
	.word	>4040,121,51,>6
	.word	>4050,199,51,>6
	.word	>4070,268,0,>0
	.word	>4050,269,207,>0
	.word	>4050,356,127,>4
	.word	>4070,357,51,>2
	.word	>4050,357,131,>2
	.word	0FFFFH	;End Marker

LTPGMOD0BLKS:
	.word	>4040	;flags
	.word	1303,610 ;x,y
	.word	>2	;pal5,pal4,hdr13-0
	.word	>4040,1303,686,>0
	.word	>4060,1303,530,>2
	.word	>4060,1303,479,>0
	.word	>4040,1304,605,>4
	.word	>4040,1424,530,>6
	.word	>4040,1429,479,>8
	.word	>4040,1429,731,>A
	.word	>4040,1464,479,>8
	.word	>4040,1465,731,>8
	.word	>4050,1502,530,>6
	.word	>4070,1571,479,>0
	.word	>4050,1572,686,>0
	.word	>4050,1659,606,>4
	.word	>4050,1660,610,>2
	.word	>4070,1660,530,>2
	.word	>4060,1773,480,>0
	.word	>4060,1773,531,>2
	.word	>4040,1773,611,>2
	.word	>4040,1774,606,>4
	.word	>4040,2007,917,>2
	.word	>4060,2007,718,>0
	.word	>4060,2007,769,>2
	.word	>4040,2007,849,>2
	.word	>4040,2008,844,>4
	.word	>4070,2041,480,>0
	.word	>4050,2129,607,>4
	.word	>4070,2130,531,>2
	.word	>4050,2130,611,>2
	.word	>4070,2275,718,>0
	.word	>4050,2363,845,>4
	.word	>4050,2364,918,>2
	.word	>4070,2364,769,>2
	.word	>4050,2364,849,>2
	.word	0FFFFH		;End Marker
logo2BMOD:
	.word	397,276,10	;x size, y size, #blocks
	.long	logo2BLKS, LTPGHDRS, LTPGPALS
LOGOBMOD:
	.word	397,258,12	;x size, y size, #blocks
	.long	LOGOBLKS, LTPGHDRS, LTPGPALS

SHDRS:
	.word	20,164	;x size, y size
	.long	>2823D40	;address
	.word	20,90
	.long	>282A3C0
	.word	160,15
	.long	>282DC00
	.word	80,16
	.long	>2832700
	.word	68,45
	.long	>2834F00
	.word	20,164
	.long	>283AEA0
	.word	160,15
	.long	>2841520


BONUSBLKS:
	.word	>4040	;flags
	.word	0,0 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,2,166,>2
	.word	>4040,17,149,>4
	.word	>4040,19,166,>2
	.word	>4040,20,0,>6
	.word	>4040,27,214,>8
	.word	>4040,36,166,>2
	.word	>4040,53,166,>2
	.word	>4040,70,166,>2
	.word	>4040,87,166,>2
	.word	>4050,93,214,>8
	.word	>4040,95,0,>6
	.word	>4040,104,166,>2
	.word	>4040,121,166,>2
	.word	>4040,138,166,>2
	.word	>4040,154,166,>2
	.word	>4040,171,166,>2
	.word	>4050,174,0,>0
	.word	>4040,177,166,>2
	.word	>4040,197,166,>2
	.word	>4040,197,0,>0
	.word	>4040,214,166,>2
	.word	>4040,214,149,>4
	.word	>4040,216,0,>6
	.word	>4040,228,214,>8
	.word	>4040,231,166,>2
	.word	>4040,248,166,>2
	.word	>4040,265,166,>2
	.word	>4040,282,166,>2
	.word	>4040,291,0,>6
	.word	>4050,294,214,>8
	.word	>4040,299,166,>2
	.word	>4040,315,166,>2
	.word	>4040,332,166,>2
	.word	>4040,349,166,>2
	.word	>4040,365,166,>2
	.word	>4050,371,0,>0
	.word	>4040,373,166,>2
	.word	0FFFFH	;End Marker

SMOD0BLKS:
	.word	>4040	;flags
	.word	2287,26 ;x,y
	.word	>A	;pal5,pal4,hdr13-0
	.word	>4040,2289,192,>2
	.word	>4040,2304,175,>C
	.word	>4040,2306,192,>2
	.word	>4040,2307,26,>6
	.word	>4040,2314,240,>8
	.word	>4040,2323,192,>2
	.word	>4040,2340,192,>2
	.word	>4040,2357,192,>2
	.word	>4040,2374,192,>2
	.word	>4050,2380,240,>8
	.word	>4040,2382,26,>6
	.word	>4040,2391,192,>2
	.word	>4040,2408,192,>2
	.word	>4040,2425,192,>2
	.word	>4040,2441,192,>2
	.word	>4040,2458,192,>2
	.word	>4050,2461,26,>A
	.word	>4040,2464,192,>2
	.word	>4040,2483,26,>A
	.word	>4040,2484,192,>2
	.word	>4040,2501,175,>C
	.word	>4040,2501,192,>2
	.word	>4040,2503,26,>6
	.word	>4040,2515,240,>8
	.word	>4040,2518,192,>2
	.word	>4040,2535,192,>2
	.word	>4040,2552,192,>2
	.word	>4040,2569,192,>2
	.word	>4040,2578,26,>6
	.word	>4050,2581,240,>8
	.word	>4040,2586,192,>2
	.word	>4040,2602,192,>2
	.word	>4040,2619,192,>2
	.word	>4040,2636,192,>2
	.word	>4040,2652,192,>2
	.word	>4050,2658,26,>A
	.word	>4040,2660,192,>2
	.word	0FFFFH		;End Marker
BONUSBMOD:
	.word	393,259,38	;x size, y size, #blocks
	.long	BONUSBLKS, SHDRS, SPALS

EW2HDRS:
	.word	196,12	;x size, y size
	.long	>25ACEC0	;address
	.word	24,96
	.long	>25A20C0
	.word	24,60
	.long	>25A68C0
	.word	24,76
	.long	>25A95C0
	.word	52,56
	.long	>25B1840
	.word	12,70
	.long	>25B7340
	.word	12,59
	.long	>25B8D80
	.word	112,14
	.long	>25BBEA0
	.word	16,54
	.long	>25BA3A0
	.word	16,17
	.long	>25BEFA0
	.word	112,33
	.long	>25BF820
	.word	20,46
	.long	>25C6BA0
	.word	20,46
	.long	>25C6BA0
	.word	32,7
	.long	>25C8860
	.word	84,7
	.long	>25C8F60
	.word	108,17
	.long	>25CA1C0
	.word	36,23
	.long	>25CDB20
	.word	104,46
	.long	>25EFDA0
	.word	20,11
	.long	>25D9780
	.word	24,14
	.long	>25D9E60
	.word	24,14
	.long	>25D9E60
	.word	24,24
	.long	>25DA8E0
	.word	32,30
	.long	>25DC9C0
	.word	64,18
	.long	>25DE7C0
	.word	64,43
	.long	>25E0BC0
	.word	40,15
	.long	>25FA9A0
	.word	40,30
	.long	>25E7840
	.word	40,25
	.long	>25FBC60
	.word	32,30
	.long	>25E9DC0
	.word	32,30
	.long	>25E9DC0
	.word	20,61
	.long	>25EBBC0
	.word	64,43
	.long	>25E0BC0
	.word	40,25
	.long	>25FBC60
	.word	40,15
	.long	>25FA9A0
	.word	64,18
	.long	>25DE7C0
	.word	40,30
	.long	>25E7840
	.word	32,30
	.long	>25E9DC0
	.word	32,30
	.long	>25E9DC0
	.word	20,61
	.long	>25EBBC0
	.word	12,14
	.long	>25EE1E0
	.word	104,46
	.long	>25EFDA0
	.word	112,14
	.long	>25BBEA0
	.word	112,33
	.long	>25BF820
	.word	20,11
	.long	>25D9780
	.word	24,14
	.long	>25D9E60
	.word	24,14
	.long	>25D9E60
	.word	32,7
	.long	>25C8860
	.word	16,54
	.long	>25BA3A0
	.word	16,17
	.long	>25EE720
	.word	12,59
	.long	>25B8D80
	.word	24,60
	.long	>25A68C0
	.word	24,76
	.long	>25A95C0
	.word	12,70
	.long	>25B7340
	.word	12,50
	.long	>2846020
	.word	52,43
	.long	>28472E0
	.word	24,61
	.long	>284B8C0
	.word	196,15
	.long	>284E680
	.word	24,67
	.long	>2854260
	.word	24,96
	.long	>28574A0
	.word	16,24
	.long	>285BCA0
	.word	44,13
	.long	>285C8A0
	.word	12,70
	.long	>285DA80
	.word	32,34
	.long	>285F4C0
	.word	28,69
	.long	>28616C0
	.word	52,35
	.long	>2865320
	.word	100,34
	.long	>2868C00
	.word	40,46
	.long	>286F640
	.word	48,34
	.long	>2872FC0
	.word	68,46
	.long	>28762C0
	.word	64,37
	.long	>287C480
	.word	48,35
	.long	>2880E80
	.word	44,17
	.long	>2884300
	.word	44,25
	.long	>2885A60
	.word	40,25
	.long	>2887CC0
	.word	44,17
	.long	>2884300
	.word	64,37
	.long	>287C480
	.word	44,25
	.long	>2885A60
	.word	40,46
	.long	>286F640
	.word	52,43
	.long	>28472E0
	.word	24,61
	.long	>284B8C0
	.word	16,24
	.long	>285BCA0
	.word	24,67
	.long	>2854260
	.word	132,8
	.long	>2889C00
	.word	124,69
	.long	>288BD00
	.word	40,46
	.long	>286F640
	.word	68,46
	.long	>289C860
	.word	8,67
	.long	>28A2A20
	.word	68,46
	.long	>289C860
	.word	40,46
	.long	>286F640
	.word	68,46
	.long	>28A3AE0
	.word	68,46
	.long	>28A3AE0
	.word	32,34
	.long	>28A9CA0
	.word	32,34
	.long	>28A9CA0
	.word	56,35
	.long	>28ABEA0
	.word	96,34
	.long	>28AFBE0
	.word	96,34
	.long	>28B61E0
	.word	48,34
	.long	>28BC7E0
	.word	68,46
	.long	>28BFAE0
	.word	48,35
	.long	>28C5CA0
	.word	40,46
	.long	>28C9120
	.word	12,61
	.long	>28CCAA0
	.word	68,46
	.long	>28CE180
	.word	68,46
	.long	>28D4340
	.word	68,46
	.long	>28CE180
	.word	28,68
	.long	>28DA500
	.word	20,33
	.long	>28DE080
	.word	20,25
	.long	>28DF520
	.word	20,61
	.long	>28E04C0
	.word	12,61
	.long	>28E2AE0
	.word	96,43
	.long	>28E41C0
	.word	20,22
	.long	>2690260
	.word	40,46
	.long	>28C9120
	.word	16,15
	.long	>2656D60
	.word	12,14
	.long	>2656820
	.word	12,12
	.long	>265A360
	.word	12,15
	.long	>265A7E0
	.word	12,85
	.long	>28EC2C0
	.word	40,41
	.long	>28EE2A0
	.word	84,33
	.long	>26707A0
	.word	44,24
	.long	>2682380
	.word	44,24
	.long	>2680280
	.word	84,50
	.long	>2675E40
	.word	44,24
	.long	>267E180
	.word	16,15
	.long	>26574E0
	.word	44,41
	.long	>28F15E0
	.word	60,48
	.long	>28F4E40
	.word	12,28
	.long	>28FA840
	.word	60,52
	.long	>28FB2C0
	.word	96,35
	.long	>2901440
	.word	96,35
	.long	>2907D40
	.word	56,48
	.long	>290E640
	.word	56,40
	.long	>2913A40
	.word	68,46
	.long	>28A3AE0
	.word	68,46
	.long	>289C860
	.word	68,46
	.long	>28BFAE0
	.word	68,46
	.long	>28762C0
	.word	68,46
	.long	>28BFAE0
	.word	68,46
	.long	>28762C0


NWVERTBLKS:
	.word	>7F51	;flags
	.word	0,211 ;x,y
	.word	>EA	;pal5,pal4,hdr13-0
	.word	>7F41,1,40,>F2
	.word	>7F41,1,90,>F4
	.word	>7F41,1,138,>EE
	.word	>7F41,1,162,>F2
	.word	>7F41,1,114,>F0
	.word	>7F41,1,7,>EC
	.word	>7F41,1,0,>F4
	.word	>7F58,8,231,>E2
	.word	>7F58,10,217,>F6
	.word	>7F51,38,114,>F0
	.word	>7F51,38,138,>EE
	.word	>7F51,38,212,>F8
	.word	>7F51,38,90,>F4
	.word	>7F51,38,0,>F4
	.word	>7F48,48,56,>DC
	.word	>7F48,48,178,>DC
	.word	0FFFFH	;End Marker

ARBTADBLKS:
	.word	>7347	;flags
	.word	0,0 ;x,y
	.word	>6A	;pal5,pal4,hdr13-0
	.word	>7340,0,13,>6C
	.word	>4047,0,55,>6E
	.word	>7F47,0,238,>70
	.word	>4047,0,178,>72
	.word	>7E47,0,82,>74
	.word	>4240,10,55,>76
	.word	>7347,11,0,>78
	.word	>7A47,13,101,>7A
	.word	>4067,20,148,>7C
	.word	>4047,20,114,>7C
	.word	>7440,23,10,>12
	.word	>4047,24,182,>7E
	.word	>4047,24,79,>80
	.word	>4140,24,46,>14
	.word	>7640,29,65,>1C
	.word	>4047,51,215,>82
	.word	>4047,51,181,>82
	.word	>4047,51,147,>82
	.word	>4047,51,113,>82
	.word	>4147,52,0,>84
	.word	>4047,75,79,>86
	.word	>4147,89,0,>88
	.word	>4047,123,79,>86
	.word	>4047,135,42,>8A
	.word	>4047,147,181,>82
	.word	>4047,147,113,>8C
	.word	>4067,147,147,>8C
	.word	>4047,147,215,>82
	.word	>7C47,154,0,>8E
	.word	>4047,155,17,>90
	.word	>7847,157,17,>92
	.word	>4047,171,79,>86
	.word	>7C57,192,0,>94
	.word	>4057,193,42,>96
	.word	>4057,193,18,>98
	.word	>7957,194,17,>92
	.word	>4057,195,113,>8C
	.word	>4077,195,147,>8C
	.word	>7F57,195,238,>70
	.word	>4047,219,79,>86
	.word	>4157,234,0,>88
	.word	>4047,243,215,>82
	.word	>4047,243,181,>82
	.word	>4047,243,113,>82
	.word	>4047,243,147,>82
	.word	>4150,257,46,>54
	.word	>7740,266,65,>1C
	.word	>4047,267,79,>86
	.word	>4157,299,0,>9A
	.word	>4057,315,79,>80
	.word	>7357,336,0,>78
	.word	>4057,338,181,>7E
	.word	>4077,338,148,>7C
	.word	>4057,338,114,>7C
	.word	>7350,339,13,>9C
	.word	>7540,355,10,>60
	.word	>7B57,366,98,>7A
	.word	>4057,367,55,>9E
	.word	>4250,367,55,>A0
	.word	>4057,367,178,>A2
	.word	>7E57,367,82,>74
	.word	>7357,379,0,>6A
	.word	0FFFFH	;End Marker

ARBTACBLKS:
	.word	>7346	;flags
	.word	0,0 ;x,y
	.word	>6A	;pal5,pal4,hdr13-0
	.word	>7340,0,13,>6C
	.word	>4046,0,55,>6E
	.word	>7F46,0,238,>70
	.word	>4046,0,178,>72
	.word	>7E46,0,82,>74
	.word	>4240,10,55,>76
	.word	>7346,11,0,>78
	.word	>7A46,13,101,>7A
	.word	>4066,20,148,>7C
	.word	>4046,20,114,>7C
	.word	>7440,23,10,>12
	.word	>4046,24,182,>7E
	.word	>4046,24,79,>80
	.word	>4140,24,46,>14
	.word	>7640,29,65,>1C
	.word	>4046,51,215,>82
	.word	>4046,51,181,>82
	.word	>4046,51,147,>82
	.word	>4046,51,113,>82
	.word	>4146,52,0,>84
	.word	>4046,75,79,>86
	.word	>4146,89,0,>88
	.word	>4046,123,79,>86
	.word	>4046,135,42,>8A
	.word	>4046,147,181,>82
	.word	>4046,147,113,>8C
	.word	>4066,147,147,>8C
	.word	>4046,147,215,>82
	.word	>7C46,154,0,>8E
	.word	>4046,155,17,>90
	.word	>7846,157,17,>92
	.word	>4046,171,79,>86
	.word	>7C56,192,0,>94
	.word	>4056,193,42,>96
	.word	>4056,193,18,>98
	.word	>7956,194,17,>92
	.word	>4056,195,113,>8C
	.word	>4076,195,147,>8C
	.word	>7F56,195,238,>70
	.word	>4046,219,79,>86
	.word	>4156,234,0,>88
	.word	>4046,243,215,>82
	.word	>4046,243,181,>82
	.word	>4046,243,113,>82
	.word	>4046,243,147,>82
	.word	>4150,257,46,>54
	.word	>7740,266,65,>1C
	.word	>4046,267,79,>86
	.word	>4156,299,0,>9A
	.word	>4056,315,79,>80
	.word	>7356,336,0,>78
	.word	>4056,338,181,>7E
	.word	>4076,338,148,>7C
	.word	>4056,338,114,>7C
	.word	>7350,339,13,>9C
	.word	>7540,355,10,>60
	.word	>7B56,366,98,>7A
	.word	>4056,367,55,>9E
	.word	>4250,367,55,>A0
	.word	>4056,367,178,>A2
	.word	>7E56,367,82,>74
	.word	>7356,379,0,>6A
	.word	0FFFFH	;End Marker

ARBTABBLKS:
	.word	>7345	;flags
	.word	0,0 ;x,y
	.word	>6A	;pal5,pal4,hdr13-0
	.word	>7340,0,13,>6C
	.word	>4045,0,55,>6E
	.word	>7F45,0,238,>70
	.word	>4045,0,178,>72
	.word	>7E45,0,82,>74
	.word	>4240,10,55,>76
	.word	>7345,11,0,>78
	.word	>7A45,13,101,>7A
	.word	>4067,20,148,>7C
	.word	>4047,20,114,>7C
	.word	>7440,23,10,>12
	.word	>4047,24,182,>7E
	.word	>4041,24,79,>80
	.word	>4140,24,46,>14
	.word	>7640,29,65,>1C
	.word	>4047,51,215,>82
	.word	>4041,51,181,>82
	.word	>4041,51,147,>82
	.word	>4041,51,113,>82
	.word	>4145,52,0,>84
	.word	>4041,75,79,>86
	.word	>4145,89,0,>88
	.word	>4041,123,79,>86
	.word	>4041,135,42,>8A
	.word	>4041,147,181,>82
	.word	>4047,147,113,>8C
	.word	>4067,147,147,>8C
	.word	>4047,147,215,>82
	.word	>7C45,154,0,>8E
	.word	>4047,155,17,>90
	.word	>7847,158,18,>92
	.word	>4041,171,79,>86
	.word	>7C55,192,0,>94
	.word	>4051,193,42,>96
	.word	>4057,193,18,>98
	.word	>4057,195,113,>8C
	.word	>4077,195,147,>8C
	.word	>7F55,195,238,>70
	.word	>7957,195,18,>92
	.word	>4041,219,79,>86
	.word	>4155,234,0,>88
	.word	>4047,243,215,>82
	.word	>4041,243,181,>82
	.word	>4041,243,113,>82
	.word	>4041,243,147,>82
	.word	>4150,257,46,>54
	.word	>7740,266,65,>1C
	.word	>4041,267,79,>86
	.word	>4155,299,0,>9A
	.word	>4051,315,79,>80
	.word	>7355,336,0,>78
	.word	>4057,338,181,>7E
	.word	>4077,338,148,>7C
	.word	>4057,338,114,>7C
	.word	>7350,339,13,>9C
	.word	>7540,355,10,>60
	.word	>7B56,366,98,>7A
	.word	>4055,367,55,>9E
	.word	>4250,367,55,>A0
	.word	>4055,367,178,>A2
	.word	>7E55,367,82,>74
	.word	>7355,379,0,>6A
	.word	0FFFFH	;End Marker

ARBTAABLKS:
	.word	>7344	;flags
	.word	0,0 ;x,y
	.word	>6A	;pal5,pal4,hdr13-0
	.word	>7340,0,13,>6C
	.word	>4044,0,55,>6E
	.word	>7F44,0,238,>70
	.word	>4044,0,178,>72
	.word	>7E44,0,82,>74
	.word	>4240,10,55,>76
	.word	>7344,11,0,>78
	.word	>7A44,13,101,>7A
	.word	>4064,20,148,>7C
	.word	>4044,20,114,>7C
	.word	>7440,23,10,>12
	.word	>4044,24,182,>7E
	.word	>4044,24,79,>80
	.word	>4140,24,46,>14
	.word	>7640,29,65,>1C
	.word	>4044,51,215,>82
	.word	>4044,51,181,>82
	.word	>4044,51,147,>82
	.word	>4044,51,113,>82
	.word	>4144,52,0,>84
	.word	>4044,75,79,>86
	.word	>4144,89,0,>88
	.word	>4044,123,79,>86
	.word	>4044,135,42,>8A
	.word	>4044,147,181,>82
	.word	>4044,147,113,>8C
	.word	>4064,147,147,>8C
	.word	>4044,147,215,>82
	.word	>7C44,154,0,>8E
	.word	>4044,155,17,>90
	.word	>7844,156,17,>92
	.word	>4044,171,79,>86
	.word	>7C54,192,0,>94
	.word	>4054,193,42,>96
	.word	>4054,193,18,>98
	.word	>7954,194,17,>92
	.word	>4054,195,113,>8C
	.word	>4074,195,147,>8C
	.word	>7F54,195,238,>70
	.word	>4044,219,79,>86
	.word	>4154,234,0,>88
	.word	>4044,243,215,>82
	.word	>4044,243,181,>82
	.word	>4044,243,113,>82
	.word	>4044,243,147,>82
	.word	>4150,257,46,>54
	.word	>7740,266,65,>1C
	.word	>4044,267,79,>86
	.word	>4154,299,0,>9A
	.word	>4054,315,79,>80
	.word	>7354,336,0,>78
	.word	>4054,338,181,>7E
	.word	>4074,338,148,>7C
	.word	>4054,338,114,>7C
	.word	>7350,339,13,>9C
	.word	>7540,355,10,>60
	.word	>7B54,366,98,>7A
	.word	>4054,367,55,>9E
	.word	>4250,367,55,>A0
	.word	>4054,367,178,>A2
	.word	>7E54,367,82,>74
	.word	>7354,379,0,>6A
	.word	0FFFFH	;End Marker

ARBTBBLKS:
	.word	>7F46	;flags
	.word	0,238 ;x,y
	.word	>70	;pal5,pal4,hdr13-0
	.word	>4046,0,178,>72
	.word	>4043,0,54,>6E
	.word	>4046,0,55,>6E
	.word	>7340,0,13,>6C
	.word	>7346,0,0,>6A
	.word	>7E46,0,82,>74
	.word	>4240,10,55,>76
	.word	>7346,11,0,>78
	.word	>7A46,13,101,>7A
	.word	>7F42,15,175,>A4
	.word	>4066,20,148,>7C
	.word	>4046,20,114,>7C
	.word	>4042,23,181,>A6
	.word	>7440,23,10,>12
	.word	>4046,24,79,>80
	.word	>4140,24,46,>14
	.word	>7640,29,65,>1C
	.word	>4046,51,147,>82
	.word	>4046,51,113,>82
	.word	>4146,52,0,>A8
	.word	>4046,75,79,>86
	.word	>4146,89,0,>AA
	.word	>4046,123,79,>86
	.word	>4046,135,42,>8A
	.word	>4066,147,147,>8C
	.word	>4046,147,113,>8C
	.word	>4046,147,215,>82
	.word	>4046,147,181,>82
	.word	>4146,148,181,>AC
	.word	>7C46,154,0,>8E
	.word	>4046,155,17,>90
	.word	>7846,157,17,>92
	.word	>4046,171,79,>86
	.word	>7C56,192,0,>94
	.word	>4056,193,42,>96
	.word	>4056,193,18,>98
	.word	>4056,195,113,>8C
	.word	>4076,195,147,>8C
	.word	>7F56,195,238,>70
	.word	>7956,195,17,>92
	.word	>4046,219,79,>86
	.word	>4156,234,0,>AE
	.word	>4046,243,215,>82
	.word	>4046,243,181,>82
	.word	>4046,243,113,>82
	.word	>4046,243,147,>82
	.word	>4150,257,46,>54
	.word	>7740,266,65,>1C
	.word	>4046,267,79,>86
	.word	>4156,299,0,>B0
	.word	>4056,315,79,>80
	.word	>7356,336,0,>78
	.word	>4056,338,181,>7E
	.word	>4076,338,148,>7C
	.word	>4056,338,114,>7C
	.word	>7350,339,13,>9C
	.word	>7540,355,10,>60
	.word	>4250,366,55,>A0
	.word	>7B56,366,98,>7A
	.word	>4056,367,178,>A2
	.word	>7E56,367,82,>74
	.word	>4056,367,55,>9E
	.word	>7356,379,0,>6A
	.word	0FFFFH	;End Marker

ARBTCBLKS:
	.word	>4043	;flags
	.word	0,178 ;x,y
	.word	>72	;pal5,pal4,hdr13-0
	.word	>7F43,0,238,>70
	.word	>7E43,0,82,>74
	.word	>4043,0,55,>6E
	.word	>7340,0,13,>6C
	.word	>7343,0,0,>6A
	.word	>4240,10,55,>76
	.word	>7343,11,0,>78
	.word	>7A43,13,101,>7A
	.word	>7F42,15,174,>A4
	.word	>4043,20,114,>7C
	.word	>4063,20,148,>7C
	.word	>4042,23,181,>A6
	.word	>7440,23,10,>12
	.word	>4140,24,46,>14
	.word	>4043,24,79,>80
	.word	>7640,29,65,>1C
	.word	>4043,51,113,>82
	.word	>4043,51,147,>82
	.word	>4143,52,0,>A8
	.word	>4043,75,79,>86
	.word	>4143,89,0,>B2
	.word	>4043,123,79,>86
	.word	>4043,135,42,>8A
	.word	>4043,147,181,>82
	.word	>4043,147,215,>82
	.word	>4063,147,147,>8C
	.word	>4043,147,113,>8C
	.word	>4143,149,182,>AC
	.word	>7C43,154,0,>8E
	.word	>4043,155,17,>90
	.word	>7843,157,17,>92
	.word	>4043,171,79,>86
	.word	>7C53,192,0,>94
	.word	>4053,193,18,>98
	.word	>4053,193,42,>96
	.word	>7F53,195,238,>70
	.word	>4053,195,113,>8C
	.word	>7953,195,17,>92
	.word	>4073,195,147,>8C
	.word	>4043,219,79,>86
	.word	>4153,234,184,>AC
	.word	>4153,234,0,>B4
	.word	>4043,243,147,>82
	.word	>4043,243,113,>82
	.word	>4052,243,181,>A6
	.word	>7F52,244,175,>A4
	.word	>4150,257,46,>54
	.word	>7740,266,65,>1C
	.word	>4043,267,79,>86
	.word	>4153,299,0,>B0
	.word	>4053,315,79,>80
	.word	>7353,336,0,>78
	.word	>4053,338,114,>7C
	.word	>4073,338,148,>7C
	.word	>7350,339,13,>9C
	.word	>7540,355,10,>60
	.word	>7B53,366,98,>7A
	.word	>4053,367,178,>A2
	.word	>4250,367,55,>A0
	.word	>7E53,367,82,>74
	.word	>4053,367,55,>9E
	.word	>7353,379,0,>6A
	.word	0FFFFH	;End Marker

ARBTDBLKS:
	.word	>7F47	;flags
	.word	0,238 ;x,y
	.word	>70	;pal5,pal4,hdr13-0
	.word	>4047,0,178,>72
	.word	>4047,0,55,>6E
	.word	>7340,0,13,>6C
	.word	>7347,0,0,>6A
	.word	>7E47,0,82,>74
	.word	>4240,10,55,>76
	.word	>7347,11,0,>78
	.word	>7A47,13,101,>7A
	.word	>4067,21,148,>B6
	.word	>4047,21,114,>B8
	.word	>4047,23,79,>BA
	.word	>7440,23,10,>12
	.word	>4047,24,182,>7E
	.word	>4140,24,46,>14
	.word	>7640,29,65,>1C
	.word	>4047,51,215,>82
	.word	>4047,51,182,>BC
	.word	>4047,52,114,>BE
	.word	>4067,52,148,>BE
	.word	>4147,52,0,>A8
	.word	>4047,75,79,>C0
	.word	>4147,89,0,>C2
	.word	>4047,123,79,>C0
	.word	>4047,135,42,>8A
	.word	>4047,147,215,>82
	.word	>4047,147,181,>82
	.word	>4047,148,113,>C4
	.word	>4067,148,147,>C4
	.word	>7C47,154,0,>8E
	.word	>4047,155,17,>90
	.word	>7847,157,17,>92
	.word	>4047,171,79,>C0
	.word	>7C57,192,0,>94
	.word	>4057,193,42,>96
	.word	>4057,193,18,>98
	.word	>7F57,195,238,>70
	.word	>7957,195,17,>92
	.word	>4057,196,113,>C4
	.word	>4077,196,147,>C4
	.word	>4047,219,79,>C0
	.word	>4157,234,0,>C2
	.word	>4047,243,215,>82
	.word	>4077,243,148,>BE
	.word	>4057,243,181,>BC
	.word	>4057,244,114,>BE
	.word	>4150,257,46,>54
	.word	>7740,266,65,>1C
	.word	>4047,267,79,>C0
	.word	>4157,299,0,>B0
	.word	>4057,312,79,>BA
	.word	>7357,336,0,>78
	.word	>4057,338,114,>B6
	.word	>4077,338,148,>B6
	.word	>4057,339,182,>7E
	.word	>7350,339,13,>9C
	.word	>7540,355,10,>60
	.word	>4250,366,55,>A0
	.word	>7B57,366,98,>7A
	.word	>4057,367,178,>A2
	.word	>4057,367,55,>9E
	.word	>7E57,367,82,>74
	.word	>7357,379,0,>6A
	.word	0FFFFH	;End Marker

ARBTEBLKS:
	.word	>7F43	;flags
	.word	0,238 ;x,y
	.word	>70	;pal5,pal4,hdr13-0
	.word	>4043,0,178,>72
	.word	>4043,0,55,>6E
	.word	>7340,0,13,>6C
	.word	>7343,0,0,>6A
	.word	>7E43,0,82,>74
	.word	>4240,10,55,>76
	.word	>7343,11,0,>78
	.word	>7A43,13,100,>7A
	.word	>4063,20,148,>7C
	.word	>4043,20,114,>7C
	.word	>7440,23,10,>12
	.word	>4043,24,182,>7E
	.word	>4043,24,79,>80
	.word	>4140,24,46,>14
	.word	>7640,29,65,>1C
	.word	>4043,51,215,>82
	.word	>4043,51,181,>82
	.word	>4043,51,147,>82
	.word	>4043,51,113,>82
	.word	>4143,52,0,>A8
	.word	>4043,75,79,>86
	.word	>4143,89,0,>CA
	.word	>4043,123,79,>86
	.word	>4043,135,42,>8A
	.word	>4043,147,181,>82
	.word	>4047,147,113,>8C
	.word	>4067,147,147,>8C
	.word	>4043,147,215,>82
	.word	>7C43,154,0,>8E
	.word	>4043,155,17,>90
	.word	>7843,157,17,>92
	.word	>4043,171,79,>86
	.word	>7C53,192,0,>94
	.word	>4053,193,42,>96
	.word	>4053,193,18,>98
	.word	>4057,195,113,>8C
	.word	>4077,195,147,>8C
	.word	>7F53,195,238,>70
	.word	>7953,195,17,>92
	.word	>4043,219,79,>86
	.word	>4153,234,0,>CE
	.word	>4043,243,113,>82
	.word	>4043,243,147,>82
	.word	>4043,243,181,>D0
	.word	>4150,257,46,>54
	.word	>7740,266,65,>1C
	.word	>4043,267,79,>86
	.word	>7F43,268,160,>D2
	.word	>4043,269,183,>D8
	.word	>4143,274,184,>C8
	.word	>7F51,284,159,>DA
	.word	>7F71,284,202,>DA
	.word	>7F58,295,209,>DC
	.word	>4153,299,0,>B0
	.word	>4053,315,79,>80
	.word	>7F48,316,167,>E0
	.word	>7F48,320,181,>E2
	.word	>7353,336,0,>78
	.word	>4073,338,148,>7C
	.word	>4053,338,114,>7C
	.word	>7350,339,13,>9C
	.word	>7540,355,10,>60
	.word	>7B53,366,98,>7A
	.word	>7E53,367,82,>74
	.word	>4250,367,55,>A0
	.word	>4053,367,55,>9E
	.word	>7F58,370,203,>E4
	.word	>7F58,376,189,>E6
	.word	>7F51,379,160,>E8
	.word	>7353,379,0,>6A
	.word	0FFFFH	;End Marker

ARBTFBLKS:
	.word	>7F40	;flags
	.word	0,167 ;x,y
	.word	>FA	;pal5,pal4,hdr13-0
	.word	>7F40,0,77,>FA
	.word	>7E47,1,82,>74
	.word	>7F47,1,238,>70
	.word	>4047,1,178,>72
	.word	>4047,1,55,>6E
	.word	>7340,1,13,>6C
	.word	>7347,1,0,>6A
	.word	>4240,11,55,>76
	.word	>7347,12,0,>78
	.word	>7A47,14,101,>7A
	.word	>4067,21,148,>7C
	.word	>4047,21,114,>7C
	.word	>7440,24,10,>12
	.word	>4047,25,79,>80
	.word	>4140,25,46,>14
	.word	>4047,25,182,>7E
	.word	>7640,30,65,>1C
	.word	>4047,39,119,>FC
	.word	>4047,40,218,>FC
	.word	>7F50,50,163,>FE
	.word	>4047,52,113,>100
	.word	>4047,52,147,>102
	.word	>4047,52,181,>102
	.word	>4047,52,215,>100
	.word	>4147,53,0,>A8
	.word	>7F40,57,77,>104
	.word	>7F40,57,125,>106
	.word	>4047,76,79,>86
	.word	>4147,90,0,>108
	.word	>4047,124,79,>86
	.word	>4047,136,42,>8A
	.word	>4047,148,181,>82
	.word	>4043,148,113,>8C
	.word	>4063,148,147,>8C
	.word	>4047,148,215,>82
	.word	>7C47,155,0,>8E
	.word	>4047,156,17,>90
	.word	>7847,158,17,>92
	.word	>4047,172,79,>86
	.word	>7C57,193,0,>94
	.word	>4057,194,42,>96
	.word	>4057,194,18,>98
	.word	>4053,196,113,>8C
	.word	>4073,196,147,>8C
	.word	>7F57,196,238,>70
	.word	>7957,196,17,>92
	.word	>4047,220,79,>86
	.word	>4157,235,0,>10A
	.word	>4047,244,215,>82
	.word	>4047,244,181,>82
	.word	>4047,244,113,>82
	.word	>4047,244,147,>82
	.word	>4150,258,46,>54
	.word	>7740,267,65,>1C
	.word	>4047,268,79,>86
	.word	>4157,300,0,>B0
	.word	>4057,316,79,>80
	.word	>7357,337,0,>78
	.word	>4057,339,181,>7E
	.word	>4077,339,148,>7C
	.word	>4057,339,114,>7C
	.word	>7350,340,13,>9C
	.word	>7540,356,10,>60
	.word	>4250,367,55,>A0
	.word	>7B57,367,98,>7A
	.word	>7E57,368,82,>74
	.word	>4057,368,178,>A2
	.word	>4057,368,55,>9E
	.word	>7357,380,0,>6A
	.word	0FFFFH	;End Marker

ARBTGBLKS:
	.word	>7E43	;flags
	.word	0,82 ;x,y
	.word	>74	;pal5,pal4,hdr13-0
	.word	>7F43,0,238,>70
	.word	>4043,0,178,>72
	.word	>4043,0,55,>6E
	.word	>7340,0,13,>6C
	.word	>7343,0,0,>6A
	.word	>4240,10,55,>76
	.word	>7343,11,0,>78
	.word	>7A43,13,101,>7A
	.word	>4063,20,148,>7C
	.word	>4043,20,114,>7C
	.word	>7440,23,10,>12
	.word	>4043,24,182,>7E
	.word	>4043,24,79,>80
	.word	>4140,24,46,>14
	.word	>7640,29,65,>1C
	.word	>4043,51,215,>82
	.word	>4043,51,181,>82
	.word	>4057,51,113,>BC
	.word	>4057,51,147,>BC
	.word	>4143,52,0,>A8
	.word	>4043,75,79,>86
	.word	>4143,89,0,>10C
	.word	>4043,123,79,>86
	.word	>4043,135,42,>8A
	.word	>4043,147,181,>82
	.word	>4043,147,215,>82
	.word	>4047,147,113,>C4
	.word	>4067,147,147,>C4
	.word	>7C43,154,0,>8E
	.word	>4043,155,17,>90
	.word	>7843,157,17,>92
	.word	>4043,171,79,>86
	.word	>7C53,192,0,>94
	.word	>4053,193,42,>96
	.word	>4053,193,18,>98
	.word	>7F53,195,238,>70
	.word	>7953,195,17,>92
	.word	>4057,195,113,>C4
	.word	>4077,195,147,>C4
	.word	>4043,219,79,>86
	.word	>4153,234,0,>110
	.word	>4043,243,215,>82
	.word	>4043,243,181,>82
	.word	>4067,243,113,>BE
	.word	>4047,243,147,>BE
	.word	>4150,257,46,>54
	.word	>7740,266,65,>1C
	.word	>4043,267,79,>86
	.word	>4153,299,0,>B0
	.word	>4053,315,79,>80
	.word	>7353,336,0,>78
	.word	>4053,338,181,>7E
	.word	>4073,338,148,>7C
	.word	>4053,338,114,>7C
	.word	>7350,339,13,>9C
	.word	>7540,355,10,>60
	.word	>7B53,366,98,>7A
	.word	>7E53,367,82,>74
	.word	>4053,367,178,>A2
	.word	>4250,367,55,>A0
	.word	>4053,367,55,>9E
	.word	>7353,379,0,>6A
	.word	0FFFFH	;End Marker

ARBTHBLKS:
	.word	>4043	;flags
	.word	0,178 ;x,y
	.word	>72	;pal5,pal4,hdr13-0
	.word	>7F43,0,238,>70
	.word	>7E43,0,82,>74
	.word	>4043,0,55,>6E
	.word	>7340,0,13,>6C
	.word	>7343,0,0,>6A
	.word	>4240,10,55,>76
	.word	>7343,11,0,>78
	.word	>7A43,13,101,>7A
	.word	>4043,20,114,>7C
	.word	>4063,20,148,>7C
	.word	>7440,23,10,>12
	.word	>4140,24,46,>14
	.word	>4043,24,79,>80
	.word	>4043,24,182,>7E
	.word	>7640,29,65,>1C
	.word	>4043,51,181,>82
	.word	>4043,51,215,>82
	.word	>4043,51,113,>82
	.word	>4043,51,147,>82
	.word	>4143,52,0,>A8
	.word	>4043,75,79,>86
	.word	>4143,89,0,>10E
	.word	>4043,123,79,>86
	.word	>4043,135,42,>8A
	.word	>4043,147,215,>82
	.word	>4043,147,181,>82
	.word	>4047,147,113,>C4
	.word	>4067,147,147,>C4
	.word	>7C43,154,0,>8E
	.word	>4043,155,17,>90
	.word	>7843,157,17,>92
	.word	>4043,171,79,>86
	.word	>7C53,192,0,>94
	.word	>4053,193,18,>98
	.word	>4053,193,42,>96
	.word	>7F53,195,238,>70
	.word	>7953,195,17,>92
	.word	>4057,195,113,>C4
	.word	>4077,195,147,>C4
	.word	>4043,219,79,>86
	.word	>4153,234,0,>112
	.word	>4043,243,181,>82
	.word	>4043,243,215,>82
	.word	>4077,243,147,>BE
	.word	>4057,243,113,>BE
	.word	>4150,257,46,>54
	.word	>7740,266,65,>1C
	.word	>4043,267,79,>86
	.word	>4153,299,0,>B0
	.word	>4053,315,79,>80
	.word	>7353,336,0,>78
	.word	>4053,338,181,>7E
	.word	>4077,338,147,>B6
	.word	>4057,338,113,>B6
	.word	>7350,339,13,>9C
	.word	>7540,355,10,>60
	.word	>7B53,366,98,>7A
	.word	>4053,367,178,>A2
	.word	>4250,367,55,>A0
	.word	>7E53,367,82,>74
	.word	>4053,367,55,>9E
	.word	>7353,379,0,>6A
	.word	0FFFFH	;End Marker

EW2MOD0BLKS:
	.word	>7F40	;flags
	.word	101,343 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>7E40,101,184,>2
	.word	>4140,101,157,>4
	.word	>4040,101,280,>6
	.word	>7340,102,102,>8
	.word	>7A40,112,197,>A
	.word	>4040,115,217,>C
	.word	>4040,124,182,>E
	.word	>4040,124,292,>10
	.word	>7440,125,112,>12
	.word	>4140,125,148,>14
	.word	>4060,125,246,>16
	.word	>4040,125,202,>18
	.word	>4040,125,195,>1A
	.word	>7640,130,167,>1C
	.word	>4060,143,247,>1E
	.word	>4040,143,230,>1E
	.word	>4060,149,318,>20
	.word	>4140,154,102,>22
	.word	>4050,161,220,>24
	.word	>4040,183,197,>26
	.word	>4050,184,294,>28
	.word	>4040,194,270,>2A
	.word	>4040,233,190,>2C
	.word	>4040,234,147,>2E
	.word	>4040,236,165,>30
	.word	>4050,250,276,>2A
	.word	>7C40,257,102,>32
	.word	>4040,257,117,>34
	.word	>7840,259,117,>36
	.word	>4060,265,245,>38
	.word	>4040,265,215,>3A
	.word	>4040,279,282,>3C
	.word	>4050,294,165,>3E
	.word	>7950,295,117,>40
	.word	>7F50,296,343,>0
	.word	>7C50,296,102,>42
	.word	>4050,296,147,>44
	.word	>4050,297,117,>46
	.word	>4070,297,245,>48
	.word	>4050,297,215,>4A
	.word	>4050,298,282,>4C
	.word	>4040,334,320,>4E
	.word	>4150,335,102,>50
	.word	>4070,343,247,>1E
	.word	>4050,343,230,>1E
	.word	>4060,351,190,>4E
	.word	>4050,357,182,>52
	.word	>4150,358,148,>54
	.word	>7740,367,167,>1C
	.word	>4040,367,220,>56
	.word	>4050,376,197,>58
	.word	>4040,378,294,>5A
	.word	>4050,385,305,>20
	.word	>4040,399,199,>20
	.word	>4040,436,195,>5C
	.word	>7350,439,102,>8
	.word	>4070,449,246,>16
	.word	>4050,449,202,>18
	.word	>4050,453,292,>5E
	.word	>7540,456,111,>60
	.word	>4050,467,217,>62
	.word	>7E50,468,184,>2
	.word	>4150,468,157,>64
	.word	>4050,468,280,>66
	.word	>7B50,469,197,>68
	.word	>4043,551,280,>72
	.word	>7F43,551,340,>70
	.word	>7E43,551,184,>74
	.word	>4043,551,157,>6E
	.word	>7340,551,115,>6C
	.word	>7343,551,102,>6A
	.word	>4240,561,157,>76
	.word	>7343,562,102,>78
	.word	>7A43,564,203,>7A
	.word	>4043,571,216,>7C
	.word	>4063,571,250,>7C
	.word	>7440,574,112,>12
	.word	>4140,575,148,>14
	.word	>4043,575,181,>80
	.word	>4043,575,284,>7E
	.word	>7640,580,167,>1C
	.word	>4043,602,215,>82
	.word	>4043,602,249,>82
	.word	>4043,602,283,>82
	.word	>4043,602,317,>82
	.word	>4143,603,102,>84
	.word	>4043,626,181,>86
	.word	>4143,639,102,>88
	.word	>4043,674,181,>86
	.word	>4043,686,144,>8A
	.word	>4043,698,317,>82
	.word	>4063,698,249,>8C
	.word	>4043,698,215,>8C
	.word	>4043,698,283,>82
	.word	>7C43,705,102,>8E
	.word	>4043,706,119,>90
	.word	>7843,707,119,>92
	.word	>4043,722,181,>86
	.word	>7C53,743,102,>94
	.word	>4053,744,120,>98
	.word	>4053,744,144,>96
	.word	>7953,745,119,>92
	.word	>7F53,746,340,>70
	.word	>4073,746,249,>8C
	.word	>4053,746,215,>8C
	.word	>4043,770,181,>86
	.word	>4153,785,102,>88
	.word	>4043,794,249,>82
	.word	>4043,794,215,>82
	.word	>4043,794,283,>82
	.word	>4043,794,317,>82
	.word	>4150,808,148,>54
	.word	>7740,817,167,>1C
	.word	>4043,818,181,>86
	.word	>4153,850,102,>9A
	.word	>4053,866,181,>80
	.word	>7353,887,102,>78
	.word	>4053,889,216,>7C
	.word	>4073,889,250,>7C
	.word	>4053,889,283,>7E
	.word	>7350,890,115,>9C
	.word	>7540,906,112,>60
	.word	>7B53,917,200,>7A
	.word	>4053,918,280,>A2
	.word	>4250,918,157,>A0
	.word	>7E53,918,184,>74
	.word	>4053,918,157,>9E
	.word	>7353,930,102,>6A
	.word	>7343,2355,854,>6A
	.word	>7340,2355,867,>6C
	.word	>4043,2355,909,>6E
	.word	>4043,2355,1032,>72
	.word	>7F43,2355,1092,>70
	.word	>7E43,2355,936,>74
	.word	>4240,2365,909,>76
	.word	>7343,2366,854,>78
	.word	>7843,2368,955,>7A
	.word	>4043,2375,968,>7C
	.word	>4063,2375,1002,>7C
	.word	>4140,2379,900,>14
	.word	>7440,2379,864,>12
	.word	>4043,2379,933,>80
	.word	>4043,2379,1036,>7E
	.word	>7640,2384,919,>1C
	.word	>4043,2406,967,>82
	.word	>4043,2406,1001,>82
	.word	>4043,2406,1035,>82
	.word	>4043,2406,1069,>82
	.word	>4043,2407,854,>C6
	.word	>4043,2412,386,>C8
	.word	>4043,2430,933,>86
	.word	>4043,2444,854,>CC
	.word	>4043,2478,933,>86
	.word	>4043,2490,896,>8A
	.word	>4043,2502,1069,>82
	.word	>4063,2502,1001,>8C
	.word	>4043,2502,967,>8C
	.word	>4043,2502,1035,>82
	.word	>7C43,2509,854,>8E
	.word	>4043,2510,871,>90
	.word	>7843,2512,871,>92
	.word	>4043,2526,933,>86
	.word	>7C53,2547,854,>94
	.word	>4053,2548,872,>98
	.word	>4053,2548,896,>96
	.word	>7853,2550,871,>92
	.word	>7F53,2550,1092,>70
	.word	>4073,2550,1001,>8C
	.word	>4053,2550,967,>8C
	.word	>4043,2574,933,>86
	.word	>4053,2589,854,>CC
	.word	>4043,2598,1035,>D0
	.word	>4043,2598,1001,>82
	.word	>4043,2598,967,>82
	.word	>4150,2612,900,>54
	.word	>4053,2620,1013,>D4
	.word	>4053,2620,1038,>D6
	.word	>7F53,2620,372,>D4
	.word	>7740,2621,919,>1C
	.word	>4043,2622,933,>86
	.word	>7E71,2639,1056,>DA
	.word	>7E51,2639,1013,>DA
	.word	>7F58,2650,1063,>DC
	.word	>7F53,2650,372,>D4
	.word	>7F53,2650,371,>D4
	.word	>7F53,2650,369,>D4
	.word	>7F53,2650,367,>D4
	.word	>7F53,2650,365,>D4
	.word	>7F53,2650,363,>D4
	.word	>4053,2654,854,>DE
	.word	>4053,2670,933,>80
	.word	>7F48,2671,1021,>E0
	.word	>7F48,2675,1035,>E2
	.word	>7353,2691,854,>78
	.word	>4053,2693,968,>7C
	.word	>4073,2693,1002,>7C
	.word	>7350,2694,867,>9C
	.word	>7540,2710,863,>60
	.word	>7853,2721,952,>7A
	.word	>4053,2722,909,>9E
	.word	>4250,2722,909,>A0
	.word	>7E53,2722,936,>74
	.word	>7F58,2725,1057,>E4
	.word	>7F58,2731,1043,>E6
	.word	>7353,2734,854,>6A
	.word	>7F51,2734,1014,>E8
	.word	>7F51,2747,1082,>EA
	.word	>7F41,2747,878,>EC
	.word	>7F41,2747,854,>EE
	.word	>7F41,2748,985,>F0
	.word	>7F41,2748,1033,>F2
	.word	>7F41,2748,1009,>EE
	.word	>7F41,2748,961,>F4
	.word	>7F41,2748,911,>F2
	.word	>7F58,2755,1102,>E2
	.word	>7F58,2757,1088,>F6
	.word	>7F51,2784,854,>EE
	.word	>7F51,2785,1083,>F8
	.word	>7F51,2785,1009,>EE
	.word	>7F51,2785,985,>F0
	.word	>7F51,2785,961,>F4
	.word	>7F48,2795,1049,>DC
	.word	>7F48,2795,927,>DC
	.word	>7F58,2802,974,>E4
	.word	>7F58,2808,961,>E6
	.word	>7F51,2836,1069,>EA
	.word	>7F41,2837,856,>F4
	.word	>7F41,2837,865,>EC
	.word	>7F41,2837,972,>F0
	.word	>7F41,2837,1020,>F2
	.word	>7F41,2837,996,>EE
	.word	>7F41,2837,948,>F4
	.word	>7F41,2837,898,>F2
	.word	>7F58,2844,1089,>E2
	.word	>7F58,2846,1075,>F6
	.word	>7F51,2874,856,>F4
	.word	>7F51,2874,948,>F4
	.word	>7F51,2874,1070,>F8
	.word	>7F51,2874,996,>EE
	.word	>7F51,2874,972,>F0
	.word	>7F48,2884,1036,>DC
	.word	>7F48,2884,914,>DC
	.word	>7F51,2926,1068,>EA
	.word	>7F41,2927,857,>F4
	.word	>7F41,2927,864,>EC
	.word	>7F41,2927,971,>F0
	.word	>7F41,2927,1019,>F2
	.word	>7F41,2927,995,>EE
	.word	>7F41,2927,947,>F4
	.word	>7F41,2927,897,>F2
	.word	>7F58,2934,1088,>E2
	.word	>7F58,2936,1074,>F6
	.word	>7F51,2964,857,>F4
	.word	>7F51,2964,947,>F4
	.word	>7F51,2964,1069,>F8
	.word	>7F51,2964,995,>EE
	.word	>7F51,2964,971,>F0
	.word	>7F48,2974,1035,>DC
	.word	>7F48,2974,913,>DC
	.word	0FFFFH		;End Marker
NWVERTBMOD:
	.word	85,253,17	;x size, y size, #blocks
	.long	NWVERTBLKS, EW2HDRS, EW2PALS
ARBTADBMOD:
	.word	391,253,63	;x size, y size, #blocks
	.long	ARBTADBLKS, EW2HDRS, EW2PALS
ARBTACBMOD:
	.word	391,253,63	;x size, y size, #blocks
	.long	ARBTACBLKS, EW2HDRS, EW2PALS
ARBTABBMOD:
	.word	391,253,63	;x size, y size, #blocks
	.long	ARBTABBLKS, EW2HDRS, EW2PALS
ARBTAABMOD:
	.word	391,253,63	;x size, y size, #blocks
	.long	ARBTAABLKS, EW2HDRS, EW2PALS
ARBTBBMOD:
	.word	391,253,64	;x size, y size, #blocks
	.long	ARBTBBLKS, EW2HDRS, EW2PALS
ARBTCBMOD:
	.word	391,253,63	;x size, y size, #blocks
	.long	ARBTCBLKS, EW2HDRS, EW2PALS
ARBTDBMOD:
	.word	391,253,63	;x size, y size, #blocks
	.long	ARBTDBLKS, EW2HDRS, EW2PALS
ARBTEBMOD:
	.word	391,253,71	;x size, y size, #blocks
	.long	ARBTEBLKS, EW2HDRS, EW2PALS
ARBTFBMOD:
	.word	392,253,70	;x size, y size, #blocks
	.long	ARBTFBLKS, EW2HDRS, EW2PALS
ARBTGBMOD:
	.word	391,253,63	;x size, y size, #blocks
	.long	ARBTGBLKS, EW2HDRS, EW2PALS
ARBTHBMOD:
	.word	391,253,63	;x size, y size, #blocks
	.long	ARBTHBLKS, EW2HDRS, EW2PALS

ZHDRS:
	.word	24,96	;x size, y size
	.long	>2918040	;address
	.word	200,11
	.long	>291C840
	.word	12,50
	.long	>2920D00
	.word	24,67
	.long	>2921FC0
	.word	24,61
	.long	>2925200
	.word	52,43
	.long	>28472E0
	.word	60,50
	.long	>2927FC0
	.word	12,50
	.long	>2846020
	.word	24,61
	.long	>284B8C0
	.word	24,96
	.long	>28574A0
	.word	196,15
	.long	>284E680
	.word	24,67
	.long	>2854260
	.word	12,58
	.long	>292DD80
	.word	12,70
	.long	>292F340
	.word	44,13
	.long	>2930D80
	.word	16,24
	.long	>285BCA0
	.word	44,13
	.long	>285C8A0
	.word	12,70
	.long	>285DA80
	.word	32,34
	.long	>2931F60
	.word	32,34
	.long	>285F4C0
	.word	28,69
	.long	>2934160
	.word	16,17
	.long	>25BEFA0
	.word	52,35
	.long	>2937DC0
	.word	112,33
	.long	>25BF820
	.word	28,69
	.long	>28616C0
	.word	52,35
	.long	>2865320
	.word	84,7
	.long	>25C8F60
	.word	100,34
	.long	>293B6A0
	.word	40,46
	.long	>29420E0
	.word	100,34
	.long	>2868C00
	.word	40,46
	.long	>286F640
	.word	48,34
	.long	>2945A60
	.word	48,34
	.long	>2872FC0
	.word	68,46
	.long	>2948D60
	.word	68,46
	.long	>28762C0
	.word	60,36
	.long	>294EF20
	.word	64,37
	.long	>29532A0
	.word	64,37
	.long	>287C480
	.word	48,35
	.long	>2957CA0
	.word	48,35
	.long	>2880E80
	.word	44,30
	.long	>295B120
	.word	44,30
	.long	>295DA60
	.word	44,18
	.long	>29603A0
	.word	44,17
	.long	>2884300
	.word	44,25
	.long	>2885A60
	.word	40,25
	.long	>2887CC0
	.word	44,17
	.long	>2884300
	.word	64,37
	.long	>287C480
	.word	44,25
	.long	>2885A60
	.word	112,33
	.long	>25BF820
	.word	40,46
	.long	>286F640
	.word	52,43
	.long	>28472E0
	.word	16,17
	.long	>25EE720
	.word	24,61
	.long	>284B8C0
	.word	16,24
	.long	>285BCA0
	.word	24,67
	.long	>2854260
	.word	24,48
	.long	>2961C60
	.word	52,47
	.long	>2964060
	.word	40,50
	.long	>2968CC0
	.word	12,70
	.long	>292F340
	.word	72,54
	.long	>296CB40
	.word	72,54
	.long	>296CB40
	.word	12,70
	.long	>292F340
	.word	68,46
	.long	>29744C0
	.word	68,46
	.long	>29744C0
	.word	12,70
	.long	>292F340
	.word	32,213
	.long	>297A680
	.word	208,23
	.long	>2987B80
	.word	12,50
	.long	>2991100
	.word	44,13
	.long	>29923C0
	.word	104,49
	.long	>29935A0
	.word	64,37
	.long	>299D4E0
	.word	44,13
	.long	>29A1EE0
	.word	44,34
	.long	>29A30C0
	.word	44,30
	.long	>295B120
	.word	48,34
	.long	>29A5F80


JNG6BLKS:
	.word	>4041	;flags
	.word	0,177 ;x,y
	.word	>6	;pal5,pal4,hdr13-0
	.word	>4041,0,53,>8
	.word	>7340,0,12,>A
	.word	>7343,0,0,>88
	.word	>7E41,0,241,>2
	.word	>7F41,0,63,>C
	.word	>7E41,0,82,>0
	.word	>4041,9,114,>18
	.word	>4240,10,54,>1E
	.word	>7343,10,0,>8A
	.word	>7A43,10,95,>82
	.word	>4061,19,147,>24
	.word	>4041,19,113,>24
	.word	>4041,23,181,>28
	.word	>7440,23,9,>2A
	.word	>4041,24,78,>2C
	.word	>4140,24,45,>2E
	.word	>7640,29,64,>34
	.word	>4041,50,214,>36
	.word	>4041,50,180,>36
	.word	>4041,50,146,>36
	.word	>4041,50,112,>36
	.word	>4143,52,0,>8C
	.word	>4041,76,78,>3E
	.word	>4041,124,78,>3E
	.word	>4043,135,41,>8E
	.word	>4041,147,214,>36
	.word	>4041,147,180,>36
	.word	>4061,147,145,>4C
	.word	>4041,147,112,>4C
	.word	>7C43,155,0,>90
	.word	>4043,155,7,>92
	.word	>7843,155,9,>94
	.word	>4043,172,78,>96
	.word	>7E51,191,241,>2
	.word	>7C53,192,0,>90
	.word	>7953,192,9,>94
	.word	>4053,193,41,>8E
	.word	>4071,195,145,>4C
	.word	>4051,195,112,>4C
	.word	>4043,195,7,>92
	.word	>4041,220,78,>3E
	.word	>4153,235,0,>8C
	.word	>4041,242,180,>36
	.word	>4041,243,146,>36
	.word	>4041,243,112,>36
	.word	>4041,244,214,>36
	.word	>4150,257,45,>62
	.word	>7740,266,64,>34
	.word	>4041,268,78,>3E
	.word	>4051,315,78,>2C
	.word	>7353,337,0,>8A
	.word	>4051,339,180,>28
	.word	>4071,339,146,>24
	.word	>4051,339,112,>24
	.word	>7350,339,12,>66
	.word	>7F51,351,138,>74
	.word	>7540,356,9,>68
	.word	>4051,367,177,>6
	.word	>4051,367,53,>8
	.word	>7E51,367,81,>0
	.word	>7B53,368,95,>82
	.word	>4041,371,114,>18
	.word	>7353,379,0,>88
	.word	0FFFFH	;End Marker

JNG5BLKS:
	.word	>7341	;flags
	.word	0,0 ;x,y
	.word	>4	;pal5,pal4,hdr13-0
	.word	>4041,0,178,>6
	.word	>4041,0,54,>8
	.word	>7340,0,13,>A
	.word	>7E41,0,242,>2
	.word	>7E41,0,82,>0
	.word	>7F41,0,67,>C
	.word	>4041,9,115,>18
	.word	>7341,10,0,>1C
	.word	>4240,10,55,>1E
	.word	>7A43,10,97,>82
	.word	>4061,19,148,>24
	.word	>4041,19,114,>24
	.word	>4041,23,182,>28
	.word	>7440,23,10,>2A
	.word	>4041,24,79,>2C
	.word	>4140,24,46,>2E
	.word	>7640,29,65,>34
	.word	>4041,50,215,>36
	.word	>4041,50,181,>36
	.word	>4041,50,147,>36
	.word	>4041,50,113,>36
	.word	>4041,52,0,>38
	.word	>4041,76,79,>3E
	.word	>4041,89,0,>42
	.word	>7F41,100,0,>46
	.word	>4041,124,79,>3E
	.word	>4041,135,42,>48
	.word	>4041,147,215,>36
	.word	>4041,147,181,>36
	.word	>4061,147,146,>4C
	.word	>4041,147,113,>4C
	.word	>4041,155,12,>52
	.word	>7C41,155,0,>54
	.word	>7843,156,13,>50
	.word	>4041,172,79,>3E
	.word	>7E51,191,242,>2
	.word	>4051,192,12,>52
	.word	>7C51,192,0,>54
	.word	>7953,193,13,>50
	.word	>4051,194,42,>48
	.word	>4071,195,146,>4C
	.word	>4051,195,113,>4C
	.word	>4041,220,79,>3E
	.word	>4251,230,0,>7A
	.word	>7F41,230,202,>C
	.word	>4041,242,181,>36
	.word	>4041,243,147,>36
	.word	>4041,243,113,>36
	.word	>4041,244,215,>36
	.word	>4150,257,46,>62
	.word	>7740,266,65,>34
	.word	>4041,268,79,>3E
	.word	>4051,299,0,>38
	.word	>4051,315,79,>2C
	.word	>4051,337,0,>1C
	.word	>4051,339,181,>28
	.word	>4071,339,147,>24
	.word	>4051,339,113,>24
	.word	>7350,339,13,>66
	.word	>7540,356,10,>68
	.word	>4051,367,178,>6
	.word	>4051,367,54,>8
	.word	>7E51,367,82,>0
	.word	>7B53,368,95,>82
	.word	>4041,371,115,>18
	.word	>4051,379,0,>4
	.word	0FFFFH	;End Marker

JNG4BLKS:
	.word	>7341	;flags
	.word	0,0 ;x,y
	.word	>4	;pal5,pal4,hdr13-0
	.word	>4041,0,178,>6
	.word	>4041,0,54,>8
	.word	>7340,0,13,>A
	.word	>7E41,0,242,>2
	.word	>7E41,0,82,>0
	.word	>4041,9,115,>18
	.word	>7341,10,0,>1C
	.word	>4240,10,55,>1E
	.word	>7A43,10,96,>82
	.word	>4061,19,148,>24
	.word	>4041,19,114,>24
	.word	>4041,23,182,>28
	.word	>7440,23,10,>2A
	.word	>4041,24,79,>2C
	.word	>4140,24,46,>2E
	.word	>7640,29,65,>34
	.word	>7F41,43,177,>C
	.word	>4041,50,215,>36
	.word	>4041,50,181,>36
	.word	>4041,50,147,>36
	.word	>4041,50,113,>36
	.word	>4041,52,0,>38
	.word	>4041,76,79,>3E
	.word	>4241,89,0,>78
	.word	>7F41,90,200,>C
	.word	>4041,124,79,>3E
	.word	>4041,135,42,>48
	.word	>4041,147,215,>36
	.word	>4041,147,181,>36
	.word	>4061,147,146,>4C
	.word	>4041,147,113,>4C
	.word	>4041,155,12,>52
	.word	>7C41,155,0,>54
	.word	>7843,156,14,>50
	.word	>4041,172,79,>3E
	.word	>7E51,191,242,>2
	.word	>4051,192,12,>52
	.word	>7C51,192,0,>54
	.word	>7953,193,14,>50
	.word	>4051,194,42,>48
	.word	>4071,195,146,>4C
	.word	>4051,195,113,>4C
	.word	>4041,220,79,>3E
	.word	>4051,234,0,>80
	.word	>4041,242,181,>36
	.word	>4041,243,147,>36
	.word	>4041,243,113,>36
	.word	>4041,244,215,>36
	.word	>4150,257,46,>62
	.word	>7740,266,65,>34
	.word	>4041,268,79,>3E
	.word	>4051,299,0,>38
	.word	>4051,315,79,>2C
	.word	>4051,337,0,>1C
	.word	>4051,339,181,>28
	.word	>4071,339,147,>24
	.word	>4051,339,113,>24
	.word	>7350,339,13,>66
	.word	>7F51,349,53,>74
	.word	>7540,356,10,>68
	.word	>4051,367,178,>6
	.word	>4051,367,54,>8
	.word	>7E51,367,82,>0
	.word	>7B53,369,95,>82
	.word	>4041,371,115,>18
	.word	>4051,379,0,>4
	.word	0FFFFH	;End Marker

JNG3BLKS:
	.word	>7341	;flags
	.word	0,0 ;x,y
	.word	>4	;pal5,pal4,hdr13-0
	.word	>4041,0,178,>6
	.word	>4041,0,54,>8
	.word	>7340,0,13,>A
	.word	>7E41,0,242,>2
	.word	>7E41,0,82,>0
	.word	>4041,9,115,>18
	.word	>7341,10,0,>1C
	.word	>4240,10,55,>1E
	.word	>7A43,10,94,>7C
	.word	>4061,19,148,>24
	.word	>4041,19,114,>24
	.word	>4041,23,182,>28
	.word	>7440,23,10,>2A
	.word	>4041,24,79,>2C
	.word	>4140,24,46,>2E
	.word	>7640,29,65,>34
	.word	>4041,50,215,>36
	.word	>4041,50,181,>36
	.word	>4041,50,147,>36
	.word	>4041,50,113,>36
	.word	>4041,52,0,>38
	.word	>4041,76,79,>3E
	.word	>4041,89,0,>7E
	.word	>4041,124,79,>3E
	.word	>4041,135,42,>48
	.word	>4041,147,215,>36
	.word	>4041,147,181,>36
	.word	>4061,147,146,>4C
	.word	>4041,147,113,>4C
	.word	>7C41,155,0,>54
	.word	>4041,155,12,>52
	.word	>7843,155,13,>50
	.word	>4041,172,79,>3E
	.word	>7E51,191,242,>2
	.word	>4051,191,13,>52
	.word	>7C51,192,0,>54
	.word	>7953,192,13,>50
	.word	>4051,194,42,>48
	.word	>4071,195,146,>4C
	.word	>4051,195,113,>4C
	.word	>4041,220,79,>3E
	.word	>4051,234,0,>80
	.word	>4041,242,181,>36
	.word	>4041,243,147,>36
	.word	>4041,243,113,>36
	.word	>4041,244,215,>36
	.word	>4150,257,46,>62
	.word	>7740,266,65,>34
	.word	>4041,268,79,>3E
	.word	>4051,299,0,>38
	.word	>7F41,307,199,>C
	.word	>4051,315,79,>2C
	.word	>7F41,324,159,>C
	.word	>4051,337,0,>1C
	.word	>4051,339,181,>28
	.word	>4071,339,147,>24
	.word	>4051,339,113,>24
	.word	>7350,339,13,>66
	.word	>7540,356,10,>68
	.word	>4051,367,178,>6
	.word	>4051,367,54,>8
	.word	>7B53,367,97,>82
	.word	>7E51,367,82,>0
	.word	>4041,371,115,>18
	.word	>4051,379,0,>4
	.word	0FFFFH	;End Marker

JNG2BLKS:
	.word	>7341	;flags
	.word	0,0 ;x,y
	.word	>4	;pal5,pal4,hdr13-0
	.word	>4041,0,178,>6
	.word	>4041,0,54,>8
	.word	>7340,0,13,>A
	.word	>7E41,0,242,>2
	.word	>7F41,0,164,>74
	.word	>7E41,0,81,>0
	.word	>4041,9,115,>18
	.word	>7341,10,0,>1C
	.word	>4240,10,55,>1E
	.word	>7A43,10,97,>76
	.word	>4061,19,148,>24
	.word	>4041,19,114,>24
	.word	>4041,23,182,>28
	.word	>7440,23,10,>2A
	.word	>4041,24,79,>2C
	.word	>4140,24,46,>2E
	.word	>7640,29,65,>34
	.word	>4041,50,215,>36
	.word	>4041,50,181,>36
	.word	>4041,50,147,>36
	.word	>4041,50,113,>36
	.word	>4041,52,0,>38
	.word	>4041,76,79,>3E
	.word	>4241,89,0,>78
	.word	>4041,124,79,>3E
	.word	>4041,135,42,>48
	.word	>4041,147,215,>36
	.word	>4041,147,181,>36
	.word	>4061,147,146,>4C
	.word	>4041,147,113,>4C
	.word	>7843,154,13,>50
	.word	>4041,155,12,>52
	.word	>7C41,155,0,>54
	.word	>4041,172,79,>3E
	.word	>7E51,191,242,>2
	.word	>7953,191,13,>50
	.word	>4051,192,12,>52
	.word	>7C51,192,0,>54
	.word	>4051,194,42,>48
	.word	>4071,195,146,>4C
	.word	>4051,195,113,>4C
	.word	>4041,220,79,>3E
	.word	>4251,230,0,>7A
	.word	>4041,242,181,>36
	.word	>4041,243,147,>36
	.word	>4041,243,113,>36
	.word	>4041,244,215,>36
	.word	>4150,257,46,>62
	.word	>7740,266,65,>34
	.word	>4041,268,79,>3E
	.word	>4051,299,0,>38
	.word	>4051,315,79,>2C
	.word	>7F41,315,198,>C
	.word	>4051,337,0,>1C
	.word	>4051,339,181,>28
	.word	>4071,339,147,>24
	.word	>4051,339,113,>24
	.word	>7350,339,13,>66
	.word	>7540,356,10,>68
	.word	>4051,367,178,>6
	.word	>4051,367,54,>8
	.word	>7E51,367,82,>0
	.word	>7B53,368,96,>7C
	.word	>4051,369,115,>18
	.word	>4051,379,0,>4
	.word	0FFFFH	;End Marker

JNG1BLKS:
	.word	>7340	;flags
	.word	0,13 ;x,y
	.word	>A	;pal5,pal4,hdr13-0
	.word	>4041,0,54,>8
	.word	>4041,0,178,>6
	.word	>7341,0,0,>4
	.word	>7E41,0,242,>2
	.word	>7E41,0,82,>0
	.word	>7F51,1,202,>C
	.word	>4041,9,115,>18
	.word	>4240,10,55,>1E
	.word	>7341,10,0,>1C
	.word	>7A43,10,98,>1A
	.word	>4041,19,114,>24
	.word	>4061,19,148,>24
	.word	>7F41,19,169,>C
	.word	>7440,23,10,>2A
	.word	>4041,23,182,>28
	.word	>4140,24,46,>2E
	.word	>4041,24,79,>2C
	.word	>7640,29,65,>34
	.word	>4041,50,113,>36
	.word	>4041,50,147,>36
	.word	>4041,50,181,>36
	.word	>4041,50,215,>36
	.word	>7F51,51,203,>C
	.word	>4041,52,0,>38
	.word	>4041,76,79,>3E
	.word	>4041,89,0,>42
	.word	>7F41,101,0,>46
	.word	>4041,124,79,>3E
	.word	>4041,135,42,>48
	.word	>4041,147,113,>4C
	.word	>4061,147,146,>4C
	.word	>4041,147,181,>36
	.word	>4041,147,215,>36
	.word	>7C41,155,0,>54
	.word	>4041,155,12,>52
	.word	>7843,155,14,>50
	.word	>4041,172,79,>3E
	.word	>7E51,191,242,>2
	.word	>7C51,192,0,>54
	.word	>4051,192,12,>52
	.word	>7953,192,14,>50
	.word	>4051,194,42,>48
	.word	>4051,195,113,>4C
	.word	>4071,195,146,>4C
	.word	>4041,220,79,>3E
	.word	>4051,234,0,>42
	.word	>4041,242,181,>36
	.word	>4041,243,113,>36
	.word	>4041,243,147,>36
	.word	>4041,244,215,>36
	.word	>4150,257,46,>62
	.word	>7740,266,65,>34
	.word	>4041,268,79,>3E
	.word	>4051,299,0,>38
	.word	>4051,315,79,>2C
	.word	>4051,337,0,>1C
	.word	>7350,339,13,>66
	.word	>4051,339,113,>24
	.word	>4071,339,147,>24
	.word	>4051,339,181,>28
	.word	>7540,356,10,>68
	.word	>4051,367,54,>8
	.word	>4051,367,178,>6
	.word	>7E51,367,82,>0
	.word	>4051,369,115,>18
	.word	>7B53,370,94,>1A
	.word	>4051,379,0,>4
	.word	0FFFFH	;End Marker

ZMOD0BLKS:
	.word	>7E41	;flags
	.word	101,734 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>7E41,101,894,>2
	.word	>7341,101,652,>4
	.word	>4041,101,830,>6
	.word	>4041,101,706,>8
	.word	>7340,101,665,>A
	.word	>7F51,102,854,>C
	.word	>7342,102,101,>E
	.word	>7340,102,114,>A
	.word	>4042,102,156,>10
	.word	>7E42,102,183,>12
	.word	>7F42,102,339,>14
	.word	>4042,102,279,>16
	.word	>4041,110,767,>18
	.word	>7A43,111,750,>1A
	.word	>7341,111,652,>1C
	.word	>4240,111,707,>1E
	.word	>4240,112,156,>1E
	.word	>7342,113,101,>20
	.word	>7A42,115,202,>22
	.word	>7F41,120,821,>C
	.word	>4061,120,800,>24
	.word	>4041,120,766,>24
	.word	>4062,122,249,>26
	.word	>4042,122,215,>26
	.word	>4041,124,834,>28
	.word	>7440,124,662,>2A
	.word	>4041,125,731,>2C
	.word	>4140,125,698,>2E
	.word	>7440,125,111,>2A
	.word	>4042,126,283,>30
	.word	>4042,126,180,>32
	.word	>4140,126,147,>2E
	.word	>7640,130,717,>34
	.word	>7640,131,166,>34
	.word	>4041,151,867,>36
	.word	>4041,151,833,>36
	.word	>4041,151,799,>36
	.word	>4041,151,765,>36
	.word	>7F51,152,855,>C
	.word	>4041,153,652,>38
	.word	>4042,153,316,>3A
	.word	>4042,153,282,>3A
	.word	>4042,153,248,>3A
	.word	>4042,153,214,>3A
	.word	>4042,154,101,>3C
	.word	>4041,177,731,>3E
	.word	>4042,177,180,>40
	.word	>4041,190,652,>42
	.word	>4042,190,101,>44
	.word	>7F41,202,652,>46
	.word	>4041,225,731,>3E
	.word	>4042,225,180,>40
	.word	>4041,236,694,>48
	.word	>4042,237,143,>4A
	.word	>4041,248,867,>36
	.word	>4041,248,833,>36
	.word	>4061,248,798,>4C
	.word	>4041,248,765,>4C
	.word	>4042,249,282,>3A
	.word	>4042,249,214,>4E
	.word	>4062,249,248,>4E
	.word	>4042,249,316,>3A
	.word	>7843,256,666,>50
	.word	>4041,256,664,>52
	.word	>7C41,256,652,>54
	.word	>7C42,256,101,>56
	.word	>4042,257,118,>58
	.word	>7842,258,118,>5A
	.word	>4041,273,731,>3E
	.word	>4042,273,180,>40
	.word	>7E51,292,894,>2
	.word	>7953,293,666,>50
	.word	>4051,293,664,>52
	.word	>7C51,293,652,>54
	.word	>7C52,294,101,>5C
	.word	>4051,295,694,>48
	.word	>4052,295,143,>5E
	.word	>4052,295,119,>60
	.word	>4071,296,798,>4C
	.word	>4051,296,765,>4C
	.word	>7952,296,118,>5A
	.word	>4052,297,214,>4E
	.word	>4072,297,248,>4E
	.word	>7F52,297,339,>14
	.word	>4041,321,731,>3E
	.word	>4042,321,180,>40
	.word	>4051,335,652,>42
	.word	>4052,336,101,>44
	.word	>4041,343,833,>36
	.word	>4041,344,799,>36
	.word	>4041,344,765,>36
	.word	>4041,345,867,>36
	.word	>4042,345,316,>3A
	.word	>4042,345,282,>3A
	.word	>4042,345,214,>3A
	.word	>4042,345,248,>3A
	.word	>4150,358,698,>62
	.word	>4150,359,147,>62
	.word	>7740,367,717,>34
	.word	>7740,368,166,>34
	.word	>4041,369,731,>3E
	.word	>4042,369,180,>40
	.word	>4051,400,652,>38
	.word	>4052,401,101,>64
	.word	>4051,416,731,>2C
	.word	>4052,417,180,>32
	.word	>4051,438,652,>1C
	.word	>7352,438,101,>20
	.word	>4051,440,833,>28
	.word	>4071,440,799,>24
	.word	>4051,440,765,>24
	.word	>7350,440,665,>66
	.word	>4052,440,282,>30
	.word	>4072,440,249,>26
	.word	>4052,440,215,>26
	.word	>7350,441,114,>66
	.word	>7540,457,662,>68
	.word	>7540,458,111,>68
	.word	>7E51,468,734,>0
	.word	>4051,468,830,>6
	.word	>4051,468,706,>8
	.word	>7B52,468,199,>22
	.word	>4052,469,156,>6A
	.word	>4250,469,156,>6C
	.word	>4052,469,279,>6E
	.word	>7E52,469,183,>12
	.word	>4051,470,767,>18
	.word	>7B53,471,746,>1A
	.word	>4051,480,652,>4
	.word	>7352,481,101,>E
	.word	>4241,667,13,>70
	.word	>4141,705,29,>72
	.word	>7F41,1877,412,>74
	.word	>4041,2302,435,>84
	.word	>4041,2345,434,>86
	.word	0FFFFH		;End Marker
JNG6BMOD:
	.word	391,252,64	;x size, y size, #blocks
	.long	JNG6BLKS, ZHDRS, ZPALS
JNG5BMOD:
	.word	391,253,67	;x size, y size, #blocks
	.long	JNG5BLKS, ZHDRS, ZPALS
JNG4BMOD:
	.word	391,253,67	;x size, y size, #blocks
	.long	JNG4BLKS, ZHDRS, ZPALS
JNG3BMOD:
	.word	391,253,66	;x size, y size, #blocks
	.long	JNG3BLKS, ZHDRS, ZPALS
JNG2BMOD:
	.word	391,253,66	;x size, y size, #blocks
	.long	JNG2BLKS, ZHDRS, ZPALS
JNG1BMOD:
	.word	391,253,68	;x size, y size, #blocks
	.long	JNG1BLKS, ZHDRS, ZPALS

XHDRS:
	.word	24,96	;x size, y size
	.long	>29A9280	;address
	.word	24,67
	.long	>29ADA80
	.word	24,61
	.long	>29B0CC0
	.word	196,11
	.long	>29B3A80
	.word	52,43
	.long	>28472E0
	.word	12,51
	.long	>29B7DE0
	.word	12,50
	.long	>2846020
	.word	24,61
	.long	>284B8C0
	.word	24,96
	.long	>28574A0
	.word	196,15
	.long	>284E680
	.word	24,67
	.long	>2854260
	.word	16,69
	.long	>29B9100
	.word	16,24
	.long	>285BCA0
	.word	44,13
	.long	>29BB380
	.word	44,13
	.long	>285C8A0
	.word	12,70
	.long	>2647620
	.word	12,70
	.long	>285DA80
	.word	32,34
	.long	>285F4C0
	.word	52,35
	.long	>29BC560
	.word	28,69
	.long	>29BFE40
	.word	16,17
	.long	>25BEFA0
	.word	112,33
	.long	>25BF820
	.word	28,69
	.long	>28616C0
	.word	52,35
	.long	>2865320
	.word	100,33
	.long	>29C3AA0
	.word	84,7
	.long	>25C8F60
	.word	100,34
	.long	>29CA1C0
	.word	100,34
	.long	>2868C00
	.word	40,46
	.long	>286F640
	.word	48,34
	.long	>29D0C00
	.word	48,34
	.long	>2872FC0
	.word	68,46
	.long	>28762C0
	.word	64,37
	.long	>287C480
	.word	64,37
	.long	>29D3F00
	.word	48,35
	.long	>29D8900
	.word	48,35
	.long	>2880E80
	.word	100,5
	.long	>29DBD80
	.word	44,17
	.long	>2884300
	.word	44,25
	.long	>2885A60
	.word	44,13
	.long	>29A1EE0
	.word	44,34
	.long	>29A30C0
	.word	40,25
	.long	>2887CC0
	.word	40,25
	.long	>25FBC60
	.word	44,17
	.long	>2884300
	.word	64,37
	.long	>287C480
	.word	44,25
	.long	>2885A60
	.word	112,33
	.long	>25BF820
	.word	40,46
	.long	>286F640
	.word	52,43
	.long	>28472E0
	.word	16,17
	.long	>25EE720
	.word	12,70
	.long	>2647620
	.word	16,24
	.long	>285BCA0
	.word	24,67
	.long	>2854260
	.word	24,61
	.long	>284B8C0
	.word	12,50
	.long	>29DCD20
	.word	44,13
	.long	>29DDFE0
	.word	12,70
	.long	>292F340
	.word	40,46
	.long	>29DF1C0
	.word	68,46
	.long	>29E2B40
	.word	44,16
	.long	>29E8D00
	.word	44,30
	.long	>295B120
	.word	44,30
	.long	>295B120
	.word	68,46
	.long	>29EA300
	.word	44,16
	.long	>29F04C0
	.word	68,46
	.long	>29F1AC0
	.word	100,67
	.long	>29F7C80
	.word	104,49
	.long	>2A04DE0
	.word	68,46
	.long	>2A0ED20


TEMPL5BLKS:
	.word	>7340	;flags
	.word	0,13 ;x,y
	.word	>8	;pal5,pal4,hdr13-0
	.word	>7342,0,0,>6C
	.word	>7F42,0,242,>6
	.word	>4042,0,54,>4
	.word	>4142,0,178,>2
	.word	>7E42,0,82,>0
	.word	>4240,10,55,>18
	.word	>7342,10,0,>6E
	.word	>4042,10,116,>16
	.word	>7A42,10,94,>70
	.word	>7440,23,10,>28
	.word	>4042,23,180,>26
	.word	>4042,23,113,>26
	.word	>4042,23,79,>24
	.word	>4140,24,46,>2A
	.word	>7640,29,65,>32
	.word	>4042,51,113,>34
	.word	>4042,51,180,>34
	.word	>4042,51,146,>34
	.word	>4042,51,213,>34
	.word	>4042,52,0,>72
	.word	>4042,75,79,>3A
	.word	>4042,89,0,>86
	.word	>4042,123,79,>3A
	.word	>4042,135,42,>42
	.word	>4042,147,113,>44
	.word	>4062,147,146,>44
	.word	>4042,147,180,>34
	.word	>4042,147,213,>34
	.word	>7C42,155,0,>7E
	.word	>4042,155,8,>50
	.word	>7842,155,11,>78
	.word	>4042,171,79,>3A
	.word	>7C52,192,0,>7E
	.word	>7952,192,11,>7A
	.word	>4052,194,42,>42
	.word	>7F52,195,242,>6
	.word	>4042,195,8,>50
	.word	>4052,195,113,>44
	.word	>4072,195,146,>44
	.word	>4042,219,79,>3A
	.word	>4052,234,0,>86
	.word	>4042,242,113,>34
	.word	>4042,242,146,>34
	.word	>4042,242,180,>34
	.word	>4042,242,213,>34
	.word	>4150,257,46,>5C
	.word	>7740,266,65,>32
	.word	>4042,267,79,>3A
	.word	>4052,299,0,>72
	.word	>4052,315,79,>24
	.word	>7352,337,0,>6E
	.word	>7350,339,13,>60
	.word	>4052,339,113,>26
	.word	>4052,339,180,>26
	.word	>7540,356,10,>62
	.word	>4052,364,115,>16
	.word	>4250,367,56,>66
	.word	>4052,367,54,>4
	.word	>4152,367,178,>2
	.word	>7E52,367,82,>0
	.word	>7B52,368,92,>70
	.word	>7352,379,0,>6C
	.word	0FFFFH	;End Marker

TEMPL1BLKS:
	.word	>7340	;flags
	.word	0,13 ;x,y
	.word	>8	;pal5,pal4,hdr13-0
	.word	>7342,0,0,>6C
	.word	>7F42,0,242,>6
	.word	>4042,0,54,>4
	.word	>4142,0,178,>2
	.word	>7E42,0,82,>0
	.word	>4240,10,55,>18
	.word	>7342,10,0,>6E
	.word	>4042,10,116,>16
	.word	>7A42,10,94,>70
	.word	>7440,23,10,>28
	.word	>4042,23,180,>26
	.word	>4042,23,113,>26
	.word	>4042,23,79,>24
	.word	>4140,24,46,>2A
	.word	>7640,29,65,>32
	.word	>4042,51,113,>34
	.word	>4042,51,180,>34
	.word	>4042,51,146,>34
	.word	>4042,51,213,>34
	.word	>4042,52,0,>72
	.word	>4042,75,79,>3A
	.word	>4042,89,0,>74
	.word	>4042,123,79,>3A
	.word	>4042,135,42,>42
	.word	>4042,147,113,>44
	.word	>4062,147,146,>44
	.word	>4042,147,180,>34
	.word	>4042,147,213,>34
	.word	>4042,155,8,>50
	.word	>7C42,155,0,>76
	.word	>7842,155,11,>78
	.word	>4042,171,79,>3A
	.word	>7C52,192,0,>76
	.word	>7952,192,11,>7A
	.word	>4052,194,42,>42
	.word	>7F52,195,242,>6
	.word	>4042,195,8,>50
	.word	>4052,195,113,>44
	.word	>4072,195,146,>44
	.word	>4042,219,79,>3A
	.word	>4052,234,0,>74
	.word	>4042,242,113,>34
	.word	>4042,242,146,>34
	.word	>4042,242,180,>34
	.word	>4042,242,213,>34
	.word	>4150,257,46,>5C
	.word	>7740,266,65,>32
	.word	>4042,267,79,>3A
	.word	>4052,299,0,>72
	.word	>4052,315,79,>24
	.word	>7352,337,0,>6E
	.word	>7350,339,13,>60
	.word	>4052,339,113,>26
	.word	>4052,339,180,>26
	.word	>7540,356,10,>62
	.word	>4052,364,115,>16
	.word	>4250,367,56,>66
	.word	>4052,367,54,>4
	.word	>4152,367,178,>2
	.word	>7E52,367,82,>0
	.word	>7B52,368,92,>70
	.word	>7352,379,0,>6C
	.word	0FFFFH	;End Marker

TEMPL2BLKS:
	.word	>4142	;flags
	.word	0,178 ;x,y
	.word	>2	;pal5,pal4,hdr13-0
	.word	>4042,0,54,>4
	.word	>7F42,0,242,>6
	.word	>7342,0,0,>6C
	.word	>7340,0,13,>8
	.word	>7E42,0,82,>0
	.word	>4042,10,116,>16
	.word	>7342,10,0,>6E
	.word	>4240,10,55,>18
	.word	>7A42,10,94,>70
	.word	>4042,23,79,>24
	.word	>4042,23,113,>26
	.word	>4042,23,180,>26
	.word	>7440,23,10,>28
	.word	>4140,24,46,>2A
	.word	>7640,29,65,>32
	.word	>4042,51,213,>34
	.word	>4042,51,146,>34
	.word	>4042,51,180,>34
	.word	>4042,51,113,>34
	.word	>4042,52,0,>72
	.word	>4042,75,79,>3A
	.word	>4042,89,0,>7C
	.word	>4042,123,79,>3A
	.word	>4042,135,42,>42
	.word	>4042,147,213,>34
	.word	>4042,147,180,>34
	.word	>4062,147,146,>44
	.word	>4042,147,113,>44
	.word	>7842,155,11,>78
	.word	>4042,155,8,>50
	.word	>7C42,155,0,>7E
	.word	>4042,171,79,>3A
	.word	>7952,192,11,>7A
	.word	>7C52,192,0,>7E
	.word	>4052,194,42,>42
	.word	>4072,195,146,>44
	.word	>4052,195,113,>44
	.word	>4042,195,8,>50
	.word	>7F52,195,242,>6
	.word	>4042,219,79,>3A
	.word	>4052,234,0,>7C
	.word	>4042,242,213,>34
	.word	>4042,242,180,>34
	.word	>4042,242,146,>34
	.word	>4042,242,113,>34
	.word	>4150,257,46,>5C
	.word	>7740,266,65,>32
	.word	>4042,267,79,>3A
	.word	>4052,299,0,>72
	.word	>4052,315,79,>24
	.word	>7352,337,0,>6E
	.word	>4052,339,180,>26
	.word	>4052,339,113,>26
	.word	>7350,339,13,>60
	.word	>7540,356,10,>62
	.word	>4052,364,115,>16
	.word	>4152,367,178,>2
	.word	>4052,367,54,>4
	.word	>4250,367,56,>66
	.word	>7E52,367,82,>0
	.word	>7B52,368,92,>70
	.word	>7352,379,0,>6C
	.word	0FFFFH	;End Marker

TEMPL3BLKS:
	.word	>4142	;flags
	.word	0,178 ;x,y
	.word	>2	;pal5,pal4,hdr13-0
	.word	>4042,0,54,>4
	.word	>7F42,0,242,>6
	.word	>7342,0,0,>6C
	.word	>7340,0,13,>8
	.word	>7E42,0,82,>0
	.word	>4042,10,116,>16
	.word	>7342,10,0,>6E
	.word	>4240,10,55,>18
	.word	>7A42,10,94,>70
	.word	>4042,23,79,>24
	.word	>4042,23,113,>26
	.word	>4042,23,180,>26
	.word	>7440,23,10,>28
	.word	>4140,24,46,>2A
	.word	>7640,29,65,>32
	.word	>4042,51,213,>34
	.word	>4042,51,146,>34
	.word	>4042,51,180,>34
	.word	>4042,51,113,>34
	.word	>4042,52,0,>72
	.word	>4042,75,79,>3A
	.word	>4042,89,0,>80
	.word	>4042,123,79,>3A
	.word	>4042,135,42,>42
	.word	>4042,147,213,>34
	.word	>4042,147,180,>34
	.word	>4062,147,146,>44
	.word	>4042,147,113,>44
	.word	>7842,155,11,>78
	.word	>4042,155,8,>50
	.word	>7C42,155,0,>7E
	.word	>4042,171,79,>3A
	.word	>7952,192,11,>7A
	.word	>7C52,192,0,>7E
	.word	>4052,194,42,>42
	.word	>4072,195,146,>44
	.word	>4052,195,113,>44
	.word	>4042,195,8,>50
	.word	>7F52,195,242,>6
	.word	>4042,219,79,>3A
	.word	>4052,234,0,>80
	.word	>4042,242,213,>34
	.word	>4042,242,180,>34
	.word	>4042,242,146,>34
	.word	>4042,242,113,>34
	.word	>4150,257,46,>5C
	.word	>7740,266,65,>32
	.word	>4042,267,79,>3A
	.word	>4052,299,0,>72
	.word	>4052,315,79,>24
	.word	>7352,337,0,>6E
	.word	>4052,339,180,>26
	.word	>4052,339,113,>26
	.word	>7350,339,13,>60
	.word	>7540,356,10,>62
	.word	>4052,364,115,>16
	.word	>4152,367,178,>2
	.word	>4052,367,54,>4
	.word	>4250,367,56,>66
	.word	>7E52,367,82,>0
	.word	>7B52,368,92,>70
	.word	>7352,379,0,>6C
	.word	0FFFFH	;End Marker

TEMPL4BLKS:
	.word	>4042	;flags
	.word	0,54 ;x,y
	.word	>4	;pal5,pal4,hdr13-0
	.word	>7340,0,13,>8
	.word	>7342,0,0,>A
	.word	>4142,0,178,>2
	.word	>7E42,0,82,>0
	.word	>4142,0,194,>2
	.word	>4042,10,116,>16
	.word	>4240,10,55,>18
	.word	>7342,10,0,>1A
	.word	>7A42,10,94,>70
	.word	>7440,23,10,>28
	.word	>4042,23,162,>26
	.word	>4042,23,95,>26
	.word	>4042,23,193,>26
	.word	>4140,24,46,>2A
	.word	>4042,24,79,>24
	.word	>7640,29,65,>32
	.word	>4042,51,162,>34
	.word	>4142,51,96,>82
	.word	>4042,51,195,>34
	.word	>4042,51,228,>34
	.word	>4142,52,0,>84
	.word	>4042,76,79,>3A
	.word	>4042,123,79,>3A
	.word	>4042,135,42,>42
	.word	>4062,147,146,>44
	.word	>4042,147,113,>44
	.word	>4042,147,178,>34
	.word	>4042,147,211,>34
	.word	>4042,147,228,>34
	.word	>7842,155,11,>78
	.word	>4042,155,8,>50
	.word	>7C42,155,0,>4E
	.word	>4042,171,79,>3A
	.word	>7952,192,11,>7A
	.word	>7C52,192,0,>4E
	.word	>4052,194,42,>42
	.word	>4072,195,146,>44
	.word	>4052,195,113,>44
	.word	>4042,195,8,>50
	.word	>4042,219,79,>3A
	.word	>4152,235,0,>84
	.word	>4052,240,96,>82
	.word	>4042,243,161,>34
	.word	>4042,243,194,>34
	.word	>4042,244,228,>34
	.word	>4150,257,46,>5C
	.word	>7740,266,65,>32
	.word	>4042,267,79,>3A
	.word	>4052,315,79,>24
	.word	>7352,337,0,>1A
	.word	>4052,337,193,>26
	.word	>4052,339,180,>26
	.word	>4052,339,113,>26
	.word	>7350,339,13,>60
	.word	>7540,356,10,>62
	.word	>4052,364,115,>16
	.word	>4152,367,178,>2
	.word	>4052,367,54,>4
	.word	>4250,367,56,>66
	.word	>7E52,367,82,>0
	.word	>4152,367,195,>2
	.word	>7B52,368,92,>70
	.word	>7352,379,0,>A
	.word	0FFFFH	;End Marker

XMOD0BLKS:
	.word	>7E42	;flags
	.word	102,758 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4142,102,854,>2
	.word	>4042,102,730,>4
	.word	>7F42,102,918,>6
	.word	>7340,102,689,>8
	.word	>7342,102,676,>A
	.word	>7341,102,101,>C
	.word	>7340,102,114,>8
	.word	>4041,102,156,>E
	.word	>7E41,102,183,>10
	.word	>7F41,102,339,>12
	.word	>4041,102,279,>14
	.word	>7342,103,397,>A
	.word	>7340,103,410,>8
	.word	>7F42,103,639,>6
	.word	>4042,103,451,>4
	.word	>4142,103,575,>2
	.word	>7E42,103,479,>0
	.word	>4042,112,792,>16
	.word	>4240,112,731,>18
	.word	>7342,112,676,>1A
	.word	>4240,112,156,>18
	.word	>7342,113,397,>1A
	.word	>4240,113,452,>18
	.word	>4042,113,513,>16
	.word	>7341,113,101,>1C
	.word	>7A40,115,772,>1E
	.word	>7A41,115,202,>20
	.word	>7A40,116,493,>1E
	.word	>4061,122,249,>22
	.word	>4041,122,215,>22
	.word	>4042,125,755,>24
	.word	>4042,125,789,>26
	.word	>4042,125,856,>26
	.word	>7440,125,686,>28
	.word	>7440,125,111,>28
	.word	>4140,126,722,>2A
	.word	>7440,126,407,>28
	.word	>4041,126,283,>2C
	.word	>4041,126,180,>2E
	.word	>4140,126,147,>2A
	.word	>4142,126,476,>30
	.word	>4052,126,574,>26
	.word	>4052,126,508,>26
	.word	>4140,127,443,>2A
	.word	>7640,131,741,>32
	.word	>7640,131,166,>32
	.word	>7640,132,462,>32
	.word	>4042,153,789,>34
	.word	>4042,153,823,>34
	.word	>4042,153,889,>34
	.word	>4042,153,856,>34
	.word	>4041,153,316,>36
	.word	>4041,153,282,>36
	.word	>4041,153,248,>36
	.word	>4041,153,214,>36
	.word	>4041,154,101,>38
	.word	>4142,154,542,>30
	.word	>4142,154,575,>30
	.word	>4142,154,608,>30
	.word	>4142,154,509,>30
	.word	>4042,177,755,>3A
	.word	>4041,177,180,>3C
	.word	>4041,190,101,>3E
	.word	>4042,223,476,>30
	.word	>4042,225,755,>3A
	.word	>4041,225,180,>3C
	.word	>4041,237,143,>40
	.word	>4042,238,439,>42
	.word	>4052,243,575,>30
	.word	>4142,244,608,>30
	.word	>4042,249,889,>34
	.word	>4042,249,856,>34
	.word	>4062,249,822,>44
	.word	>4042,249,789,>44
	.word	>4041,249,282,>36
	.word	>4041,249,214,>46
	.word	>4061,249,248,>46
	.word	>4041,249,316,>36
	.word	>4262,251,540,>44
	.word	>4242,251,505,>44
	.word	>4042,252,508,>48
	.word	>7C41,256,101,>4A
	.word	>4041,257,118,>4C
	.word	>7C42,258,397,>4E
	.word	>4042,258,405,>50
	.word	>7841,258,118,>52
	.word	>7840,260,407,>54
	.word	>4042,273,755,>3A
	.word	>4041,273,180,>3C
	.word	>7C51,294,101,>56
	.word	>7C52,295,397,>4E
	.word	>4051,295,143,>58
	.word	>4051,295,119,>5A
	.word	>7951,296,118,>52
	.word	>4072,297,822,>44
	.word	>4052,297,789,>44
	.word	>7F52,297,918,>6
	.word	>4052,297,439,>42
	.word	>4051,297,214,>46
	.word	>4071,297,248,>46
	.word	>7F51,297,339,>12
	.word	>7F52,298,639,>6
	.word	>4042,298,405,>50
	.word	>4272,299,540,>44
	.word	>4042,319,476,>30
	.word	>4042,321,755,>3A
	.word	>4041,321,180,>3C
	.word	>4051,336,101,>3E
	.word	>4042,343,509,>30
	.word	>4042,343,542,>30
	.word	>4042,343,575,>30
	.word	>4042,343,608,>30
	.word	>4042,344,789,>34
	.word	>4042,344,823,>34
	.word	>4042,344,889,>34
	.word	>4042,344,856,>34
	.word	>4041,345,316,>36
	.word	>4041,345,282,>36
	.word	>4041,345,214,>36
	.word	>4041,345,248,>36
	.word	>4150,359,722,>5C
	.word	>4150,359,147,>5C
	.word	>4150,360,443,>5C
	.word	>7740,368,741,>32
	.word	>7740,368,166,>32
	.word	>4042,369,755,>3A
	.word	>7740,369,462,>32
	.word	>4041,369,180,>3C
	.word	>4051,401,101,>5E
	.word	>4052,417,755,>24
	.word	>4051,417,180,>2E
	.word	>4062,418,476,>24
	.word	>7351,438,101,>1C
	.word	>7352,439,676,>1A
	.word	>7352,440,397,>1A
	.word	>4051,440,282,>2C
	.word	>4071,440,249,>22
	.word	>4051,440,215,>22
	.word	>4052,441,856,>26
	.word	>4052,441,789,>26
	.word	>7350,441,689,>60
	.word	>7350,441,114,>60
	.word	>7350,442,410,>60
	.word	>4062,442,509,>26
	.word	>4062,442,574,>26
	.word	>7540,458,686,>62
	.word	>7540,458,111,>62
	.word	>7540,459,407,>62
	.word	>4052,466,791,>16
	.word	>4052,467,512,>16
	.word	>7B50,468,768,>64
	.word	>7B51,468,199,>20
	.word	>7E52,469,758,>0
	.word	>4152,469,854,>2
	.word	>4052,469,730,>4
	.word	>4250,469,732,>66
	.word	>4250,469,156,>66
	.word	>4051,469,279,>68
	.word	>4051,469,155,>6A
	.word	>7E51,469,183,>10
	.word	>7B50,469,489,>64
	.word	>4250,470,453,>66
	.word	>4052,470,451,>4
	.word	>4152,470,575,>2
	.word	>7E52,470,479,>0
	.word	>7352,481,676,>A
	.word	>7351,481,101,>C
	.word	>7352,482,397,>A
	.word	0FFFFH		;End Marker
TEMPL5BMOD:
	.word	391,253,63	;x size, y size, #blocks
	.long	TEMPL5BLKS, XHDRS, XPALS
TEMPL1BMOD:
	.word	391,253,63	;x size, y size, #blocks
	.long	TEMPL1BLKS, XHDRS, XPALS
TEMPL2BMOD:
	.word	391,253,63	;x size, y size, #blocks
	.long	TEMPL2BLKS, XHDRS, XPALS
TEMPL3BMOD:
	.word	391,253,63	;x size, y size, #blocks
	.long	TEMPL3BLKS, XHDRS, XPALS
TEMPL4BMOD:
	.word	391,262,64	;x size, y size, #blocks
	.long	TEMPL4BLKS, XHDRS, XPALS

RNHDRS:
	.word	52,43	;x size, y size
	.long	>28472E0	;address
	.word	12,50
	.long	>2A14EE0
	.word	24,61
	.long	>2A161A0
	.word	196,8
	.long	>2A18F60
	.word	24,67
	.long	>2A1C060
	.word	24,96
	.long	>2A1F2A0
	.word	16,24
	.long	>285BCA0
	.word	44,13
	.long	>2A23AA0
	.word	12,70
	.long	>2647620
	.word	32,34
	.long	>2A24C80
	.word	16,17
	.long	>25BEFA0
	.word	52,35
	.long	>2A26E80
	.word	28,69
	.long	>2A2A760
	.word	112,33
	.long	>25BF820
	.word	84,7
	.long	>25C8F60
	.word	100,34
	.long	>2A2E3C0
	.word	104,46
	.long	>2A34E00
	.word	48,34
	.long	>2A3E380
	.word	64,37
	.long	>2A41680
	.word	48,35
	.long	>2A46080
	.word	44,25
	.long	>2A49500
	.word	44,16
	.long	>2A4B760
	.word	40,25
	.long	>25FBC60
	.word	44,25
	.long	>2A49500
	.word	64,37
	.long	>2A41680
	.word	112,33
	.long	>25BF820
	.word	52,43
	.long	>28472E0
	.word	16,17
	.long	>25EE720
	.word	16,24
	.long	>285BCA0
	.word	12,70
	.long	>285DA80
	.word	40,25
	.long	>2887CC0
	.word	12,70
	.long	>292F340
	.word	44,30
	.long	>295B120
	.word	104,50
	.long	>25CF500
	.word	40,30
	.long	>2A4CD60
	.word	40,18
	.long	>25E61C0


MCENDBLKS:
	.word	>7E41	;flags
	.word	0,82 ;x,y
	.word	>A	;pal5,pal4,hdr13-0
	.word	>7340,0,13,>0
	.word	>7341,0,0,>2
	.word	>4041,0,54,>4
	.word	>7F41,0,245,>6
	.word	>4041,0,178,>8
	.word	>7A42,9,93,>3E
	.word	>4240,10,55,>C
	.word	>7341,11,0,>E
	.word	>4061,20,148,>12
	.word	>4041,20,114,>12
	.word	>7440,23,10,>14
	.word	>4041,23,79,>16
	.word	>4041,23,182,>18
	.word	>4140,24,46,>1A
	.word	>7640,29,65,>1C
	.word	>4041,51,215,>1E
	.word	>4041,51,147,>1E
	.word	>4041,51,181,>1E
	.word	>4041,51,113,>1E
	.word	>4044,52,0,>42
	.word	>4041,74,79,>22
	.word	>4041,122,79,>22
	.word	>4041,135,42,>24
	.word	>4051,143,181,>1E
	.word	>4051,143,215,>1E
	.word	>4041,147,113,>26
	.word	>4061,147,146,>26
	.word	>4241,153,16,>44
	.word	>4044,155,15,>46
	.word	>4144,155,28,>46
	.word	>4044,156,0,>46
	.word	>4041,170,79,>22
	.word	>4051,192,42,>30
	.word	>4251,193,16,>44
	.word	>7F51,195,245,>6
	.word	>4051,195,113,>26
	.word	>4071,195,146,>26
	.word	>4044,195,9,>46
	.word	>4144,195,27,>46
	.word	>4044,196,0,>46
	.word	>4041,218,79,>22
	.word	>4054,235,0,>42
	.word	>4051,240,147,>1E
	.word	>4051,240,113,>1E
	.word	>4051,240,215,>1E
	.word	>4051,240,181,>1E
	.word	>4150,257,46,>32
	.word	>7740,266,65,>1C
	.word	>4041,266,79,>22
	.word	>4051,314,79,>16
	.word	>7351,336,0,>E
	.word	>7350,339,13,>34
	.word	>4071,339,148,>12
	.word	>4051,339,114,>12
	.word	>4051,340,182,>18
	.word	>7540,356,10,>36
	.word	>7E51,367,82,>A
	.word	>4250,367,55,>38
	.word	>4051,367,54,>4
	.word	>4051,367,178,>8
	.word	>7B52,369,93,>3E
	.word	>7351,379,0,>2
	.word	0FFFFH	;End Marker

TRSR3BLKS:
	.word	>4041	;flags
	.word	0,178 ;x,y
	.word	>8	;pal5,pal4,hdr13-0
	.word	>7F41,0,245,>6
	.word	>4041,0,54,>4
	.word	>7341,0,0,>2
	.word	>7340,0,13,>0
	.word	>7E41,0,82,>A
	.word	>7A42,9,93,>3E
	.word	>4240,10,55,>C
	.word	>7341,11,0,>E
	.word	>4041,20,114,>12
	.word	>4061,20,148,>12
	.word	>4041,23,182,>18
	.word	>4041,23,79,>16
	.word	>7440,23,10,>14
	.word	>4140,24,46,>1A
	.word	>7640,29,65,>1C
	.word	>4041,51,113,>1E
	.word	>4041,51,181,>1E
	.word	>4041,51,147,>1E
	.word	>4041,51,215,>1E
	.word	>4041,52,0,>20
	.word	>4041,74,79,>22
	.word	>4041,122,79,>22
	.word	>4041,135,42,>24
	.word	>4051,143,215,>1E
	.word	>4051,143,181,>1E
	.word	>4061,147,146,>26
	.word	>4041,147,113,>26
	.word	>7C41,155,0,>2A
	.word	>4041,155,17,>28
	.word	>7842,155,13,>40
	.word	>4041,170,79,>22
	.word	>7C51,192,0,>2A
	.word	>4051,192,42,>30
	.word	>4051,192,17,>2E
	.word	>7952,192,13,>40
	.word	>4071,195,146,>26
	.word	>4051,195,113,>26
	.word	>7F51,195,245,>6
	.word	>4041,218,79,>22
	.word	>4051,235,0,>20
	.word	>4051,240,181,>1E
	.word	>4051,240,215,>1E
	.word	>4051,240,113,>1E
	.word	>4051,240,147,>1E
	.word	>4150,257,46,>32
	.word	>4041,266,79,>22
	.word	>7740,266,65,>1C
	.word	>4051,314,79,>16
	.word	>7351,336,0,>E
	.word	>4051,339,114,>12
	.word	>4071,339,148,>12
	.word	>7350,339,13,>34
	.word	>4051,340,182,>18
	.word	>7540,356,10,>36
	.word	>4051,367,178,>8
	.word	>4051,367,54,>4
	.word	>4250,367,55,>38
	.word	>7E51,367,82,>A
	.word	>7B52,369,93,>3E
	.word	>7351,379,0,>2
	.word	0FFFFH	;End Marker

TRSR2BLKS:
	.word	>4041	;flags
	.word	0,178 ;x,y
	.word	>8	;pal5,pal4,hdr13-0
	.word	>7F41,0,245,>6
	.word	>4041,0,54,>4
	.word	>7341,0,0,>2
	.word	>7340,0,13,>0
	.word	>7E41,0,82,>A
	.word	>4240,10,55,>C
	.word	>7341,11,0,>E
	.word	>7A43,11,98,>3A
	.word	>4041,20,114,>12
	.word	>4061,20,148,>12
	.word	>4041,23,182,>18
	.word	>4041,23,79,>16
	.word	>7440,23,10,>14
	.word	>4140,24,46,>1A
	.word	>7640,29,65,>1C
	.word	>4041,51,113,>1E
	.word	>4041,51,181,>1E
	.word	>4041,51,147,>1E
	.word	>4041,51,215,>1E
	.word	>4041,52,0,>20
	.word	>4041,74,79,>22
	.word	>4041,122,79,>22
	.word	>4041,135,42,>24
	.word	>4051,143,215,>1E
	.word	>4051,143,181,>1E
	.word	>4061,147,146,>26
	.word	>4041,147,113,>26
	.word	>7C41,155,0,>2A
	.word	>4041,155,17,>28
	.word	>7843,157,16,>3C
	.word	>4041,170,79,>22
	.word	>7C51,192,0,>2A
	.word	>4051,192,42,>30
	.word	>4051,192,17,>2E
	.word	>4071,195,146,>26
	.word	>4051,195,113,>26
	.word	>7F51,195,245,>6
	.word	>7953,195,16,>3C
	.word	>4041,218,79,>22
	.word	>4051,235,0,>20
	.word	>4051,240,181,>1E
	.word	>4051,240,215,>1E
	.word	>4051,240,113,>1E
	.word	>4051,240,147,>1E
	.word	>4150,257,46,>32
	.word	>4041,266,79,>22
	.word	>7740,266,65,>1C
	.word	>4051,314,79,>16
	.word	>7351,336,0,>E
	.word	>4051,339,114,>12
	.word	>4071,339,148,>12
	.word	>7350,339,13,>34
	.word	>4051,340,182,>18
	.word	>7540,356,10,>36
	.word	>4051,367,178,>8
	.word	>4051,367,54,>4
	.word	>4250,367,55,>38
	.word	>7B53,367,99,>3A
	.word	>7E51,367,82,>A
	.word	>7351,379,0,>2
	.word	0FFFFH	;End Marker

TRSRBLKS:
	.word	>7340	;flags
	.word	0,13 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>7341,0,0,>2
	.word	>4041,0,54,>4
	.word	>7F41,0,245,>6
	.word	>4041,0,178,>8
	.word	>7E41,0,82,>A
	.word	>4240,10,55,>C
	.word	>7341,11,0,>E
	.word	>7A40,11,96,>10
	.word	>4061,20,148,>12
	.word	>4041,20,114,>12
	.word	>7440,23,10,>14
	.word	>4041,23,79,>16
	.word	>4041,23,182,>18
	.word	>4140,24,46,>1A
	.word	>7640,29,65,>1C
	.word	>4041,51,215,>1E
	.word	>4041,51,147,>1E
	.word	>4041,51,181,>1E
	.word	>4041,51,113,>1E
	.word	>4041,52,0,>20
	.word	>4041,74,79,>22
	.word	>4041,122,79,>22
	.word	>4041,135,42,>24
	.word	>4051,143,181,>1E
	.word	>4051,143,215,>1E
	.word	>4041,147,113,>26
	.word	>4061,147,146,>26
	.word	>4041,155,17,>28
	.word	>7C41,155,0,>2A
	.word	>7840,157,16,>2C
	.word	>4041,170,79,>22
	.word	>4051,192,17,>2E
	.word	>4051,192,42,>30
	.word	>7C51,192,0,>2A
	.word	>7950,194,16,>2C
	.word	>7F51,195,245,>6
	.word	>4051,195,113,>26
	.word	>4071,195,146,>26
	.word	>4041,218,79,>22
	.word	>4051,235,0,>20
	.word	>4051,240,147,>1E
	.word	>4051,240,113,>1E
	.word	>4051,240,215,>1E
	.word	>4051,240,181,>1E
	.word	>4150,257,46,>32
	.word	>7740,266,65,>1C
	.word	>4041,266,79,>22
	.word	>4051,314,79,>16
	.word	>7351,336,0,>E
	.word	>7350,339,13,>34
	.word	>4071,339,148,>12
	.word	>4051,339,114,>12
	.word	>4051,340,182,>18
	.word	>7540,356,10,>36
	.word	>4250,367,55,>38
	.word	>4051,367,54,>4
	.word	>4051,367,178,>8
	.word	>7B50,367,96,>10
	.word	>7E51,367,82,>A
	.word	>7351,379,0,>2
	.word	0FFFFH	;End Marker

RNMOD0BLKS:
	.word	0FFFFH		;End Marker
MCENDBMOD:
	.word	391,253,63	;x size, y size, #blocks
	.long	MCENDBLKS, RNHDRS, RNPALS
TRSR3BMOD:
	.word	391,253,61	;x size, y size, #blocks
	.long	TRSR3BLKS, RNHDRS, RNPALS
TRSR2BMOD:
	.word	391,253,61	;x size, y size, #blocks
	.long	TRSR2BLKS, RNHDRS, RNPALS
TRSRBMOD:
	.word	391,253,61	;x size, y size, #blocks
	.long	TRSRBLKS, RNHDRS, RNPALS

ISCHDRS:
	.word	20,38	;x size, y size
	.long	>2A4F2E0	;address
	.word	20,154
	.long	>2A50AA0
	.word	76,15
	.long	>2A56AE0
	.word	8,25
	.long	>2A58E80
	.word	16,31
	.long	>2A594C0
	.word	28,39
	.long	>2A5A440
	.word	12,10
	.long	>2A5C660
	.word	12,7
	.long	>2A5CA20
	.word	48,15
	.long	>2A5CCC0
	.word	40,33
	.long	>2A5E340
	.word	16,12
	.long	>2A60C80
	.word	12,12
	.long	>2A61280
	.word	12,12
	.long	>2A61700
	.word	12,12
	.long	>2A61B80
	.word	12,12
	.long	>2A62000
	.word	12,12
	.long	>2A62480
	.word	12,12
	.long	>2A62900
	.word	12,12
	.long	>2A62D80
	.word	12,12
	.long	>2A63200
	.word	12,12
	.long	>2A63680
	.word	24,22
	.long	>2A63B00
	.word	100,18
	.long	>2A64B80
	.word	28,11
	.long	>2A683C0
	.word	200,17
	.long	>2A68D60
	.word	76,17
	.long	>2A6F7A0
	.word	156,162
	.long	>2A72000


tenBLKS:
	.word	>4050	;flags
	.word	0,39 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>3C40,1,95,>2
	.word	>4040,2,245,>4
	.word	>4040,2,151,>6
	.word	>4040,2,69,>8
	.word	>4040,3,259,>A
	.word	>4040,3,237,>C
	.word	>4040,3,134,>E
	.word	>4040,7,41,>10
	.word	>3B40,15,216,>12
	.word	>4041,20,206,>14
	.word	>4041,22,94,>16
	.word	>4041,22,110,>18
	.word	>4041,22,126,>1A
	.word	>4041,22,142,>1C
	.word	>4041,22,158,>1E
	.word	>4041,22,174,>20
	.word	>4041,22,190,>22
	.word	>4041,23,62,>24
	.word	>4041,23,78,>26
	.word	>4040,30,259,>A
	.word	>4040,34,216,>12
	.word	>4240,37,233,>28
	.word	>4640,51,39,>2A
	.word	>4040,58,259,>A
	.word	>4040,65,41,>10
	.word	>3C40,70,216,>12
	.word	>4150,74,0,>0
	.word	>4040,76,245,>4
	.word	>4040,76,20,>8
	.word	>4040,82,237,>2C
	.word	>4040,86,259,>A
	.word	>4040,88,2,>10
	.word	>4640,96,18,>2E
	.word	>4040,106,216,>12
	.word	>4040,114,259,>A
	.word	>4040,130,2,>10
	.word	>4040,133,41,>10
	.word	>4240,134,233,>28
	.word	>4040,142,259,>A
	.word	>4040,142,216,>12
	.word	>4040,149,245,>4
	.word	>4040,170,259,>A
	.word	>4040,172,2,>10
	.word	>3C50,177,95,>2
	.word	>4040,178,39,>0
	.word	>4050,180,65,>8
	.word	>3F40,180,237,>2C
	.word	>4040,188,151,>6
	.word	>4050,189,39,>0
	.word	>4040,189,134,>E
	.word	>3C40,190,95,>2
	.word	>4050,191,151,>6
	.word	>4040,191,134,>E
	.word	>4040,191,65,>8
	.word	>3240,193,216,>12
	.word	>4040,198,259,>A
	.word	>4040,200,41,>10
	.word	>4040,208,41,>10
	.word	>4041,210,206,>14
	.word	>4041,212,62,>24
	.word	>4041,212,78,>26
	.word	>4041,212,94,>16
	.word	>4041,212,110,>18
	.word	>4041,212,126,>1A
	.word	>4041,212,142,>1C
	.word	>4041,212,158,>1E
	.word	>4041,212,174,>20
	.word	>4041,212,190,>22
	.word	>4040,214,2,>10
	.word	>4140,224,245,>4
	.word	>4040,226,259,>A
	.word	>4040,229,216,>12
	.word	>4240,231,233,>28
	.word	>4040,247,41,>10
	.word	>4040,248,2,>10
	.word	>4640,251,40,>30
	.word	>4040,254,259,>A
	.word	>3C40,265,216,>12
	.word	>4040,273,41,>10
	.word	>3F40,278,237,>2C
	.word	>4040,282,259,>A
	.word	>3C40,296,0,>0
	.word	>4050,298,23,>8
	.word	>4040,299,245,>4
	.word	>4040,301,216,>12
	.word	>4040,310,259,>A
	.word	>4040,313,41,>10
	.word	>4040,320,41,>10
	.word	>4240,327,233,>28
	.word	>3F40,337,216,>12
	.word	>4040,338,259,>A
	.word	>4040,366,259,>A
	.word	>4050,367,95,>2
	.word	>4140,368,39,>0
	.word	>4050,370,66,>8
	.word	>4040,373,245,>4
	.word	>4050,373,237,>C
	.word	>4040,378,151,>6
	.word	>4040,379,134,>E
	.word	0FFFFH	;End Marker

ISCMOD0BLKS:
	.word	>4050	;flags
	.word	1025,266 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>3C40,1026,322,>2
	.word	>4040,1027,296,>8
	.word	>4040,1027,378,>6
	.word	>4040,1027,472,>4
	.word	>4040,1028,361,>E
	.word	>4040,1028,464,>C
	.word	>4040,1028,486,>A
	.word	>4040,1032,268,>10
	.word	>3B40,1040,443,>12
	.word	>4041,1046,284,>32
	.word	>4040,1055,486,>A
	.word	>4040,1059,443,>12
	.word	>4240,1062,460,>28
	.word	>4640,1076,265,>2A
	.word	>4040,1083,486,>A
	.word	>4040,1090,268,>10
	.word	>3C40,1095,443,>12
	.word	>4150,1099,227,>0
	.word	>4040,1101,247,>8
	.word	>4040,1101,472,>4
	.word	>4040,1107,464,>2C
	.word	>4040,1111,486,>A
	.word	>4040,1113,229,>10
	.word	>4640,1120,246,>2E
	.word	>4040,1131,443,>12
	.word	>4040,1139,486,>A
	.word	>4040,1155,229,>10
	.word	>4040,1158,268,>10
	.word	>4240,1159,460,>28
	.word	>4040,1167,443,>12
	.word	>4040,1167,486,>A
	.word	>4040,1174,472,>4
	.word	>4040,1195,486,>A
	.word	>4040,1197,229,>10
	.word	>3C50,1202,322,>2
	.word	>4040,1203,266,>0
	.word	>3F40,1205,464,>2C
	.word	>4050,1205,292,>8
	.word	>4040,1213,378,>6
	.word	>4040,1214,361,>E
	.word	>4050,1214,266,>0
	.word	>3C40,1215,322,>2
	.word	>4040,1216,292,>8
	.word	>4040,1216,361,>E
	.word	>4050,1216,378,>6
	.word	>3240,1218,443,>12
	.word	>4040,1223,486,>A
	.word	>4040,1225,268,>10
	.word	>4040,1233,268,>10
	.word	>4040,1239,229,>10
	.word	>4140,1249,472,>4
	.word	>4040,1251,486,>A
	.word	>4040,1254,443,>12
	.word	>4240,1256,460,>28
	.word	>4040,1272,268,>10
	.word	>4040,1273,229,>10
	.word	>4640,1277,266,>30
	.word	>4040,1279,486,>A
	.word	>3C40,1290,443,>12
	.word	>4040,1298,268,>10
	.word	>3F40,1303,464,>2C
	.word	>4040,1307,486,>A
	.word	>3C40,1321,227,>0
	.word	>4050,1323,250,>8
	.word	>4040,1324,472,>4
	.word	>4040,1326,443,>12
	.word	>4040,1335,486,>A
	.word	>4040,1338,268,>10
	.word	>4040,1345,268,>10
	.word	>4240,1352,460,>28
	.word	>3F40,1362,443,>12
	.word	>4040,1363,486,>A
	.word	>4040,1391,486,>A
	.word	>4050,1392,322,>2
	.word	>4140,1393,266,>0
	.word	>4050,1395,293,>8
	.word	>4050,1398,464,>C
	.word	>4040,1398,472,>4
	.word	>4040,1403,378,>6
	.word	>4040,1404,361,>E
	.word	0FFFFH		;End Marker
tenBMOD:
	.word	449,298,100	;x size, y size, #blocks
	.long	tenBLKS, ISCHDRS, ISCPALS

SEHDRS:
	.word	20,164	;x size, y size
	.long	>2823D40	;address
	.word	20,90
	.long	>282A3C0
	.word	160,15
	.long	>282DC00
	.word	80,16
	.long	>2832700
	.word	68,45
	.long	>2834F00
	.word	16,15
	.long	>2AA35C0
	.word	12,15
	.long	>2AA3D40
	.word	16,15
	.long	>2AA42E0
	.word	12,15
	.long	>2AA4A60
	.word	12,15
	.long	>2AA5000
	.word	12,15
	.long	>2AA55A0
	.word	12,15
	.long	>2AA5B40
	.word	12,15
	.long	>2AA60E0
	.word	16,15
	.long	>2AA6680
	.word	12,15
	.long	>2AA6E00
	.word	36,15
	.long	>2AA73A0
	.word	12,15
	.long	>2AA8480
	.word	12,15
	.long	>2AA8A20
	.word	12,15
	.long	>2AA8FC0
	.word	4,15
	.long	>2AA9560
	.word	4,15
	.long	>2AA9740
	.word	12,15
	.long	>2AA9920
	.word	16,15
	.long	>2AA9EC0
	.word	12,15
	.long	>2AAA640
	.word	16,15
	.long	>2AAABE0
	.word	12,15
	.long	>2AAB360
	.word	16,15
	.long	>2AAB900
	.word	12,15
	.long	>2AAC080
	.word	16,17
	.long	>2AAC620
	.word	12,15
	.long	>2AACEA0
	.word	12,15
	.long	>2AAD440
	.word	20,16
	.long	>2AAD9E0
	.word	16,15
	.long	>2AAE3E0
	.word	12,15
	.long	>2AAEB60
	.word	12,15
	.long	>2AAF100
	.word	12,15
	.long	>2AAF6A0
	.word	80,153
	.long	>2AAFC40
	.word	60,101
	.long	>2AC7AC0
	.word	68,48
	.long	>2AD3820


BONUSIIBLKS:
	.word	>4040	;flags
	.word	0,0 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,2,166,>2
	.word	>4040,18,149,>4
	.word	>4040,19,166,>2
	.word	>4040,20,0,>6
	.word	>4040,36,166,>2
	.word	>4040,39,214,>8
	.word	>4040,53,166,>2
	.word	>4040,70,166,>2
	.word	>4040,87,166,>2
	.word	>4040,95,0,>6
	.word	>4040,104,166,>2
	.word	>4050,105,214,>8
	.word	>4040,121,166,>2
	.word	>4042,133,62,>A
	.word	>4042,134,84,>C
	.word	>4042,134,107,>E
	.word	>4042,135,41,>10
	.word	>4042,136,19,>12
	.word	>4040,138,166,>2
	.word	>4040,153,0,>6
	.word	>4040,154,166,>2
	.word	>4042,158,41,>14
	.word	>4042,158,62,>16
	.word	>4042,158,84,>18
	.word	>4042,158,107,>1A
	.word	>4042,158,19,>1C
	.word	>4040,171,166,>2
	.word	>4040,177,149,>1E
	.word	>4042,179,19,>20
	.word	>4042,180,62,>22
	.word	>4042,180,84,>24
	.word	>4042,184,41,>26
	.word	>4042,184,107,>28
	.word	>4040,187,166,>2
	.word	>4040,197,166,>2
	.word	>4042,200,19,>2A
	.word	>4042,200,84,>2C
	.word	>4042,201,41,>2E
	.word	>4042,201,107,>30
	.word	>4042,202,62,>32
	.word	>4050,213,149,>4
	.word	>4040,214,166,>2
	.word	>4040,216,0,>6
	.word	>4042,220,84,>34
	.word	>4042,221,41,>36
	.word	>4042,221,62,>38
	.word	>4040,221,214,>8
	.word	>4042,222,19,>3A
	.word	>4042,223,107,>3C
	.word	>4040,231,166,>2
	.word	>4042,238,106,>3E
	.word	>4042,241,84,>40
	.word	>4042,243,19,>42
	.word	>4042,243,41,>44
	.word	>4042,243,62,>46
	.word	>4040,248,166,>2
	.word	>4040,265,166,>2
	.word	>4040,282,166,>2
	.word	>4050,287,214,>8
	.word	>4040,291,0,>6
	.word	>4040,299,166,>2
	.word	>4040,315,166,>2
	.word	>4040,332,166,>2
	.word	>4040,349,166,>2
	.word	>4040,365,166,>2
	.word	>4050,371,0,>0
	.word	>4040,373,166,>2
	.word	0FFFFH	;End Marker

GRATSBLKS:
	.word	>4040	;flags
	.word	0,151 ;x,y
	.word	>1E	;pal5,pal4,hdr13-0
	.word	>4040,2,166,>2
	.word	>4141,4,0,>48
	.word	>4040,19,166,>2
	.word	>4141,33,153,>4A
	.word	>4040,36,166,>2
	.word	>4040,36,151,>4
	.word	>4040,53,166,>2
	.word	>4141,68,27,>4C
	.word	>4040,70,166,>2
	.word	>4040,87,166,>2
	.word	>4040,104,166,>2
	.word	>4040,121,166,>2
	.word	>4040,138,166,>2
	.word	>4040,155,166,>2
	.word	>4040,171,166,>2
	.word	>4040,188,166,>2
	.word	>4040,194,151,>1E
	.word	>4040,204,166,>2
	.word	>4040,214,166,>2
	.word	>4050,229,151,>4
	.word	>4040,231,166,>2
	.word	>4040,248,166,>2
	.word	>4040,265,166,>2
	.word	>4040,282,166,>2
	.word	>4040,299,166,>2
	.word	>4040,316,166,>2
	.word	>4040,332,166,>2
	.word	>4040,349,166,>2
	.word	>4040,366,166,>2
	.word	>4040,382,166,>2
	.word	>4040,385,151,>1E
	.word	>4040,390,166,>2
	.word	>4040,406,166,>2
	.word	0FFFFH	;End Marker

SEMOD0BLKS:
	.word	>4040	;flags
	.word	1356,41 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,1358,207,>2
	.word	>4040,1373,190,>4
	.word	>4040,1375,207,>2
	.word	>4040,1376,41,>6
	.word	>4040,1383,255,>8
	.word	>4040,1392,207,>2
	.word	>4040,1409,207,>2
	.word	>4040,1426,207,>2
	.word	>4040,1443,207,>2
	.word	>4050,1449,255,>8
	.word	>4040,1451,41,>6
	.word	>4040,1460,207,>2
	.word	>4040,1477,207,>2
	.word	>4040,1494,207,>2
	.word	>4040,1527,207,>2
	.word	>4040,1533,207,>2
	.word	>4040,1553,207,>2
	.word	>4040,1570,207,>2
	.word	>4040,1572,41,>6
	.word	>4040,1584,255,>8
	.word	>4040,1587,207,>2
	.word	>4040,1604,207,>2
	.word	>4040,1621,207,>2
	.word	>4040,1638,207,>2
	.word	>4040,1647,41,>6
	.word	>4050,1650,255,>8
	.word	>4040,1655,207,>2
	.word	>4040,1671,207,>2
	.word	>4040,1688,207,>2
	.word	>4040,1705,207,>2
	.word	>4050,1727,41,>0
	.word	>4040,1729,207,>2
	.word	0FFFFH		;End Marker
BONUSIIBMOD:
	.word	393,259,68	;x size, y size, #blocks
	.long	BONUSIIBLKS, SEHDRS, SEPALS
GRATSBMOD:
	.word	426,256,34	;x size, y size, #blocks
	.long	GRATSBLKS, SEHDRS, SEPALS

rtHDRS:
	.word	40,33	;x size, y size
	.long	>2A5E340	;address
	.word	20,38
	.long	>2A4F2E0
	.word	16,31
	.long	>2A594C0
	.word	48,15
	.long	>2A5CCC0
	.word	28,39
	.long	>2A5A440
	.word	68,37
	.long	>2650600
	.word	8,15
	.long	>2AD9E20
	.word	8,3
	.long	>2ADA1E0
	.word	12,15
	.long	>2AA60E0
	.word	12,15
	.long	>2AA8A20
	.word	12,15
	.long	>2ADA2A0
	.word	12,15
	.long	>2AA3D40
	.word	12,15
	.long	>2AA8A20
	.word	12,15
	.long	>2AA5000
	.word	12,15
	.long	>2AA8A20
	.word	12,15
	.long	>2AA60E0
	.word	16,15
	.long	>2AA35C0
	.word	12,15
	.long	>2AA8FC0
	.word	12,15
	.long	>2AA8A20
	.word	12,15
	.long	>2AAF6A0
	.word	12,15
	.long	>2AA60E0
	.word	12,15
	.long	>2AA8480
	.word	12,15
	.long	>2AA9920
	.word	12,15
	.long	>2AA3D40
	.word	12,15
	.long	>2ADA840
	.word	12,15
	.long	>2AA55A0
	.word	12,15
	.long	>2AA5000
	.word	12,15
	.long	>2AACEA0
	.word	16,15
	.long	>2ADADE0
	.word	12,15
	.long	>2AA55A0
	.word	12,15
	.long	>2AACEA0
	.word	12,15
	.long	>2AAF100
	.word	12,15
	.long	>2AA55A0
	.word	12,15
	.long	>2AAF6A0
	.word	16,15
	.long	>2ADB560
	.word	12,15
	.long	>2AA5B40
	.word	4,15
	.long	>2AA9560
	.word	12,15
	.long	>2AAF100
	.word	12,15
	.long	>2AAF6A0
	.word	12,15
	.long	>2AA60E0
	.word	16,15
	.long	>2AA42E0
	.word	12,15
	.long	>2AA60E0
	.word	12,15
	.long	>2AA60E0
	.word	12,15
	.long	>2ADBCE0
	.word	4,15
	.long	>2AA9560
	.word	12,15
	.long	>2AA8A20
	.word	16,15
	.long	>2AA9EC0
	.word	12,15
	.long	>2AA8480
	.word	12,15
	.long	>2AA8FC0
	.word	12,15
	.long	>2AA8A20
	.word	12,15
	.long	>2AAF6A0
	.word	12,15
	.long	>2AA8A20


tshirtBLKS:
	.word	>4041	;flags
	.word	0,224 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4051,1,31,>2
	.word	>4071,1,187,>2
	.word	>4041,3,48,>4
	.word	>4041,3,78,>4
	.word	>4041,3,108,>4
	.word	>4041,3,138,>4
	.word	>4041,3,168,>4
	.word	>4061,4,0,>0
	.word	>4041,10,33,>6
	.word	>4061,15,208,>6
	.word	>4041,18,134,>8
	.word	>4041,18,97,>8
	.word	>4041,18,45,>8
	.word	>4041,18,61,>8
	.word	>4041,19,171,>8
	.word	>4640,21,48,>A
	.word	>4140,21,85,>A
	.word	>4140,23,126,>A
	.word	>4140,24,167,>A
	.word	>4041,36,224,>0
	.word	>4061,40,0,>0
	.word	>4041,41,45,>8
	.word	>4041,46,134,>8
	.word	>4041,46,97,>8
	.word	>4041,46,62,>8
	.word	>4041,47,171,>8
	.word	>4061,48,208,>6
	.word	>3F41,51,33,>6
	.word	>4041,68,171,>8
	.word	>4041,69,134,>8
	.word	>4041,69,97,>8
	.word	>4141,69,60,>8
	.word	>4041,69,45,>8
	.word	>4041,72,224,>0
	.word	>4061,73,0,>0
	.word	>3C41,91,127,>6
	.word	>4041,93,31,>2
	.word	>4061,93,187,>2
	.word	>4051,95,160,>4
	.word	>4051,95,131,>4
	.word	>4051,95,101,>4
	.word	>4051,95,71,>4
	.word	>4051,95,61,>4
	.word	>3C51,97,112,>6
	.word	>4051,123,14,>2
	.word	>4171,123,206,>2
	.word	>4041,125,49,>4
	.word	>4041,125,79,>4
	.word	>4041,125,108,>4
	.word	>4041,125,138,>4
	.word	>4041,125,168,>4
	.word	>4041,125,184,>4
	.word	>4061,130,227,>6
	.word	>4041,134,16,>6
	.word	>4042,147,66,>C
	.word	>4042,147,89,>E
	.word	>4042,153,114,>10
	.word	>4042,154,89,>E
	.word	>4042,157,72,>E
	.word	>4042,161,89,>E
	.word	>4042,166,114,>12
	.word	>4042,167,66,>14
	.word	>4042,168,89,>E
	.word	>4061,172,227,>6
	.word	>4041,175,16,>6
	.word	>4042,175,89,>E
	.word	>4042,178,169,>16
	.word	>4042,182,66,>18
	.word	>4042,182,142,>1A
	.word	>4042,182,89,>E
	.word	>4042,189,89,>E
	.word	>4042,191,114,>1C
	.word	>4042,192,197,>1E
	.word	>4042,193,169,>20
	.word	>4042,196,142,>22
	.word	>4042,196,89,>E
	.word	>4042,197,66,>24
	.word	>4042,203,89,>E
	.word	>4042,205,114,>26
	.word	>4042,206,203,>E
	.word	>4042,209,142,>28
	.word	>4042,210,89,>E
	.word	>4042,211,37,>2A
	.word	>4042,212,169,>1A
	.word	>4042,212,72,>E
	.word	>4061,214,227,>6
	.word	>4041,216,16,>6
	.word	>4042,217,89,>E
	.word	>4042,219,114,>2C
	.word	>4042,220,197,>2E
	.word	>4042,221,66,>30
	.word	>4042,223,142,>32
	.word	>4042,224,89,>E
	.word	>4042,225,37,>34
	.word	>4042,226,169,>16
	.word	>4042,230,89,>E
	.word	>4042,234,114,>36
	.word	>4042,235,66,>38
	.word	>4042,236,197,>3A
	.word	>4042,237,89,>E
	.word	>4042,238,142,>3C
	.word	>4042,241,37,>3E
	.word	>4042,241,169,>40
	.word	>4042,244,89,>E
	.word	>4042,248,114,>42
	.word	>4042,250,66,>44
	.word	>4042,251,89,>E
	.word	>4042,252,142,>46
	.word	>4042,252,197,>48
	.word	>4042,255,37,>4A
	.word	>4061,256,227,>6
	.word	>4041,257,16,>6
	.word	>4042,258,89,>E
	.word	>4042,259,197,>4C
	.word	>4042,265,89,>E
	.word	>4042,266,72,>E
	.word	>4042,266,142,>4E
	.word	>4042,269,114,>50
	.word	>4042,272,89,>E
	.word	>4042,273,197,>52
	.word	>4042,274,169,>54
	.word	>4042,278,66,>56
	.word	>4042,279,89,>E
	.word	>4042,280,142,>58
	.word	>4042,285,114,>5A
	.word	>4042,286,89,>E
	.word	>4042,287,169,>5C
	.word	>4042,287,142,>5E
	.word	>4042,293,89,>E
	.word	>4042,293,66,>30
	.word	>4061,298,227,>6
	.word	>4041,299,16,>6
	.word	>4042,300,114,>60
	.word	>4042,300,89,>E
	.word	>4042,307,89,>E
	.word	>4042,308,66,>62
	.word	>4042,314,89,>E
	.word	>4042,315,114,>64
	.word	>4042,321,89,>E
	.word	>4042,323,66,>66
	.word	>4042,327,89,>E
	.word	>4141,338,14,>2
	.word	>4161,338,206,>2
	.word	>4051,340,182,>4
	.word	>4051,340,167,>4
	.word	>4051,340,137,>4
	.word	>4051,340,109,>4
	.word	>4051,340,79,>4
	.word	>3F51,340,49,>4
	.word	0FFFFH	;End Marker

rtMOD0BLKS:
	.word	0FFFFH		;End Marker
tshirtBMOD:
	.word	358,257,150	;x size, y size, #blocks
	.long	tshirtBLKS, rtHDRS, rtPALS
