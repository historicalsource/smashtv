****************  U P D A T E   D I S P   L I S T **********************
;* deletes all display objects which are not on the screen
;* insures all background blocks on screen are on the disp list
BGND_UD1:		;* call to update main background
;* input, WORLDTL, SCRNTL, SCRNLR, BAKLST, BAKBITS, BAKMODS
	;* this protects DISP_MOD and DISP_DEL TOO!
	mmtm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14
	mmtm	SP,B0

	;* Get coors of area to be put on display list.
	move	@WORLDTL,A3,1
	move	A3,A4
	move	@SCRNTL,A0,1
	addxy	A0,A3 		
	move	@SCRNLR,A0,1
	addxy	A0,A4		
	movi	DISP_PAD,A0
	subxy	A0,A3		;A3 - disp_tl
	addxy	A0,A4		;A4 - disp_lr
	movi	BAKLST,A8	;A8 - bakground list
	callr	DISP_DEL

	;* determine which module
	move	@BAKMODS,A0,L		;A0- ptr to the module list
	movi	INSBOBJ,B0		;B0 - which insert routine
	movi	BAKBITS,A7		;A7 - bit table for block being on disp list
	callr	DISP_MOD
	mmfm	SP,B0
	mmfm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14
	rets

BGND_UD2:		;* call to update secondary background
;* input, BAK2TLX, BAK2TLY, SCRNTL, SCRNLR, BAK2LST, BAK2BITS, BAK2MODS
	mmtm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14
	mmtm	SP,B0
	;* Get coors of area to be put on display list.
	move	@BAK2TLX+16,A3,W
	move	@BAK2TLY+16,A0,W
	sll	16,A0
	movy	A0,A3
	move	A3,A4
	move	@SCRNTL,A0,L
	addxy	A0,A3 		
	move	@SCRNLR,A0,L
	addxy	A0,A4		
	movi	DISP_PAD,A0
	subxy	A0,A3		;A3 = disp_tl
	addxy	A0,A4		;A4 = disp_lr
	movi	BAK2LST,A8   		;A8 - bakground list
	callr	DISP_DEL

	movi	INSB2OBJ,B0		;B0 - which insert routine
	move	@BAK2MODS,A0,L		;* A0- ptr to the module list
	movi	BAK2BITS,A7
	callr	DISP_MOD
	mmfm	SP,B0
	mmfm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14
	rets
***********************************************************************


*********************** D I S P   M O D *******************************
;* Scan a Module list to find out which modules contain blocks
;* which need to be checked for addition to the display list.
;	B0 - which insert routine
;	A0 - Module list
;	A3 - disp_tl
;	A4 - disp_lr
;	A7 - BAKBITS	;A7 - bit table for block being on disp list

;PARMS For DISP_ADD
;	A1 - Background Block table
;	A2 - End of Background Block table
;	A5 - Background hdr table
;	A9 - Module Start Position Y:X
;	A10 - ptr to palette table for new block
;	    ;passed from above
;	A3 - disp_tl
;	A4 - disp_lr
;	A6 - which bakground insert routine primary|secondary
;	A7 - bit table for block being on disp list

;* caller is responsible for pushing and popping all A-registers

DISP_MOD:
	clr	A9			;init y:x starting position
	clr	A11			;ending y:x pos
	move	A7,A6			;A6 will point to BakBits after Mod

ModLp:	
SkDAdd:
	move	A6,A7
	move	*A0+,A8,L		;load module ptr
	cmpi	>FFFFFFFF,A8
	jrz	ModX			;end of the module tbl
	move	*A8+,A10,L		;load y:x size

	move	*A0+,A14,W		;X start position
	zext	A14,W
	cmpi	BLSTSTRT,A14
	jrnz	NotLastStartX
	move	A11,A14		
	subxy	A10,A14
	jruc	GotNewX
NotLastStartX:
	cmpi	BLSTEND,A14
	jrnz	GotNewX
	move	A11,A14
