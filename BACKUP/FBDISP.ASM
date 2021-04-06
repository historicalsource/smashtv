**************************************************************************
*                                                                        *
*  GSP DMA OBJECT HANDLER                                                *
*                                                                        *
*  Modified more times then we would like to admit. Written and modified *
*  by:                                                                   *
*          Warren Davis    (9/1/87)                                      *
*          Eugnene Jarvis  (8/8/88)                                      *
*          Todd Allen      (3/26/89)                                     *
*          Ed Boon         (2/13/90)                                     *
*                                                                        *
*   COPYRIGHT (C) 1988 WILLIAMS ELECTRONICS GAMES, INC.                  *
*   ALL RIGHTS RESERVED.                                                 *
*                                                                        *
**************************************************************************
	.FILE	'FBDISP.ASM'
	.TITLE	"GSP DISPLAY PROCESSOR"

	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
* FILES REQUIRED FOR ASSEMBLY
*
         .INCLUDE 	GSP.INC
         .INCLUDE 	SYS.INC
	.INCLUDE	MACROS.HDR
	.INCLUDE	MPROCEQU.ASM
	.INCLUDE	DISPEQU.ASM
         .INCLUDE        MAINEQU.ASM

*
* GLOBAL VARIABLES
*
	.sect	"OFIXED"

OBJLST	.long	0	;POINTER TO ACTIVE OBJECT LIST
OFREE	.long	0	; pointer to free object block
BAKLST	.LONG	0	;BACKGROUND LIST
BAK2LST  .LONG	0	;SLOW SCROLL BACKGROUND PLANE

	.SECT	".text"
*
	.BSS	SCROLLX,32		;X SCROLL VALUE
	.BSS	SCROLLY,32		;Y SCROLL VALUE
	.BSS	WORLDTLX,32		;TOP LEFT X SCREEN COORD (WORLD)
	.BSS	WORLDTLY,32		;TOP LEFT Y SCREEN COORD (WORLD)
	.BSS	WORLDTL,32		;PACKED TOP LEFT WORLD COORD
	.BSS	SCRNTL,32		;TOP LEFT [Y,X] SCREEN (SCRN COORD.)
	.BSS	SCRNLR,32		;LOWER RIGHT [Y,X] SCREEN (SCRN COORD.)
	.BSS	DISPLAYON,16		;DO DISPLAY PROCESSING WHEN != 0
  	.BSS	OBJSTR,NOBJ*OBSIZ	;OBJECT STRUCTURE LIST START
	.BSS	OBJLSTND,0		;OBJECT LIST END
	.BSS	BAK2TLY,32		;TOP LFT Y SLOW SCROLL BACKGROUND
	.BSS	BAK2TLX,32		;TOP LFT X SLOW SCROLL BACKGROUND

*
* DMA QUEUE RAM - NOW UNUSED (EJB 2/13/90)
*
;	.BSS	QSYNC,16		;SIGNALS ACTIVE Q
;	.BSS	DMAQCUR,32		;CURRENT DMAQ
;	.BSS	DMAQCNT,16		;CURRENT DMAQ COUNT
;	.BSS	BOTQ0CNT,16		;BOTTOM QUEUE COUNT #0
;	.BSS	BOTQ1CNT,16		;BOTTOM QUEUE COUNT #1
;	.BSS	TOPQ0CNT,16		;TOP QUEUE COUNT #0
;	.BSS	TOPQ1CNT,16		;TOP QUEUE COUNT #1
;	.BSS	BOTQ0FLG,16	     ;BOTTOM Q0 VALID FLAG  VALID=NE
;	.BSS	BOTQ1FLG,16		;BOTTOM Q1 VALID FLAG  VALID=NE
;	.BSS	TOPQ0FLG,16		;TOP Q0 VALID FLAG  VALID=NE
;	.BSS	TOPQ1FLG,16		;TOP Q1 VALID FLAG  VALID=NE
;QSIZE	.SET	NOBJ*BQCELL		;SIZE OF QUEUES
;	.BSS	BOTQ0,QSIZE		;BOTTOM OBJECT DMA Q #0
;	.BSS	BOTQ1,QSIZE   		;BOTTOM OBJECT DMA Q #1
;	.BSS	TOPQ0,QSIZE		;TOP OBJECT DMA Q #0
;	.BSS	TOPQ1,QSIZE		;TOP OBJECT DMA Q #1
;	.BSS	DMAQ,QSIZE		;MISC. NON-SYNC DMA QUEUE	
;	.BSS	SKIPDMA,16		;SKIP DMA RESTART IF != 0
;	.BSS	QDMAFLG,16		;SPECIAL DMAQ BEING UPDATED=1


**************************************************************************
*                                                                        *
*  DCLIPL                                                                *
*                                                                        *
*  This routine is executed often and it is VERY IMPORTANT to keep it    *
*  on a 128 byte boundary and IN CACHE ! Make sure this file is 1st      *
*  in your makefile and this is the first routine in this file. Other    *
*  wise this code may not be executed in CACHE and run REAL SLOW !!      *
*                                                                  EJB   *
**************************************************************************
DCLIPL
	move   	*a0(OXPOS),a10		;GET YOUR X
	move	*a0(OYVAL),a2,L		;GET YOUR Y
	move	*a0(OZVAL),a3,L		;GET YOUR Z
	ADD	A2,A3
	movy	a3,a10			; Y:X in a10	
	MOVE	A10,*A0(ODMAXY),L	;UPDATED XY POSITION
	MOVE	B4,A6			;SUBTRACT WORLD COORD TO GET SCREEN COORD.

*        SUBXY   A6,A10
*        MOVE    A0,A3
*        ADDI    OFLAGS,A3            ; GET PARAMETER LOCATION
*        MMFM    A3,A12,A11,A9,A8
*
*  FOOTBALL DISPLAY SYSTEM MODIFICATION #1
*  The next 6 lines replace the 4 commented lines above for
*  Football. They implement the NO SCROLL function.  (FMOD)
*
*
	MOVE	A0,A3
	ADDI	OFLAGS,A3		;GET PARAMETER LOCATION
	MMFM	A3,A12,A11,A9,A8
         BTST    B_NOSCROLL,A12       ; DO WE SCROLL ?
         JRNE    DCLIP_SKIP           ; NO, THEN DON'T
	SUBXY	A6,A10

DCLIP_SKIP

*	CHECK FOR FLIPPING, NECESSITY OF CLIPPING, ADJUST OFFSET, SAG
*	A0 IS THE ADDRESS OF THE OBJECT BLOCK
* 	A1 BECOMES OFFSET
*	A2=AMOUNT TO CLIP OFF BOTTOM, RIGHT	(BC,RC)
* 	A3=AMOUNT TO CLIP OFF TOP, LEFT	(TC,LC)
*	A6=SCREEN TOP LEFT (SCREEN COORDINATES); THEN TOTAL HORIZ. SIZE
*
*	A8 IS CONST:PALETTE
*	A9 BECOMES VS : HS
*	A10 IS DAG (Y : X)
*	A11 IS THE SAG
*	A12 IS THE CONTROL WORD B0-15; OFFSET B16-31
*	A13 IS THE WINDOW BOTTOM RT
*	A14 IS THE WINDOW TOP LEFT
*
*  COMPUTE LC, RC, TC, BC	
*
	CLR	A6		; UPPER LEFT SCREEN COORDINATES
	CLR	A1     		; USE FOR CLEARING NOW, BECOMES OFFSET LATER
	MOVE	A10,A2 		; PT IN A2
	ADDXY	A9,A2 		; LOWER RIGHT IN A2
	SUBXY	A13,A2		; PT - WEND -> A2  ( BC : RC )
	JRYGE	DIS_CLP0
	MOVY    A1,A2  		; CLEAR BC IF Y NEGATIVE
DIS_CLP0:	
	JRXGE	DIS_CLP1
	MOVX   	A1,A2  		; CLEAR RC IF X NEGATIVE	
