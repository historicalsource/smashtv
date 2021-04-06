	.FILE	'ROBOAUD.ASM'
	.TITLE	"ROBO AUDITS"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST
;	.INCLUDE	"\VIDEO\ROBO\MPROC.EQU"		;MPROC EQUATES
;	.INCLUDE	"\VIDEO\ROBO\DISP.EQU"		;DISPLAY PROC. EQUATES
	.INCLUDE	"\VIDEO\SYS\GSP.INC"	;GSP ASSEMBLER EQUATES
	.INCLUDE	"\VIDEO\SYS\SYS.INC"	;Z UNIT SYSTEM EQUATES
	.INCLUDE	"\VIDEO\SYS\MACROS.HDR"	;MACROS DEFINITIONS

;	.INCLUDE	"STRING.H"
	.INCLUDE	"ROBOAUD.EQU"
	.REF	CIRCLE, HVLINE, STRING, RECTANGLE, POINT, DSCRCLR, INITCOLR
*
*        BAD_AUD - ANYTIME AN AUDIT NUMBER IS FETCHED, IF ITS
*                  CHECKSUM IS BAD, THEN BAD_AUD GETS SET TO 1
*                  THIS CAUSES "ERROR" IF ANY AUDIT IN A CALCULATION
*                  IS CORRUPTED, AND KEEPS A BAD CHECKSUM BAD WHEN
*                  AN AUDIT IS CHANGED.

         .BSS            BAD_AUD,16   ;(BAD_AUD...NOT BAD_DOG!)     
	.BSS		SYSCOPY,16
         .TEXT
**************************************************************************
*                                                                        *
*          SET_PAGE                                                      *
*                                                                        *
*          This is called to set the CMOS page to the bits               *
*          contained in A1.                                              *
*                                                                        *
**************************************************************************
SET_PAGE
         MMTM    SP,A0,A1
         ANDI    CMOS_PAGE_SELECT_BITS,A1  ;KILL SIGN EXTEND..SAVE BITS
         PUSHST                            ;SAVE INTERRUPT STATUS
         DINT                              ;STOP INTERRUPTS
         MOVE    @SYSCOPY,A0,W             ;GET THE RAM COPY
         ANDNI   CMOS_PAGE_SELECT_BITS,A0  ;REMOVE THE CURRENT PAGE SELECT
         OR      A1,A0                     ;ADD IN OUR BITS
         MOVE    A0,@SYSCOPY,W             ;PUT THEM BACK IN THE RAM COPY
         MOVE    A0,@SYSCTRL,W             ;NOW THE HARDWARE
         POPST                             ;OK TO RE-START INTS
	MMFM    SP,A0,A1
	RETS
**************************************************************************
*                                                                        *
*          COIN_PAG                                                     *
*                                                                        *
*          THIS SETS THE CURRENT CMOS PAGE FOR COIN/CREDITS              *
*                                                                        *
**************************************************************************
COIN_PAG
         MMTM    SP,A1
         MOVI    COIN_SELECT,A1       ;THIS IS COIN/CREDITS PAGE
         CALLA   SET_PAGE             ;SET IT PLEASE
	MMFM    SP,A1
	RETS

**************************************************************************
*                                                                        *
*         AUDIT HANDLING                                                 *
*                                                                        *
**************************************************************************
*                                                                        *
*          POINT_AT_AUDIT                                                *
*                                                                        *
*          THIS IS CALLED TO POINT AT THE AUDIT INDICATED BY             *
*          A0.  A0 IS THE AUDIT NUMBER 0-30.  A7 IS RETURNED             *
*          POINTING AT THE BEGINNING OF THE AUDIT.                       *
*                                                                        *
**************************************************************************
POINT_AT_AUDIT
         MMTM    SP,A1
         CALLR   AUDIT_PAGE

         MOVI    AUD_SIZE,A7          ;THIS IS SIZE PER AUDIT
         MPYU    A0,A7                ;A1 NOW HAS OFFSET
         ADDI    AUDITORG,A7          ;ADD BASE
	MMFM    SP,A1
	RETS

AUDIT_PAGE
         MMTM    SP,A1
         MOVI    AUDIT_SELECT,A1      ;THIS IS AUDIT PAGE
         CALLA   SET_PAGE             ;SET IT PLEASE
	MMFM    SP,A1
	RETS

**************************************************************************
*                                                                        *
*          FORM_AUD_CKSUM                                                *
*                                                                        *
*          THIS IS CALLED TO FORM THE CHECKSUM FOR THE AUDIT             *
*          SPECIFIED IN A0.                                              *
*                                                                        *
*          A1 RETURNS THE CHECKSUM.                                      *
*                                                                        *
*          Z BIT IS SET BASED ON WHETHER IT MATCHES THE CHECKSUM THERE.  *
*                                                                        *
**************************************************************************

FORM_AUD_CKSUM
         MMTM    SP,A0,A4,A7
         CALLR   POINT_AT_AUDIT            ;A7 = POINTER TO CURRENT ENTRY
         MMTM    SP,A7                     ;SAVE POINTER TO ENTRY
         MOVI    AUD_BYTES_TO_CHECK,A4     ;COUNT DOWN THE BYTES
         CLR     A1                        ;KEEP SUM IN A1