GotNewX:
	move	*A0+,A5,W		;Y start position
	zext	A5,W
	cmpi	BLSTSTRT,A5
	jrnz	NotLastStartY
	move	A11,A5		
	subxy	A10,A5
	jruc	GotNewY
NotLastStartY:
	cmpi	BLSTEND,A5
	jrnz	NotLastEndY
	move	A11,A5
	jruc	GotNewY
NotLastEndY:
	sll	16,A5
GotNewY:
	movy	A5,A14
	move	A14,A9

	move	A9,A11
	addxy	A10,A11	;A11 is module y:x end
	move	*A8+,A10,W		;load # of blocks
	add	A10,A6		;A6 is new BAKBITS ptr

; 	cmpxy	A9,A4
;	jrxle	ModX  	;jump to exit loop if Mod start X > Screen End X

	cmpxy	A3,A11
	jrxlt	SkDAdd		;skip if Mod X End < TL X
	jrylt	SkDAdd		;skip if Mod Y End < TL Y

	cmpxy	A9,A4
	jrxlt	SkDAdd  ;use this if modules aren't sorted left to right
				;jump to if Mod start X > Screen End X
	jrylt	SkDAdd		;skip if Mod Y Start > BR Y

	move	*A8+,A1,L		;A1-block table	
	move	A10,A2
	sll	6,A2			;each block is 4 words long
	add	A1,A2			;A2-block table end
	move	*A8+,A5,L		;A5-Hdrs
	move	*A8+,A10,L		;A10-Pal tbl
	subxy	A9,A3
	subxy	A9,A4
	callr	DISP_ADD
	addxy	A9,A3
	addxy	A9,A4
	jruc	ModLp

ModX:
	rets
***********************************************************************

*********************** D I S P   A D D *******************************
;* This function adds all module blocks in the given range of Module
;* relative coors to the display list.
;* The boundries are included in the group to add.
DISP_ADD:
;***	PARMS:
;       B0 - which bakground insert routine primary|secondary
;	A5 - Background hdr table
;	A7 - bit table for block being on disp list
;	A9 - Module Start Position Y:X
;	A10 - ptr to palette table for new block
;	A1 - Background Block table
;	A2 - End of Background Block table
;	A3 - disp_tl	- relative to the Module start POS
;	A4 - disp_lr	- " 
;*** RETURNS nothing

;thrashes A1,A8,A14
	mmtm	SP,A0,A6,A7,A11

	;* Find first universe block with an X coor >= A9
	movx	A3,A0
	sext	A0,W
	subi	WIDEST_BLOCK,A0
;A0 - x coordinate of a block
;A1 - Start of background block table
;A2 - end of block table
	callr	BSrch1stXB
;A0 is now the address of a block
	jrz	DADONE	;* no blocks with gtr Xcoor
	
	movi	block_size,A6

	move	A0,A8
	sub	A1,A8	;* subtract off start of table
	srl	6,A8	;* divide by block size (64)
	add	A7,A8	;* A8 - ptr to bit which indicates block on list
	subk	8,A8	;* after inc A8, use movb *A8 to load sign bit
	sub	A6,A0	;subtract block size