DIS_CLP1:
	MOVE   	A14,A7 		; MOVE WSTART
	CLR    	A3				;
	SUBXY	A10,A7	    	; WSTART - PT -> A7 (TC : LC)
	JRYLT  	DIS_CLP2
	MOVY   	A7,A3	    	; TC IN UPPER HALF OF A3
	MOVY   	A14,A10	    	; ADJUST START POSITION TO WINDOW EDGE
DIS_CLP2:
	JRXLT  	DIS_CLP3
	MOVX   	A7,A3	    	; LC IN LOWER HALF OF A3
	MOVX   	A14,A10	    	; ADJUST START POSITION TO WINDOW EDGE
DIS_CLP3:
	MOVX	A9,A6		;GET TOTAL HORIZONTAL SIZE (MORSEL CORRECTED)
	ADD	A3,A2	    	; (TC+BC : LC+RC) IN A2
	JREQ	NOCLIP		; TOTAL CLIP IS ZERO, NOCLIP
	SUBXY	A2,A9	    	; GET CLIPPED SIZE...TOTALLY CLIPPED?
	JRXLE	DISPNEXT	; YES, DON'T DISPLAY IT
	JRYLE	DISPNEXT
*
* CLIP THE SAG, HS, VS, AND ADJUST OFFSET
*	
	MOVX	A3,A1		;GET LEFT CLIP
	SRL	16,A3		;GET TOP CLIP
	JREQ	CLIP1
	MOVE	*A0(OXCLIP),A7
	ADD	A6,A7		;ADD PRECLIP TO THE WIDTH TO CALC NEW SAG
	MPYS	A7,A3		;TOP CLIP X TOTAL HORIZ SIZE
CLIP1:
	SLL	16,A2
	BTST	B_FLIPH,A12
	JREQ	CLIP2
	NEG	A2		;NEGATE RC+LC
	NEG	A1		;NEGATE LC
CLIP2:
	BTST	B_FLIPV,A12
	JREQ	CLIP3
	NEG	A3		;NEGATE	THS*TC
CLIP3:
	ADD	A1,A3		;ADD LEFT CLIP TERM +  TC*THS
	SLL	3,A3
	ADD	A3,A11		;ADD TO SAG
	ADD	A2,A12		;ADD CLIP OFFSET TO OFFSET
NOCLIP:

*
* DMA IT
* A8 = CONST:PALETTE XLATE
* A9 = VSIZE:HSIZE
* A10 = DESTINATION Y:X
* A11 = IMAGE SAG
* A12 = OFFSET:CONTROL
*
	addxy	A5,A10		     ; PAGE OFFSET
	movi	DMAREGS,A7

DMA_WAIT
	MOVE	@DMACTRL,A6,W
	JRN	DMA_WAIT		; WAIT FOR DMA WHILE IT IS BUSY

	MMTM	A7,A8,A9,A10,A11     ; STUFF THE DMA REGS
	RL	16,A12
	MOVE	A12,-*A7,W
	RL	16,A12
	MOVE	A12,-*A7,W	     ; STUFF THE CONTROL TO GO

DISPNEXT
	MOVE	*A0,A0,L	     ; GET NEXT LINK
	JRNE	DCLIPL		     ; DONE?
	RETS

**************************************************************************
*                                                                        *
*                      END OF CACHE ALLIGNED CODE                        *
*                      END OF CACHE ALLIGNED CODE                        *
*                      END OF CACHE ALLIGNED CODE                        *
*                      END OF CACHE ALLIGNED CODE                        *
*                                                                        *
**************************************************************************

**************************************************************************
*                                                                        *
*                    DISPLAY OBJECT LISTS                                *
*                                                                        *
**************************************************************************
DISPLAY:
	MOVE	@DISPLAYON,A0,W
	JREQ	DISPX	             ; NO PROCESSING WHILE THIS IS ZERO !!

	MOVI	OXVEL,A1
	MOVI	OBJLST,A0
	CALLR	ADD_VELOCITIES

	MOVE	@SCROLLX,A6,L	     ; get Y:X scroll values
	MOVE	@SCROLLY,A7,L
	MOVE	@WORLDTLY,A14,L	     ; SCROLL YOUR SCREEN FOLKS
	MOVE	@WORLDTLX,A13,L
	ADD	A6,A13
	ADD	A7,A14
	MOVE	A14,@WORLDTLY,L
	MOVE	A13,@WORLDTLX,L
	SRL	16,A13
	MOVX	A13,A14		;COMBINE TO FORM TOP LEFT Y:X		

	MOVE	A14,B4		;SETUP WORLD TOP LEFT [Y,X]
	MOVE	B4,@WORLDTL,L	;STORE THE WORLD TOP LEFT [Y,X]
	MOVE	@SCRNTL,A14,L	;GET SCREEN BOUNDARIES
	MOVE	@SCRNLR,A13,L

	move	@PAGEADDR,A5,L
	sll	16-12,A5	;convert >100000 into 256 for y val
*
* BACKGROUND LIST
*
         MOVI    BAKLST,A0
	MOVE	@WORLDTL,B4,L	;B4 = WORLD TOP LEFT [Y,X]
	CALLR	DISPNEXT
*
* MAIN OBJECT LIST
*
	MOVI	OBJLST,A0
	MOVE	@WORLDTL,B4,L	;B4 = WORLD TOP LEFT [Y,X]
	CALLR	DISPNEXT
DISPX:
	RETS



ADD_VELOCITIES
         MOVE    @NO_VEL,A3,W         ; DO WE ADD VELOCITIES ?
         JRNE    DONT_ADD             ; NO

ADD_LOOP
	MOVE	A0,A3
	ADD	A1,A3  			; ADD IN OXVEL
	MMFM	A3,A7,A8,A9,A10,A11,A12

* A12:OXVEL, A11:0YVEL, A10:OXPOS, A9:OYPOS, A8: OZPOS  A7:OZVEL

	ADD	A12,A10		     ; ADD X VELOCITY TO XVAL
	ADD	A11,A9		     ; ADD Y VELOCITY TO YVAL
	ADD	A7,A8		     ; ADD Z VELOCITY TO ZVAL
	SUBK	20H,A3
	MMTM	A3,A8,A9,A10

DVELP
	MOVE  	*A0,A0,L     	     ; GET NEXT ONE FOLKS
	JRNE  	ADD_LOOP

DONT_ADD
	RETS


*
* QDMA PUTS IMAGE ON DMA Q
* INPUTS:
* A1: CONSTANT COLOR:PALETTE
* A3: DESTINATION Y:X
* A5: OFFSET:CONTROL
* A14: ADDRESS OF IMAGE HEADER
* GETS: A2=H/W; A4=SAG
;QDMA:
;	MMTM	SP,A2,A4,A13
;	MOVE	*A14,A2,L		;GET VSIZE:HSIZE
;	MOVE	*A14(ISAG),A4,L		;GET SAG
;QDMA1:
;	MOVK	1,A13
;	MOVE	A13,@QDMAFLG,W		;Q BEING MODIFIED
;	MOVE	@DMAQCUR,A13,L
;	CMPI	DMAQ,A13
;	JRLS	QDMAX			;Q OVERLOAD, CAN IT
;	MMTM	A13,A1,A2,A3,A4,A5
;	MOVE	A13,@DMAQCUR,L
;	CLR	A13
;	MOVE	A13,@QDMAFLG,W
;QDMAX:
;	MMFM	SP,A2,A4,A13
;	RETS
*MANUAL DMA (SETUP YOUR OWN REGS)
*INPUTS:
*A1: CONSTANT COLOR:PALETTE
*A2: VSIZE:HSIZE
*A3: DESTINATION Y:X
*A4: SAG
*A5: OFFSET:CONTROL
;QDMAN:
;	MMTM	SP,A2,A4,A13
;	JRUC	QDMA1


