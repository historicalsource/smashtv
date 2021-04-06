     	.FILE	'DEMO.ASM'
	.TITLE	'ROBO-RAMA GAME PROGRAM-DEMO MODE STUFF'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

;
; INITIATED:		 APRIL 13,1989
; MODIFIED:		 !
; SOFTWARE:		 MARK TURMELL
;
; COPYRIGHT (C) 1989 WILLIAMS ELECTRONICS GAMES, INC.
;
;
; GET THE SYSTEM STUFF

	.INCLUDE	"MPROC.EQU"		;MPROC EQUATES
	.INCLUDE	"DISP.EQU"		;DISPLAY PROC. EQUATES
	.INCLUDE	"\VIDEO\SYS\SYS.INC"	;Z UNIT SYSTEM EQUATES
	.INCLUDE	"\VIDEO\SYS\MACROS.HDR"	;MACROS DEFINITIONS
	.INCLUDE	"IMGTBL.GLO"
	.INCLUDE	"ROBO.EQU"
	.INCLUDE	"BGNDTBL.GLO"		;BACKGROUND EQUATES

;
;SOUNDS
;
	.REF	TUNE1,FADE_UP,CROWD1,GOGO,TUNE1B,TUNE4

;
;SYMBOLS EXTERNALLY DEFINED
;
	.REF	SCRCLR,WNDWON,WNDWOFF,BTOF,FINDPAL,PALSET
	.REF	GAL1P,GAL2P,MCPTR,FRANIM,SMASHON
	.REF	INIT_SCORE,RD15FONT,STRCNRM,WAVE
	.REF	P1CTRL,P2CTRL,GAMSTATE,BAKMODS,ADJSTWTL,STFOBJ,GPALOBJ,INSOBJ
	.REF	BGND_UD1,KILALL,JOYSW
	.REF	HALT,BAKMODS,DEMOPLAY,CIRCUIT
	.REF	AUTOEON,GAMERASE
	.REF	BLAKOUT,FADEIN,FADEOUT
	.REF	AUTOPAL
;
;SYMBOLS DEFINED IN THIS FILE
;
;	.DEF	FBI_LIT
	.DEF	SPR_LIT,SPR_LIT1,GOS,GAMEMODS
	.DEF	INIT_DEMO,JOY_UPDATE,PUTBGND,DEMOBGND,DUMB,AP_LIT,LAZ_LIT
	.DEF	CMP_LIT,MIN_LIT,RNG_LIT,RNG_LIT2,RED1,RED2,FLR_LIT,STUD_LIT
	.DEF	PZON,PRZ_LIT,ORB_LIT,FLR2_LIT,P2_LIT,P1_LIT,ARW_LIT
	.DEF	HOSPG_LIT,STATIC_LIT,HOSPR_LIT,COLTAB
;
;UNINITIALIZED RAM DEFINITIONS
;
	.BSS	TMP,8
	.BSS	PZON,8
	.BSS	DUMB,8
	.BSS	PFRAM,96
;
;EQUATES FOR THIS FILE
;
BLSTEND 	.EQU	>8001
BLSTSTRT	.EQU	>8000
	.TEXT
DOIMG
	CALLA	GPALOBJ			;ALLOCATE A COLOR PALETTE 
	CALLA	STFOBJ			;STUFF OBJECT DATA
	MOVE	A13,*A0(OPLINK),L
	CALLA	INSOBJ			;INSERT OBJECT INTO LIST
	MOVE	A0,A8
	MOVE	A11,*A8(OYPOS),W
	MOVE	A10,*A8(OXPOS),W
	CALLA	ADJSTWTL
	RETS
STAR_COLOR
	 SLEEP	3	;GET PAL OUT THERE!