BScanLP0:
	inc	A8
	add	A6,A0	;* get next block
	;* check if there are no more bgnd blocks
	cmp	A2,A0
	jrge	DADONE

	;* if block already on display list try again
	movb	*A8,A11
	jrn	BScanLP0

	;* check if x to big
	move	*A0(map_x),A11,W
	cmpxy	A3,A11
	jrxge	BScan1	   	;* Jump if BlockX >= TL X

	;* load map header
	move	*A0(map_hdr),A14,W
	sll	20,A14	;* only want bottom 12 bits, top 4 are pal bits
	srl	15,A14	;* leaves B9 << 5 == long word offset
	add	A5,A14	;* A14 now pts to block hdr

	;* check if right end of block hangs onto screen
	move	*A14,A1,W	;A1 is now the width of the block
	add	A11,A1
	cmpxy	A3,A1	;* right end of block doesn't hang on to screen
	jrxlt	BScanLP0		;* jump if Block X+W < TL X

	;* if ycoor to big try again
	move	*A0(map_y),A1,0
	sll	16,A1
	cmpxy	A1,A4
	jrylt BScanLP0		;* Jump if Block Y > BR Y

	;* if ycoor+height to small try again
	move	*A14(map_h),A11,0
	sll	16,A11
	add	A11,A1
	cmpxy	A3,A1
	jrylt BScanLP0		;* Jump if Block Y+H < TL Y

	move	A0,A7
	callr	ADDBLOCK	;Thrashes A1,A14
	jrnc BScanLP0
	jruc	DADONE		;* was unable to add block - no blocks left

BScan1:
	dec	A8		;* bit ptr for block on disp list
	sub	A6,A0		;subtract off block size
BScanLP1:
	inc	A8
	add	A6,A0	;Get next block
	;* check if there are no more bgnd blocks
	cmp	A2,A0
	jrge	DADONE

	;* if block already on display list try again
	movb	*A8,A11
	jrn	BScanLP1

	;* if ycoor to big try again
	move	*A0(map_y),A1,W
	sll	16,A1
	cmpxy	A1,A4
	jrylt BScanLP1		;* Jump if Block Y > BR Y

	;* if ycoor+height to small try again
	move	*A0(map_hdr),A14,W
	sll	20,A14	;* only want bottom 12 bits, top 4 are pal bits
	srl	15,A14	;* leaves B9 << 5 == long word offset
	add	A5,A14	;* B9 now pts to block hdr
	move	*A14(map_h),A11,W
	sll	16,A11
	add	A11,A1
	cmpxy	A3,A1
	jrylt BScanLP1		;* Jump if Block Y+H < TL Y

	;* if xcoor to big quit
	move	*A0(map_x),A1,W
	cmpxy	A1,A4
	jrxlt DADONE	;* Jump if Block X > BR X

	move	A0,A7
	callr	ADDBLOCK
	jrnc	BScanLP1

DADONE:
	mmfm	SP,A0,A6,A7,A11
	rets
***********************************************************************

***********************************************************************
ADDBLOCK:
;* PARMS
; B0 - which INS routine
; A5 - base of background block hdr
; A7 - ptr to background block
; A8 - ptr to bit map for block on disp list
; A9 - Module Start Position Y:X
; A10 - ptr to palette table for new block

;* Returns carry set if GETOBJ fails...
	;* Also Destroys A1,A14 but they are used as temps in DISP_ADD
	mmtm	SP,A0,A2,A3,A4

	calla	GETOBJ
	jrz  	ADDX

	;* set bit in bitmap for block on list
	movb	*A8,A14
	ori	>80,A14
	movb	A14,*A8
	move	A8,*A0(OPLINK),L ;set OPLINK to be a ptr to the disp list bit
	
	move	*A7(map_x),A1,L	;A1 ypos:xpos of block from Mod Base
	addxy	A9,A1		;Add in Module Base Position
	move	A1,*A0(OXPOS),W
	srl	16,A1
	move	A1,*A0(OYPOS),W
	move	*A7,A4,W	;A4 - map_z,8:map_flags,4:map_pal,4
	move	A4,A3
	srl	8,A3
	sll	24,A3
	srl	8,A3
	move	A3,*A0(OZVAL),L

	move	*A7(map_hdr),A1,W
	movx	A1,A14
	sll	16,A14
	srl	28,A14
	sll	4,A14		;* bits 12-15 are bits 4-7 of pal index
	
	sll	20,A1		;* bits 0-11 are hdr ptr;
	srl	15,A1		;* A1-long word offset into block hdr tbl
	add	A5,A1		;* A1 - Ptr to oimg hdr - input to GSAGOF

	;A4 - map_z,8:map_flags,4:map_pal,4
	move	A4,A3
	sll	28,A4		;* last four bits for pal
	srl	28,A4
	add	A14,A4	
	sll	5,A4   		;* A4 is lword ptr from pal tbl
	add	A10,A4		;* add in pal tbl
	move	A0,A2		;save A0
	move	*A4,A0,L	;* get palette
	calla	GETBPAL
	jrnz	BSetPal
	clr	A0