*****************************************************************
;DISPMAN:
;	MOVE	@QDMAFLG,A2	;Q BEING MODIFIED?
;	JRNE	DISPMANX 	;YES, DON'T SCREW WITH IT
;	MOVE	@DMAQCUR,A2,L
;	MOVI	DMAQ+QSIZE,A1
;	CMP	A1,A2
;	JREQ	DISPMANX		;NONE 
;	MOVE	A1,@DMAQCUR,L	;RESET TOP OF QUEUE
;DMANLP:
;	;*** DUMP THE MANUAL Q
;	movi	DMAREGS,A7
;	;*** WAIT FOR DMA NOT BUSY ***
;DMAWT1:	MOVE	@DMACTRL,A4,W	;DMA BUSY?
;	JRN	DMAWT1		;BR = YES
;	;STUFF DMA REGS
;	MOVE	-*A1,-*A7,L	;CONST:PALETTE
;	MOVE	-*A1,-*A7,L	;VSIZE:HSIZE
;	MOVE	-*A1,-*A7,L	;DESTINATION Y:X
;	MOVE	-*A1,-*A7,L	;IMAGE SAG
;	MOVE	-*A1,-*A7,W	;OFFSET
;	MOVE	-*A1,-*A7,W	;STUFF THE CONTROL
;
;	CMP	A2,A1
;	JRHI	DMANLP
;DISPMANX:
*****************************************************************


**************************************************************************
*                                                                        *
* STOPOBJS - ZEROS VELOCITIES FOR ALL OBJECTS ON OBJLST.		          *
*                                                                        *
**************************************************************************
STOPOBJS
	MMTM	SP,A0,A1
	CLR	A0
	MOVI	OBJLST,A1
SOBJS1
	MOVE	*A1,A1,L
	JREQ	SOBJSX
	MOVE	A0,*A1(OXVEL),L
	MOVE	A0,*A1(OYVEL),L
	MOVE	A0,*A1(OZVEL),L
	JRUC	SOBJS1
SOBJSX
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
* SHADOW STUFF								 *
*                                                                        *
**************************************************************************
*START A PART 2 SHADOW
*A8 = OBJECT TO SHADOW
;SHADST2
;	MMTM	SP,A1
;	CALLR	GETOBJ
;	JREQ	SHADSTX			;NONE AVAIL
;	CALLR	SHADCPY2	
;	JRUC	SHADSTG

*START A SHADOW
*INPUTS
*A8=OBJECT TO SHADOW
*RETURNS:
*A0=PTR TO SHADOW, OR 0 IF NO SHADOW WAS CREATED
*
SHADST:
	MMTM	SP,A1
	CALLR	GETOBJ
	JREQ	SHADSTX			;NONE AVAIL
	CALLR	SHADCPY	
SHADSTG
	MOVI	DUMCOLL,A1
	MOVE	A1,*A0(OCVECT),L	;DUMMY COLLISION
	CALLR	INSOBJ
	MOVI	OID_SHAD,A1,W
	MOVE	A1,*A0(OID),W		;SET ID
	MOVI	>FDFD0000,A1
	MOVE	A1,*A0(OPAL),L		;SET PALLETTE,COLOR
	MOVE	A8,*A0(OSHAD),L		;LINK TO SHADOWED OBJECT
	MOVE	A0,*A8(OSHAD),L		;LINK TO SHADOW
SHADSTX:
	MMFM	SP,A1
	RETS

**************************************************************************
*                                                                        *
* SHADUPD - SHADOW UPDATE						 *
* A8 = OBJECT								 *
*                                                                        *
**************************************************************************
SHADUPD
	PUSH	A0
	MOVE	*A8(OSHAD),A0,L
	JRZ	SHADUPDX
	CALLR	SHADCPY
SHADUPDX
	PULL	A0
	RETS
	
**************************************************************************
*                                                                        *
* SHADUPD2 - SHADOW UPDATE MULTI PART OBJECT				 *
* A8 = OBJECT								 *
*                                                                        *
**************************************************************************
;SHADUPD2
;	PUSH	A0
;	MOVE	*A8(OSHAD),A0,L
;	JRZ	SHADUP2X
;	CALLR	SHADCPY2
;SHADUP2X
;	PULL	A0
;	RETS

**************************************************************************
*                                                                        *
* SHADCPY - COPIES OSAG,OIMG,OXVEL,OYVEL,OXVAL				 *
* 	  ADJUSTS OSIZE,OFSET,OYVAL,OXCLIP				 *
* A0 = PTR TO SHADOW OBJECT						 *
* A8 = PTR TO OBJECT BEING SHADOWED					 *
*                                                                        *
**************************************************************************
SHADCPY:
   	MMTM	SP,A1,A2,A3
	CALLR	SHADCPYG
SHADC1
	MOVE	A2,*A0(OYVAL),L
	MOVE	*A8(OIMG),*A0(OIMG),L
	MOVE	*A8(OZVAL),A1,L		;ADJUST Z IN BACK OF OBJECT
	SUBK	2,A1
	MOVE	A1,*A0(OZVAL),L
	MMFM	SP,A1,A2,A3
	RETS

**************************************************************************
*                                                                        *
* SHADCPY2 - COPIES OSAG,OIMG,OXVEL,OYVEL,OXVAL				 *
* 	   ADJUSTS OSIZE,OFSET,OYVAL,OXCLIP				 *
* 	   THIS CALL IS FOR A TORSO OBJECT, I.E. TWO OBJECT THIS	 *
* 	   ONE MOUNTED ON TOP OF THE OTHER, PLAYER ONLY.		 *
* A0 = PTR TO SHADOW OBJECT						 *
* A8 = PTR TO OBJECT BEING SHADOWED					 *
*                                                                        *
**************************************************************************
;SHADCPY2
;	MMTM	SP,A1,A2,A3,A4,A5
;	CALLR	SHADCPYG
;
;	SRA	2,A1			;A1 = DISTANCE_FROM_GROUND/4
;	SUBI	20000H,A1		;FUDGE FACTOR
;	SUB	A1,A2			;ADJUST Y POSITION OF SHADOW
;SHADC22
;	MOVE	A2,*A0(OYVAL),L
;	MOVE	*A8(OIMG),*A0(OIMG),L
;	MOVE	*A8(OZVAL),A1,L		;ADJUST Z IN BACK OF OBJECT
;	SUBK	2,A1
;	MOVE	A1,*A0(OZVAL),L
;	MMFM	SP,A1,A2,A3,A4,A5
;	RETS

*A SUBROUTINE OF SHADCPY AND SHADCPY2
*RETURNS
*A1 = DISTANCE OF THIS SHADOW FROM THE GROUND (32 BITS)
*A2 = SHADOW Y POSITION ON THE GROUND (32 BITS)
*A3 = 3/4 HEIGHT OF THE SHADOW
SHADCPYG
	MOVE	*A8(OZVEL),*A0(OZVEL),L
	MOVE	*A8(OSAG),*A0(OSAG),L
	MOVE	*A8(OXVEL),*A0(OXVEL),L
	MOVE	*A8(OXVAL),*A0(OXVAL),L
	MOVE	*A8(OSIZE),A1,L
	MOVY	A1,A2			;GET H/4
	CLR	A3			;SAVE H
	MOVY	A1,A3
	SRL	16,A2			;RUB-OUT OTHER GARBAGE
	CMPI	2,A2
	JRLE	SHDCPYG1
	SUBK	2,A2			;FUDGE-O-MATIC
SHDCPYG1
	CMPI	>A,A2
	JRHS	SHDCPYG2		;BR = BIG OBJECT
	MOVE	A1,*A0(OSIZE),L		;SMALL OBJECT, DONT REDUCE
*	SRL	2,A2			;NOW DIVIDE BY FOUR
*	SLL	16,A2			;BRING BACK TO PROPER SPOT
*	SUBXY	A2,A3			;3/4 H
	CLR	A3
	CLR	A2
	JRUC	SHDCPYG3
SHDCPYG2
	SRL	2,A2			;NOW DIVIDE BY FOUR
	SLL	16,A2			;BRING BACK TO PROPER SPOT
	SUBXY	A2,A3			;3/4 H
	MOVY	A2,A1			
	MOVE	A1,*A0(OSIZE),L		;STORE OUT NEW SIZE
	MOVE	A1,A2			;GET WIDTH
	ADDXY	A1,A2
	ADDXY	A1,A2			;MULTIPLY BY 3