ADD_A_BYTE
         CALLA   RC_BYTEI                  ;GET A BYTE INTO A0
         ADD     A0,A1                     ;ADD TO SUM
         DSJ     A4,ADD_A_BYTE             ;ONE MORE ADDED
         NOT     A1                        ;CHECKSUM IS NOW IN LOW WORD
         ANDI    WORD_MASK,A1              ;MASK SO ITS COOL
	MMFM    SP,A7                     ;GET POINTER BACK
         ADDI    AUD_CKSUM,A7              ;POINT AT CHECKBYTE
         CALLA   RC_WORD                   ;READ IN THE CKSUM
         CMP     A0,A1                     ;COMPARE WHAT'S THERE TO WHAT WE GOT
	MMFM    SP,A0,A4,A7               ;Z BIT RETURNS COMPARE
	RETS                              ;A1 RETURNS CKSUM

**************************************************************************
*                                                                        *
*          STORE_AUD_CKSUM                                               *
*                                                                        *
*          THIS WILL STORE THE AUDIT CHECKSUM IN A1 FOR THE              *
*          AUDIT NUMBER SPECIFIED BY A0.                                 *
*                                                                        *
**************************************************************************

STORE_AUD_CKSUM
         MMTM    SP,A7,A0                  ;POINTING REGISTER
         CALLR   POINT_AT_AUDIT            ;A7 POINTS AT AUDIT
         ADDI    AUD_CKSUM,A7              ;POINT AT CHECKBYTE
         MOVE    A1,A0                     ;GET CHECKBYTE IN A0
         CALLA   WC_WORD                   ;WRITE THE CKSUM
	MMFM    SP,A7,A0                  ;POINTING REGISTER
	RETS

**************************************************************************
*                                                                        *
*          FORM_AUD_CKSUM_AND_STORE                                      *
*                                                                        *
*          THE VALUE AT BAD_AUD IS USED TO DETERMINE WHETHER TO STORE    *
*          THE CORRECT OR INCORRECT VALUE!                               *
*                                                                        *
*          A0 = AUDIT NUMBER                                             *
*                                                                        *
**************************************************************************

FORM_AUD_CKSUM_AND_STORE
         MMTM    SP,A1,A2                     ;SAVE A1!
         CALLR   FORM_AUD_CKSUM
         MOVE    @BAD_AUD,A2,W                ;GET THE "FUDGE" WORD
         XOR     A2,A1                        ;MAKE CKSUM BAD IF AUDIT IS BAD
         CALLR   STORE_AUD_CKSUM
	MMFM    SP,A1,A2
	RETS

**************************************************************************
*                                                                        *
*          GET_AUD                                                       *
*                                                                        *
*          THIS IS CALLED TO FETCH THE AUDIT VALUE FOR THE AUDIT         *
*          SPECIFIED IN A0 INTO A1.  IF THE CHECKBYTE FOR THE            *
*          AUDIT IS INCORRECT, THEN RAM LOCATION BAD_AUD WILL BE         *
*          SET TO 1.                                                     *
*                                                                        *
**************************************************************************
GET_AUD
         MMTM    SP,A7,A0
         CALLR   FORM_AUD_CKSUM       ;SEE IF CKSUM IS OK
         JRZ     FETCH_AUDIT_1        ;ITS OK....
*
*        CHECKSUM IS BAD....SET GLOBAL
*
         MOVK    1,A1
         MOVE    A1,@BAD_AUD,W        ;SET THE FLAG!

FETCH_AUDIT_1
         CALLR   POINT_AT_AUDIT       ;A7 POINTS AT AUDIT
         ADDI    AUD_DATA,A7          ;ADD ZERO OFFSET
         CALLA   RC_LONG              ;FETCH THE LONG WORD TO A0
         MOVE    A0,A1                ;RETURN IN A1
	MMFM    SP,A7,A0
	RETS

**************************************************************************
*                                                                        *
*          STORE_AUDIT                                                   *
*                                                                        *
*          A0 = AUDIT NUMBER TO STORE VALUE FOR                          *
*          A1 = VALUE TO STORE.                                          *
*          BAD_AUD = NON ZERO IF BAD CHECKSUM IS TO BE MAINTAINED.       *
*                                                                        *
**************************************************************************

STORE_AUDIT
         MMTM    SP,A0,A7
         CALLR   POINT_AT_AUDIT       ;A7 POINTS AT AUDIT
         ADDI    AUD_DATA,A7          ;ADD ZERO OFFSET
         MOVE    A1,A0                ;MOVE DATA TO WRITING REGISTER
         CALLA   WC_LONG              ;WRITE THE DATA BACK
	MMFM    SP,A0,A7             ;GET AUDIT NUMBER BACK
         JRUC    FORM_AUD_CKSUM_AND_STORE    ;STORE GOOD OR BAD CKSUM BASED
*                                            ;ON BAD_AUD

**************************************************************************
*                                                                        *
*          CLR_AUDR                                                 *
*                                                                        *
*          THIS IS CALLED TO CLEAR OUT A RANGE OF AUDITS.                *
*          A0 = 1ST AUDIT NUMBER                                         *
*          A1 = LAST AUDIT NUMBER (INCLUSIVE)                            *
*                                                                        *
**************************************************************************

CLR_AUDR
         MMTM    SP,A0,A1,A2
         MOVE    A1,A2                     ;MOVE "LAST" TO A2
         CLR     A1                        ;WE'LL STORE ZEROS
         MOVE    A1,@BAD_AUD               ;MAKE CKSUMS GOOD ON STORING
CAR1     CALLR   STORE_AUDIT               ;STORE THIS AUDIT
         INC     A0                        ;KICK TO NEXT AUDIT
         CMP     A2,A0
         JRLS    CAR1
	MMFM    SP,A0,A1,A2
	RETS