;BLACKEN LIGHTS TO START!
	 MOVI	LGHTFX,a0
         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	 JAEQ	SUCIDE

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	 ADDK	13,A8                 ; A8 = [PAL #,1]
	 MOVI    BLKC,A9

	 MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    1,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
	 SLEEP	027H
;START CROWD
;START MUSIC FOR GAMESHOW SET
	MOVK	2,A11		;FADE RATE
	CREATE	0,FADE_UP
	MOVE	@CIRCUIT,A0
	JRZ	NOGO
	CMPI	1,A0
	JRNZ	J8
	MOVI	TUNE1B,A0
	CALLA	ONESND
	JRUC	J88
J8	MOVI	TUNE4,A0	;CIRCUIT 3 MUSIC
	CALLA	ONESND
J88	CREATE	0,GOS
	JRUC	YGO
NOGO 
	MOVI	TUNE1,A0
	CALLA	ONESND
	CREATE	0,CHEER

YGO	SLEEP	30

;NABBED FROM BOON FOOTBALL
	 MOVI	LGHTFX,a0
         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	 JAEQ	SUCIDE

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	 ADDK	13,A8                 ; A8 = [PAL #,1]
         MOVI    STARCTBL,A9

STC2     MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    1,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
         SLEEP   >09
         ADDK    >10,A9
         CMPI    STARCEND,A9          ; END OF TABLE ?
         JRNE    STC2
	DIE
GOS	SLEEP	6AH
	MOVK	11,A9
GOS1	MOVI	GOGO,A0
	CALLA	ONESND
	SLEEP	30
	DSJS	A9,GOS1
	DIE

CHEER	SLEEP	10
	MOVI	CROWD1,A0
	CALLA	ONESND
	SLEEP	25
	MOVI	CROWD1,A0
	CALLA	ONESND
	SLEEP	10
	MOVI	CROWD1,A0
	CALLA	ONESND
	SLEEP	45
	MOVI	CROWD1,A0
	CALLA	ONESND
	SLEEP	10
	MOVI	CROWD1,A0
	CALLA	ONESND
	SLEEP	10
	MOVI	CROWD1,A0
	CALLA	ONESND
	SLEEP	10
	MOVI	CROWD1,A0
	CALLA	ONESND
	SLEEP	45
	MOVI	CROWD1,A0
	CALLA	ONESND
	SLEEP	25
	MOVI	CROWD1,A0
	CALLA	ONESND
	SLEEP	45
	MOVI	CROWD1,A0
	CALLA	ONESND
	DIE


STATIC
      .word   ( 14 *32*32)+( 14 *32)+( 14 )       ; color 48
      .word   (  6 *32*32)+(  6 *32)+(  6 )       ; color 49
      .word   ( 10 *32*32)+(  9 *32)+( 14 )       ; color 50
      .word   ( 19 *32*32)+( 19 *32)+( 27 )       ; color 51
      .word   ( 27 *32*32)+( 23 *32)+( 23 )       ; color 52
      .word   ( 25 *32*32)+( 25 *32)+( 25 )       ; color 53
STATICD
      .word   ( 14 *32*32)+( 14 *32)+( 14 )       ; color 48
      .word   (  6 *32*32)+(  6 *32)+(  6 )       ; color 49
      .word   ( 10 *32*32)+(  9 *32)+( 14 )       ; color 50
      .word   ( 19 *32*32)+( 19 *32)+( 27 )       ; color 51
      .word   ( 27 *32*32)+( 23 *32)+( 23 )       ; color 52
      .word   ( 25 *32*32)+( 25 *32)+( 25 )       ; color 53
;BRAIN
;      .word   (  8 *32*32)+(  8 *32)+( 12 )       ; color 7
;      .word   (  9 *32*32)+(  0 *32)+( 12 )       ; color 8
;      .word   (  7 *32*32)+(  0 *32)+(  9 )       ; color 9
;      .word   (  5 *32*32)+(  0 *32)+(  7 )       ; color 10
;      .word   (  1 *32*32)+(  0 *32)+(  5 )       ; color 11
;BRAIND
;      .word   (  8 *32*32)+(  8 *32)+( 12 )       ; color 7
;      .word   (  9 *32*32)+(  0 *32)+( 12 )       ; color 8
;      .word   (  7 *32*32)+(  0 *32)+(  9 )       ; color 9
;      .word   (  5 *32*32)+(  0 *32)+(  7 )       ; color 10
;      .word   (  1 *32*32)+(  0 *32)+(  5 )       ; color 11
HOSPR
      .word   (  0 *32*32)+( 29 *32)+(  0 )       ; color 58
      .word   (  0 *32*32)+( 16 *32)+(  0 )       ; color 57
      .word   (  0 *32*32)+( 11 *32)+(  0 )       ; color 56
      .word   (  0 *32*32)+(  7 *32)+(  0 )       ; color 55
      .word   (  0 *32*32)+(  0 *32)+(  0 )       ; color 54
HOSPRD
      .word   (  0 *32*32)+( 29 *32)+(  0 )       ; color 58
      .word   (  0 *32*32)+( 16 *32)+(  0 )       ; color 57
      .word   (  0 *32*32)+( 11 *32)+(  0 )       ; color 56
      .word   (  0 *32*32)+(  7 *32)+(  0 )       ; color 55
      .word   (  0 *32*32)+(  0 *32)+(  0 )       ; color 54
HOSPG
      .word   ( 31 *32*32)+(  4 *32)+(  0 )       ; color 63
      .word   ( 19 *32*32)+(  2 *32)+(  0 )       ; color 62
      .word   ( 12 *32*32)+(  0 *32)+(  0 )       ; color 61
      .word   (  7 *32*32)+(  0 *32)+(  0 )       ; color 60
      .word   (  0 *32*32)+(  0 *32)+(  0 )       ; color 59
HOSPGD
      .word   ( 31 *32*32)+(  4 *32)+(  0 )       ; color 63
      .word   ( 19 *32*32)+(  2 *32)+(  0 )       ; color 62
      .word   ( 12 *32*32)+(  0 *32)+(  0 )       ; color 61
      .word   (  7 *32*32)+(  0 *32)+(  0 )       ; color 60
      .word   (  0 *32*32)+(  0 *32)+(  0 )       ; color 59

;YELLOWT
;	.word	>7FE6,>6640,>3CE0,>7FE6,>6640	; Cycling Yellow Colors
BLKC	.WORD	0
;FLOOR LIGHTS
STARCTBL
      .word   ( 25 *32*32)+( 14 *32)+(  7 )       ; color 60
      .word   ( 29 *32*32)+( 21 *32)+(  8 )       ; color 59
      .word   ( 31 *32*32)+( 27 *32)+( 10 )       ; color 58
STARCEND
FLITE
      .word   ( 29 *32*32)+( 21 *32)+(  8 )       ; color 59
      .word   ( 25 *32*32)+( 14 *32)+(  7 )       ; color 60
      .word   ( 31 *32*32)+( 27 *32)+( 10 )       ; color 58
FD
      .word   ( 29 *32*32)+( 21 *32)+(  8 )       ; color 59
      .word   ( 25 *32*32)+( 14 *32)+(  7 )       ; color 60
      .word   ( 31 *32*32)+( 27 *32)+( 10 )       ; color 58
;COMPUTER LIGHTS
CLITE
      .word   ( 31 *32*32)+(  5 *32)+(  4 )       ; color 61
      .word   (  4 *32*32)+( 14 *32)+( 30 )       ; color 62
      .word   (  6 *32*32)+( 25 *32)+(  7 )       ; color 63
CLITED
      .word   ( 31 *32*32)+(  5 *32)+(  4 )       ; color 61
      .word   (  4 *32*32)+( 14 *32)+( 30 )       ; color 62
      .word   (  6 *32*32)+( 25 *32)+(  7 )       ; color 63
RRED
      .word   ( 29 *32*32)+(  0 *32)+(  0 )       ; color 63
      .word   (  0 *32*32)+(  0 *32)+(  0 )       ; color 62
      .word   (  0 *32*32)+(  0 *32)+(  0 )       ; color 62
MLIT
      .word   (  0 *32*32)+(  0 *32)+(  0 )       ; color 62
      .word   ( 29 *32*32)+(  0 *32)+(  0 )       ; color 63
MLITD
      .word   (  0 *32*32)+(  0 *32)+(  0 )       ; color 62
      .word   ( 29 *32*32)+(  0 *32)+(  0 )       ; color 63
RLIT
      .word   ( 17 *32*32)+( 30 *32)+(  4 )       ; color 27
      .word   (  7 *32*32)+( 18 *32)+(  6 )       ; color 28
      .word   (  0 *32*32)+( 13 *32)+(  0 )       ; color 29
RLITD
      .word   ( 17 *32*32)+( 30 *32)+(  4 )       ; color 27
      .word   (  7 *32*32)+( 18 *32)+(  6 )       ; color 28
      .word   (  0 *32*32)+( 13 *32)+(  0 )       ; color 29
OLITE:
      .word   (  0 *32*32)+(  0 *32)+( 31 )       ; color 1
      .word   (  0 *32*32)+(  1 *32)+( 21 )       ; color 2
      .word   (  0 *32*32)+(  0 *32)+( 10 )       ; color 3
      .word   (  31 *32*32)+( 31 *32)+(  31 )       ; color 4
      .word   (  0 *32*32)+( 17 *32)+(  0 )       ; color 5
      .word   (  0 *32*32)+(  7 *32)+(  0 )       ; color 6
      .word   ( 31 *32*32)+(  31 *32)+(  31 )       ; color 7
OD:
      .word   (  0 *32*32)+(  0 *32)+( 31 )       ; color 1
      .word   (  0 *32*32)+(  1 *32)+( 21 )       ; color 2
      .word   (  0 *32*32)+(  0 *32)+( 10 )       ; color 3
      .word   (  31 *32*32)+( 31 *32)+(  31 )       ; color 4
      .word   (  0 *32*32)+( 17 *32)+(  0 )       ; color 5
      .word   (  0 *32*32)+(  7 *32)+(  0 )       ; color 6
      .word   ( 31 *32*32)+(  0 *32)+(  0 )       ; color 7

APLIT	;APPLAUSE LIGHT
      .word   ( 31 *32*32)+(  0 *32)+(  0 )       ; color 62
      .word   ( 21 *32*32)+(  0 *32)+(  0 )       ; color 63
APD
      .word   ( 31 *32*32)+(  0 *32)+(  0 )       ; color 62
      .word   ( 21 *32*32)+(  0 *32)+(  0 )       ; color 63
P1LIT
      .word   ( 11 *32*32)+(  0 *32)+( 11 )       ; color 1
      .word   ( 17 *32*32)+(  0 *32)+( 17 )       ; color 2
      .word   ( 21 *32*32)+(  5 *32)+( 23 )       ; color 3
      .word   ( 31 *32*32)+(  8 *32)+( 26 )       ; color 4
P1D:
      .word   ( 11 *32*32)+(  0 *32)+( 11 )       ; color 1
      .word   ( 17 *32*32)+(  0 *32)+( 17 )       ; color 2
      .word   ( 21 *32*32)+(  5 *32)+( 23 )       ; color 3
      .word   ( 31 *32*32)+(  8 *32)+( 26 )       ; color 4
P2LIT
      .word   (  3 *32*32)+(  9 *32)+(  4 )       ; color 1
      .word   (  0 *32*32)+( 18 *32)+(  5 )       ; color 2
      .word   (  0 *32*32)+( 26 *32)+( 11 )       ; color 3
      .word   (  1 *32*32)+( 31 *32)+( 21 )       ; color 4
P2D:
      .word   (  3 *32*32)+(  9 *32)+(  4 )       ; color 1
      .word   (  0 *32*32)+( 18 *32)+(  5 )       ; color 2
      .word   (  0 *32*32)+( 26 *32)+( 11 )       ; color 3
      .word   (  1 *32*32)+( 31 *32)+( 21 )       ; color 4


ARW_P
      .word   ( 27 *32*32)+(  0 *32)+(  0 )       ; color 39
      .word   ( 31 *32*32)+( 14 *32)+(  0 )       ; color 40
      .word   ( 31 *32*32)+( 23 *32)+( 10 )       ; color 41
      .word   ( 31 *32*32)+( 28 *32)+( 25 )       ; color 42
ARD
      .word   ( 27 *32*32)+(  0 *32)+(  0 )       ; color 39
      .word   ( 31 *32*32)+( 14 *32)+(  0 )       ; color 40
      .word   ( 31 *32*32)+( 23 *32)+( 10 )       ; color 41
      .word   ( 31 *32*32)+( 28 *32)+( 25 )       ; color 42
;TITCLR
;      .word   ( 18 *32*32)+( 12 *32)+(  0 )       ; color 41
;      .word   ( 20 *32*32)+( 16 *32)+(  0 )       ; color 42
;      .word   ( 23 *32*32)+( 18 *32)+(  0 )       ; color 43
;      .word   ( 26 *32*32)+( 20 *32)+(  0 )       ; color 44
;      .word   ( 28 *32*32)+( 23 *32)+(  0 )       ; color 45
;      .word   ( 31 *32*32)+( 28 *32)+(  0 )       ; color 46
;      .word   ( 31 *32*32)+( 31 *32)+( 11 )       ; color 47
;      .word   ( 31 *32*32)+( 31 *32)+( 14 )       ; color 48
;      .word   ( 31 *32*32)+( 31 *32)+( 26 )       ; color 49
;      .word   ( 18 *32*32)+( 12 *32)+(  0 )       ; color 50
;      .word   ( 18 *32*32)+( 12 *32)+(  0 )       ; color 51
;      .word   ( 18 *32*32)+( 12 *32)+(  0 )       ; color 52
;      .word   ( 18 *32*32)+( 12 *32)+(  0 )       ; color 53
;      .word   ( 18 *32*32)+( 12 *32)+(  0 )       ; color 54
;      .word   ( 18 *32*32)+( 12 *32)+(  0 )       ; color 55
;TITD
;      .word   ( 18 *32*32)+( 12 *32)+(  0 )       ; color 41
;      .word   ( 20 *32*32)+( 16 *32)+(  0 )       ; color 42
;      .word   ( 23 *32*32)+( 18 *32)+(  0 )       ; color 43
;      .word   ( 26 *32*32)+( 20 *32)+(  0 )       ; color 44
;      .word   ( 28 *32*32)+( 23 *32)+(  0 )       ; color 45
;      .word   ( 31 *32*32)+( 28 *32)+(  0 )       ; color 46
;      .word   ( 31 *32*32)+( 31 *32)+( 11 )       ; color 47
;      .word   ( 31 *32*32)+( 31 *32)+( 14 )       ; color 48
;      .word   ( 31 *32*32)+( 31 *32)+( 26 )       ; color 49
;      .word   ( 18 *32*32)+( 12 *32)+(  0 )       ; color 50
;      .word   ( 18 *32*32)+( 12 *32)+(  0 )       ; color 51
;      .word   ( 18 *32*32)+( 12 *32)+(  0 )       ; color 52
;      .word   ( 18 *32*32)+( 12 *32)+(  0 )       ; color 53
;      .word   ( 18 *32*32)+( 12 *32)+(  0 )       ; color 54
;      .word   ( 18 *32*32)+( 12 *32)+(  0 )       ; color 55

COLTAB	.WORD	0380H,1380H,2380H,3380H,4380H,5380H,6380H,7380H,7300H
	.WORD	7280H,7200H,7180H,7080H,7008H,7008H,7010H,7010H,701CH
	.WORD	701CH,601CH,501CH,409CH,309CH,209CH,219CH,029CH,039CH
	.WORD	139CH,239CH,339CH,539CH,739CH,7390H,7380H,6380H,4380H
COLEND	.WORD	0F000H,1380H,2380H,3380H,4380H,5380H,6380H,7380H,7300H
	.WORD	7280H,7200H,7180H,7080H,7008H,7008H,7010H,7010H,701CH
	.WORD	701CH,601CH,501CH,409CH,309CH,209CH,219CH,029CH,039CH
	.WORD	139CH,239CH,339CH,539CH,739CH,7390H,7380H,6380H,4380H

SPR_LIT1	SLEEP	3		;SPEAR CYCLE
SPR_LIT		;SPEAR CYCLE
;	MOVI	FBIP,a0
	MOVE	A9,A0
;A0=SNKGP, OR SPL
         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	JAEQ	SPR_LIT1

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	ADDI	36,A8                 ; A8 = [PAL #,1]
	MOVI    COLTAB,A9

XZT    MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    1,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
         SLEEP   >6
         ADDK    >10,A9
         CMPI    COLEND,A9          ; END OF TABLE ?
         JRNE    XZT
         MOVI    COLTAB,A9          ; YES --> BEGINNING OF TABLE
         JRUC    XZT

;FBI_LIT
;	MOVI	FBIP,a0
;         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
;	JAEQ	SUCIDE
;
;	 SRL     8,A0
;         SLL     8,A0
;         MOVE    A0,A8                ; A8 = [PAL #,0]
;	ADDI	1,A8                 ; A8 = [PAL #,1]
;	MOVI    TITCLR,A9
;	MOVI    ARW_P,A9
;
;ZT    MOVE    A8,A1
;         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
;         MOVI    1,A2                 ; A2 = COLOR COUNT
;         CALLA   PALSET               ; DO THE TRANSFER
;         SLEEP   >4
;         ADDK    >10,A9
;         CMPI    TITD,A9          ; END OF TABLE ?
;         CMPI    ARD,A9          ; END OF TABLE ?
;         JRNE    ZT
;	MOVI    ARW_P,A9
;         MOVI    TITCLR,A9          ; YES --> BEGINNING OF TABLE
;         JRUC    ZT

;BRAIN
;STATIC ONLY ON CORRECT ARENAS!
;BRN_LIT
;	MOVE	A10,A0
;	CALLA	PRCSLP
;	MOVE	A9,A0
;	MOVI	YBG,A0
;         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
;	JAEQ	SUCIDE
;
;	 SRL     8,A0
;         SLL     8,A0
;         MOVE    A0,A8                ; A8 = [PAL #,0]
;	ADDI	7,A8                 ; A8 = [PAL #,1]
;	MOVI    BRAIN,A9
;
;CZZ     MOVE    A8,A1
;         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
;         MOVI    5,A2                 ; A2 = COLOR COUNT
;         CALLA   PALSET               ; DO THE TRANSFER
;         SLEEP   >04
;         ADDK    >10,A9
;         CMPI    BRAIND,A9          ; END OF TABLE ?
;         JRNE    CZZ
;         MOVI    BRAIN,A9          ; YES --> BEGINNING OF TABLE
;         JRUC    CZZ

;STATIC
;STATIC ONLY ON CORRECT ARENAS!
STATIC_LIT
;A9=RBTP5 OR RBTP
	MOVE	A9,A0
         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	JAEQ	SUCIDE

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	ADDI	49,A8                 ; A8 = [PAL #,1]
	MOVI    STATIC,A9

STCZZ     MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    5,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
         SLEEP   >02
         ADDK    >10,A9
         CMPI    STATICD,A9          ; END OF TABLE ?
         JRNE    STCZZ
         MOVI    STATIC,A9          ; YES --> BEGINNING OF TABLE
         JRUC    STCZZ

;HOSPITAL MONITOR GREEN
;STATIC ONLY ON CORRECT ARENAS!
HOSPG_LIT
	MOVE	A9,A0
;A0=RBTP5 OR RBTP ETC
         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	JAEQ	SUCIDE

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	ADDI	54,A8                 ; A8 = [PAL #,1]
	MOVI    HOSPR,A9

STCZZZ    MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    5,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
         SLEEP   >08
         ADDK    >10,A9
         CMPI    HOSPRD,A9          ; END OF TABLE ?
         JRNE    STCZZZ
         MOVI    HOSPR,A9          ; YES --> BEGINNING OF TABLE
         JRUC    STCZZZ

;HOSPITAL MONITOR RED
;STATIC ONLY ON CORRECT ARENAS!
HOSPR_LIT
	MOVE	A9,A0
;A0=RBTP5 OR RBTP ETC
         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	JAEQ	SUCIDE

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	ADDI	59,A8                 ; A8 = [PAL #,1]
	MOVI    HOSPG,A9

STCZZZZ   MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    5,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
         SLEEP   >05
         ADDK    >10,A9
         CMPI    HOSPGD,A9          ; END OF TABLE ?
         JRNE    STCZZZZ
         MOVI    HOSPG,A9          ; YES --> BEGINNING OF TABLE
         JRUC    STCZZZZ



PRZ_LIT
;PRIZE LIGHTS AROUND TV SCREEN
	MOVI	PRZ,A0
	CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	JAEQ	SUCIDE

	MOVI	350,A1
	MOVB	A1,@PZON

	SRL     8,A0
        SLL     8,A0
        MOVE    A0,A8                ; A8 = [PAL #,0]
	ADDI	61,A8                 ; A8 = [PAL #,1]
	MOVI    FLITE,A9
	MOVI	50,A10

OTCZ    MOVE    A8,A1
        MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
        MOVI    3,A2                 ; A2 = COLOR COUNT
        CALLA   PALSET               ; DO THE TRANSFER
        SLEEP   >05
        ADDK    >10,A9
        CMPI    FD,A9          ; END OF TABLE ?
        JRNE    OTCZ
        MOVI    FLITE,A9          ; YES --> BEGINNING OF TABLE

	MOVB	@PZON,A0
	DEC	A0
	JRNZ	OTCZ
	MOVB	A0,@PZON
	DIE

;FLOOR LIGHTS
FLR_LIT
	MOVI	SETCOL,a0
         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	JAEQ	SUCIDE

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	ADDI	58,A8                 ; A8 = [PAL #,1]
	MOVI    FLITE,A9

STCZ     MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    3,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
         SLEEP   >07
         ADDK    >10,A9
         CMPI    FD,A9          ; END OF TABLE ?
         JRNE    STCZ
         MOVI    FLITE,A9          ; YES --> BEGINNING OF TABLE
         JRUC    STCZ
;LAZER IN HZ WALKWAY
LAZ_LIT
	MOVI	SETCOL,a0
         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	JAEQ	SUCIDE

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	ADDI	58,A8                 ; A8 = [PAL #,1]
	MOVI    FLITE,A9

LTCZ     MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    2,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
         SLEEP   >02
         ADDK    >10,A9
         CMPI    FD,A9          ; END OF TABLE ?
         JRNE    LTCZ
         MOVI    FLITE,A9          ; YES --> BEGINNING OF TABLE
         JRUC    LTCZ

FLR2_LIT
;FLOOR LIGHTS
	MOVI	BONUSP,a0
         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	JAEQ	SUCIDE

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	ADDI	61,A8                 ; A8 = [PAL #,1]
	MOVI    FLITE,A9

CZ     MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    3,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
         SLEEP   >07
         ADDK    >10,A9
         CMPI    FD,A9          ; END OF TABLE ?
         JRNE    CZ
         MOVI    FLITE,A9          ; YES --> BEGINNING OF TABLE
         JRUC    CZ
P1_LIT
;P1 BONUS 
	SLEEP	5
	MOVI	BGPLYR1P,a0
         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	JAEQ	SUCIDE

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	ADDI	60,A8                 ; A8 = [PAL #,1]
	MOVI    P1LIT,A9

XCZZ     MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    4,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
         SLEEP   >08
         ADDK    >10,A9
         CMPI    P1D,A9          ; END OF TABLE ?
         JRNE    XCZZ
         MOVI    P1LIT,A9          ; YES --> BEGINNING OF TABLE
         JRUC    XCZZ
P2_LIT
;P2 BONUS
	SLEEP	5
	MOVI	BGPLYR2P,a0
         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	JAEQ	SUCIDE

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	ADDI	60,A8                 ; A8 = [PAL #,1]
	MOVI    P2LIT,A9

CZX     MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    4,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
         SLEEP   >08
         ADDK    >10,A9
         CMPI    P2D,A9          ; END OF TABLE ?
         JRNE    CZX
         MOVI    P2LIT,A9          ; YES --> BEGINNING OF TABLE
         JRUC    CZX

;ORB COLOR CYCLE
ORB_LIT:
	MOVI	NUORB,a0
         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	JAEQ	SUCIDE

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	ADDI	22,A8                 ; A8 = [PAL #,1]
	MOVI    OLITE,A9

STCO     MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    1,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
         SLEEP   >02
         ADDK    >10,A9
         CMPI    OD,A9          ; END OF TABLE ?
         JRNE    STCO
         MOVI    OLITE,A9          ; YES --> BEGINNING OF TABLE
         JRUC    STCO

;ORB COLOR CYCLE
ARW_LIT:
	MOVI	nup1,a0
         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	JAEQ	SUCIDE

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	ADDI	39,A8                 ; A8 = [PAL #,1]
	MOVI    ARW_P,A9

ATCO     MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    1,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
         SLEEP   >08
         ADDK    >10,A9
         CMPI    ARD,A9          ; END OF TABLE ?
         JRNE    ATCO
         MOVI    ARW_P,A9          ; YES --> BEGINNING OF TABLE
         JRUC    ATCO

;APPLAUSE SIGN
AP_LIT:
	MOVI	MNTR,a0
         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	JAEQ	SUCIDE

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	ADDI	62,A8                 ; A8 = [PAL #,1]
	MOVI    APLIT,A9

ASTCO     MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    1,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
         SLEEP   >012
         ADDK    >10,A9
         CMPI    APD,A9          ; END OF TABLE ?
         JRNE    ASTCO
         MOVI    APLIT,A9          ; YES --> BEGINNING OF TABLE
         JRUC    ASTCO
;X SIGN
STUD_LIT:
	MOVI	MAPP,a0
         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	JAEQ	SUCIDE

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	ADDI	63,A8                 ; A8 = [PAL #,1]
	MOVI    ARW_P,A9

XO     MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    1,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
         SLEEP   >07
         ADDK    >10,A9
         CMPI    ARD,A9          ; END OF TABLE ?
         JRNE    XO
         MOVI    ARW_P,A9          ; YES --> BEGINNING OF TABLE
         JRUC    XO

CMP_LIT
	MOVI	SETCOL,a0
         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	JAEQ	SUCIDE

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	ADDI	61,A8                 ; A8 = [PAL #,1]
         MOVI    CLITE,A9

STCX     MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    3,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
         SLEEP   >09
         ADDK    >10,A9
         CMPI    CLITED,A9          ; END OF TABLE ?
         JRNE    STCX
         MOVI    CLITE,A9          ; YES --> BEGINNING OF TABLE
         JRUC    STCX
MIN_LIT
	MOVI	BULLET,a0
         CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	JAEQ	SUCIDE

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	ADDI	60,A8                 ; A8 = [PAL #,1]
         MOVI    MLIT,A9

STCA     MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    1,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
         SLEEP   10
         ADDK    >10,A9
         CMPI    MLITD,A9          ; END OF TABLE ?
         JRNE    STCA
         MOVI    MLIT,A9          ; YES --> BEGINNING OF TABLE
         JRUC    STCA
RNG_LIT2
	MOVI	nup2,a0
	JRUC	RT
RNG_LIT
	MOVI	nup1,a0
RT      CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	JAEQ	SUCIDE

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	ADDI	27,A8                 ; A8 = [PAL #,1]
         MOVI    RLIT,A9

STCR     MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    3,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
         SLEEP   7
         ADDK    >10,A9
         CMPI    RLITD,A9          ; END OF TABLE ?
         JRNE    STCR
         MOVI    RLIT,A9          ; YES --> BEGINNING OF TABLE
         JRUC    STCR
RED2
	MOVI	nup2,a0
	JRUC	RTQ
RED1
	MOVI	nup1,a0
RTQ      CALLA   FINDPAL              ; FIND PALLETE WE WANNA MESS WITH
	JAEQ	SUCIDE

	 SRL     8,A0
         SLL     8,A0
         MOVE    A0,A8                ; A8 = [PAL #,0]
	ADDI	27,A8                 ; A8 = [PAL #,1]
         MOVI    RRED,A9

	 MOVE    A8,A1
         MOVE    A9,A0                ; A0 = SOURCE = TABLE POSITION
         MOVI    3,A2                 ; A2 = COLOR COUNT
         CALLA   PALSET               ; DO THE TRANSFER
	DIE

TURNON
;TURN ON ALL OVERHEAD IMAGES
	MOVI	0,A9
	CREATE	CYCPID,STAR_COLOR
	CLR	A0
	MOVB	A0,@TMP
TOP0
	MOVB	@TMP,A0
	SLL	5,A0
	ADDI	IMAG,A0
	MOVE	*A0,A9,L
	JRZ	DONE
TOP
	MOVE	*A9+,A10,W
	SUBI	89,A10
	MOVE	*A9+,A11,W
	SUBI	800,A11
;A10=X FROM TABLE
;A11=Y 
	MOVB	@TMP,A0
	SLL	5,A0
	ADDI	IMAG2,A0
	MOVE	*A0,A14,L

	CALLR	DOIMG

	MOVE	*A9,A0
	ANDI	0FFFFH,A0
	CMPI	0FFFFH,A0
	JRNE	TOP
;NEXT LIST
	MOVB	@TMP,A0
	INC	A0
	MOVB	A0,@TMP
	JRUC	TOP0
DONE
	RETS
IMAG	.LONG	HZG,HZGF,VTG,VTGF,CAP,CAPF,LITE,LITEF,PIN,PINF,WIRE,WIREF
	.LONG	LHZ,LHZG,LVT,LVTG,0
IMAG2	.LONG	IMG3,IMG4,IMG1,IMG2,IMG11,IMG12,IMG5,IMG6,IMG7,IMG8,IMG9,IMG10
	.LONG	IMG13,IMG14,IMG15,IMG16
IMG1:
	.LONG	0,0,VGRID
	.WORD	07FEDH,DMAWNZ+M_NOCOLL,CLSNEUT|TYPNEUT|SUBUP
	.LONG	0,0
IMG2:
	.LONG	0,0,VGRID
	.WORD	07FEDH,DMAWNZ+M_FLIPH+M_NOCOLL,CLSNEUT|TYPNEUT|SUBUP
	.LONG	0,0
IMG3:
	.LONG	0,0,HGRID
	.WORD	07FEDH,DMAWNZ+M_NOCOLL,CLSNEUT|TYPNEUT|SUBUP
	.LONG	0,0
IMG4:
	.LONG	0,0,HGRID
	.WORD	07FEDH,DMAWNZ+M_FLIPH+M_NOCOLL,CLSNEUT|TYPNEUT|SUBUP
	.LONG	0,0
IMG5:
	.LONG	0,0,LAMP
	.WORD	07FEBH,DMAWNZ+M_NOCOLL,CLSNEUT|TYPNEUT|SUBUP
	.LONG	0,0
IMG6:
	.LONG	0,0,LAMP
	.WORD	07FEBH,DMAWNZ+M_FLIPH+M_NOCOLL,CLSNEUT|TYPNEUT|SUBUP
	.LONG	0,0
IMG7:
	.LONG	0,0,LGHTBAR
	.WORD	07FECH,DMAWNZ+M_NOCOLL,CLSNEUT|TYPNEUT|SUBUP
	.LONG	0,0
IMG8:
	.LONG	0,0,LGHTBAR
	.WORD	07FECH,DMAWNZ+M_FLIPH+M_NOCOLL,CLSNEUT|TYPNEUT|SUBUP
	.LONG	0,0
IMG9:
	.LONG	0,0,LGHTWIRE
	.WORD	07FECH,DMAWNZ+M_NOCOLL,CLSNEUT|TYPNEUT|SUBUP
	.LONG	0,0
IMG10:
	.LONG	0,0,LGHTWIRE
	.WORD	07FECH,DMAWNZ+M_FLIPH+M_NOCOLL,CLSNEUT|TYPNEUT|SUBUP
	.LONG	0,0
IMG11:
	.LONG	0,0,ENDGRID
	.WORD	07FEDH,DMAWNZ+M_NOCOLL,CLSNEUT|TYPNEUT|SUBUP
	.LONG	0,0
IMG12:
	.LONG	0,0,ENDGRID
	.WORD	07FEDH,DMAWNZ+M_FLIPH+M_NOCOLL,CLSNEUT|TYPNEUT|SUBUP
	.LONG	0,0
IMG13:
	.LONG	0,0,BIGH
	.WORD	07FEDH,DMAWNZ+M_NOCOLL,CLSNEUT|TYPNEUT|SUBUP
	.LONG	0,0
IMG14:
	.LONG	0,0,BIGH
	.WORD	07FEDH,DMAWNZ+M_FLIPH+M_NOCOLL,CLSNEUT|TYPNEUT|SUBUP
	.LONG	0,0
IMG15:
	.LONG	0,0,BIGV
	.WORD	07FEDH,DMAWNZ+M_NOCOLL,CLSNEUT|TYPNEUT|SUBUP
	.LONG	0,0
IMG16:
	.LONG	0,0,BIGV
	.WORD	07FEDH,DMAWNZ+M_FLIPH+M_NOCOLL,CLSNEUT|TYPNEUT|SUBUP
	.LONG	0,0

;IMAGES X/Y POSITION
HZG:
	.WORD	569,1063
	.WORD	606,1063
	.WORD	746+10,1030-25
	.WORD	817+10,1105-25
	.WORD	0FFFFH
HZGF
	.WORD	853+10,1105-25
	.WORD	970+10,953-25
	.WORD	0FFFFH
VTG
	.WORD	397,1112
	.WORD	0FFFFH
VTGF
	.WORD	553,1073
	.WORD	0FFFFH
CAP
	.WORD	201,1005
	.WORD	555,1024
	.WORD	561,1104
	.WORD	644,1063
	.WORD	784+10,1030-25
	.WORD	1005+10,953-25
	.WORD	0FFFFH
CAPF
	.WORD	312,1024
	.WORD	553,1063
	.WORD	692+10,1105-25
	.WORD	731+10,1030-25
	.WORD	957+10,953-25
	.WORD	0FFFFH
LITE	
	.WORD	137,1022
	.WORD	216,1022
	.WORD	608,1086
	.WORD	784+10,1051-25
	.WORD	0FFFFH
LITEF
	.WORD	287,1039
	.WORD	387,1051
	.WORD	937+10,975-25
	.WORD	0FFFFH
PIN
	.WORD	130,1016
	.WORD	208,1017
	.WORD	600,1081
	.WORD	775+10,1046-25
	.WORD	0FFFFH
PINF
	.WORD	411,1044
	.WORD	961+10,970-25
	.WORD	0FFFFH
WIRE
	.WORD	129,1005
	.WORD	211,1022
	.WORD	603,1076
	.WORD	779+10,1041-25
	.WORD	0FFFFH
WIREF
	.WORD	412,1039
	.WORD	964+10,965-25
	.WORD	0FFFFH
LHZ	.WORD	90,1005
	.WORD	90,1084
	.WORD	703+10,1105-25
	.WORD	0FFFFH
LHZG	.WORD	326,1024
	.WORD	333,1103
	.WORD	440,1024
	.WORD	446,1103
	.WORD	891+10,1105-25
	.WORD	0FFFFH
LVT	.WORD	312,1037
	.WORD	312,1111
	.WORD	918+10,1114-25
	.WORD	998+10,966-25
	.WORD	998+10,1039-25
	.WORD	998+10,1114-25
	.WORD	0FFFFH
LVTG	.WORD	117,1095
	.WORD	192,1018
	.WORD	192,1094
	.WORD	636,847
	.WORD	636,921
	.WORD	636,996
	.WORD	730+10,1039-25
	.WORD	767+10,1114-25
	.WORD	0FFFFH

INIT_DEMO:
	CREATE	0,DEMOPLAY
	RETS
;
; UPDATE PLAYER CONTROLS
;  
JOY_UPDATE:
 	MOVE	@GAMSTATE,A0
	CMPI	INGAME,A0
	JRNZ	SKP_FSTICK
	CLR	A5
	NOT	A5
	MOVE	@HALT,A0,W
	JRNZ	SKP_READ
	MOVE	@JOYSW,A5,L		;MOVE PLAYER SWITCHES TO A5 (32 BIT PORT)
SKP_READ:
	NOT	A5
	MOVE	A5,@P1CTRL
	SRL	4,A5

	.IF	YUNIT
	SRL	4,A5
	.ENDIF

	MOVE	A5,@P2CTRL
SKP_FSTICK:
	SLEEP	1
	JRUC	JOY_UPDATE

PUTBGND:
	CLR	A0
	MOVE	A0,@SCROLLX,L
	MOVE	A0,@SCROLLY,L
	MOVE	@CIRCUIT,A0		;FETCH CIRCUIT
	SLL	5,A0			;TABLE ENTRY UHL OFFSET
	ADDI	GAMEMODS,A0
	MOVE	*A0,A0,L		;FETCH DATA POINTER TO WAVE MODULES
	MOVE	A0,A1
	ADDI	32,A1			;GET X,Y POSITION OF MODULE
	MOVE	*A1,A2,L
	SLL	16,A2
	SUBI	[6,0],A2
;	MOVE	A2,@WORLDTLX,L		;AND SET WORLD COORS ACCORDINGLY
	MOVE	A2,A6
	ADDI	16,A1
	MOVE	*A1,A2,L
	SLL	16,A2
;	MOVE	A2,@WORLDTLY,L
	MOVE	A2,A7
	MOVE	A0,@BAKMODS,L
	CLR	A0
	MOVE	A0,@WORLDTLY,L
	MOVE	A0,@WORLDTLX,L

	CALLA	BGND_UD1

	MOVK	1,A0
	MOVE	A0,@GAMERASE
	CALLA	AUTOEON
	MOVI	SETCOL,A0
	CALLA	BLAKOUT			;BLACK OUT BAKGROUND PALETTES
	MOVI	PAL2TV,A0
	CALLA	BLAKOUT			;BLACK OUT BAKGROUND PALETTES
	MOVI	NUARENAP,A0
	CALLA	BLAKOUT			;BLACK OUT BAKGROUND PALETTES

	MOVE	A7,A0
	MOVE	A0,@WORLDTLY,L
	MOVE	A6,A0
	MOVE	A0,@WORLDTLX,L

	MOVK	1,A0
	MOVB	A0,@DUMB
	JSRP	WNDWON
;TURN A WINDOW ON FULL SCREEN
	CALLA	BGND_UD1
 	SLEEP	1
	CALLA	BGND_UD1
;TAKE IT AWAY
	CALLA	BTOF

	CALLA	TURNON			;TURN ON OVERHEAD IMAGES
	CREATE	0,SMASHON
;GIVE THEM ALL A NEG Y VEL
;DO OVERHEAD IMAGES EXIST? IF SO, GIVE EACH IMAGE A NEGATIVE X VEL
	SLEEP	1
D33	MOVI	CLSNEUT|TYPNEUT|SUBUP,A0
	CLR	A1
	NOT	A1
	CALLA	EXISTOBJ
	JRZ	D34
	MOVI	-010000H,A1
	MOVE	A1,*A0(OYVEL),L
	MOVI	CLSNEUT|TYPNEUT|SUBUP2,A1
	MOVE	A1,*A0(OID),W
	JRUC	D33
D34

	SLEEP	85	;90

;PIECES ARE SCROLLING
D35	MOVI	CLSNEUT|TYPNEUT|SUBUP2,A0
	CLR	A1
	NOT	A1
	CALLA	EXISTOBJ
	JRZ	D36
	CLR	A1
	MOVE	A1,*A0(OYVEL),L
	MOVI	CLSNEUT|TYPNEUT|SUBUP,A1
	MOVE	A1,*A0(OID),W
	JRUC	D35
D36
	MOVI	SETCOL,A0
	CALLA	BLAKOUT			;BLACK OUT BAKGROUND PALETTES
	MOVI	PAL2TV,A0
	CALLA	BLAKOUT			;BLACK OUT BAKGROUND PALETTES
	MOVI	NUARENAP,A0
	CALLA	BLAKOUT			;BLACK OUT BAKGROUND PALETTES
	JSRP	WNDWOFF
;STOP THEM
;FADE IN LIGHTS FIRST
;THEN FADE IN TVSET STAGE

	MOVI	PAL1TAB,A0
	MOVK	3,A1		
	CALLA	FADEIN			;SO THAT WE MAY FADE IT IN

	CREATE	0,FADLOGO

	CREATE	0,PEEPL
	CREATE	0,DUX

	CLR	A0
	MOVB	A0,@DUMB
	SLEEP	54
	RETP

FADLOGO
	SLEEP	070H
	MOVI	PAL1TABA,A0
	MOVK	3,A1		
	CALLA	FADEIN			;SO THAT WE MAY FADE IT IN
	DIE

DUX	SLEEP	30
	CREATE	CYCPID,FLR_LIT
	CREATE	CYCPID,CMP_LIT
	DIE
PEEPL
	CREATE	SETPID,CLAP
	CREATE	SETPID,MC
	CREATE	SETPID,GGAL1
	CREATE	SETPID,GGAL2
	DIE
CLAP
	MOVI	49,A9
CL1
	CREATE	SETPID,HANDS
	SLEEP	3
	DSJS	A9,CL1
	DIE
HND1:
	.LONG	0,0,SARM1
	.WORD	07F1H,DMAWNZ+M_NOCOLL,CLSNEUT
	.LONG	0,0
HND2:
	.LONG	0,0,SARM2
	.WORD	07F1H,DMAWNZ+M_NOCOLL,CLSNEUT
	.LONG	0,0
HND3:
	.LONG	0,0,SARM3
	.WORD	07F1H,DMAWNZ+M_NOCOLL,CLSNEUT
	.LONG	0,0
HND4:
	.LONG	0,0,SARM4
	.WORD	07F1H,DMAWNZ+M_NOCOLL,CLSNEUT
	.LONG	0,0

ITBL	.LONG	HND1,HND2,HND3,HND4,HND3,HND2,HND1,HND2,HND3,HND4
	.LONG	HND3,HND4,HND3,HND2,HND1,HND2,HND3,HND4,HND2,HND1
	.LONG	HND3,HND4,HND3,HND2,HND1,HND2,HND3,HND4,HND2,HND1
	.LONG	HND3,HND4,HND3,HND2,HND1,HND2,HND3,HND4,HND2,HND1
	.LONG	HND3,HND4,HND3,HND2,HND1,HND2,HND3,HND4,HND2,HND1
FTBL	.LONG	CLP1,CLP2,CLP3,CLP4,CLP3,CLP2,CLP1,CLP2,CLP3,CLP4
	.LONG	CLP3,CLP4,CLP3,CLP2,CLP1,CLP2,CLP3,CLP4,CLP3,CLP1
	.LONG	CLP3,CLP4,CLP3,CLP2,CLP1,CLP2,CLP3,CLP4,CLP3,CLP1
	.LONG	CLP1,CLP2,CLP3,CLP4,CLP3,CLP2,CLP1,CLP2,CLP3,CLP4
	.LONG	CLP1,CLP2,CLP3,CLP4,CLP3,CLP2,CLP1,CLP2,CLP3,CLP4
XH:	.WORD	20,40,80,100,150,200,240,300,330,360,380
	.WORD	30,46,72,90,120,160,206,230,310,350,370
	.WORD	35,66,85,140,195,170,310,320,320,340,365
	.WORD	55,96,105,120,238,174,316,229,315,334,375
	.WORD	15,76,185,193,205,214,226,239,225,314,385
YH:	.WORD	0F0H,0E5H,0E0H,0EAH,0F0H,0F5H,0F0H,0F0H,0E8H,0F0H
	.WORD	0ECH,0EAH,0DAH,0F0H,0E7H,0F0H,0F2H,0F5H,0EBH,0E8H
	.WORD	0E7H,0E6H,0E6H,0F0H,0F5H,0F2H,0F3H,0EDH,0EFH,0E5H
	.WORD	0DCH,0E0H,0F8H,0F2H,0F0H,0E7H,0ECH,0E4H,0F0H,0D6H
	.WORD	0F2H,0F1H,0F3H,0F4H,0F6H,0F2H,0F1H,0F3H,0F2H,0F3H
HANDS
	MOVE	A9,A0
	SLL	5,A0
	ADDI	ITBL,A0
	MOVE	*A0,A14,L
	CALLA	DOIMG
	MOVE	A9,A0
	SLL	4,A0
	ADDI	XH,A0
	MOVE	*A0,A0
	MOVE	A0,*A8(OXPOS)
	MOVE	A9,A0
	SLL	4,A0
	ADDI	YH,A0
	MOVE	*A0,A0
	MOVE	A0,*A8(OYPOS)
	MOVE	A8,A0
	CALLA	ADJSTWTL

	MOVE	A9,A0
	SLL	5,A0
	ADDI	FTBL,A0
	MOVE	*A0,A9,L
	MOVE	A9,A10
HN1
	MOVE	A10,A9
	MOVK	1,A1
	JSRP	FRANIM
	JRUC	HN1	

MC
	MOVE	@MCPTR,A8,L
	MOVE	*A8(OXPOS),A0
	ADDI	14,A0
	MOVE	A0,*A8(OXPOS)
	MOVE	*A8(OYPOS),A0
	SUBI	12H,A0			;16H
	MOVE	A0,*A8(OYPOS)
M1
	MOVI	GOMC,A9
	MOVK	1,A1
	JSRP	FRANIM
	JRUC	M1
GGAL1
	MOVE	@GAL1P,A8,L
	MOVE	*A8(OXPOS),A0
	ADDI	8,A0
	MOVE	A0,*A8(OXPOS)
	MOVE	*A8(OYPOS),A0
	SUBI	8,A0
	MOVE	A0,*A8(OYPOS)
G1
	MOVI	GAL1L,A9
	MOVK	1,A1
	JSRP	FRANIM
	JRUC	G1
GGAL2
	MOVE	@GAL2P,A8,L
	MOVE	*A8(OXPOS),A0
	SUBI	8,A0
	MOVE	A0,*A8(OXPOS)
	MOVE	*A8(OYPOS),A0
	SUBI	9,A0
	MOVE	A0,*A8(OYPOS)
G2
	MOVI	GAL2L,A9
	MOVK	1,A1
	JSRP	FRANIM
	JRUC	G2


CLP1	.LONG	SARM1
	.WORD	10
	.LONG	SARM1A
	.WORD	10
	.LONG	0
CLP2	.LONG	SARM2
	.WORD	10
	.LONG	SARM2A
	.WORD	10
	.LONG	0
CLP3	.LONG	SARM3
	.WORD	10
	.LONG	SARM3A
	.WORD	10
	.LONG	0
CLP4	.LONG	SARM4
	.WORD	10
	.LONG	SARM4A
	.WORD	10
	.LONG	0

GAL1L
	.LONG	GAL1
	.WORD	FLIPBITS|45,0
	.LONG	GAL2
	.WORD	60
	.LONG	GAL3
	.WORD	25
	.LONG	GAL4
	.WORD	30
	.LONG	GAL3
	.WORD	35
	.LONG	GAL1
	.WORD	40
	.LONG	GAL4
	.WORD	150
	.LONG	0
GAL2L
	.LONG	GAL1
	.WORD	FLIPBITS|43,(M_FLIPH)
	.LONG	GAL3
	.WORD	35
	.LONG	GAL4
	.WORD	25
	.LONG	GAL3
	.WORD	FLIPBITS|35,(M_FLIPH)
	.LONG	GAL2
	.WORD	45
	.LONG	GAL1
	.WORD	40
	.LONG	GAL4
	.WORD	FLIPBITS|140,0
	.LONG	0
	.LONG	0
GOMC	
	.LONG	MC1
	.WORD	FLIPBITS|8,0
	.LONG	MC2
	.WORD	8
	.LONG	MC3
	.WORD	30
	.LONG	MC2
	.WORD	8
	.LONG	0


PAL1TAB:
	.LONG	AUTOPAL,SETCOL,BLCHR2,NUARENAP,0
PAL1TABA
	.LONG	PAL2TV,0

DEMOBGND:
	CLR	A0
	MOVE	A0,@SCROLLX,L
	MOVE	A0,@SCROLLY,L
	MOVI	BGMODS,A1
	CLR	A0
	MOVE	A0,@CIRCUIT
	MOVE	@WAVE,A0,W
	CMPI	3,A0
	JRNE	DMG
;START COLOR CYCLE FOR THIS ROBOT ARENA
	MOVI	RBTP5,A9
	CREATE	CYCPID,STATIC_LIT
	MOVI	RBTP5,A9
	CREATE	CYCPID,HOSPG_LIT
	CREATE	CYCPID,HOSPR_LIT
	MOVK	1,A0
	MOVE	A0,@CIRCUIT
	MOVE	@WAVE,A0
	MOVI	BGMODS,A1
DMG	SLL	5,A0
	ADD	A0,A1
	MOVE	*A1,A1,L
	MOVE	A1,@BAKMODS,L
	CALLA	BGND_UD1
	MOVK	1,A0
	MOVE	A0,@GAMERASE
	JAUC	AUTOEON

BGMODS:
	.LONG	0,PWAVE2,PWAVE3,PWAVE4,PWAVE3,PWAVE3,0,0,0,0,PWAVE3
;
; MODULE DEFINITION FOR BACKGROUND
;
GAMEMODS:
	.LONG	CIRCUIT1,CIRCUIT2,CIRCUIT3

CIRCUIT1:
;
; GAME MODULE FOR CIRCUIT 1
;
;ARENAS AND TVSET POSITIONS
	.LONG	TVSETBMOD	;TV INTRO SCREEN
	.WORD	6,>152

	.LONG	ARENA3BMOD	;ARENA 3
	.WORD	>3B4,>5
	.LONG	ARENA2BMOD	;ARENA 4
	.WORD	>58D,>5
	.LONG	TRSRBMOD	;ARENA 5	;CASH ROOM
	.WORD	>765,>5		;764

	.LONG	ARENABMOD 	;ARENA 1
	.WORD	>1DD,>152			;1D6
	.LONG	ARENABMOD	;ARENA 2
	.WORD	>3B5,>152			;3A7 3B4
	.LONG	ARENA2BMOD	;ARENA 8
	.WORD	>58D,>152			;3A7
	.LONG	ARENA2BMOD	;ARENA 9
	.WORD	>765,>152			;3A7
	.LONG	BROKENBMOD	;ARENA 10	;MUTOID MAN
	.WORD	>93D,>152			;578
;	.LONG	TVSETBMOD	;TV SCREEN END
;	.WORD	>B15,>152			;749

	.LONG	BONUSBMOD	;BONUS SCRN
	.WORD	>1DD,>29E-55
	.LONG	BONUSBMOD	;BONUS SCRN
	.WORD	>93D,>29E-55
	.LONG	ARENABMOD	;ARENA 6	;EASY AREA
	.WORD	>3B4,>29E
	.LONG	ARENABMOD	;ARENA 7	;EASY AREA
	.WORD	>58D,>29E

;VERTICAL WALKWAYS
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 3/4
	.WORD	>53C,>5		;53C
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 4/5
	.WORD	>714,>5

	.LONG	WLKRGTBMOD	;WALK WAY BETWEEN TV/1
	.WORD	>189,>153			;

	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 1/2
	.WORD	>364,>152
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 8/9
	.WORD	>714,>152
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 9/10
	.WORD	>8ED,>152

	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 6/7
	.WORD	>53C,>29E

;HORIZONTAL WALKWAYS
	.LONG	HWLKWYBMOD	;HZ BETWEEN 3/2
	.WORD	>3B2,>101
	.LONG	HWLKWYBMOD 	;HZ BETWEEN 4/8
	.WORD	>58B,>102	;100
	.LONG	HWLKWYBMOD	;HZ BETWEEN 5/9
	.WORD	>762,>102	;764/100

	.LONG	HWLKWYBMOD	;HZ BETWEEN 2/6
	.WORD	>3B2,>24F
	.LONG	HWLKWYBMOD 	;HZ BETWEEN 8/7
	.WORD	>589,>24D

	.LONG	>FFFFFFFF
	

CIRCUIT2:
;
; GAME MODULE FOR CIRCUIT 2
;
;ARENAS AND TVSET POSITIONS

;TVSET ARENA
	.LONG	TVSETBMOD	;TV INTRO SCREEN
	.WORD	6,>29E

;TOP ROW
	.LONG	ARBTBBMOD	;ARENA 11
	.WORD	>58D,>5
	.LONG	TRSR2BMOD	;ARENA 12
;	.LONG	ARBTADBMOD	;ARENA 12
	.WORD	>765,>5		;764

;ROW 2
	.LONG	ARBTFBMOD 	;ARENA 8
	.WORD	>1DC,>152
	.LONG	ARBTAABMOD	;ARENA 9
	.WORD	>3B5,>152		
	.LONG	ARBTABBMOD	;ARENA 4
	.WORD	>58D,>152		
	.LONG	ARBTGBMOD	;ARENA 5
	.WORD	>765,>152

;ROW 3
	.LONG	ARBTEBMOD	;ARENA 1
	.WORD	>1DD,>29E		
	.LONG	ARBTCBMOD	;ARENA 2
	.WORD	>3B5,>29E
	.LONG	ARBTADBMOD	;ARENA 3
	.WORD	>58D,>29E
	.LONG	ARBTHBMOD	;ARENA 6
	.WORD	>764,>29E
	.LONG	ARBTDBMOD	;ARENA 7
	.WORD	>93D,>29E

;ROW 4
	.LONG	ARBTFBMOD	;ARENA 13
	.WORD	>1DD,>3EA		
;	.LONG	ARBTACBMOD	;ARENA 14
	.LONG	TRSR2BMOD	;ARENA 14	;CASH ROOM
	.WORD	>3B5,>3EA
	.LONG	ARBTAABMOD	;ARENA 15
	.WORD	>58D,>3EA
	.LONG	ARBTGBMOD	;ARENA 16
	.WORD	>764,>3EA
	.LONG	BONUSBMOD	;BONUS SCRN
	.WORD	>93D,>3EA-55

;ROW 5
	.LONG	ARBTCBMOD	;ARENA 17
	.WORD	>58D,>536		
	.LONG	ARBTADBMOD	;ARENA 18
	.WORD	>764,>536


;VERTICAL WALKWAYS
;ROW 1
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 11/12
	.WORD	>714,>5	

;ROW 2
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 8/9
	.WORD	>364,>152
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 9/4
	.WORD	>53C,>152
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 4/5
	.WORD	>714,>152

;ROW 3
	.LONG	WLKRGTBMOD	;WALKWAY BETWEEN TV/1
	.WORD	>189,>29F
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 1/2
	.WORD	>364,>29E
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 2/3
	.WORD	>53C,>29E
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 6/7
	.WORD	>8ED,>29E

;ROW 4
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 13/14
	.WORD	>364,>3EA
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 14/15
	.WORD	>53C,>3EA
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 15/16
	.WORD	>714,>3EA

;ROW 5
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 17/18
	.WORD	>714,>536


;HORIZONTAL WALKWAYS
;ROW 1
	.LONG	HWLKWYBMOD	;HZ BETWEEN 4/11
	.WORD	>58B,>102
	.LONG	HWLKWYBMOD 	;HZ BETWEEN 5/12
	.WORD	>761,>102	;764

;ROW 2
	.LONG	HWLKWYBMOD	;HZ BETWEEN 1/8
	.WORD	>1D9,>24F
	.LONG	HWLKWYBMOD	;HZ BETWEEN 2/9
	.WORD	>3B2,>24F
	.LONG	HWLKWYBMOD 	;HZ BETWEEN 3/4
	.WORD	>58B,>24F
	.LONG	HWLKWYBMOD 	;HZ BETWEEN 6/5
	.WORD	>761,>24F

;ROW3
	.LONG	HWLKWYBMOD	;HZ BETWEEN 13/1
	.WORD	>1D9,>39C
	.LONG	HWLKWYBMOD	;HZ BETWEEN 14/2
	.WORD	>3B2,>39C
	.LONG	HWLKWYBMOD 	;HZ BETWEEN 15/3
	.WORD	>58B,>39C
	.LONG	HWLKWYBMOD 	;HZ BETWEEN 16/6
	.WORD	>761,>39C

;ROW 4
	.LONG	HWLKWYBMOD 	;HZ BETWEEN 17/15
	.WORD	>58B,>4E9
	.LONG	HWLKWYBMOD 	;HZ BETWEEN 18/16
	.WORD	>761,>4E9

	.LONG	>FFFFFFFF


CIRCUIT3:
; GAME MODULE FOR CIRCUIT 3
;
;ARENAS AND TVSET POSITIONS

;TVSET ARENA
	.LONG	TVSETBMOD	;TV INTRO SCREEN
	.WORD	6,>29E

;TOP ROW
	.LONG	TEMPL1BMOD	;ARENA 11
	.WORD	>58D,>5
;	.LONG	TEMPL3BMOD	;ARENA 12
	.LONG	TRSR3BMOD	;ARENA 12
	.WORD	>764,>5		;764

;ROW 2
	.LONG	JNG5BMOD 	;ARENA 8
	.WORD	>1DC,>152
	.LONG	JNG2BMOD	;ARENA 9
	.WORD	>3B5,>152		
	.LONG	JNG6BMOD	;ARENA 4
	.WORD	>58D,>152		
	.LONG	TEMPL5BMOD	;ARENA 5
	.WORD	>765,>152

;ROW 3
	.LONG	JNG2BMOD	;ARENA 9	;TWO MOUTHS!
;	.LONG	JNG1BMOD	;ARENA 1
	.WORD	>1DC,>29E			;1DD
	.LONG	JNG5BMOD	;ARENA 2
	.WORD	>3B5,>29E
	.LONG	JNG4BMOD	;ARENA 3
	.WORD	>58D,>29E
	.LONG	TEMPL2BMOD	;ARENA 6
	.WORD	>764,>29E
	.LONG	TEMPL4BMOD	;ARENA 7
	.WORD	>93D,>29E
	.LONG	TRSR3BMOD	;ARENA 19
	.WORD	>B16,>29E
	.LONG	TRSR3BMOD	;ARENA 20
	.WORD	>CEF,>29E
	.LONG	MCENDBMOD	;ARENA 10	;MUTOID MAN
	.WORD	>EC8,>29E

;ROW 4
	.LONG	JNG5BMOD	;ARENA 13
	.WORD	>1DD,>3EA		
;	.LONG	JNG4BMOD	;ARENA 14
	.LONG	TRSR3BMOD	;ARENA 14
	.WORD	>3B5,>3EA
	.LONG	JNG2BMOD	;ARENA 15
	.WORD	>58D,>3EA
	.LONG	TEMPL1BMOD	;ARENA 16
	.WORD	>764,>3EA
	.LONG	BONUSBMOD	;BONUS SCRN
	.WORD	>EC8,>3EA-55

;ROW 5
	.LONG	JNG2BMOD	;ARENA 17
	.WORD	>58D,>536		
	.LONG	JNG6BMOD	;ARENA 18
	.WORD	>764,>536


;VERTICAL WALKWAYS
;ROW 1
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 11/12
	.WORD	>714,>5	

;ROW 2
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 11/12
;	.LONG	VWLKYCBMOD	;WALKWAY BETWEEN 8/9
	.WORD	>364,>152
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 11/12
;	.LONG	VWLKWYABMOD	;WALKWAY BETWEEN 9/4
	.WORD	>53C,>152
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 4/5
	.WORD	>714,>152

;ROW 3
;	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 11/12
	.LONG	WLKRGTBMOD	;WALK WAY BETWEEN TV/1
;	.LONG	VWLKWYBBMOD	;WALKWAY BETWEEN TV/1
	.WORD	>189,>29F
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 11/12
;	.LONG	VWLKYCBMOD	;WALKWAY BETWEEN 1/2
	.WORD	>364,>29E
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 11/12
;	.LONG	VWLKYCBMOD	;WALKWAY BETWEEN 2/3
	.WORD	>53C,>29E
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 6/7
	.WORD	>8EC,>29E
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 7/19
	.WORD	>AC4,>29E
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 19/20
	.WORD	>C9D,>29E
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 20/21
	.WORD	>E76,>29E

;ROW 4
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 11/12
;	.LONG	VWLKYCBMOD	;WALKWAY BETWEEN 13/14
	.WORD	>364,>3EA
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 11/12
;	.LONG	VWLKWYABMOD	;WALKWAY BETWEEN 14/15
	.WORD	>53C,>3EA
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 15/16
	.WORD	>714,>3EA

;ROW 5
	.LONG	VWLKWYBMOD	;WALKWAY BETWEEN 11/12
;	.LONG	VWLKWYABMOD	;WALKWAY BETWEEN 17/18
	.WORD	>714,>536


;HORIZONTAL WALKWAYS
;ROW 1
	.LONG	HWLKWYBMOD	;HZ BETWEEN 4/11
;	.LONG	HWLKWYABMOD	;HZ BETWEEN 4/11
	.WORD	>58B,>102
	.LONG	HWLKWYBMOD 	;HZ BETWEEN 5/12
	.WORD	>761,>102	;764

;ROW 2
	.LONG	HWLKWYBMOD	;HZ BETWEEN 4/11
;	.LONG	HWLKWYBBMOD	;HZ BETWEEN 1/8
	.WORD	>1D9,>24F
	.LONG	HWLKWYBMOD	;HZ BETWEEN 4/11
;	.LONG	HWLKWYBBMOD	;HZ BETWEEN 2/9
	.WORD	>3B2,>24F
	.LONG	HWLKWYBMOD	;HZ BETWEEN 4/11
;	.LONG	HWLKWYABMOD 	;HZ BETWEEN 3/4
	.WORD	>58B,>24F
	.LONG	HWLKWYBMOD 	;HZ BETWEEN 6/5
	.WORD	>761,>24F

;ROW3
	.LONG	HWLKWYBMOD	;HZ BETWEEN 4/11
;	.LONG	HWLKWYBBMOD	;HZ BETWEEN 13/1
	.WORD	>1D9,>39C
	.LONG	HWLKWYBMOD	;HZ BETWEEN 4/11
;	.LONG	HWLKWYABMOD	;HZ BETWEEN 14/2
	.WORD	>3B2,>39C
	.LONG	HWLKWYBMOD	;HZ BETWEEN 4/11
;	.LONG	HWLKWYABMOD 	;HZ BETWEEN 15/3
	.WORD	>58B,>39C
	.LONG	HWLKWYBMOD 	;HZ BETWEEN 16/6
	.WORD	>761,>39C

;ROW 4
	.LONG	HWLKWYBMOD	;HZ BETWEEN 4/11
;	.LONG	HWLKWYABMOD 	;HZ BETWEEN 17/15
	.WORD	>58B,>4E9
	.LONG	HWLKWYBMOD 	;HZ BETWEEN 18/16
	.WORD	>761,>4E9


	.LONG	>FFFFFFFF


PWAVE2:
	.LONG	ARENA2BMOD	;ARENA 9
	.WORD	5,0
	.LONG	>FFFFFFFF
PWAVE3:
	.LONG	BROKENBMOD
	.WORD	5,0
	.LONG	>FFFFFFFF
PWAVE4:
	.LONG	ARBTDBMOD
	.WORD	5,0
	.LONG	>FFFFFFFF

	.END