SHDCPYG3
	ZEXT	A2,W			;WIPE OUT Y JIVE
	MOVE	A2,*A0(OXCLIP),W	;ADDITIONAL CLIPPING FACTOR
	PUSH	A4
	MOVE	*A8(OFLAGS),A1,L
	MOVE	A1,A4	
	SRL	4,A1			;SHIFT OFF FLAGS
	SLL	4,A1
	SLL	28,A4
	JRZ	SHAD1A			;BR = THIS DUDE'S NOT ON
	ADDK	8,A1			;SET CONSTANT WRITE NON-ZERO
SHAD1A
	PULL	A4
	BTST	B_FLIPV,A1
	JREQ	SHAD1
	NEG	A2			;NEGATE OFFSET
SHAD1:	SLL	16,A2	
	ADDXY	A2,A1			;ADD IN OFFSET
	MOVE	A1,*A0(OFLAGS),L
	MOVE	*A8(OYVAL),A2,L
	ADD	A3,A2
	CALLR	DFRMGRND
	SLL	16,A1
	ADD	A1,A2			;NOW ADD THE SHADOW TO GROUND ADJUSTMENT
	RETS
*
*CALC DISTANCE FROM GROUND
*A8=OBJECT
*A1 RET WITH HT ABOVE GROUND
*
DFRMGRND
	PUSH	A2
	MOVE	*A8(OSIZEY),A2,W
	MOVE	*A8(OYPOS),A1,W
	ADD	A2,A1
         NEG     A1
	MMFM	SP,A2
	RETS

*
* SORT OBJECT LIST IN Z:Y PRIORITY
*
YZSORT:
	MMTM	SP,A0,A1,A2,A4,A5,A7,A8
	MOVI	080000000H,A1	;LOWEST POSSIBLE Z
	MOVI	080000000H,A5	;LOWEST POSSIBLE Y
	MOVI	OBJLST,A0
	JRUC	YZLP
YZLP0:
	MOVE	*A2(OZVAL),A8,L		;TEST Z
	MOVE	*A2(OYVAL),A7,L		;TEST Y
	CMP   	A1,A8
	JRGT  	PRIOK
	JRLT	PRISWAP

	CMP	A5,A7
	JRGE	PRIOK
PRISWAP:
	PUSHST
	DINT
	MOVE  	A2,*A4,L
	MOVE  	*A2,*A0,L
	MOVE  	A0,*A2,L
	POPST
	MOVE  	A2,A4
	JRUC	YZLP
PRIOK:
	MOVE  	A0,A4
	MOVE  	A2,A0
	MOVE  	A8,A1
	MOVE	A7,A5
YZLP:
	MOVE	*A0,A2,L     	; CURRENT LINK IN A2, PREV IN A4
	JRNE  	YZLP0
	MMFM	SP,A0,A1,A2,A4,A5,A7,A8
	RETS
*                                                                        *
**************************************************************************
*
*TEST IF OBJECT ON SCREEN
*A8=OBJECT
*RETURNS EQ IF ON SCREEN
*
*ENTER HERE AND PROVIDE YOUR OWN SCREEN BOUNDRIES
SCRTSTG
	MMTM	SP,A0,A1,A2,A3
	JRUC	SCRTST1
*NORMAL SCREEN BOUNDRIES
SCRTST:
	MMTM	SP,A0,A1,A2,A3	

	MOVE	@SCRNTL,A2,L		;GET SCREEN TOP LEFT
	MOVE	@SCRNLR,A3,L		;GET SCREEN LOWER RT.
SCRTST1
	MOVE	*A8(OYPOS),A0,W
	MOVE	*A8(OXPOS),A1,W
	SLL	16,A0
	MOVX	A1,A0	       		;GET TOP LEFT OF OBJECT
	MOVE	@WORLDTL,A1,L
	SUBXY	A1,A0			;SUBTRACT OUT WORLD BASE
	MOVE	*A8(OSIZE),A1,L
	ADDXY	A0,A1			;GET LOWER RT OF OBJECT

	CMPXY	A3,A0			;IS IT LOWER THAN LOWER RT?
	JRYGE	SCRTF			;LOWER
	JRXGE	SCRTF			;TO THE RIGHT

	CMPXY	A2,A1
	JRYLE	SCRTF			;ABOVE...
	JRXLE	SCRTF			;TO THE LEFT..

	CLR	A0
	JRUC	SCRTX		;RETRUN EQ (ON SCREEN)
SCRTF:
	MOVK	1,A0
	MOVE	A0,A0		;RETURN NE (NOT ON SCREEN)
SCRTX:
	MMFM	SP,A0,A1,A2,A3
	RETS
*
*CLIP AN OBJECT
*INPUTS:
*A2=BOTTOM:RIGHT CLIP (RELATIVE TO CURRENT SIZE)
*A3=TOP:LEFT CLIP (RELATIVE TO CURRENT SIZE)
*A8=OBJECT BLOCK
*RETURNS
*NEW SAG,H,W,OFFSET,XCLIP IN OBJECT STRUCTURE
*ALL REGISTERS PRESERVED
*
CLIPOBJ:
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9,A11,A12
	MOVE	A8,A0
	MOVE	*A8(OXPOS),A4,W
	MOVE	*A8(OYPOS),A5,W
	ADDI	OFLAGS,A0  	;GET INDEX INTO OBJECT STRUCTURE

* 	a1 becomes OFFSET
*	a6= TOTAL HORIZ. SIZE
*	A9= VS:HS
*	A11= SAG
*	A12= OFFSET:FLAGS

	MMFM	A0,A9,A11,A12
	MOVE	*A8(OXCLIP),A7
	CLR	A6
	MOVX	A9,A6		;GET TOTAL HORIZ SIZE
	ADD	A3,A2		;LC+RC
	SUBXY	A2,A9		;DECREASE H,W BY XCLIP,YCLIP
*
*CLIP THE SAG, HS, VS, AND ADJUST OFFSET
*	
	MOVX	A3,A1		;GET LEFT CLIP
	SEXT	A1,W
	ADD	A1,A4		;ADJUST OXPOS
	SRA	16,A3		;GET TOP CLIP
	ADD	A3,A5		;ADJUST OYPOS
	JREQ	OCLIP1
	ADD	A7,A6		;ADD PRECLIP TO THE WIDTH TO CALC NEW SAG
	MPYS	A6,A3		;TOP CLIP X TOTAL HORIZ SIZE
OCLIP1:
	ADDXY	A2,A7
	ZEXT	A7,W		;NEW OXCLIP
	SLL	16,A2
	BTST	B_FLIPH,A12
	JREQ	OCLIP2
	NEG	A2		;NEGATE RC+LC
	NEG	A1		;NEGATE LC
OCLIP2:
	BTST	B_FLIPV,A12
	JREQ	OCLIP3
	NEG	A3		;NEGATE	THS*TC
OCLIP3:
	ADD	A1,A3		;ADD LEFT CLIP TERM +  TC*THS
	SLL	3,A3
	ADD	A3,A11		;ADD TO SAG
	ADD	A2,A12		;ADD CLIP OFFSET TO OFFSET
	PUSHST
	DINT
	MMTM	A0,A9,A11,A12
	MOVE	A4,*A8(OXPOS),W
	MOVE	A5,*A8(OYPOS),W
	MOVE	A7,*A8(OXCLIP),W	;NEW OXCLIP
	POPST
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9,A11,A12
	RETS
	
**************************************************************************
*                                                                        *
* OBJECT BLOCK INITIALIZATION ROUTINES					 *
*                                                                        *
**************************************************************************

**************************************************************************
*                                                                        *
* OINIT - INITIALIZE FREE LIST						               *
*                                                                        *
**************************************************************************
OINIT:
	MMTM	SP,A0,A1,A2,A3	;SAVE REG		
	CLR	B13		;CLEAR OUT DMA DEDICATED REGISTERS
	CLR	B14	
	MOVI	NOBJ,A3,W	 ;# OF OBJECT BLOCKS TO INIT

	MOVI	SCRNST,A0,L	;INIT SCREEN TOP LEFT [Y,X]
	MOVE	A0,@SCRNTL,L
	MOVI	SCRNEND,A0,L	;INIT SCREEN LOWER RIGHT [Y,X]
	MOVE	A0,@SCRNLR,L

	PUSHST
	DINT
	MOVE	@INTENB,A0,W
	ANDNI	X1E,A0		;NO MORE DMA INTERRUPTS
	MOVE	A0,@INTENB,W
	POPST

	CLR     A0
;	MOVE	A0,@SKIPDMA,W
	MOVE	A0,@WORLDTLY,L
;	MOVE	A0,@BAK2TLY,L
	MOVE	A0,@WORLDTLX,L
;	MOVE	A0,@BAK2TLX,L
	MOVE	A0,@WORLDTL,L
;	MOVE	A0,@DMAQCNT,W		;CLEAR CURRENT DMAQ COUNT
;        MOVE	A0,@BOTQ0CNT,W		;CLEAR BOTTOM QUEUE COUNT #0
;	MOVE	A0,@BOTQ1CNT,W		;CLEAR BOTTOM QUEUE COUNT #1
;	MOVE	A0,@TOPQ0CNT,W		;CLEAR TOP QUEUE COUNT #0
;	MOVE	A0,@TOPQ1CNT,W		;CLEAR TOP QUEUE COUNT #1

;	MOVI	DMAQ+QSIZE,A1
;	MOVE	A1,@DMAQCUR,L		;INIT MISC DMA QUEUE
	
	MOVE	A0,@SCROLLX,L	;CLEAR SCROLLX
	MOVE	A0,@SCROLLY,L	;CLEAR SCROLLX

	MOVE	A0,@BAK2LST,L	;NULL BACKGROUND 2 OBJECT LIST
	MOVE	A0,@BAKLST,L	;NULL BACKGROUND OBJECT LIST
	MOVE	A0,@OBJLST,L	;NULL OBJECT LIST
	MOVI	OBJSTR,A1,L
	MOVE	A1,@OFREE,L	;SETUP FREE LIST
oinitl: 
	MOVE	A1,A2
	ADDI	OBSIZ,A1,W
	MOVE	A1,*A2,L		;LINK EM UP
	DSJS	A3,oinitl		;CONTINUE FOR NPROC
    	MOVE	A0,*A2,L		;ZERO LAST LINK
	MMFM	SP,A0,A1,A2,A3	;RESTORE REGS
	RETS

**************************************************************************
*                                                                        *
* GETOBJ - GET A FREE OBJECT BLOCK FOR USE				               *
* RETURNS								               *
* A0 = PTR TO OBJECT BLOCK						               *
* IF NO BLOCKS WERE AVAILABLE THEN THE Z FLAG IS SET			          *
*                                                                        *
**************************************************************************
GETOBJ:
	MMTM	SP,A1,A2
 	MOVE  	@OFREE,A0,L	; pointer to next available obj block
	jreq  	getox
	move  	*A0,A2,L
	move  	A2,@OFREE,L	; adjust pointer to free list
	CLR	A2	       	; CLEAR OUT THE SHIT
	MOVI	(OBSIZ/16)-2,A1
	ADDK	32,A0
	SRL	1,A1
	JRNC	GETOBJ1
	MOVE	A2,*A0+,W
GETOBJ1
	MOVE	A2,*A0+,L
	DSJS	A1,GETOBJ1
	SUBI	OBSIZ,A0    		;RESTORE A0, SET NON ZERO FLAG
getox:		
	MMFM	SP,A1,A2	  	;DONT SCREW UP Z-FLAG
	RETS

**************************************************************************
*                                                                        *
* FREEOBJ - PUT AN OBJECT BLOCK BACK ON THE FREE LIST			 *
* A0 = POINTER TO OBJECT BLOCK						 *
*                                                                        *
**************************************************************************
*
*FREE OBJECT AND SHADOW OBJECT
*
;FREESOBJ
;	PUSH	A0
;	MOVE	*A0(OSHAD),A0,L
;	JREQ	FREENSHD
;	CALLR	FREEOBJ
;FREENSHD
;	PULL	A0
;	JRUC	FREEOBJ
*
*FREE OBJECT WITH ERROR CHECKING
*
FREEOBJE
	MMTM	SP,A1,A2
	CMPI	OBJSTR,A0
	JRHS	FREEE1
	LOCKUP
*	CALLERR	2		        ;PTR TOO LOW
	JRUC	FREERRX
FREEE1
	CMPI	OBJLSTND,A0
	JRLO	FREEE2
*      	CALLERR	2			;PTR TOO HIGH
	LOCKUP
	JRUC	FREERRX
FREEE2
	MOVE	A0,A2
	SUBI	OBJSTR,A2
	MOVI	OBSIZ,A1
	MODU	A1,A2
	JRZ	FREEE3
*	CALLERR	2			;PTR NOT VALID
	LOCKUP
	JRUC	FREERRX	
FREEE3
	CALLR	ISOBJ
	JREQ	FREEE4
*	CALLERR	2			;OBJECT IS ON THE ACTIVE LIST
	LOCKUP
	JRUC	FREERRX
FREEE4
	CALLR	ISFREE
	JREQ	FREEEC
*	CALLERR	2			;OBJECT IS ALREADY ON THE FREE LIST
	LOCKUP
FREERRX
	MMFM	SP,A1,A2		;EXIT WITH ERROR
	RETS
FREEEC
	MMFM	SP,A1,A2		;EVERYTHING IS O.K. CONTINUE TO FREEOBJ
*
*MAIN FREE OBJECT ENTRY
FREEOBJ
	PUSH	A2
	MOVE	@OFREE,A2,L				
	MOVE	A2,*A0,L
	MOVE	A0,@OFREE,L		;BLOCK IS ON FREE LIST NOW
	PULL	A2
	RETS


*
*	INSERT AN OBJECT BLOCK INTO AN OBJECT LIST
*	List is sorted by increasing Z and increasing Y within constant Z
*
*	Block to be inserted in A0
*
*INSERT BACKGROUND 2 OBJECT (SORTED)
INSB2OBJ:
	mmtm 	sp,a1,a2,a3,a4,a5
	movi  	BAK2LST,a4
	JRUC	INSOBJ0
*INSERT BACKGROUND OBJECT (SORTED)
INSBOBJ:
	mmtm 	sp,a1,a2,a3,a4,a5
	movi  	BAKLST,a4
	JRUC	INSOBJ0
*INSERT OBJECT AND SHADOW
INSSOBJ
	PUSH	A0
	MOVE	*A0(OSHAD),A0,L
	JREQ	INSNSHD
       	CALLR	INSOBJ
INSNSHD
	PULL	A0
*INSERT FOREGROUND OBJECT
INSOBJ:
	mmtm 	sp,a1,a2,a3,a4,a5
	movi  	OBJLST,a4
INSOBJ0:
	move 	*A0(OZVAL),A1,L		; GET Z POSITION
	MOVE	*A0(OYVAL),A5,L		; GET Y POSITION
ins_loop:
	move 	a4,a2			; ptr to PREV in a2
	move 	*a2,a4,L		; ptr to NEXT in a4
	jreq 	INS_AT_END		; bra if at end of list
	MOVE 	*A4(OZVAL),A3,L		; ZPOS in A3
	CMP  	A3,A1
	jrgt 	ins_loop
	JRLT	INS_AT_END

	MOVE	*A4(OYVAL),A3,L		;TEST Y POSITION
	CMP	A3,A5
	JRGT	ins_loop
INS_AT_END:
	move 	a4,*a0,L		; put NEXT link in new block
	move 	a0,*a2,L		; put link to new in PREV block
	mmfm 	sp,a1,a2,a3,a4,a5
	rets
*
*	DELETE AN OBJECT BLOCK FROM THE OBJECT LIST
*
*	Block to be deleted in A0
*
*DELETE BACKGROUND OBJECT
DELB2OBJ:
	mmtm	sp,a2,a4
	movi	BAK2LST,a4
	JRUC	del_loop
*DELETE BACKGROUND OBJECT
DELBOBJ:
	mmtm	sp,a2,a4
	movi	BAKLST,a4
	JRUC	del_loop