**************************************************************************
*                                                                        *
* 	KILL_AUD							 *
* 									 *
* 	This is called to clear out an audit.				 *
* 									 *
* 	A0 = audit number.						 *
*                                                                        *
**************************************************************************
KILL_AUD
	MMTM	SP,A1
        CLR     A1                        ;WE'LL STORE ZEROS
        MOVE    A1,@BAD_AUD               ;MAKE CKSUMS GOOD ON STORING
        CALLR   STORE_AUDIT               ;STORE THIS AUDIT
	MMFM	SP,A1
	RETS

**************************************************************************
*                                                                        *
*          AUD                                                           *
*                                                                        *
*          A0 = AUDIT NUMBER.......A1 = COUNT TO ADD.                    *
*                                                                        *
**************************************************************************

AUD      MMTM    SP,A1,A2
         CLR     A2                   ;SET "BAD_AUD" GOOD UNTIL OTHERWISE PROVEN!
         MOVE    A2,@BAD_AUD,W        ;ITS GOOD.
         MOVE    A1,A2                ;COPY OUR COUNT
         CALLR   GET_AUD              ;FETCH THE CURRENT AUDIT COUNTER
         ADD     A2,A1                ;ADD THE NEW COUNT
         CALLR   STORE_AUDIT          ;STORE IT BACK
         CALLR   DEF_PAGE             ;SWITCH PAGE AWAY FROM THE DATA!
	MMFM    SP,A1,A2
	RETS

AUD1     MMTM    SP,A1
         MOVK    1,A1
         CALLR   AUD
	MMFM    SP,A1
	RETS

**************************************************************************
*                                                                        *
*          CLR_AUD                                                       *
*                                                                        *
*          This is called to clear out all of the audits.                *
*                                                                        *
*          A relatively easy task given the primitives available.        *
*                                                                        *
**************************************************************************

CLR_AUD  MMTM    SP,A0,A1
         MOVI    1,A0                 ;START AT AUDIT 1
         MOVI    N_AUDITS-1,A1        ;THIS IS TOTAL ALLOCATED
         CALLR   CLR_AUDR
	MMFM    SP,A0,A1
	RETS

**************************************************************************
*								         *
* 	DEF_PAGE							 *
* 									 *
* 	SET TO THE DEFAULT PAGE -- THE ONE WE DON'T CARE ABOUT		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

DEF_PAGE
        PUSHST                       ;PRESERVE CODES THAT ARE BEING RETURNED
        MMTM    SP,A1
        MOVI    TODAYS_SELECT,A1     ;THIS IS TODAY'S HIGH SCORES PAGE
        CALLA   SET_PAGE             ;SET IT PLEASE
        MMFM    SP,A1
        POPST
	RETS

**************************************************************************
*								         *
* 	CMOSUNLOCK							 *
* 									 *
* 	CALL THIS TO UNLOCK THE PROTECTED PORTION OF CMOS		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

CMOSUNLOCK:
	PUSH	A0
;	.IF	YUNIT
;	MOVE	@SYSCOPY,A0,W		; UNLOCK CMOS
;	ANDI	00FFH,A0
;	ORI	0200H,A0		; OR IS IT 2?
;	MOVE	A0,@SYSCOPY,W
;	MOVE	A0,@SYSCTRL,W
	MOVI	0200H,A0
*	MOVE	A0,@SECCHIP,W
;	.ENDIF
	PULL	A0
	RETS

**************************************************************************
*								         *
* 	CMOSLOCK							 *
* 									 *
* 	CALL THIS TO RELOCK CMOS 					 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

CMOSLOCK
	PUSH	A0
;	.IF	YUNIT
;	MOVE	@SYSCOPY,A0,W		; RELOCK CMOS
;	ANDI	00FFH,A0	
;	ORI	0300H,A0		; OR IS IT 3?
;	MOVE	A0,@SYSCOPY,W
;	MOVE	A0,@SYSCTRL,W
;	MOVE	@SYSCOPY,A0,W
	MOVI	0300H,A0
*	MOVE	A0,@SECCHIP,W
;	.ENDIF
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
*          CMOS UTILITIES                                                *
*                                                                        *
**************************************************************************

**************************************************************************
*                                                                        *
*          FOR ALL OF THESE CMOS ROUTINES.                               *
*                                                                        *
*                  A7 = POINTER TO MEMORY                                *
*                  A0 = DATA TO/FROM MEMORY                              *
*                                                                        *
**************************************************************************
*
*        ****  IMPORTANT NOTE ON WORD AND LONG WORD PACKING  ****
*        ****  IMPORTANT NOTE ON WORD AND LONG WORD PACKING  ****
*        ****  IMPORTANT NOTE ON WORD AND LONG WORD PACKING  ****
*        ****  IMPORTANT NOTE ON WORD AND LONG WORD PACKING  ****
*        ****  IMPORTANT NOTE ON WORD AND LONG WORD PACKING  ****
*
*        NOTE THAT REQUESTS FOR WORDS RETURN THE 2 BYTES PACKED
*        INTO A WORD AS <1ST BYTE><2ND BYTE>.   THIS IS NOT
*        THE SAME WAY THAT THE GSP HANDLES A WORD POINTED AT
*        WITH A POINTER.
*
*        LONG WORDS WORK SIMILARLY:
*
*           MSB                                              LSB
*               <1ST BYTE> <2ND BYTE> <3RD BYTE> <4TH BYTE>
*
*        TOUGH LUCK INTEL HACKERS!
*
*
*        RC_BYTE
*        WC_BYTE
*
*        These 2 routines are the only routines that ever touch
*        CMOS ram.  This is done to localize the effect of
*        changes in the architecture.  All efforts to deal with
*        CMOS should come through these routines.  Locking
*        hardware will be easily added in the future (as well
*        as different memory mapping).
*
RC_BYTE
         MOVB    *A7,A0
         ANDI    BYTE_MASK,A0
         RETS

