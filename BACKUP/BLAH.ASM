	.include offend.h	

	.globl	TVPATCH,TVPATCHX
	.globl	TVBP,TVBPX
	.ref	HalfSwap

	.text
	.even
OLDINTEN:	.word	0

TVBP:
	mmtm	SP,A0

	move	@HalfSwap,A0,W
	jrnz	SkChngPg
	move	@PAGE,A0,W
	jrne	ShowPg0
	;*** MAY BE PLOTTING PAGE 0, so let's see page 1
	movi	DPYSTRT1,A0	;DISPLAY PAGE 1	next frame
	jruc	GotPg
ShowPg0:
	movi	DPYSTRT0,A0	;DISPLAY PAGE 0	next frame
GotPg:
	move	A0,@DPYSTRT,W
SkChngPg:

	MOVE	@INTENB,A0,W	;DISABLE ROM PROTECT INTERRUPT (ext2)
	move	A0,@OLDINTEN,W
	ANDNI	X2E,A0
;	ORI	DIE,A0
	MOVE	A0,@INTENB,W

	mmfm	SP,A0
	rets

TVBPX:
	mmtm	SP,A0

	MOVE	@INTENB,A0,W	;ENABLE ROM PROTECT INTERRUPT (ext2)
;	move	@OLDINTEN,A0,W
	ORI	X2E,A0
	MOVE	A0,@INTENB,W

	MOVE	@INTPEND,A0,W	;Clear any pending X2E
	ANDNI	X2E,A0
	ANDNI	DIE,A0
	MOVE	A0,@INTPEND,W

	mmfm	SP,A0
	rets


TVPATCH:
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
TVPATCHX:
