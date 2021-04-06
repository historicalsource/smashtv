	.INCLUDE	"\VIDEO\sys\gsp.inc"
	
	.globl	TVPATCH,TVPATCHX
	.globl	TVBP,TVBPX
	.globl	SAVESCR

;	.BSS	OLDAUTOE,16,1
;	.BSS	OLDDSPON,16,1

	.ref	SYNCHALF,AUTOEOFF,DMAQWAIT
	.ref	NOAUTOE,DISPLAYON

	.text
	.even
OLDAUTOE:	.word	0
OLDDSPON:	.word	1
OLDINTEN:	.word	0
SAVESCR:	.word	0


TVBP:
	mmtm	SP,A0

	MOVE	@INTENB,A0,0	;DISABLE ROM PROTECT INTERRUPT (ext2)
	move	A0,@OLDINTEN,0
	ANDNI	X2E,A0
	ORI	DIE,A0
	MOVE	A0,@INTENB,0

	MOVE	@SAVESCR,A0,0
	jrz	SkSave
	PUSHST
	EINT
	CALLA	SYNCHALF
	MOVE	@NOAUTOE,@OLDAUTOE,0
	MOVK	1,A0
	MOVE	A0,@NOAUTOE,0
	CALLA 	AUTOEOFF		;SHUT OFF AUTO-ERASE
	MOVE	@DISPLAYON,@OLDDSPON,0
	CLR	A0
	MOVE	A0,@DISPLAYON,0
	CALLA	DMAQWAIT		;BLOW OUT THE QUEUE'D IMAGES
	POPST
SkSave:

	mmfm	SP,A0
	rets

TVBPX:
	mmtm	SP,A0

	MOVE	@SAVESCR,A0,0
	jrz	SkUnSave
	MOVE	@OLDAUTOE,@NOAUTOE,0
	MOVE	@OLDDSPON,@DISPLAYON,0
SkUnSave:

;	MOVE	@INTENB,A0,0	;ENABLE ROM PROTECT INTERRUPT (ext2)
	move	@OLDINTEN,A0,0
	ORI	X2E,A0
	MOVE	A0,@INTENB,0

	MOVE	@INTPEND,A0,0	;Clear any pending X2E
	ANDNI	X2E,A0
	ANDNI	DIE,A0
	MOVE	A0,@INTPEND,0

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