WC_BYTE
         MOVB    A0,*A7          ;WRITE OUT THE BYTE
         RETS                    ;AND RETURN

**************************************************************************
*                                                                        *
*          RC_BYTEI                                            *
*                                                                        *
*          READ BYTE POINTED TO BY A7...INCREMENT POINTER TO             *
*          "NEXT" BYTE.                                                  *
*                                                                        *
**************************************************************************
RC_BYTEI
         CALLR   RC_BYTE
         ADDI    C_BYTE_SIZE,A7    ;WORDS SEPARATE CMOS BYTES.
         MOVE    A0,A0             ;RETURN FLAGS ACCORDINGLY
         RETS

RC_WORD
         MMTM    SP,A1,A7              ;USE A1 TO COMBINE BYTES
         CALLR   RC_BYTEI    ;GET A BYTE
         MOVE    A0,A1                 ;SAVE IN A1
         ANDI    BYTE_MASK,A1          ;MASK ONLY BYTE
         SLL     8,A1                  ;SHIFT TO HIGH BYTE
         CALLR   RC_BYTE        ;GET THE 2ND BYTE
         ANDI    BYTE_MASK,A0
         OR      A1,A0                 ;A0 HAS THE WORD
	MMFM    SP,A1,A7              
	RETS

RC_WORDI
         CALLR   RC_WORD
         ADDI    C_WORD_SIZE,A7    ;LONG SEPARATE CMOS WORDS.
         MOVE    A0,A0             ;RETURN FLAGS ACCORDINGLY
         RETS

RC_LONG
         MMTM    SP,A1,A7              ;USE A1 TO COMBINE BYTES
         CALLR   RC_WORDI    ;GET A WORD
         MOVE    A0,A1                 ;SAVE IN A1
         ANDI    WORD_MASK,A1          ;MASK ONLY WORD
         SLL     16,A1                 ;SHIFT TO HIGH WORD
         CALLR   RC_WORD        ;GET THE 2ND WORD
         ANDI    WORD_MASK,A0
         OR      A1,A0                 ;A0 HAS THE LONG WORD
	MMFM    SP,A1,A7              
	RETS

RC_LONGI
         CALLR   RC_LONG
         ADDI    C_LONG_SIZE,A7    ;DOUBLE THE DISTANCE FOR BRAIN DAMIJ
         MOVE    A0,A0             ;RETURN FLAGS ACCORDINGLY
         RETS

WC_BYTEI
         CALLR   WC_BYTE
         ADDI    C_BYTE_SIZE,A7
         RETS

WC_WORD
         MMTM    SP,A0,A1,A7
         MOVE    A0,A1           ;MAKE COPY OF WORD
         SRL     8,A0            ;GET HIGH BYTE IN A0
         CALLR   WC_BYTEI  ;WRITE THE HIGH BYTE
         MOVE    A1,A0           ;NOW GET THE LOW BYTE BACK
         CALLR   WC_BYTE ;WRITE IT
	MMFM    SP,A0,A1,A7     ;AND RESTORE ALL WE TOUCHED
	RETS

WC_WORDI
         CALLR   WC_WORD
         ADDI    C_WORD_SIZE,A7
         RETS

WC_LONG
         MMTM    SP,A0,A1,A7
         MOVE    A0,A1           ;MAKE COPY OF LONG
         SRL     16,A0           ;GET HIGH WORD IN A0
         CALLR   WC_WORDI  ;WRITE THE HIGH WORD
         MOVE    A1,A0           ;NOW GET THE LOW WORD BACK
         CALLR   WC_WORD ;WRITE IT
	MMFM    SP,A0,A1,A7     ;AND RESTORE ALL WE TOUCHED
	RETS

WC_LONGI
         CALLR   WC_LONG
         ADDI    C_LONG_SIZE,A7
         RETS
**************************************************************************
*                                                                        *
* HEXTOASC - CONVERTS A 32 BIT HEX # TO AN ASCII STRING TERMINATED	 *
* 	   BY 0 WITH COMMAS.						 *
* A8 = HEX #								 *
* RETURNS:								 *
* A8 PTR TO THE STRING							 *
*                                                                        *
**************************************************************************
	.BSS	STRNGRAM,30*16	;RAM FOR BUILDING OF STRINGS BY CONVERSION ROUTINES
HEXTOASC
	MMTM	SP,A3,A4,A14
	CLR	A3
	CLR	A4
	BSET	B_COMMAS,A4
	CALLR	HEX_TO_ASCII_DEC
	MMFM	SP,A3,A4,A14
	RETS