BSetPal:
	move	A0,*A2(OPAL),W
	move	A2,A0		;restore A0

	movi	>8002,A4	;>8000 DMA GO, 2
	srl	4,A3	;* remove palette bits
	sll	30,A3		
	jrc	SKIP0	;* carry bit is the transparency bit
	addk	1,A4
SKIP0:
	srl	26,A3	;* line up flip h,v bits
	add	A3,A4	;A4 - Flags for GSAGOF
	move	A1,*A0(OIMG),L
*A1=DATA BLOCK POINTER
*A4=OBJECT FLAGS
	calla	BKGSAGOF	;USES ISAG->20 FOR ISAG
*A2=RETURNED WITH NEW OSIZE
*A3=RETURNED WITH NEW SAG
*A4=RETURNED WITH NEW OFFSET:OFLAGS
	move	A0,A1
	addi	OSIZE+>20,A1
	mmtm	A1,A2,A3,A4		;Stuff OSIZE,OSAG,OFFSET,OFLAGS

	call	B0
	clrc
	mmfm	SP,A0,A2,A3,A4
	rets
ADDX: ;failure to get object
	setc
	mmfm	SP,A0,A2,A3,A4
	rets
**********************************************************************


************************ D I S P   D E L *****************************
;* This function deletes all objs outside the given range
;* of coors from the display list.
;* The boundries are not included in the group to delete.
DISP_DEL:
;***	PARMS:
;	A8 - bak list	
;	A3 - disp_tl
;	A4 - disp_lr
;*** RETURNS nothing

;Thrashes A0,A6,A7,A8,A9	;all of which are pushed by caller

del_loop:
	move	A8,A9	   	; ptr to PREV in A9
	move	*A9,A8,L   	; ptr to NEXT in A8
	jrz	del_done	   	; QUIT if at end of list

	;if X > Xmax continue
	move	*A8(OXPOS),A7,W
	cmpxy	A7,A4
	jrxlt	DEL_IT		;* jump if BR X < Block X

	;if Y > Ymax continue
	move	*A8(OYPOS),A0,W
	sll	16,A0
	cmpxy	A0,A4
	jrylt	DEL_IT		;* jump if BR Y < Block y

	move *A8(OIMG),A1,L
	;if X+width < Xmin continue
	move	*A1,A6,W		;A6 block width
	add	A6,A7
	cmpxy	A3,A7
	jrxlt	DEL_IT		;* jump if TL X > Block X+W

	;if Y+height < Ymin continue
	move	*A1(map_h),A7,0		;A7 block height
	sll	16,A7
	add	A7,A0
	cmpxy	A3,A0
	jrylt	DEL_IT		;* jump if TL Y > Block Y+H

	jruc	del_loop

DEL_IT:	;* DELETE the OBJ
    ;* free the palette
	move	*A8(OPAL),A0,W
	jrz	NoFreeP
	calla	FREEPAL
NoFreeP:

	;* unset the on display list bit
	move	*A8(OPLINK),A0,L
	movb	*A0,A7
	andi	>7F,A7
	movb	A7,*A0
		
	move	*A8,*A9,L  	; put NEXT link in PREV obj
	move	@OFREE,A0,L				
	move	A0,*A8,L
	move	A8,@OFREE,L	; Return deleted block to free stack
	move	A9,A8		;A1- points to last obj
	jruc	del_loop

del_done:
	rets