*DELETE SHADOW
*A0 = PTR TO OBJECT THAT CREATED THE SHADOW
DELSHAD
	MMTM	SP,A0,A1,A2
	MOVE	*A0(OSHAD),A1,L
	JREQ	DELSHADX 		;BR = NO SHADOW EXISTS
	CLR	A2
	MOVE	A2,*A0(OSHAD),L		;NO MORE SHADOW RECOG.
	MOVE	A1,A0
	CALLR	DELOBJ
DELSHADX
	MMFM	SP,A0,A1,A2
	RETS

*DELETE OBJECT WITH SHADOW
DELSOBJ
	PUSH	A0
	MOVE	*A0(OSHAD),A0,L
	JREQ	DELNSOBJ
	CALLR	DELOBJ
DELNSOBJ
	PULL	A0
*DELETE FOREGROUND OBJECT
DELOBJ:
	MMTM	SP,A0,A2,A3,A4,A8
	MOVI	OBJLST,A4
del_loop:
	move	a4,a2	   	; ptr to PREV in a2
	move	*a2,a4,L   	; ptr to NEXT in a4
	JRNZ	DEL_CHK
 	LOCKUP
*	CALLERR	5		;REPORT THE PROBLEM
	JRUC	DELOBJX
***no_del:
***	jreq	no_del	   	; ERROR if at end of list (HANG UP)
DEL_CHK
	cmp	a4,a0
	jrne	del_loop
	
	move	*a0,*a2,L  	; put NEXT link in PREV block
	move	@OFREE,a2,L				
	move	a2,*a0,L
	move	a0,@OFREE,L	; Return deleted block to free stack

DELOBJX
	MMFM	SP,A0,A2,A3,A4,A8
	RETS
**************************************************************************
*                                                                        *
* KILL A CLASS OF OBJECTS						 *
* A0=OID (16 BITS) ,A1=MASK (16 BITS)					 *
* MASK BITS OF ZERO ARE DONT CARES					 *
*                                                                        *
**************************************************************************
*KILL A CLASS FROM THE BACKGROUND
KILB2OBJ
	MMTM	SP,A0,A2,A3,A4,A5
	MOVI	BAK2LST,A2,L
	JRUC	KILGEN
*KILL A CLASS FROM THE BACKGROUND
KILBOBJ
	MMTM	SP,A0,A2,A3,A4,A5
	MOVI	BAKLST,A2,L
	JRUC	KILGEN
*KILL A CLASS FROM THE OBJECT LIST
KILOBJ
	MMTM	SP,A0,A2,A3,A4,A5
	MOVI	OBJLST,A2,L

KILGEN
	AND	A1,A0		;FORM MATCH

KILOBP:	
	MOVE	A2,A3		;SAVE PREVIOUS
	MOVE	*A2,A2,L	;GET NEXT
	JREQ	KILOBX		;ALL DONE
	MOVE	*A2(OID),A4
	AND	A1,A4		;CAN DONT CARE BITS
	CMP	A0,A4		;MATCH?
	JRNE	KILOBP		;NO

	MOVE	*A2,*A3,L	;LINK AROUND IN ACTIVE LIST	
	MOVE	@OFREE,A5,L	;LINK INTO FREE LIST AT START
	MOVE	A5,*A2,L
	MOVE	A2,@OFREE,L	;POINT FREE TO CELL
	MOVE	A3,A2
	JRUC	KILOBP		;KILL THE REST
KILOBX:	
	MMFM	SP,A0,A2,A3,A4,A5
	RETS

**************************************************************************
*                                                                        *
* EXISTOBJ - DOES AN OBJECT FROM A CERTAIN CLASS EXIST?			     *
* A0 = OID								               *
* A1 = MASK(0'S DON'T CARE)						               *
* RETURNS:								               *
* 	Z BIT SET = NO OBJECT, A0 = 0					          *
* 	Z BIT CLR = NO OBJECT, A0 = PTR TO OBJECT			          *
*                                                                        *
**************************************************************************
EXISTOBJ:	
	MMTM	SP,A2,A3
         SEXT    A0
	MOVI	OBJLST,A2,L
	AND	A1,A0		;FORM MATCH
EXISTOBP:	
	MOVE	*A2,A2,L	;GET NEXT
	JREQ	EXISTOBX	;ALL DONE
	MOVE	*A2(OID),A3,W
	AND	A1,A3		;CAN DONT CARE BITS
	CMP	A0,A3		;MATCH?
	JRNE	EXISTOBP	;NO
EXISTOBX:
	MOVE	A2,A0
	MMFM	SP,A2,A3
	RETS

**************************************************************************
*                                                                        *
* ISOBJ - IS AN OBJECT ON THE OBJECT LIST?				 *
* A0 = PTR TO OBJECT							 *
* RETURNS:								 *
* 	Z BIT SET = NO OBJECT, A0 = 0					 *
* 	Z BIT CLR = NO OBJECT, A0 = PTR TO OBJECT			 *
*                                                                        *
**************************************************************************
ISOBJ:	
	PUSH	A2
	MOVI	OBJLST,A2,L
	JRUC	ISOBP
**************************************************************************
*                                                                        *
* ISFREE - IS AN OBJECT ON THE FREE LIST?				 *
* A0 = PTR TO OBJECT							 *
* RETURNS:								 *
* 	Z BIT SET = NO OBJECT, A0 = 0					 *
* 	Z BIT CLR = NO OBJECT, A0 = PTR TO OBJECT			 *
*                                                                        *
**************************************************************************
ISFREE:	
	PUSH	A2
	MOVI	OFREE,A2,L
	JRUC	ISOBP
ISOBP:	
	MOVE	*A2,A2,L	;GET NEXT
	JREQ	ISOBX		;ALL DONE
	CMP	A0,A2		;OBJECT?
	JRNE	ISOBP		;NO
	MOVE	A0,A0		;CLR Z BIT
ISOBX:
	PULL	A2
	RETS

*
*MAKE AN OBJECT
*RETURN(S)
*A0 = OBJECT BLOCK PTR
*A14 = POINTS TO THE INITIALIZATION TABLE
*
;MAKOBJ	CALLA	GETOBJ
;	JRZ	MAKOBX		;NONE LEFT
;	CALLR	STFOBJ	
;	CALLR	INSOBJ
;	MOVE	A0,A0		;RETURN NON-ZERO
;MAKOBX	RETS

**************************************************************************
*                                                                        *
* ADJSTWTL - ADJUST THE OBJECT'S COORDINATES IN RELATION TO THE		 *
* 	   WORLD. IT IS ASSUMED THAT THE CURRENT COORDINATES		 *
* 	   ARE SCREEN RELATIVE.						 *
* A0 = PTR TO THE OBJECT BLOCK						 *
*                                                                        *
**************************************************************************
ADJSTWTL
	MMTM	SP,A3,A5
	MOVE	@WORLDTLX,A5,L
	MOVE	*A0(OXVAL),A3,L
	ADD	A5,A3
	MOVE	A3,*A0(OXVAL),L
	MOVE	@WORLDTLY,A5,L
	MOVE	*A0(OYVAL),A3,L
	ADD	A5,A3
	MOVE	A3,*A0(OYVAL),L
	MMFM	SP,A3,A5
	RETS
**************************************************************************
*                                                                        *
* ADJNEWTL - ADJUST AN OBJECT TO A NEW SET OF X,Y WORLD COORDINATES	 *
* 	   BEFORE THEY ARE STORED(TAKE EFFECT).				 *
* NOTE: CURRENT OBJECT COORDS. MUST BE ABSOLUTE WORLD.			 *
* A0 = PTR TO OBJECT							 *
* A4 = NEW WTLX, 32 BITS						 *
* A5 = NEW WTLY, 32 BITS						 *
*                                                                        *
**************************************************************************
ADJNEWTL
	MMTM	SP,A1,A2
	CALLR	GSCRNREL		;SCREEN RELATIVE PLEASE
	ADD	A4,A1
	ADD	A5,A2			;ADJUST
	MOVE	A1,*A0(OXVAL),L
	MOVE	A2,*A0(OYVAL),L		;STORE
	MMFM	SP,A1,A2
	RETS