**************************************************************************
*                                                                        *
* HEX_TO_ASCII_DEC - FORMAT A HEXADECIMAL # TO AN DECIMAL ASCII STRING.	 *
* 	     	     USES THE flags AND width IN A4 AND A3.		 *
* A3 = width, MINIMUM # OF CHARACTERS TO OUTPUT				 *
* A4 = flags, USES: B_COMMAS - PUT COMMAS IN THE NUMBER			 *
* 		    B_ZPRINT - IF width IS NOT REACHED, FILL WITH 0's	 *
* 			       NOT SPACES.				 *
*		    B_SIGNED - PASSED NUMBER IS SIGNED			 *
*		    B_PSIGN  - PRINT SIGN IF NUMBER IS OF SIGNED TYPE    *
* A8 = HEXADECIMAL #							 *
* RETURNS:								 *
* A8 = PTR TO STRING							 *
* A3 & A4 PRESERVED							 *
*                                                                        *
**************************************************************************
HEX_TO_ASCII_DEC:
	MMTM	SP,A1,A2,A3,A5,A9
	CLR	A5			;CLR NEGATIVE FLAG
	BTST	B_SIGNED,A4
	JREQ	HEXTNOS			;NOT A SIGNED NUMBER
	MOVE	A8,A8
	JRNN	HEXTNOS			;NOT A NEGATIVE NUMBER
	NEG	A8
	INC	A5
HEXTNOS:
	CLR	A1
	CLR	A2			;COMMA COUNT
	MOVE	A1,-*SP,W		;HERE'S THE NULL TERMINATOR
        MOVK	10,A1			;DIVISOR FOR DECIMAL
	MOVE	A8,A9
HEXTASC2
	CLR	A8
	DIVU	A1,A8
	ADDI	'0',A9			;MAKE THE REMAINDER ASCII
	MOVE	A9,-*SP,W		;SAVE HERE
	DEC	A3			;DECREMENT THE WIDTH
	MOVE	A8,A9
	JRZ	HEXTASC3		;BR = DONE!

	BTST	B_COMMAS,A4
	JREQ	HEXTASC2		;BR = DON'T WORRY ABOUT COMMAS

	INC	A2
	CMPI	3,A2			;COMMA CHECK 	
	JRLO	HEXTASC2		;BR = NO COMMA
	MOVI	',',A2
	MOVE	A2,-*SP,W		;STUFF A COMMA
	CLR	A2
	JRUC	HEXTASC2
HEXTASC3
	MOVE	A3,A3
	JRZ	HEXTASC3A		;WIDTH HAS BEEN FULFILLED
	JRN	HEXTASC3A		;THANX TI
	BTST	B_ZPRINT,A4
	JRNE	HEXTASC30		;YES, FILL width WITH ZEROS
	MOVI	' ',A2
	JRUC	HEXTASC31
HEXTASC30:
	MOVI	'0',A2
HEXTASC31:
	MOVE	A2,-*SP,W		;STUFF THE LEADER
	DSJS	A3,HEXTASC31
HEXTASC3A:
	BTST	B_SIGNED,A4
	JREQ	HEXTASC3D		;THIS IS NOT A SIGNED NUMBER
	MOVE	A5,A5
	JRNZ	HEXTASC3B		;NUMBER IS NEGATIVE
	BTST	B_PSIGN,A4
	JREQ	HEXTASC3D		;DOESN'T WANT THE SIGN PRINTED
	MOVI	'+',A2	
	JRUC	HEXTASC3C
HEXTASC3B:
	MOVI	'-',A2
HEXTASC3C:
	MOVE	A2,-*SP,W		;STUFF THE SIGN
HEXTASC3D
	MOVI	STRNGRAM,A1		;STORE HERE FOR BLOW OUT        
	MOVE	A1,A8
HEXTASC4
	MOVE	*SP+,A9,W
	MOVB	A9,*A1
	ADDK	8,A1
	MOVE	A9,A9
	JRNZ	HEXTASC4
	MMFM	SP,A1,A2,A3,A5,A9
	RETS

**************************************************************************
*                                                                        *
* HTOHXASC - CONVERT A 32 BIT HEXADECIMAL # TO A NULL TERMINATED	 *
* 	   HEXADECIMAL ASCII STRING. USES 'ABCDEF' AND NO Ox PREFIX	 *
* 	   OR COMMAS.							 *
* A8 = HEX #								 *
* RETURNS:								 *
* A8 = PTR TO ASCII HEX STRING						 *
*                                                                        *
**************************************************************************
HTOHXASC
	MMTM	SP,A3,A4,A14
	CLR	A3
	CLR	A4
	BSET	B_CAP,A4	
	CALLR	HEX_TO_ASCII_HEX
	MMFM	SP,A3,A4,A14
	RETS
	
**************************************************************************
*                                                                        *
* HEX_TO_ASCII_HEX - CONVERTS A 32 BIT HEX # TO A NULL TERMINATED	 *
* 		   ASCII STRING.					 *
* A3 = width, MINIMUM # OF CHARACTERS CONVERTED				 *
* A4 = flags, USES: B_COMMAS - PUT COMMAS IN THE NUMBER			 *
* 		  B_ZPRINT - IF width IS NOT REACHED, FILL WITH 0's	 *
* 			     NOT SPACES.				 *
* 		  B_CAP	   - USE 'ABCDEF'				 *
* 		  B_PHEX   - PREFIX WITH HEX SPECIFIER 0x OR 0X		 *
* A8 = HEX #								 *
* RETURNS:								 *
* A8 PTR TO THE STRING							 *
* A3 & A4 ARE PRESERVED							 *
*                                                                        *
**************************************************************************
HEX_TO_ASCII_HEX
	MMTM	SP,A1,A2,A3,A9
	CLR	A1
	CLR	A2			;COMMA COUNT
	MOVE	A1,-*SP,W		;HERE'S THE NULL TERMINATOR
	MOVK	16,A1			;DIVISOR FOR HEX
	MOVE	A8,A9
HEXTASCH2
	CLR	A8
	DIVU	A1,A8
	ADDI	'0',A9			;MAKE THE REMAINDER ASCII
	CMPI    '9',A9			;IS IT IN A-F RANGE?
	JRLS    HHH1
	BTST	B_CAP,A4		;ARE WE IN CAPITAL MODE
	JRNE	HHH0			;YES
	ADDI	'a' - ':',A9		;MAKE alpha!
	JRUC	HHH1
HHH0:
	ADDI    'A' - ':',A9		;MAKE ALPHA!
HHH1:
	DEC	A3			;DECREMENT THE WIDTH
	MOVE	A9,-*SP,W		;SAVE HERE
	MOVE	A8,A9
	JRZ	HEXTASCH3		;BR = DONE!
	INC	A2
	CMPI	3,A2			;COMMA CHECK 	
	JRLO	HEXTASCH2		;BR = NO COMMA
*
*        SEE IF WE'RE DOING COMMAS
*
	BTST	B_COMMAS,A4		;COMMAS?
	JREQ	HEXTASCH2		;NOPE....IGNORE!

	MOVI	',',A2
	MOVE	A2,-*SP,W		;STUFF A COMMA
	CLR	A2
	JRUC	HEXTASCH2
HEXTASCH3:
	MOVE	A3,A3
	JRZ	HEXTASCH3A		;WIDTH HAS BEEN FULFILLED
	JRN	HEXTASCH3A		;THANX TI
	BTST	B_ZPRINT,A4
	JRNE	HEXTASCH30		;YES, FILL width WITH ZEROS
	MOVI	' ',A2
	JRUC	HEXTASCH31
HEXTASCH30:
	MOVI	'0',A2
HEXTASCH31:
	MOVE	A2,-*SP,W		;STUFF THE LEADER
	DSJS	A3,HEXTASCH31
HEXTASCH3A:
*CHECK FOR 0x PREFIX
	BTST	B_PHEX,A4
	JREQ	HEXTASCH3D		;NO PREFIX NECESSARY
	BTST	B_CAP,A4
	JRNE	HEXTASCH3B		;PRINT A CAPITAL X
	MOVI	'x',A2
	JRUC	HEXTASCH3C
HEXTASCH3B:
	MOVI	'X',A2
HEXTASCH3C:
	MOVE	A2,-*SP,W
	MOVI	'0',A2
	MOVE	A2,-*SP,W
HEXTASCH3D:
*DUMP THE STRING AND PASS IT BACK
	MOVI	STRNGRAM,A1		;STORE HERE FOR BLOW OUT        
	MOVE	A1,A8
HEXTASCH4:
	MOVE	*SP+,A9,W
	MOVB	A9,*A1
	ADDK	8,A1
	MOVE	A9,A9
	JRNZ	HEXTASCH4
	MMFM	SP,A1,A2,A3,A9
	RETS

**************************************************************************
*                                                                        *
* BCDTOASC - CONVERT A 32 BIT HEXADECIMAL # TO A NULL TERMINATED	 *
* 	   HEXADECIMAL ASCII STRING. COMMAS AND LEAD ZERO BLANKING	 *
* 	   ARE ASSERTED.						 *
* A8 = BCD #								 *
* RETURNS:								 *
* A8 = PTR TO ASCII HEX STRING						 *
*                                                                        *
**************************************************************************
BCDTOASC
	MMTM	SP,A3,A4,A14
	CLR	A3
	CLR	A4
	BSET	B_COMMAS,A4	
	CALLR	BCD_TO_ASCII_DEC
	MMFM	SP,A3,A4,A14
	RETS

**************************************************************************
*                                                                        *
* BCD_TO_ASCII_DEC - CONVERTS A BCD NUMBER INTO A NULL TERMINATED	 *
* 		   ASCII DECIMAL STRING.				 *
* A3 = width, MINIMUM # OF CHARACTERS CONTAINED IN THE STRING		 *
* A4 = flags, USES: B_COMMAS - PUT COMMAS IN THE NUMBER			 *
* 		  B_ZPRINT - IF width IS NOT REACHED, FILL WITH 0's	 *
* 			     NOT SPACES.				 *
* A8 = BCD #								 *
* RETURNS:								 *
* A8 PTR TO THE STRING							 *
* A3 & A4 ARE PRESERVED							 *
*                                                                        *
**************************************************************************
BCD_TO_ASCII_DEC:
	MMTM	SP,A1,A2,A3,A5,A9
	MOVE	A8,A1
	MOVK	1,A2
	MOVE	A2,A5		;DIGIT COUNT
	SRL	4,A1		;WE WILL ALWAYS PRINT THE FIRST DUDE
BCDZLP:
	MOVE	A1,A9	
	SRL	4,A1		;SLIDE DIGIT OFF THE END
	INC	A2		;KNOCK UP ANOTHER DIGIT
	SLL	28,A9
	SRL	28,A9
	JREQ	BCDZ		;IT'S A ZERO
	MOVE	A2,A5		;UPDATE VALID DIGIT COUNT
BCDZ:
	CMPI	8,A2
	JRLO	BCDZLP		;MORE DIGITS TO CHECK
*O.K. LET'S STRING THIS BITCH
	CLR	A2			;COMMA COUNT
	MOVE	A2,-*SP,W		;HERE'S THE NULL TERMINATOR