**************************************************************************
*                                                                        *
* GSCRNREL - GET THE SCREEN RELATIVE X,Y COORDINATES OF AN OBJECT	 *
* 	   IT IS ASSUMED THATE THE CURRENT X,Y COORDINATES ARE		 *
* 	   WORLD ABSOLUTE.						 *
* A0 = PTR TO THE OBJECT BLOCK						 *
* RETURNS								 *
* A1 = X SCREEN RELATIVE, 32 BITS					 *
* A2 = Y SCREEN RELATIVE, 32 BITS					 *
*                                                                        *
**************************************************************************
GSCRNREL
	PUSH	A5
	MOVE	@WORLDTLX,A5,L
	MOVE	*A0(OXVAL),A1,L
	SUB	A5,A1
	MOVE	@WORLDTLY,A5,L
	MOVE	*A0(OYVAL),A2,L
	SUB	A5,A2
	PULL	A5
	RETS

**************************************************************************
*                                                                        *
* SCRNRELV - MAKE THE X & Y VELOCITIES OF AN OBJECT RELATIVE TO THE	     *
* 	   SCREEN. IN OTHER WORDS, ADJUST THEM SO THAT THE CURRENT	     *
* 	   SCROLL RATE DOESN'T AFFECT THEM. 				          *
* A0 = PTR TO OBJECT							               *
*                                                                        *
**************************************************************************
SCRNRELV
	MMTM	SP,A1,A5
	MOVE	@SCROLLX,A5,L
	MOVE	*A0(OXVEL),A1,L
	ADD	A5,A1
	MOVE	A1,*A0(OXVEL),L
	MOVE	@SCROLLY,A5,L
	MOVE	*A0(OYVEL),A1,L
	ADD	A5,A1
	MOVE	A1,*A0(OYVEL),L
	MMFM	SP,A1,A5
	RETS

**************************************************************************
*                                                                        *
* GANISAG - ADJUST CURRENT OBJECT IMAGE WITH RESPECT TO IT'S		     *
* 	   ANIMATION PNT. AND FLIP FLAGS 				               *
* NOTE: CALL ONLY AFTER INITIALIZING WITH STFOBJ, OR SOMETHING.	     *
* A0 = PTR TO OBJECT BLOCK						               *
* A2 = NEW OYVAL							                    *
* A3 = NEW OXVAL							                    *
* A4 = NEW FLAGS							                    *
* RETURNS								               *
* A2 = ADJUSTED OYVAL							               *
* A3 = ADJUSTED OXVAL							               *
*                                                                        *
**************************************************************************
GANISAG
	MMTM	SP,A1,A4,A6,A7
	MMTM	SP,A2,A3
	MOVE	*A0(OIMG),A1,L
	CALLR	GSAGOF
	MOVE	A3,*A0(OSAG),L
	MOVE	A2,*A0(OSIZE),L
	MOVE	A4,*A0(OFLAGS),L
	CALLR	GANIOF
	MMFM	SP,A2,A3
	SUB	A6,A3	
	SUB	A7,A2			;ADJUST UPPER LEFT CORNER
	MOVE	A3,*A0(OXVAL),L
	MOVE	A2,*A0(OYVAL),L
	MMFM	SP,A1,A4,A6,A7
	RETS


**************************************************************************
*                                                                        *
*  STRTOBJ - START AN OBJECT USING AN INITIALIZATION TABLE               *
*  A0  = PTR TO THE IMAGE				                         *
*  A14 = PTR TO INIT. TABLE			                              *
*                                                                        *
*  START OBJECT INIT. TABLE FORMAT                                       *
*          .WORD	X,Y,Z                                                   *
*          .LONG	OIMG,OZSIZ,OCVECT                                       *
*          .WORD	OFLAGS,OID                                              *
*                                                                        *
*   RETURNS  A14 = POINTING TO WORD AFTER INIT TAB	                    *
*                                                                        *
**************************************************************************
STRTOBJ
	MMTM	SP,A1,A2,A3,A4,A6,A7,A9,A10
	MOVE	*A14+,A9,W 		;GET OXPOS
	SLL	16,A9			;CONVERT TO OXVAL
	MOVE	*A14+,A10,W		;GET OYPOS
	SLL	16,A10			;CONVERT TO OYVAL
	MOVE	*A14+,A1,W
	MOVE	A1,*A0(OZPOS),W
	JRUC	STFOBJ0

**************************************************************************
*                                                                        *
* STFOBJ - STUFF AN OBJECT USING AN INITIALIZATION TABLE		          *
* A0  = PTR TO THE IMAGE						                    *
* A14 = PTR TO INIT. TABLE						               *
* INIT. TABLE:								               *
* 	.LONG	OXVEL,OYVEL,OXVAL,XYVAL					          *
* 	.WORD	OZVEL,OZPOS						               *
* 	.LONG	OIMG,OZSIZ,OCVECT					               *
* 	.WORD	OFLAGS,OID						               *
* 	.LONG	OBLIPIMG						               *
* RETURNS								               *
* A14 = POINTING TO WORD AFTER INIT TAB					          *
*                                                                        *
**************************************************************************
STFOBJ
	MMTM	SP,A1,A2,A3,A4,A6,A7,A9,A10

	MOVE	*A14+,A1,L	;XVEL
	MOVE	A1,*A0(OXVEL),L
	MOVE	*A14+,A1,L	;YVEL
	MOVE	A1,*A0(OYVEL),L

	MOVE	*A14+,A9,L	;XVAL
	MOVE	*A14+,A10,L	;YVAL

	MOVE	*A14+,A1,L	;ZVEL:ZPOS

	CLR	A2		;SPLIT UP OZPOS:OZVEL
	MOVY	A1,A2
	SLL	16,A1
	MOVE	A1,*A0(OZVEL),L
	MOVE	A2,*A0(OZVAL),L
STFOBJ0:	
	MOVE	*A14+,A1,L	;IMG
	MOVE	A1,*A0(OIMG),L
	MOVE	*A14+,A2,L	;ZSIZE
	MOVE	A2,*A0(OZSIZ),L
	MOVE	*A14+,A2,L	;CVECT
	MOVE	A2,*A0(OCVECT),L
	MOVE	*A14+,A4,W	;FLAGS
	MOVE	*A14+,A2,W	;OID
	MOVE	A2,*A0(OID),W

*	MOVE	*A14+,A2,L	;GET THE SCANNER BLIP IMAGE
*	MOVE	A2,*A0(OBLIPIMG),L
*	MOVE	@CURPAL,A2,W		;OCONST:OPAL
*	MOVE	A2,*A0(OPAL),W

STFOBJ1
	CALLR	GSAGOF
	CALLR	GANIOF		;ADJUST ANIMATION OFFSET
	SUB	A6,A9		;SUBTRACT X ANIOFF
	SUB	A7,A10		;SUBTRACT Y ANIOFF
	MOVE	A9,*A0(OXVAL),L
	MOVE	A10,*A0(OYVAL),L
;	MOVE	A1,*A0(OIMG),L       ; REDUNDANT ?
	MOVE	A3,*A0(OSAG),L
	MOVE	A2,*A0(OSIZE),L
	MOVE	A4,*A0(OFLAGS),L
	MMFM	SP,A1,A2,A3,A4,A6,A7,A9,A10
	RETS

*
*GET SAG FOR OBJECT - ADJUSTS SAG FOR FLIP
*CALLING PARAMETERS:
*A1=PTR TO IMAGE HEADER (OIMG)
*A4=OBJECT FLAGS
*RETURNS:
*A2=RETURNED WITH NEW OSIZE
*A3=RETURNED WITH NEW SAG
*A4=RETURNED WITH NEW OFFSET:OFLAGS
*
GSAGOF:
	MMTM	SP,A5,A6,A7
	ZEXT	A4,W		;ZERO OFFSET IN A4
	MOVE	*A1(ISAG),A3,L	;GET TOP LEFT SAG
	MOVE	*A1(ISIZE),A2,L
	CLR	A5
	MOVX	A2,A5
	ADDK	3,A5		;ADJUST HOR SIZE FOR MORSEL
	SRL	2,A5
	SLL	2,A5
	MOVX	A5,A2
	SLL	3,A5		;ADJUST FOR BYTE ADDRESS