BCDCLP:
	MOVE	A8,A9
	SRL	4,A8			;SHIT THIS DIGIT
	SLL	28,A9
	SRL	28,A9			;ISOLATE
	ADDI	'0',A9			;MAKE ASCII
	CMPI	'9',A9
	JRLS	BCDISNUM		;IT'S A VALID NUMBER.
	MOVI	' ',A9			;SUBSTITUTE A SPACE FOR ERROR
BCDISNUM:
	MOVE	A9,-*SP,W		;PUSH ON MY MAN
	DEC	A3			;DECREMENT width
	DEC	A5			;DIGIT COUNT
	JRZ	BCDDONE			;WE HAVE FINISHED
*COMMA SHIT
	INC	A2
	CMPI	3,A2			;COMMA CHECK 	
	JRLO	BCDCLP			;BR = NO COMMA
	BTST	B_COMMAS,A4		;PRINT COMMAS?
	JREQ	BCDCLP			;NOPE....IGNORE!
	MOVI	',',A2
	MOVE	A2,-*SP,W		;STUFF A COMMA
	CLR	A2
	JRUC	BCDCLP
BCDDONE:
	MOVE	A3,A3
	JRZ	BCDXFER			;WIDTH HAS BEEN FULFILLED
	JRN	BCDXFER 		;THANX TI
	BTST	B_ZPRINT,A4
	JRNE	BCDZP1			;YES, FILL width WITH ZEROS
	MOVI	' ',A2
	JRUC	BCDZP2
BCDZP1:
	MOVI	'0',A2
BCDZP2:
	MOVE	A2,-*SP,W		;STUFF THE LEADER
	DSJS	A3,BCDZP2
BCDXFER:
*DUMP THE STRING AND PASS IT BACK
	MOVI	STRNGRAM,A1		;STORE HERE FOR BLOW OUT        
	MOVE	A1,A8
BCDXFER_LP:
	MOVE	*SP+,A9,W
	MOVB	A9,*A1
	ADDK	8,A1
	MOVE	A9,A9
	JRNZ	BCDXFER_LP

	MMFM	SP,A1,A2,A3,A5,A9
	RETS

*
*OUTPUT AUDIT DATA
*
AUDOUT
	FCALL	DSCRCLR,B6

	MOVI	>020020,A1
	MOVI	TROG_YELLOW,A3 	;GET COLOR
	CLR	A2		;HORIZONTAL
	MOVI	M_SMAUD,A0
	FCALL	STRING,B6

	MOVI	>F00040,A1
	MOVI	TROG_RED,A3 	;GET COLOR
	CLR	A2		;HORIZONTAL
	MOVI	M_CLRAUD,A0
	FCALL	STRING,B6

	MOVI 	AUDMTAB,A10
	MOVI	>14001C,A12
*MESSAGE HEADERS
AUDOUT1
	MOVI	TROG_WHITE,A3 	;GET COLOR
	CLR	A2		;HORIZONTAL
	MOVE	A12,A1
	MOVE 	*A10+,A0,W
	SEXT	A0,W
	JRN	AUDOUT2
	ADDI	AMBASE,A0
	FCALL	STRING,B6
	
	ADDI	>D0000,A12
	CMPI	>F00000,A12
	JRLO	AUDOUT1
	MOVI	>1400E0,A12
	JRUC	AUDOUT1	
*******************************************
	CALLA	CLR_AUD		;CLEAR OUT YOUR AUDITS
	MOVI	2345,A1
	MOVK	AUDCOB,A0
	CALLA	STORE_AUDIT

	MOVI	12345,A1
	MOVK	AUDLCOIN,A0
	CALLA	STORE_AUDIT

	MOVI	15151,A1
	MOVK	AUDXMEN,A0
	CALLA	STORE_AUDIT

	MOVI	6666,A1
	MOVK	AUDWDOG,A0
	CALLA	STORE_AUDIT

	MOVK	AUDMUT,A0
	CALLA	AUD1	
******************************************************
*WRITE DATA OUT TO SCREEN
AUDOUT2
	MOVI	>140088,A12 	;INITIAL COORD
	MOVK	1,A11 		;AUDIT #
AUDOUT3
	MOVE	A11,A0
	CALLA	GET_AUD
	MOVE	A1,A8
	CMPI	99999,A8  	;MAX IT OUT
	JRLS	AUDOUT3A
	MOVI	99999,A8
AUDOUT3A
	MOVK	5,A3
	CLR	A4
	BSET	B_ZPRINT,A4
	CALLA	HEX_TO_ASCII_DEC
	MOVE	A8,A0
	MOVI	TROG_WHITE,A3 	;GET COLOR
	CLR	A2		;HORIZONTAL
	MOVE	A12,A1
	FCALL	STRING,B6
	
	INC	A11
	CMPI 	LAST_AUDIT,A11 
	JRHI	AUDOUTX	
	ADDI	>D0000,A12
	CMPI	>F00000,A12
	JRLO	AUDOUT3
	MOVI	>140140,A12
	JRUC	AUDOUT3	

*CLEAR AUDITS IF BOTH START BUTTONS PRESSED

AUDOUTX 	
	MOVE	@SWITCH,A0,L		; GRAB ME A SWITCH REGISTER
	NOT	A0
	ANDI	00240000H,A0	   	; P1 + P2 START
	CMPI	00240000H,A0	   	; P1 + P2 START
	JRNE	AUDOUTX1
	MOVI	3000000,A0		;WAIT A SECOND
AUDELA
	DSJS	A0,AUDELA
	CALLA	CLR_AUD
	JRUC	AUDOUT
AUDOUTX1
	MOVE	@SWITCH,A0,L		; GRAB ME A SWITCH REGISTER
	BTST	22,A0			; SERVICE SWITCH?
	JRNE	AUDOUTX			; YIP, EXIT
AUDOUTXX
	JRUC	AUDOUTXX
	
*SMASH TV AUDIT MESSAGE
M_SMAUD
	.STRING		"SMASH TV AUDITS... HIT SERVICE BUTTON TO EXIT",0
	.EVEN
*CLEAR AUDIT MESSAGE
M_CLRAUD
	.STRING		"PRESS START 1 AND 2 TO CLEAR AUDITS",0
	.EVEN

*AUDIT MESSAGES
AUDMTAB
	.WORD	M_LCOIN-AMBASE
	.WORD	M_CCOIN -AMBASE  
	.WORD	M_RCOIN -AMBASE  
	.WORD	M_4COIN -AMBASE	
	.WORD	M_SCOIN -AMBASE
	.WORD	M_TOTC  -AMBASE
	.WORD	M_START -AMBASE  
	.WORD	M_CONT  -AMBASE  
	.WORD	M_1TIME -AMBASE  
	.WORD	M_2TIME -AMBASE  
	.WORD	M_UPTIME-AMBASE 
	.WORD	M_XMEN -AMBASE   
	.WORD	M_RM11 -AMBASE   
	.WORD	M_RM12 -AMBASE   
	.WORD	M_RM13 -AMBASE   
	.WORD	M_RM14 -AMBASE   
	.WORD	M_RM15 -AMBASE   
	.WORD	M_MUT  -AMBASE   
	.WORD	M_RM21 -AMBASE   
	.WORD	M_RM22 -AMBASE   
	.WORD	M_RM23 -AMBASE   
	.WORD	M_RM24 -AMBASE   
	.WORD	M_RM25 -AMBASE   
	.WORD	M_FACE -AMBASE   
	.WORD	M_RM31 -AMBASE   
	.WORD	M_RM32 -AMBASE   
	.WORD	M_RM33 -AMBASE   
	.WORD	M_RM34 -AMBASE   
	.WORD	M_RM35 -AMBASE   
	.WORD	M_COB  -AMBASE   
	.WORD	M_AUTO -AMBASE   
	.WORD	M_WDOG -AMBASE   
	.WORD	>FFFF

*AUDIT MESSAGES
AMBASE:
M_LCOIN
	.STRING "LEFT COINS",0
        .EVEN

M_CCOIN  
	.STRING "CENTER COINS",0
        .EVEN

M_RCOIN  
	.STRING "RIGHT COINS",0
        .EVEN
M_4COIN	
	.STRING	"FOURTH COINS",0
	.EVEN

M_SCOIN
	.STRING	"SERV. CREDITS"
	.BYTE	0
	.EVEN

M_TOTC
	.STRING "TOTAL CREDITS"
         .BYTE   0
         .EVEN

M_START  
	.STRING "STARTS"
         .BYTE   0
         .EVEN

M_CONT   
	.STRING "CONTINUES"
         .BYTE   0
         .EVEN

;M_PLAYS 
;	 .STRING "TOTAL PLAYS"
;         .BYTE   0
;         .EVEN

M_1TIME  
	.STRING "1 PLAYER TIME"
         .BYTE   0
         .EVEN
M_2TIME  
	.STRING "2 PLAYER TIME"
         .BYTE   0
         .EVEN
M_UPTIME 
	.STRING "TOTAL UPTIME"
         .BYTE   0
         .EVEN
M_XMEN   
	.STRING "EXTRA MEN"
         .BYTE   0
         .EVEN
M_RM11   
	.STRING "ARENA 1.1"
         .BYTE   0
         .EVEN
M_RM12   
	.STRING "ARENA 1.2"
         .BYTE   0
         .EVEN
M_RM13   
	.STRING "ARENA 1.3"
         .BYTE   0
         .EVEN
M_RM14   
	.STRING "ARENA 1.4"
         .BYTE   0
         .EVEN
M_RM15   
	.STRING "ARENA 1.5"
         .BYTE   0
         .EVEN
M_MUT    
	.STRING "MUTOID MAN"
         .BYTE   0
         .EVEN
M_RM21   
	.STRING "ARENA 2.1"
         .BYTE   0
         .EVEN
M_RM22   
	.STRING "ARENA 2.2"
         .BYTE   0
         .EVEN
M_RM23   
	.STRING "ARENA 2.3"
         .BYTE   0
         .EVEN
M_RM24   
	.STRING "ARENA 2.4"
         .BYTE   0
         .EVEN
M_RM25   
	.STRING "ARENA 2.5"
         .BYTE   0
         .EVEN
M_FACE   
	.STRING "FLATFACE"
         .BYTE   0
         .EVEN
M_RM31   
	.STRING "ARENA 3.1"
         .BYTE   0
         .EVEN
M_RM32   
	.STRING "ARENA 3.2"
         .BYTE   0
         .EVEN
M_RM33   
	.STRING "ARENA 3.3"
         .BYTE   0
         .EVEN
M_RM34   
	.STRING "ARENA 3.4"
         .BYTE   0
         .EVEN
M_RM35   
	.STRING "ARENA 3.5"
         .BYTE   0
         .EVEN
M_COB    
	.STRING "COBRA"
         .BYTE   0
         .EVEN
M_AUTO   
	.STRING "AUTO CYCLES"
         .BYTE   0
         .EVEN
M_WDOG   
	.STRING "WATCH DOGS"
         .BYTE   0
         .EVEN