*HORIZONTAL FLIP CASE
GSAGH:
	BTST	B_FLIPH,A4
	JREQ	GSAGV		;NO H FLIP, TRY VERT FLIP
	MOVE	A5,A6
	SUBK	8,A6
	ADD	A6,A3		;ADD THS-1 TO SAG

	MOVX	A2,A6
	SLL	1,A6
	DEC	A6		;2*THS-1 TO OFFSET
	SLL	16,A6		;ADJUST FOR B16-31
	ADDXY	A6,A4
	
*VERTICAL FLIP CASE
GSAGV:
	BTST	B_FLIPV,A4
	JREQ	GSAGX		;NO VERT FLIP 
	MOVY	A2,A6		;GET HEIGHT
	SRL	16,A6
	DEC	A6		;FIRST ENTRY LAST ROW
	MOVE	A5,A7  		;GET THS
	MPYS	A6,A7		;THS*(TVS-1)
	ADD	A7,A3		;ADD TO SAG

	MOVX	A2,A6
	SLL	1,A6
	NEG	A6		;-2*THS
	SLL	16,A6		;ADJUST FOR B16-31
	ADDXY	A6,A4		;ADD TO OFFSET
GSAGX:
	MMFM	SP,A5,A6,A7
	RETS

**************************************************************************
*                                                                        *
* ANI2 - ANI ROUTINE FOR THE 2nd(TOP) PART OF A TWO PART OBJECT.	 *
*	 THIS IS FOR A TWO PART PLAYER ONLY!				 *
* 									 *
* A1 = NEW IMAGE POINTER						 *
* A2 = PTR TO PLAYER DATA STRUCTURE					 *
* A4 = NEW FLAGS							 *
* A8 = OBJECT STRUCTURE TO BE UPDATED					 *
* A14 = POINTER TO PART 1'S SHADOW					 *
*                                                                        *
**************************************************************************
ANI2
	MMTM	SP,A0,A2,A3,A4,A5,A6,A7,A9,A11
	MOVK	1,A11			;FLAG FOR SPECIAL SHADOW ROUTINE
	JRUC	ANIG

**************************************************************************
*                                                                        *
* ANI - ANIMATION SUBROUTINE						               *
* A1=NEW IMAGE POINTER							               *
* A4=NEW OFLAGS								               *
* A8=OBJECT STRUCTURE POINTER TO BE UPDATED				          *
* A11 = SHADOW ROUTINE FLAG. 0 = USE SHADCPY, 1 = USE SHADCPY2		     *
* IF A11 = 1 THEN A14 = PTR TO PART 1'S SHADOW				          *
*                                                                        *
**************************************************************************
ANI0:				      	;ENTRY FOR NO REPEAT CHECK	     				
	MMTM	SP,A0,A2,A3,A4,A5,A6,A7,A9,A11
	CLR	A11
	MOVE	*A8(OFLAGS),A5,W
	MOVE	*A8(OIMG),A2,L
	JRUC	ANIG1
ANI: 
	MMTM	SP,A0,A2,A3,A4,A5,A6,A7,A9,A11
	CLR	A11
ANIG
	MOVE	*A8(OFLAGS),A5,W
	MOVE	*A8(OIMG),A3,L
	CMP	A1,A3
	JRNE	ANIG1		          ; BR = NOT THE SAME IMAGE AS LAST TIME

	ZEXT	A4
	ZEXT	A5
	CMP	A4,A5
	JREQ	ANIG2		;BR = EVERY THING IS THE SAME
ANIG1
	SWAP	A4,A5
	SWAP	A1,A3
	MOVE	*A8(OSIZE),A2,L
	CALLR	GANIOF		;GET OLD ANIMATION OFFSET
	MMTM	SP,A6,A7
	MOVE	A5,A4		;NEW OFLAGS
	MOVE	A3,A1		;NEW OIMG

	CALLR	GSAGOF		;GET SAG, OFFSET, HW
	CALLR	GANIOF		;GET NEW ANIMATION OFFSET
	MMFM	SP,A0,A5	;BRING BACK OLD ANIMATION DELTA
	SUB	A6,A0		;SUBTRACT NEW FROM OLD
	SUB	A7,A5

	MOVE	A8,A9	   		;GET PUSH ADDRESS OF OFLAGS,OSAG,OSIZE
	ADDI	OFLAGS+>60,A9
	CLR	A7
	MOVE	A7,*A8(OXCLIP),W	;CLEAR PRECLIP
	MMTM	A9,A2,A3,A4		;BLOW THIS STUFF OUT
	MOVE	A1,*A8(OIMG),L

	MOVE	*A8(OYVAL),A6,L
	ADD	A5,A6	       		;ADJUST OYVAL, OXVAL FOR DELTA X
	MOVE	A6,*A8(OYVAL),L
	MOVE	*A8(OXVAL),A7,L
	ADD	A0,A7
	MOVE	A7,*A8(OXVAL),L

	MOVE	*A8(OSHAD),A0,L
	JREQ	ANINSHD			;BR = NO SHADOWS HERE

;	MOVE	A11,A11			;CHECK A11
;	JREQ	ANISHAD
;	CALLR	SHADCPY2		;SHADOW FOR PART 2	
;	JRUC	ANINSHD
;ANISHAD

	CALLR	SHADCPY			;SHADOW FOR PART 1	 
ANINSHD
ANIGX
	MMFM	SP,A0,A2,A3,A4,A5,A6,A7,A9,A11
	RETS

ANIG2
	MOVE	*A8(OSHAD),A0,L
	JREQ	ANINSHD			;BR = NO SHADOWS HERE

*	MOVE	*A8(OZVEL),*A0(OYVEL),L
	MOVE	*A8(OZVEL),*A0(OZVEL),L
	MOVE	*A8(OXVEL),*A0(OXVEL),L	;COPY JUST THE VELOCITIES

	JRUC	ANIGX

**************************************************************************
*                                                                        *
* GETANIXY - GET THE X AND Y POSITIONS OF AN OBJECTS ANIMATION		     *
* 	   POINT.							               *
* A8 = OBLOCK PTR.							               *
* RETURNS								               *
* A2 = APOINT OYVAL, 32 BITS						               *
* A3 = APOINT OXVAL, 32 BITS						               *
*                                                                        *
**************************************************************************
GETANIXY
	MMTM	SP,A1,A4,A6,A7
	MOVE	*A8(OIMG),A1,L
	MOVE	*A8(OSIZE),A2,L
	MOVE	*A8(OFLAGS),A4,W
	CALLR	GANIOF
	MOVE	*A8(OXVAL),A3,L
	MOVE	*A8(OYVAL),A2,L
	ADD	A6,A3
	ADD	A7,A2
	MMFM	SP,A1,A4,A6,A7
	RETS
*
*GET ANIMATION OFFSET
*A1=OIMG, A2=H:W, A4=OFLAGS
*
*OUTPUT: 
*A6=X ANIMATION OFFSET X 64K
*A7=Y ANIMATION OFFSET X 64K
GANIOF:	
	MMTM	SP,A2,A3
	MOVE	*A1(IANIOFF),A6,L		
	CLR	A7		;MAKE SURE A7 IS 0
	MOVY	A6,A7
	SLL	16,A6		;MOVE TO UPPER WORD		
	SUBI	>00010001,A2	;ADJUST FOR -1
	CLR	A3
	MOVY	A2,A3
	SLL	16,A2		;MOVE TO UPPER WORD
	BTST	B_FLIPH,A4
         JRZ	GANI1
	NEG	A6
	ADD	A2,A6		;SUB THS-1 FOR H-FLIP
GANI1:
	BTST	B_FLIPV,A4
	JRZ	GANI2
	NEG	A7
	ADD	A3,A7		;SUB TVS-1 FOR V-FLIP
GANI2:
	MMFM	SP,A2,A3
	RETS

	.END

