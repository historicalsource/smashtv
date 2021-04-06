 	.FILE	'HSTAB.ASM'
	.TITLE	"ROBO HIGH-SCORE-TO-DATE TABLE ENTRY"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

;
; SOFTWARE:		 ROBERT ASHWORTH
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
	.INCLUDE	"LINK.EQU"		;LINKY EQUATES
	.INCLUDE	"SCRP.ASM"		;SCRIPT CONSTANTS

	.TEXT

*
         .GLOBAL         FREEPAL,DMAQWAIT,GETFPAL,PSCORE,RANDOM,P1DATA
         .GLOBAL         P2DATA,CLR_SCRN

*
*        OTHER MODULES
*
         .GLOBAL         VAL_TAB
         .GLOBAL         ROM_PTRS
         .GLOBAL         ALL_TAB
         .GLOBAL         TOD_TAB
         .GLOBAL         E_GAME
         .GLOBAL         INIT_TB

         .GLOBAL         HSTDTAB, SCRL_GO, SCRL_SRT, SCRL_END
         .GLOBAL         SCRL_DIV, SCRL_DIR, SCRL_FRC
         .GLOBAL         FADE_RAM

         .GLOBAL         RC_BYTEI
         .GLOBAL         GET_HSCR
         .GLOBAL         PT_ENTRY
         .GLOBAL         A2_CHECK      ;IN NARCHSTD DUE TO T.I.'S  BRAIN DAMAGE

         .GLOBAL         P1_INITS, P2_INITS, E_INITS
         .GLOBAL         P_FORK

         .GLOBAL         CHK_CMOS

	 .REF		 VCOUNT
*
*        THIS MODULE
*
         .GLOBAL         Y_CORR, RES_SCRL, P_SCRIPT, X_PL_SA3
         .GLOBAL         P1_SPRAY, P2_SPRAY, E_BRUSH, SC_CRAM
         .GLOBAL         SPR_CHAR, BINBCD, BCDBIN
         .GLOBAL         SPR_GPAL, SPR_FPAL 

         .BSS            SPR_PAL,16        ;GLOBAL FOR SPRAY PAINTERS

         .TEXT
*
*     ROM STRUCTURE FOR A GIVEN PAINTBRUSH:
*

WIDTH    EQU     0                      ;WORD   WIDTH IN BYTES
HEIGHT   EQU     WIDTH+WORD_SIZE        ;WORD   HEIGHT IN BYTES
DW       EQU     HEIGHT+WORD_SIZE       ;LONG   ADD TO CENTER FOR PLOTTING (NEGATIVE)
DH       EQU     DW+LONG_SIZE           ;LONG
UNIT_V   EQU     DH+LONG_SIZE           ;WORD   UNIT VECTOR SQUARED (2 BIT FRAC.)
S_DATA   EQU     UNIT_V+WORD_SIZE       ;WIDTH*HIGHT DATA BYTES.
*
*     RAM PARAMETERS FOR A SPRAY OPERATION:
*
*        for re-entrancy these offset from PDATA in process store
*

SPR_POINTER      EQU     PDATA                  ;LONG   POINTER TO BRUSH BEING USED.
SPR_PALETTE      EQU     SPR_POINTER+LONG_SIZE  ;WORD   6 BITS SAYS WHICH PALETTE
SPR_SCALER       EQU     SPR_PALETTE+WORD_SIZE  ;WORD   6 BIT FRACTION
SPR_X            EQU     SPR_SCALER+WORD_SIZE   ;LONG   X POSITION  12 bit fraction
SPR_Y            EQU     SPR_X+LONG_SIZE        ;LONG   Y POSITION  12 bit fraction
SPR_XV           EQU     SPR_Y+LONG_SIZE        ;LONG   X VELOCITY  Aligned to position
SPR_YV           EQU     SPR_XV+LONG_SIZE       ;LONG   Y VELOCITY
SPR_SCRIPT       EQU     SPR_YV+LONG_SIZE       ;LONG   CURRENT SCRIPT POINTER
SPR_Y_BASE       EQU     SPR_SCRIPT+LONG_SIZE   ;LONG   Y BASE FOR OUR MESSAGE
SPR_Y_SCROLL     EQU     SPR_Y_BASE+LONG_SIZE   ;LONG   CURRENT SCROLL POSITION
SPR_FIGURE       EQU     SPR_Y_SCROLL+LONG_SIZE ;LONG   Pointer to vectors in current figure.
SPR_SLEEP        EQU     SPR_FIGURE+LONG_SIZE   ;WORD   SLEEP PER BLOT (8 BIT FRACTION)
SPR_DIVIDER      EQU     SPR_SLEEP+WORD_SIZE    ;WORD   COUNT DOWN FRAMES TILL SLEEP
SPR_COL_BASE     EQU     SPR_DIVIDER+WORD_SIZE  ;WORD   BASE COLOR IN PALLATE 
                                                ;          DIVIDES 32 EVENLY.
SPR_COL_MAX      EQU     SPR_COL_BASE+WORD_SIZE ;WORD   BASE+32.  MAX COLOR ENTRY
SPR_BLOB_ROUT    EQU     SPR_COL_MAX+WORD_SIZE  ;LONG   ROUTINE TO CALL TO SPRAY BLOT
SPR_FUZZ_FLAG    EQU     SPR_BLOB_ROUT+LONG_SIZE ;WORD  NON ZERO SAYS ADD FUZZ
*                         FOR WALL SPRAYING, ITS A MASK FOR WHICH BITS TO KEEP
*                         FOR SPRAY ON BLACK, HIGH BYTE IS BASE.  LOW
*                                BYTE IS MASK FOR RANDY-NUM.
*
*        HSTD OUTPUT DATA MUST CO-EXIST WITH SPRAY DATA IN
*        PROCESS STORE AREA
*
HSTD_POINTER     EQU     SPR_FUZZ_FLAG+WORD_SIZE  ;WORD TABLE OFFSET OF NEXT ENTRY
HSTD_TABLE       EQU     HSTD_POINTER+WORD_SIZE   ;LONG POINTER TO TABLE BEING USED

         .STRING         "  NNAARRCC    --    CCOOPPYYRRIIGGHHTT  11998888  "  
         .STRING         "WWIILLLLIIAAMMSS  EELLEECCTTRROONNIICCSS  "
         .STRING         "GGAAMMEESS  IINNCC..    AALLLL  RRIIGGHHTTSS"
         .STRING         "  RREESSEERRVVEEDD..  "
         .STRING         "  --EEPPJJ  --GGNNPP  --TTRRAA  --LLEEDD  --JJEEHH  "
         .STRING         "  --JJRRNN  --MMLL  --GGWWSS  --LLIINN  --AALL  "
         .STRING         "  --BBLLSS  --MMLL  --TTJJEE  --DDTTWW  --RRMMGG  "
         .STRING         "  --WWBBDD  --JJBB  --JJRRHH  --DDPP  --JJPP  "
         .EVEN

HSTDTAB
         CALLR   RES_SCRL
         CLR     A0
         MOVE    A0,@DISPLAYON,W    ; TURN OFF DMA
         CALLA   DMAQWAIT           ; WAIT FOR DMA TO BE DONE (IF IN MOTION)
         JAUC    OUTPUT_HSTDS

**************************************************************************
*                                                                        *
*          OUTPUT HIGH SCORE TABLE                                       *
*                                                                        *
**************************************************************************
*
*        HSTD TABLE MUST BE OK BEFORE WE WOULD DO THIS PAGE.
*
OUTPUT_HSTDS
         CALLR   SPR_GPAL                  ;GET A PALETTE FOR SPRAYING
         CALLR   RES_SCRL                  ;RESET SCROLLING DATA

         MOVI    ALL_TAB,A8                ;THIS IS THE TABLE WE'RE INTERESTED IN
         MOVE    A8,*A13(HSTD_TABLE),L     ;PUT IN PROCESS AREA
         CALLA   VAL_TAB
         JRC     TABLE_DOA

         CALLA   CLR_SCRN             ;CLEAR OUT THE SCREEN

         JSRP    DRAW_BORDER

         MOVI    HIGHEST_NARCS,A4     ;FIRST PUT PUT TITLE SECTION.
         JSRP    P_SCRIPT

         MOVI    SCROLL_PROCESS,A7

         CALLA   P_FORK               ;FORK THE NEW PROCESS
         JRZ     TABLE_DOA            ;CAN'T GET A PROCESS.....EXIT NOW!

         CALLR   COPY_PDATA_AREA      ;PASS HIM OUR SPR_SCALER!

         MOVI    ALL_TIME_SPRAY_START*STRUCT_Y_UNIT,A1
         MOVE    A1,*A13(SPR_Y),L     ;THIS IS WHERE WE WILL SPRAY FROM!

         MOVK    1,A0
         MOVE    A0,*A13(HSTD_POINTER),W   ;ENTRY 1
         CALLR   SET_X_FOR_ENTRY           ;SET SCALER AND X COORDINATE

**************************************************************************
*                                                                        *
*          CLR     A0                                                    *
*          MOVE    A0,@TAB_NUM,W              ;COUNT ENTRIES...AFTER 3RD *
*                                                                        *
**************************************************************************
                                           ;SPEED UP THE DRAW RATE
         JSRP    SPRAY_A_TABLE
*
*        HIGHEST TABLE IS FINISHED.....NOW WE NEED TO PAINT THE
*        "TODAY'S TOP 5" TITLE.  HYPER THE Y TO THE CORRECT BASE
*

         MOVI    TODAYS_Y_HYPER,A0         ;THIS IS THE DISTANCE TO SKIP IT
         JSRP    HYPER_Y                   ;MOVE THE Y AND WAIT FOR IT TO GET IN RANGE
*
*        ALL TIME DONE....NOW ADD ON TODAYS
*
         MOVI    TOD_TAB,A8           ;THIS IS THE TABLE WE'RE INTERESTED IN
         MOVE    A8,*A13(HSTD_TABLE),L     ;PUT IN PROCESS AREA
         CALLA   VAL_TAB            ;TODAY TABLE DEAD
         JRC     TABLE_DOA

         MOVI    TOP_TODAY,A4               ;FIRST PUT PUT TITLE SECTION.
         JSRP    P_SCRIPT

         MOVI    TOP5_Y_HYPER,A0            ;PUSH UP THE Y AND WAIT
         JSRP    HYPER_Y

         MOVI    TOP_5,A4
         JSRP    P_SCRIPT

         MOVI    ENTRY_Y_HYPER,A0           ;MOVE DOWN FOR 1ST TABLE ENTRY
         JSRP    HYPER_Y
*
*        TODAY'S TOP 5 MESSAGE COMPLETE....NOW PRINT THE TOP 5 PLAYERS
*
         MOVK    1,A0
         MOVE    A0,*A13(HSTD_POINTER),W   ;ENTRY 1
         CALLR   SET_X_FOR_ENTRY           ;SET SCALER AND X COORDINATE

         JSRP    WAIT_A_TABLE
         JSRP    WAIT_FOR_SCROLL            ;WAIT TILL ITS IN POSITION

         SLEEP   180H                       ;LET EM LOOK

**************************************************************************
*                                                                        *
*          MOVI    6,A0                                                  *
*          MOVE    A0,@SCRL_GO,W                                         *
*          MOVE    A0,@SCRL_DIV,W                                        *
*                                                                        *
*          MOVE    *A13(SPR_PALETTE),A0,W    ;GET OUR PALETTE NUMBER     *
*          CALLR   POINT_AT_PALETTE          ;MAKE A0 A POINTER          *
*          MOVE    A0,@FADE_RAM,L            ;PASS THE POINTER           *
*          MOVI    START_FADE,A0                                         *
*          MOVE    A0,@SCRL_FRC,W            ;START THE FADE             *
*                                                                        *
*          SLEEP    120H                                                 *
*                                                                        *
*                                                                        *
**************************************************************************
TABLE_DOA
         MOVE    *A13(PROCID),A0,W    ;GET OUR ID
         MOVI    0FFFFH,A1
         CALLA   KILALL               ;KILL ANY OTHERS IN CASE OF BAD TABLE

         CLR     A0
         MOVE    A0,@SCRL_FRC,W       ;IN CASE BAD PATH COMES THROUGH...
*                                     ;TURN OFF THE SCROLLER!

         CALLR   SPR_FPAL             ;FREE UP THE SPRAYER PALETTE
         RETP                         ;RETURN TO SENDER!

**************************************************************************
*                                                                        *
*          SPRAY_A_TABLE                                                 *
*          WAIT_A_TABLE                                                  *
*                                                                        *
*          THIS IS CALLED TO SPRAY OUT ALL THE ENTRIES OF THE            *
*          CURRENT TABLE.                                                *
*                                                                        *
**************************************************************************
SPRAY_A_TABLE
PAINT_NEXT_ENTRY
         JSRP    DO_ENTRY                  ;PRINT OUT THIS ENTRY!

         CALLR   ENTRY_IN_A7               ;GET A8 SET.
         MOVE    *A8(TB_VISIBLE),A1,W      ;GET NUMBER WE'RE PLOTTING
         CMP     A1,A0                     ;ARE WE THERE?
         JRLO    NOT_DUN_YET               ;NOPE
         RETP                              ;ALL DONE...RETURN

NOT_DUN_YET
         INC     A0                        ;PUSH TO NEXT ONE.
         MOVE    A0,*A13(HSTD_POINTER),W   ;PUT BACK IN PROCESS STORE
         CALLR   SET_X_FOR_ENTRY           ;SET SCALER AND X COORDINATE
         CALLR   ADJUST_Y_OVER_A0          ;MOVE TO PLACE TO SPRAY NEXT
*
*        NOW WE KEEP CORRECTING Y FOR SCROLL, AND START TO
*        PAINT AGAIN WHEN OUR Y GETS HIGH ENOUGH TO STAY ON SCREEN
*
WAIT_A_TABLE
         JSRP    WAIT_FOR_Y
         JRUC    PAINT_NEXT_ENTRY          ;READY TO PAINT...GO!


HYPER_Y  MOVE    *A13(SPR_Y),A1,L          ;GET Y
         ADD     A0,A1
         MOVE    A1,*A13(SPR_Y),L          ;ITS NOW WHERE WE NEED IT
         JRUC    WAIT_FOR_Y                ;NOW WAIT FOR Y IN RANGE

**************************************************************************
*                                                                        *
*          WAIT_FOR_Y                                                    *
*                                                                        *
*          This is called by the high score table sprayers.              *
*          It waits for its base Y to get into visible territory         *
*          before allowing spraying.  The current Y is stored in         *
*          SPR_Y.  It updates the current y to the screen based          *
*          on the scrolling data stored at Y_CORR.  SPR_Y_SCROLL         *
*          is the processes own version to track how much movement       *
*          has occurred since the last update.                           *
*                                                                        *
**************************************************************************

WAIT_FOR_Y
         SLEEP   1
         MOVE    *A13(SPR_Y_SCROLL),A14,L    ;GET CURRENT SCROLLING COORDINATE
         MOVE    @Y_CORR,A10,L                ;GET THE ONE INDICATED BY IRQ

         SUB     A10,A14                   ;THIS IS NEGATIVE OF THE OFFSET
         NEG     A14                       ;TURN IT POSITIVE (OUR OFFSET)

         MOVE    A10,*A13(SPR_Y_SCROLL),L  ;STORE THIS BACK AS OUR DISTANCE

         MOVE    *A13(SPR_Y),A8,L          ;GET Y FOR CURRENT BLOB
         ADD     A14,A8                    ;ADD CORRECTION
         MOVE    A8,*A13(SPR_Y),L          ;STORE IT BACK

         CMPI    Y_TO_DRAW*STRUCT_Y_UNIT,A8    ;ARE WE HIGH ENOUGH
         JRHI    WAIT_FOR_Y                    ;not yet....wait some more

         RETP

*
*        THIS IS THE PASTELLY TABLE FROM ROBOTRON'S HSTD
*        TABLE
*
*INIT_BORDER_PALETTE
*         MMTM    SP,A0,A1,A2,A3
*         CALLR   POINT_AT_PALETTE          ;POINT AT REQUESTED PALETTE
*         MOVI    COLTAB,A1
*IBP1     MOVB    *A1,A2                    ;FETCH A BYTE
*         CALLR   A2_FROM_ROBO_PALETTE      ;TURN FROM ROBO PALETTE TO NARC
*         MOVE    A2,*A0+                   ;WRITE OUT THE BYTE
*         ADDI    BYTE_SIZE,A1
*         CMPI    CT_END,A1                 ;END OF TABLE?
*         JRLO    IBP1
*	MMFM    SP,A0,A1,A2,A3
*	RETS
*
*A2_FROM_ROBO_PALETTE
*         MMTM    SP,A3,A4
*         ANDI    BYTE_MASK,A2              ;KEEP BYTE
*         MOVE    A2,A3                     ;REDS IN A3
*         ANDI    7,A3                      ;KEEP REDS
*         SLL     12,A3                     ;MOVE REDS FROM UNITS TO HIGH
*         MOVE    A2,A4                     ;GREENS IN A4
*         ANDI    38H,A4                    ;MASK JUST GREEN
*         SLL     4,A4                      ;GREENS SET
*         ADD     A4,A3                     ;ADD GREENS TO RED
*         ANDI    0C0H,A2                   ;MASK BLUES
*         SRL     3,A2                      ;SHIFT TO POSITION
*         ADD     A3,A2                     ;A2 HAS THE COLOR WORD
*	MMFM    SP,A3,A4
*	RETS
*
*COLTAB .BYTE    000H                  ;BACKY IS COLOR ZERO
*       .BYTE    037H,02FH,027H,01FH,017H,047H,047H,087H
*       .BYTE    087H,0C7H,0C7H,0C6H,0C5H,0CCH,0CBH,0CAH
*       .BYTE    0C0H,0D0H,098H,038H,033H
*CT_END   

**************************************************************************
*                                                                        *
*          DRAW_BORDER                                                   *
*                                                                        *
*          THIS IS CALLED TO CREATE THE BORDER FOR THE "HIGHEST          *
*          SCORES FRAME.                                                 *
*                                                                        *
**************************************************************************
FIRST_BORDER_COLOR       EQU     0E0H
LAST_BORDER_COLOR        EQU     0E8H

RING_MIN_X    EQU     0
RING_MIN_Y    EQU     0
RING_MAX_X    EQU     512
RING_MAX_Y    EQU     400

RINGS    EQU     12                   ;12 RINGS OF 2 STRIPES ON BORDER

DRAW_BORDER
         CLR     A3              ;PALETTE 0
*         MOVE    A3,A0           ;GET PALETTE READY FOR SETUP.
*         CALLR   INIT_BORDER_PALETTE   ;SET THE PALETTE!
         CLR     A0              ;START WITH RING 0

         MOVI    FIRST_BORDER_COLOR,A8          ;THIS IS COLOR MIN
         MOVI    RING_MAX_Y,A7                  ;Y EXTENT OF BORDER.
         CLR     A9                             ;A9 IS Y OFFSET FOR DRAW RING

BORDER_LOOP
         MOVE    A8,A1           ;USE CURRENT COLOR
         CALLR   NEXT_IN_A8
         MOVE    A8,A2           ;NEXT IN A2
         CALLR   NEXT_IN_A8
         CALLR   DRAW_RING
         INC     A0              ;SET FOR NEXT RING
         CMPI    RINGS,A0           ;DO 20 RINGS.
         JRLS    BORDER_LOOP
         RETP

NEXT_IN_A8
         INC     A8
         CMPI    LAST_BORDER_COLOR,A8      ;ARE WE IN RANGE
         JRLS    NIA1                      ;YEP

         MOVI    FIRST_BORDER_COLOR,A8
NIA1     RETS

**************************************************************************
*                                                                        *
*          EXTRA_RING                                                    *
*                                                                        *
*          THIS IS CALLED TO ADD THE EXTRA RING WHICH WILL BE SCROLLED   *
*          THROUGH THE BACKGROUND.                                       *
*                                                                        *
**************************************************************************
EXTRA_RING
         MMTM    SP,A0,A1,A2,A3,A9
         MOVI    RINGS+1,A0      ;RING D
         MOVI    0E8H,A1         ;OUTER RING
         MOVI    0E0H,A2         ;INNER RING
         CLR     A3              ;PALETTE ZERO
         MOVI    RING_MAX_Y,A7                  ;Y EXTENT OF BORDER.
         CLR     A9                             ;NO Y OFFSET OF THIS RING
         CALLR   DRAW_RING
	MMFM    SP,A0,A1,A2,A3,A9
	RETS

**************************************************************************
*                                                                        *
*          DRAW_RING                                                     *
*                                                                        *
*          THIS IS CALLED TO DRAW A RING AROUND THE SCREEN BASED         *
*          ON A0.                                                        *
*                                                                        *
*          A0 IS THE RING NUMBER.  THE OUTERMOST RING IS ZERO.           *
*          A RING IS 2 PIXELS HIGH AND 2 PIXELS WIDE.                    *
*                                                                        *
*          THE "OUTER" BYTE TO USE IS PASSED IN A1                       *
*                                                                        *
*          THE "INNER" BYTE TO USE IS PASSED IN A2                       *
*                                                                        *
*          THE PALETTE NUMBER TO USE IS IN A3.                           *
*                                                                        *
*          The y-max to be used is passed in A7                          *
*                                                                        *
*          A Y OFFSET IS PASSED IN A9.  THIS DISPLACES WHOLE RING        *
*          VERTICALLY                                                    *
*                                                                        *
*          THIS IS RING 0.                                               *
*                                                                        *
*          0000000000000000000000000000000000000000                      *
*          1111111111111111111111111111111111111111                      *
*          01                             MAX-1 MAX                      *
*          01                             MAX-1 MAX                      *
*          01                             MAX-1 MAX                      *
*          MAX-1 MAX-1 MAX-1 MAX-1 MAX-1 MAX-1  MAX                      *
*          MAX   MAX   MAX   MAX   MAX   MAX    MAX                      *
*                                                                        *
*          THIS IS RING 1.                                               *
*                                                                        *
*          22222222222222222222222222222222222222222                     *
*          33333333333333333333333333333333333333333                     *
*          23                            MAX-3 MAX-2                     *
*          23                            MAX-3 MAX-2                     *
*          23                            MAX-3 MAX-2                     *
*          MAX-3 MAX-3 MAX-3 MAX-3 MAX-3 MAX-3 MAX-3                     *
*          MAX-2 MAX-2 MAX-2 MAX-2 MAX-2 MAX-2 MAX-2                     *
*                                                                        *
**************************************************************************

DRAW_RING
         MMTM    SP,A1,A2,A3,A4,A5,A6

         MOVE    A3,@CMAPSEL,W        ;SET THE PALETTE PASSED

         CALLR   X_COUNT_IN_A3        ;GET THE COUNT FOR X IN A3
         MOVE    A0,A4                ;GET THE RING NUMBER
         SLL     1,A4                 ;DOUBLE FOR OFFSET
         ADDI    RING_MIN_X,A4             ;ADD TO LEFT EDGE PARAMETER
         SLL     3,A4                 ;SHIFT TO X POSITION.
         MOVE    A0,A5                ;GET FOR Y
         SLL     1,A5                 ;DOUBLE FOR OFFSET
         ADDI    RING_MIN_Y,A5
         ADD     A9,A5                ;ADD IN VERTICAL OFFSET
         SLL     12,A5                ;DOUBLE AND SHIFT TO Y COORDINATE
         ADD     A5,A4                ;A4 NOW POINTS AT PLACE TO STORE

         MOVE    A1,A5                ;COPY OUTSIDE PIX
         SLL     8,A1
         ADD     A5,A1                ;NOW WE HAVE DOUBLE OUTSIDES IN A1

         MOVE    A2,A5                ;NOW WE HAVE DOUBLE INSIDES IN A2
         SLL     8,A2
         ADD     A5,A2

DR1:
         MOVE    A2,*A4(SCREEN_PITCH*BYTE_SIZE),W    ;INSIDE IN ROW 2
         MOVE    A1,*A4+,W                 ;OUTSIDE IN ROW 1
         DSJS    A3,DR1                    ;LOOP TILL THEY'RE ALL DONE

         ADDI    (SCREEN_PITCH*BYTE_SIZE)-WORD_SIZE,A4  ;CORRECT TO 1 ROW DOWN
         CALLR   Y_COUNT_IN_A3
*
*        NOW WE NEED <INSIDE><OUTSIDE> PACKED INTO A WORD
*
         MOVE    A1,A6                     ;INSIDE
         ANDI    0FF00H,A6                 ;HOLD HIGH OF INSIDE
         MOVE    A2,A5                     ;OUTSIDE
         ANDI    0FFH,A5
         ADD     A6,A5                     ;A5 HAS THE WORD

DR2      MOVE    A5,*A4,W                  ;STORE IN THIS ROW
         ADDI    (SCREEN_PITCH*BYTE_SIZE),A4
         DSJS    A3,DR2                    ;LOOP TILL THEY'RE ALL DONE

         MOVE    A1,*A4,W                  ;GET LOWER RIGHT CORNER IN
         SUBI    (SCREEN_PITCH*BYTE_SIZE)+WORD_SIZE,A4  ;MOVE POINTER

         CALLR   X_COUNT_IN_A3             ;RELOAD X COUNT
         DEC     A3                        ;1 LESS WORD TO LEAVE LOWER RIGHT OK

DR3      MOVE    A1,*A4(SCREEN_PITCH*BYTE_SIZE),W    ;OUTER COLOR IN NEXT ROW
         MOVE    A2,*A4,W                  ;INNER COLOR IN THIS ROW
         SUBI    WORD_SIZE,A4              ;POINT AT PREVIOUS WORD
         DSJS    A3,DR3                    ;LOOP TILL THEY'RE ALL DONE

         ADDI    WORD_SIZE,A4              ;MOVE BACK TO BORDER 1 UP
         CALLR   Y_COUNT_IN_A3
*
*        NOW WE NEED <OUTSIDE><INSIDE> PACKED INTO A WORD
*
         MOVE    A2,A6                     ;OUTSIDE
         ANDI    0FF00H,A6                 ;HOLD HIGH OF INSIDE
         MOVE    A1,A5                     ;INSIDE
         ANDI    0FFH,A5
         ADD     A6,A5                     ;A5 HAS THE WORD

DR4      MOVE    A5,*A4,W                  ;STORE IN THIS ROW
         SUBI    (SCREEN_PITCH*BYTE_SIZE),A4
         DSJS    A3,DR4                    ;LOOP TILL THEY'RE ALL DONE
	MMFM    SP,A1,A2,A3,A4,A5,A6
	RETS

X_COUNT_IN_A3
         MMTM    SP,A5
         MOVI    RING_MAX_X,A3             ;FIND HOW MANY TO DO.
         SUBI    RING_MIN_X,A3             ;THIS IS AREA SPANNED
         MOVE    A0,A5                ;GET RING NUMBER
         SLL     2,A5                 ;2X FOR 2 WIDE....2X FOR LEFT AND RIGHT SIDE
         SUB     A5,A3                ;THIS IS NUMBER OF PIXELS TO DRAW
         SRL     1,A3                 ;THIS IS NUMBER OF WORDS.
	MMFM    SP,A5
	RETS

Y_COUNT_IN_A3
         MMTM    SP,A5
         MOVE    A7,A3                ;FIND HOW MANY TO DO.
         SUBI    RING_MIN_Y,A3        ;THIS IS AREA SPANNED
         MOVE    A0,A5                ;GET RING NUMBER
         SLL     2,A5                 ;2X FOR 2 WIDE....2X FOR LEFT AND RIGHT SIDE
         SUB     A5,A3                ;THIS IS NUMBER OF PIXELS TO DRAW
         SUBI    2,A3                 ;DON'T TOUCH OUTSIDE LINES IN Y
	MMFM    SP,A5
	RETS

RES_SCRL
         MMTM    SP,A1
         CLR     A1
         MOVE    A1,@SCRL_FRC,W  ;THIS KEEPS INTERRUPTS OUT!
         MOVE    A1,@Y_CORR,L   ;TRASH ANY ACCUMULATION
         MOVE    A1,*A13(SPR_Y_SCROLL),L        ;LINE THIS UP WITH OUR PROCESS
         MOVE    A1,@SCRL_DIV,W        ;TURN OFF SCROLLER  
         MOVE    A1,@SCRL_GO,W         ;AND ANY RESIDUAL ACTIVITY
	MMFM    SP,A1
	RETS

**************************************************************************
*                                                                        *
*          SCROLL_PROCESS                                                *
*                                                                        *
*          THIS PROCESS DOES SCROLLING AND TRANSITION CONTROL            *
*          DURING THE HIGH SCORE TABLE SPRAY PAINTING.                   *
*                                                                        *
*          THE FOLLOWING DATA IS MAINTAINED IN ITS PROCESS AREA:         *
*                                                                        *
**************************************************************************
*
*        THE FOLLOWING DATA IS PUT IN THE PROCESS AREA
*        OF THE SCROLLER.  THE SCROLLER STARTS WITH
*        AN EXACT COPY OF THE DATA AREA OF THE MASTER
*        TABLE PROCESS.  THE RELEVANT DATA IS AT
*        SPR_SCALER AND HSTD_TABLE.  THIS DATA
*        IS DESINED TO FIT IN BETWEEN!
*
SP_NUM_AT_TOP    EQU     SPR_SCALER+WORD_SIZE        ;WORD - TABLE OFFSET OF
*                                                            NEXT TO HIT THE TOP
SP_CURRENT_TOP   EQU     SP_NUM_AT_TOP+WORD_SIZE     ;WORD - SCROLL Y
SP_RING_OFFSET   EQU     SP_CURRENT_TOP+WORD_SIZE    ;WORD - Y OFFSET NEXT RING!
SP_BOXES         EQU     SP_RING_OFFSET+WORD_SIZE    ;WORD - NUMBER OF BOXES (SAFETY)
SP_BOX_ON_LAST   EQU     SP_BOXES+WORD_SIZE          ;WORD - NON-ZERO IF BOX DRAWN ON LAST ENTRY
SP_END_LOCAL     EQU     SP_BOX_ON_LAST+WORD_SIZE

         .IF     SP_END_LOCAL>HSTD_TABLE
                 XXX             SP_ STRUCUTURE OVERFLOW
         .ENDIF

SCROLL_PROCESS
         SLEEP   INITIAL_SCROLL_DELAY
         MOVI    SCROLL_TOP1,A0
         MOVE    A0,@SCRL_SRT,W
         MOVI    SCROLL_BOT,A0                 
         MOVE    A0,@SCRL_END,W                
         MOVI    2000H,A0                  ;SCROLL UP 2 PIXELS
         MOVE    A0,@SCRL_DIR,W
         MOVI    2,A0                      ;EVERY 2 FRAMES
         MOVE    A0,@SCRL_DIV,W            
         MOVE    A0,@SCRL_GO,W             ;MUST DO THIS ONCE TO START IT!
*
*        ABOVE IS STEADY STUFF FOR SCROLLING
*
         MOVI    DIST_1_TO_TOP,A3           ;THIS GETS #1 SCORE TO THE TOP!
         JSRP    WAIT_FOR_A3
*
*        NUMBER 1 JUST HIT THE TOP.  WE NEED TO MOVE THE SCROLL
*        BAR AND ADD THE WHITE LINE.
*
         CLR     A9                         ;A9 SPECIFIES Y OFFSET OF BOX
         CALLR   SCORE_BOX

         MOVI    SCROLL_TOP2,A0            ;NOW MOVE SCROLL TOP TO KEEP HIGH SCORE
         MOVE    A0,*A13(SP_CURRENT_TOP),W  ;SAVE WHERE WE'RE SCROLLING FROM
         MOVE    A0,@SCRL_SRT,W

         MOVI    2,A0
         MOVE    A0,*A13(SP_NUM_AT_TOP),W  ;INDICATE NUMBER 2 IS CURRENT SCORE AT TOP!

         CLR     A0                        ;INDICATE OFFSET FOR CURRENT RING IS ZERO
         MOVE    A0,*A13(SP_RING_OFFSET),W ;PUT IN PROCESS AREA
         MOVE    A0,*A13(SP_BOXES),W       ;NO BOXES YET
         MOVE    A0,*A13(SP_BOX_ON_LAST),W ;NO BOX ON LAST ENTRY
*
*        NOW WE NEED TO SCROLL UP 1 SCORE AT A TIME AND EACH TIME A
*        SCORE HITS THE SCROLL BAR FRAME, WE FRAME IT IF NECESSARY!
*
*        AT THIS POINT IN THE CODE...THE SCORE INDICATED BY SP_NUM_AT_TOP
*        IS IN POSITION.....CHECK TO SEE IF IT SHOULD BE BOXXED!
*
NEXT_NAME_AT_TOP
         MOVE    *A13(SP_NUM_AT_TOP),A0,W       ;THIS IS ONE WE NEED TO CHECK
         CALLR   FETCH_SCORE_A0                 ;GET THIS SCORE IN A1

         MOVE    A1,A2                          ;SAVE THE CURRENT SCORE
         INC     A0                             ;POINT AT NEXT SCORE
         CALLR   FETCH_SCORE_A0                 ;IF ITS IDENTICAL THEN CURRENT
         CMP     A1,A2                          ;CAN'T BE JUST ENTERED!
         JREQ    DONT_BOX                       ;IT IS...DON'T BOX THIS ONE!

         CALLA   A2_CHECK                       ;DOES A2 MATCH EITHER PLAYER?
         JRNZ    DONT_BOX                       ;NOPE....SORRY!
*
*        WE NEED TO BOX THE CURRENT ENTRY!
*
         MOVE    *A13(SP_BOXES),A0,W        ;GET NUMBER OF BOXES OUT THERE
         CMPI    2,A0
         JRHS    DONT_BOX                   ;TOO MANY BOXES.....EXIT

         INC     A0
         MOVE    A0,*A13(SP_BOXES),W        ;CHALK IT

         CALLR   GET_INTEGRAL_LINES         ;NUMBER OF LINES PER ENTRY IN A3

         MOVE    *A13(SP_RING_OFFSET),A9,W     ;GET CURRENT RING DROP OFFSET
         ADD     A3,A9                     ;NEXT RING DROPS BY THIS  
         MOVE    A9,*A13(SP_RING_OFFSET),W ;SAVE FOR NEXT BOX.
          
         CALLR   SCORE_BOX                 ;THIS BOXES THE SCORE...NOW MOVE SCROLL POINT                            
*
*        IF WE DRAW A BOX AROUND THE LAST ENTRY, WE NEED TO KNOW TO
*        SCROLL THE BOXES EARLIER!
*

         MOVE    *A13(SP_NUM_AT_TOP),A1,W       ;THIS IS ONE WE NEED TO CHECK
         CMPI    ALL_TIME_VISIBLE,A1            ;DON'T COUNT BOX AROUND LAST ONE!
         JRNZ    NOT_LAST_ENTRY

         MOVE    A1,*A13(SP_BOX_ON_LAST),W      ;SET FLAG....
*
*        NOW CHANGE THE SCORLL POINT STUFF GOES UNDER THE BOX
*        A3 GOT SMASHED......GET A NEW VERSION
*
NOT_LAST_ENTRY
         CALLR   GET_INTEGRAL_LINES        ;THIS GETS LINE COUNT IN A3 
         MOVE    *A13(SP_CURRENT_TOP),A0,W  ;SAVE WHERE WE'RE SCROLLING FROM
         ADD     A3,A0
         MOVE    A0,@SCRL_SRT,W
         MOVE    A0,*A13(SP_CURRENT_TOP),W  ;AND PUT BACK IN PROCESS AREA.

         CALLR   NEXT_ON_TOP                ;NOW, NEXT ENT IS AT "NEW" TOP
         JRNZ    NEXT_NAME_AT_TOP           ;NOW CHECK IF IT NEEDS A BOX.

         JRUC    LAST_ENT_ON_TOP            ;STAGE REST OF JOB!
*
*        IT IS TIME TO SCROLL FROM THE "CURRENT" ENTRY UP TO THE
*        "NEXT" ENTRY.
*
DONT_BOX CALLR   NEXT_ON_TOP               ;MOVE TO NEXT NUMBER
         JRZ     LAST_ENT_ON_TOP           ;NO MORE TO SCROLL.
*
*        WE NEED TO MOVE UP BY ONE ENTRY.......LETS TRIGGER THE SCROLL.
*
         JSRP    PSYCHO_CHECK              ;SEE IF ITS TIME FOR BACKGROUND
         JSRP    WAIT_FOR_A3               ;NOW WAIT FOR THE SCORE TO HIT!

         JRUC    NEXT_NAME_AT_TOP          ;ITS THERE...CHECK FOR BOX!
*
*        ALL TIME TABLE IS DONE....
*
LAST_ENT_ON_TOP
*
*        NOW......UNLESS SP_BOX_ON_LAST IS NON-ZERO, THE LAST ENTRY
*        IS BETWEEN THE LAST BOX AND THE PSYCHO BACKGROUND.
*        WE NEED TO SCROLL ENOUGH TO JOIN THESE.
*
         MOVE    *A13(SP_BOX_ON_LAST),A0,W      ;SKIP THE JOIN?
         JRNZ    BOX_ON_LAST                    ;YEP...JUST SCROLL JOIN AMOUNT

         CALLR   GET_INTEGRAL_LINES             ;FETCH THE LINES PER ENTRY
         SRL     1,A3                           ;2 LINES AT A TIME
         JSRP    WAIT_FOR_A3                    ;SCROLL THIS MANY LINES
*
*        NOW CHANGE SCROLL TOP BACK TO TOP TO SCROLL SCORE(S) OFF
*
BOX_ON_LAST
         MOVI    SCROLL_TOP3,A0            ;NOW MOVE SCROLL TOP TO KEEP HIGH SCORE
         MOVE    A0,@SCRL_SRT,W
*
*        AT THIS POINT WE HAVE JOINED THE BACKGROUND TO THE BOTTOM
*        BOX.  HOWEVER, WHERE WE ARE ON THE SCREEN DEPENDS ON HOW
*        MANY BOXES ARE THERE.  WE NEED TO SCROLL 1 SCORE HEIGHT 
*        FOR EACH OF THE 2 POSSIBLE EXTRA BOXES.
*
         MOVE    *A13(SP_BOXES),A0,W        ;GET NUMBER OF BOXES OUT THERE
         JRZ     NO_EXTRA_BOXES             ;NONE THERE....RESUME

         CALLR   GET_INTEGRAL_LINES         ;FETCH THE LINES PER ENTRY
         SRL     1,A3                       ;2 LINES AT A TIME
         MPYU    A0,A3                      ;TIMES EXTRA BOXES!
         JSRP    WAIT_FOR_A3                ;SCROLL THIS MUCH EXTRA

NO_EXTRA_BOXES
         MOVI    FINAL_SCROLL,A3
         MOVE    A3,@SCRL_FRC,W             ;THIS IS NUMBER OF FRAMES TO SCROLL

         JAUC    SUCIDE                     ;THAT'S ALL OUR WORK

**************************************************************************
*                                                                        *
*          GET_INTEGRAL_LINES                                            *
*                                                                        *
*          RETURN NUMBER OF VERTICAL LINES PER ENTRY IN A3.              *
*                                                                        *
**************************************************************************
GET_INTEGRAL_LINES
         CALLR   GET_LINES_PER_ENTRY       ;THIS GETS 12 BIT FRAC VERSION
         SRL     6,A3                      ;THIS MAKES IT INTEGRAL LINES
         RETS

**************************************************************************
*                                                                        *
*          PSYCHO_CHECK                                                  *
*                                                                        *
*          This is called to check if its time to start the              *
*          psycho background.  If its not psycho time we return          *
*          the frame count for 1 entry in a3  (it will scroll that       *
*          much).  If it is psycho time, we scroll enough frames         *
*          till we should hit it, then we hit it, then we return         *
*          the balance of the scroll for this entry.                     *
*                                                                        *
**************************************************************************
PSYCHO_CHECK
         CALLR   GET_LINES_PER_ENTRY       ;THIS GETS LINE COUNT IN A3 
         SRL     7,A3                      ;6 BIT FRAC....AND DIVIDE BY 2
*
*        A3 HAS THE NUMBER OF DOUBLE LINES TO SCROLL.
*
         MOVE    *A13(SP_NUM_AT_TOP),A0,W  ;GET THE NUMBER WE'RE GOING TO
         MOVE    *A13(SP_BOXES),A1,W       ;REMOVE NUMBER OF BOXES.
         SUB     A1,A0
         CMPI    PSYCHO_BOX_NUMBER,A0      ;IS THIS TIME?
         JRNZ    PSYCHO_EXIT
*
*        BETWEEN THIS ENTRY AND THE NEXT.
*
         MOVE    A3,A8                     ;PUT WHOLE COUNT IN A8
         MOVI    PSYCHO_FRACTION,A0        ;THIS IS AMOUNT TO SCROLL FIRST
         SUB     A0,A8                     ;REMOVE THIS (FOR REMAINDER)

         MOVE    A0,@SCRL_FRC,W            ;THIS IS NUMBER OF FRAMES TO SCROLL
         JSRP    WAIT_FOR_SCROLL           ;NOW WAIT FOR THE PERFECT MOMENT

         MOVE    A8,A3                     ;RETURN THE EXTRA FRACTION

PSYCHO_EXIT
         RETP                              ;RETURN TO CALLER

**************************************************************************
*                                                                        *
*          NEXT_ON_TOP                                                   *
*                                                                        *
*          THIS IS CALLED TO STEP THE "CURRENT SCORE ON TOP"             *
*          (AT SP_NUM_AT_TOP) BY ONE AND CHECK TO SEE IF                 *
*          THE NEXT ONE IS OUT OF VISIBLE RANGE.                         *
*                                                                        *
*          .EQ. MEANS WE'RE DONE                                         *
*          .NE. MEANS KEEP GOING                                         *
*                                                                        *
**************************************************************************
NEXT_ON_TOP
         MMTM    SP,A1
         MOVE    *A13(SP_NUM_AT_TOP),A1,W  ;GET THE ONE ON TOP
         CMPI    ALL_TIME_VISIBLE,A1       ;IS THIS THE LAST?
         JRLO    NEX_CON                   ;THERE'S ROOM FOR MORE

         CLR     A1                        ;SET .EQ.
         JRUC    NO_NEXT                   ;ANE RETURN

NEX_CON
         INC     A1                        ;KICK TO NEXT
         MOVE    A1,*A13(SP_NUM_AT_TOP),W  ;AND PUT BACK
NO_NEXT
	MMFM    SP,A1
	RETS

**************************************************************************
*                                                                        *
*          SCORE_BOX                                                     *
*                                                                        *
*          THIS IS CALLED TO ADD THE WHITE RING AROUND THE SCORE AT THE  *
*          TOP OF THE SCREEN.  THE VERTICAL OFFSET (IN Y LINE UNITS)     *
*          IS PASSED IN A9.                                              *
*                                                                        *
**************************************************************************
SCORE_BOX
         MOVI    RINGS+3,A0       ;leave a 2 unit border
         MOVI    SCORE_BOX_Y,A7   ;THIS SETS BOX HEIGHT
*
*        THIS IS THE BOX AROUND NUMBER 1
*
MINI_RING_1
         MOVI    0F5H,A1         ;USE BRIGHT COLOR FOR BOX.
         MOVE    A1,A2
         CLR     A3              ;PALETTE ZERO
         CALLR   DRAW_RING

         INC     A0
         CMPI    RINGS+5,A0
         JRLO    MINI_RING_1
         RETS

**************************************************************************
*                                                                        *
*          WAIT_FOR_SCROLL                                               *
*                                                                        *
*          HOLD CONTROL TILL REQUESTED SCROLLING IS COMPLETED.           *
*                                                                        *
**************************************************************************
WAIT_FOR_A3
         MOVE    A3,@SCRL_FRC,W             ;STORE A3 AS THE SCROLL
WAIT_FOR_SCROLL
TL1      SLEEP   1
         MOVE    @SCRL_FRC,A0,W             ;WAIT FOR NUMBER 1 TO GET THERE
         JRNE    TL1
         RETP
**************************************************************************
*                                                                        *
*          P_SCRIPT                                                *
*                                                                        *
*          THIS IS CALLED WITH A SCRIPT POINTER IN A4.  IT               *
*          PAINTS BASED ON THE SCRIPTED COMMANDS.                        *
*                                                                        *
*          THE FOLLOWING COMMANDS EXIST FOR SCRIPTS:                     *
*                                                                        *
*             SET COLOR FOR BLACK DRAW (FOLLOWED BY COLOR BYTE           *
*             SET COLOR FOR WALL DRAW  (LONG POINTER TO PALETTE DATA     *
*             SAVE IN PROCESS STORE    (SKIP BYTE IF NEC. THEN OPERANDS) *
*                          BRUSH                                         *
*                          NEW COLOR                                     *
*                          SCALE FACTOR                                  *
*                          FUZZ FACTOR                                   *
*                          X    (CURSOR)                                 *
*                          Y                                             *
*                          DRAWING RATE (SLEEP)                          *
*                          NUMBER WIDTH (MULTI DIGIT NUM-NUMS)           *
*             OUTPUT SCORE IN A0 (AT CURSOR).  (NO OPERAND)              *
*             OUTPUT (SPRAY) CHARCTER.         (OPERAND IN 2ND BYTE)     *
*             CALL "SUBROUTINE"                (SKIP BYTE IF NEC.)       *
*             END OF SCRIPT                    (NO OPERAND               *
*                                                                        *
*                     SCRIPT IS "BYTE" ORIENTED.  FOLLOWING WORD AND     *
*                     LONGWORD OPERANDS WILL BE AFTER A "SKIPPED"        *
*                     BYTE IF THE OPCODE BYTE IS ON A WORD BOUNDARY.     *
*                     IF OPCODE BYTE ADDRESS ENDS IN "8" THEN            *
*                     WORD AND LONG WORD OPERANDS FOLLOW IMMEDIATELY.    *
*                                                                        *
*                     THIS SOFTWARE WILL POSSIBLY BE USED FOR AUDITS     *
*                     ETC. IN WHICH CASE 1 BYTE PER CHAR IN MESSAGE      *
*                     WILL USE GENUINE ASCII DATA                        *
*                                                                        *
**************************************************************************

P_SCRIPT
SCRIPT_RET
         CALLR   BYTE_FETCH     ;FETCH AN OPERAND BYTE
         CMPI    LAST_OPERATOR,A1 ;IS IT IN RANGE
         JRLS    SCRIPT_IN_RANGE

SPURIOUS_END
         .IF DEBUG
            JRUC   $                         ;HANG IN DEVELOPMENT
         .ENDIF

SCRIPT_DONE
         RETP                                ;RETURN IF THIS HAPPENS IN FIELD!

SCRIPT_IN_RANGE
         SLL     5,A1                        ;MAKE IT OFFSET INTO TABLE
         JRZ     SCRIPT_DONE                 ;THAT'S ALL FOLKS
         ADDI    SCRIPT_VECTORS,A1           ;NOW WE POINT AT ROUTINE TO USE
         MOVE    *A1,A1,L                    ;FETCH THE ROUTINE
*
*        THIS IS THE "JSRP" MACRO CODED IN LINE
*
         MOVI    SCRIPT_RET,A7   ;JUST LOAD UP RETURN ADDRESS
	MOVE	A7,-*A12,L	;PUSH RET ADDR
	JUMP    A1              ;DO THE "JSRP"

SCRIPT_VECTORS
         .LONG   SPURIOUS_END         ;0 SHOULD BE GRABBED BEFORE VECTOR 
         .LONG   DO_COL_FOR_BLACK
         .LONG   DO_COL_FOR_WALL
         .LONG   DO_SPRAY_SCORE
         .LONG   DO_SUBROUTINE
         .LONG   DO_WORD
         .LONG   DO_LONG
         .LONG   DO_SPRAY_CHARACTER
         .LONG   DO_SPRAY_CHAR_A0
         .LONG   DO_FORK
         .LONG   DO_SLEEP
         .LONG   DO_ENTRY
         .LONG   DO_BLACK_BLOB
         .LONG   DO_WALL_BLOB
         .LONG   DO_GPAL              ;SET OUR PALETTE TO GLOBAL
         .LONG   DO_DY                ;DELTA Y

**************************************************************************
*                                                                        *
*          SPR_GPAL                                                      *
*                                                                        *
*          THIS IS CALLED TO ALLOCATE A GLOBAL PALETTE FOR               *
*          SPRAY PAINTING.                                               *
*                                                                        *
**************************************************************************
SPR_GPAL MMTM    SP,A0
         MOVI    BRUSH_ROM,A0              ;INITIALIZE W/ GARBAGE
         CALLA   GETFPAL
         MOVE    A0,@SPR_PAL,W              ;STORE PALETTE IN MEMORY
	MMFM    SP,A0
	RETS

SPR_FPAL MMTM    SP,A0
         MOVE    @SPR_PAL,A0,W
         CALLA   FREEPAL                   ;FREE UP THE SPRAY PALETTE
	MMFM    SP,A0
	RETS

DO_GPAL  MOVE    @SPR_PAL,A0,W             ;GET GLOBAL PALETTE
         MOVE    A0,*A13(SPR_PALETTE),W    ;STORE IN PROCESS AREA
         RETP                              ;AND RETURN

**************************************************************************
*                                                                        *
*          DO_COL_FOR_BLACK                                              *
*                                                                        *
*          THIS ASSUMES PROCESS CONTAINS PALETTE NUMBER.                 *
*          (SET IN ASSEMBLY BEFORE INVOKING SCRIPT OR USING              *
*          A "DO_WORD" SCRIPT COMMAND)                                   *
*                                                                        *
**************************************************************************
DO_COL_FOR_BLACK
         CALLR   BYTE_FETCH                ;FETCH NEXT BYTE IN A1
         MOVE    *A13(SPR_PALETTE),A0,W    ;GET THE CURRENT PALETTE IN A0
         CALLR   PALETTE_FOR_BLACK_SPRAY   ;SET FOR SPRAY ON BLACK
         RETP

DO_COL_FOR_WALL
         CALLR   LONG_FETCH                ;SETUP TABLE FOR PALETTE
         MOVE    *A13(SPR_PALETTE),A0,W    ;GET THE CURRENT PALETTE IN A0
         CALLR   PALETTE_FOR_WALL_SPRAY
         RETP

**************************************************************************
*                                                                        *
*          DO_DY                                                         *
*                                                                        *
*          THIS IS FOLLOWED BY A LONG WORD THAT MODIFIES THE             *
*          CURRENT Y COORDINATE.  IT IS ADDED TO THE LONG                *
*          WORD Y POSITION.                                              *
*                                                                        *
**************************************************************************
DO_DY
         CALLR   LONG_FETCH                ;GET DELTA
         MOVE    *A13(SPR_Y),A0,L          ;GET Y
         ADD     A1,A0                     ;ADD DELTA
         MOVE    A0,*A13(SPR_Y),L          ;AND WE'RE DONE!
         RETP

**************************************************************************
*                                                                        *
*          DO_SPRAY_SCORE                                                *
*                                                                        *
*          THIS IS CALLED WITH A0 CONTAINING AN 8 DIGIT NUMBER           *
*          TO BE SPRAYED (USING SETUP PARAMETERS) AT THE CURRENT         *
*          POSITION.  IT IS TO BE LEAD ZERO BLANKED AND COMMAS           *
*          ADDED AT THE APPROPRIATE POSITION.  BEWARE THAT               *
*          DRAW_FIGURE SLEEPS, THUS STATE DATA MUST BE KEPT IN           *
*          THE PROCESS AREA.                                             *
*                                                                        *
**************************************************************************
DO_SPRAY_SCORE
         RETP                         ;WE'LL DO THIS LATER

**************************************************************************
*                                                                        *
*          DO_ENTRY                                                      *
*                                                                        *
*          THIS IS CALLED TO SPRAY THE "CURRENT ENTRY" IN THE            *
*          "CURRENT" HSTD WITH THE "CURRENT" PARAMETERS SETUP.           *
*                                                                        *
**************************************************************************
*
*        THE ENTRY IS PRINTED FROM X=0 IN THE FOLLOWING FORM:
*
*                  12) <MARGIN_1> LED <MARGIN_2> SCORE
*
*        THE MARGINS ARE SCALED ACCORDING TO THE CURRENT SCALER.
*
*
DO_ENTRY
         MOVE    *A13(HSTD_POINTER),A0,W   ;GET THE CURRENT ENTRY NUMBER
         CALLR   BINBCD                    ;TURN A0 INTO BCD
         CALLR   LEAD_BLANKING_ON          ;ESTABLISH LEAD BLANKING.
         SLL     24,A0                     ;PUT IT ON TOP OF WORK
         CALLR   GENERATE_NUMBER_STEP      ;GENERATE TENS, STEP FIXED AMOUNT
*
*        NOTE THAT GENERATE_NUMBER_STEP AUTOMATICALLY SHIFTS
*        NEXT NIBBLE TO THE TOP OF A0
*
         CALLR   GENERATE_NUMBER_STEP

         MOVI    RIGHT_PAREN,A0            ;PRINT RIGHT PAREN STEP ITS SIZE
         CALLR   GENERATE_CHAR_STEP

         MOVI    MARGIN_1,A3               ;GET 1ST MARGIN
         CALLR   X_PL_SA3           ;AND MOVE X ACCORDINGLY.

         CALLR   ENTRY_IN_A7               ;GET OUR ENTRY POINTER IN A7
         ADDI    HS_INITS,A7               ;POINT AT FIRST INITIAL
*
*        NOW FIND A FINAL SPOT FOR X AFTER 3 INITIALS
*
         MOVE    *A13(SPR_X),A2,L          ;GET CURRENT X

         CALLR   NUMBER_WIDTH              ;GET THE FULL SCALE WIDTH OF NUMBERS
         MOVK    NUM_INITS+1,A4
         MPYU    A4,A3                     ;4 INITIALS WILL CONTAIN IT
         CALLR   X_PL_SA3           ;MOVE OUR X FOR THE DIGITS WIDTH.
         MOVE    *A13(SPR_X),A3,L          ;GET RESULTING X

         MOVE    A2,*A13(SPR_X),L          ;PUT BACK CURRENT X
         MMTM    SP,A3                     ;PUSH THE X BEYOND THE INITIALS

         MOVI    NUM_INITS,A1              ;THIS IS NUMBER OF INITIALS

SPR_INIT_LOOP
         CALLA   RC_BYTEI        ;FETCH THE LETTER
         CALLR   GENERATE_CHAR_STEP        ;GENERATE IS PRINT...AND STEP ITS WIDTH

         DSJS    A1,SPR_INIT_LOOP          ;DO THIS FOR EACH LETTER

	MMFM    SP,A3                     ;GET RESULTING X
         MOVE    A3,*A13(SPR_X),L          ;PUT IT OUT

         MOVI    MARGIN_2,A3               ;GET 2ND MARGIN
         CALLR   X_PL_SA3           ;AND MOVE X ACCORDINGLY.

         CALLR   ENTRY_IN_A7               ;GET OUR ENTRY POINTER IN A7
         CALLA   GET_HSCR
         MOVE    A1,A0                     ;MOVE NUMBER TO A0
         CALLR   LEAD_BLANKING_ON          ;THIS IS THE WAY WE SPRAY THE SCORE
         CALLR   GENERATE_NUMBER_STEP2     ;PUT OUT 2 NUMBERS
         CALLR   GENERATE_COMMA
         CALLR   GENERATE_NUMBER_STEP3
         CALLR   GENERATE_COMMA
         CALLR   GENERATE_NUMBER_STEP     
         CALLR   LEAD_BLANKING_OFF
         CALLR   GENERATE_NUMBER_STEP2
         RETP

**************************************************************************
*                                                                        *
*          GENERATE_COMMA                                                *
*                                                                        *
*          THIS IS CALLE TO DRAW THE COMMAS.  THE X IS SET.              *
*          WE MUST OBEY BLANKING AS TO WHETHER OR NOT TO                 *
*          DO THE DRAWING.                                               *
*                                                                        *
*                                                                        *
**************************************************************************
GENERATE_COMMA
         MMTM    SP,A8
         CALLR   LEAD_BLANKING_TEST   ;IS BLANKING ON?
         JRZ     GC1                  ;YEP...GENERATE NOTHING!

         MOVI    ASCII_COMMA,A8
         CALLR   CLONE_OURSELVES      ;GET A CLONE FOR US 

GC1      CALLR   COMMA_WIDTH          ;GET THE WIDTH USED FOR A COMMA
         CALLR   X_PL_SA3      ;SCALE BY OUR FACTOR AND PUSH X BY AMOUNT
	MMFM    SP,A8
	RETS

**************************************************************************
*                                                                        *
*          GENERATE_NUMBER_STEP                                          *
*                                                                        *
*          THIS IS CALLED TO OUTPUT THE NUMBER IN THE HIGH               *
*          NIBBLE OF A0.  LEAD BLANKING (A5) IS TO BE TAKEN              *
*          INTO ACCOUNT.  WHETHER OR NOT ANYTHING IS OUTPUT              *
*          (BY A FORKED PROCESS), THIS SHOULD MOVE THE                   *
*          CURRENT PROCESS'S X CURSOR FORWARD BY THE                     *
*          FIXED SCALED CHARACTER WIDTH FOR THE CHARACTER SET.           *
*                                                                        *
*          ALSO...THIS RETURNS A0 ROTATED TO THE NEXT POSISION.          *
*                                                                        *
**************************************************************************
GENERATE_NUMBER_STEP3
         CALLR   GENERATE_NUMBER_STEP
GENERATE_NUMBER_STEP2
         CALLR   GENERATE_NUMBER_STEP
GENERATE_NUMBER_STEP
         MMTM    SP,A8,A3
         RL      4,A0            ;ROTATE INTO LOW NIBBLE
         MOVE    A0,A8           ;COPY INTO A3
         ANDI    0FH,A8          ;SAVE THE LOW NIBBLE
         JRNZ    BL_DUN          ;BLANKING OVER...
*
*        ITS ZERO...CHECK BLANKING
*
         CALLR   LEAD_BLANKING_TEST   ;IS BLANKING ON?
         JREQ    BL_DIG               ;YEP..BLANK THE DIGIT

BL_DUN   CALLR   LEAD_BLANKING_OFF    ;TURN OFF LEAD BLANKING
         ADDI    30H,A8               ;MAKE ASCII
         CALLR   CLONE_OURSELVES      ;GET A CLONE FOR US 

BL_DIG   CALLR   NUMBER_WIDTH         ;GET THE FIXED WIDTH FOR NUMBERS
         CALLR   X_PL_SA3      ;SCALE BY OUR FACTOR AND PUSH X BY AMOUNT
	MMFM    SP,A8,A3
	RETS

**************************************************************************
*                                                                        *
*          GENERATE_CHAR_STEP                                            *
*                                                                        *
*          This is called to fork to a process to spray a letter.        *
*          The letter is in the low byte of A0.  This should             *
*          immediately update the SPR_X of the current process           *
*          by the width of the character.                                *
*                                                                        *
**************************************************************************
GENERATE_CHAR_STEP
         MMTM    SP,A8,A3
         MOVE    A0,A8                ;MOVE THE CHARACTER TO PASS TO ROUTINE
         CALLR   CLONE_OURSELVES      ;GET A CLONE FOR US 
         CALLR   FETCH_FIGURE_PTR     ;GET POINTER TO FIGURE LIST IN A4
         CALLR   GET_X_OFFSET         ;GET X OFFSET FOR CHARACTER IN A3
         CALLR   X_PL_SA3      ;SCALE BY OUR FACTOR AND PUSH X BY AMOUNT
	MMFM    SP,A8,A3
	RETS

**************************************************************************
*                                                                        *
*          GET_X_OFFSET                                                  *
*                                                                        *
*          THIS IS CALLED TO DETERMINE THE POSITIVE X DISTANCE           *
*          TRAVERSED BY THE FIGURE (CHARCTER) POINTER TO BY              *
*          A4...RETURN THE RESULT IN A3.                                 *
*                                                                        *
**************************************************************************
GET_X_OFFSET
         MMTM    SP,A4,A5
         CLR     A3                   ;TALLY UP TOTAL X OFFSET IN A3
GEN_C_2
         MOVE    *A4+,A5,W            ;FETCH A WORD
         CMPI    END_EXTENDED,A5      ;END OF CHAR?
         JREQ    GEN_C_1

         CMPI    HIDDEN_EXTENDED,A5   ;HIDDEN?
         JREQ    GEN_C_2              ;JUST SKIP THE OPCODE...FETCH X NOW

         ADD     A5,A3                ;ACCUMULATE X
         ADDI    WORD_SIZE,A4         ;PUSH BEYOND THE Y COORDINATE
         JRUC    GEN_C_2

GEN_C_1
	MMFM    SP,A4,A5             ;A3 NOW HAS WIDTH
	RETS

**************************************************************************
*                                                                        *
*          BINBCD                                                        *
*                                                                        *
*          CONVERT BINARY NUMBER IN A0 TO BCD.                           *
*                                                                        *
**************************************************************************
BINBCD   MMTM    SP,A1,A2,A3,A4,A5
         CMPI    99999999,A0               ;ARE WE TOO BIG?
         JRLS    BBIR                      ;IN RANGE
         MOVI    99999999H,A0              ;RETURN THE LARGEST NUMBER WE HAVE!
         JRUC    BB_RET

BBIR     MOVI    10,A1                     ;ALWAYS DIVIDE BY A0
         CLR     A5                        ;ACCUMULATE RESULT IN A5
         CLR     A4                        ;A4 HAS CURRENT SHIFT COUNT
         MOVE    A0,A3                     ;<A2><A3> HAS NUMERATOR
DO_BCD_AGAIN
         CLR     A2
         DIVU    A1,A2                     ;A2 HAS LEFTOVER...A3 HAS CURRENT DIGIT
         SLL     A4,A3                     ;SHIFT IT CORRECT NUMBER OF TIMES
         ADD     A3,A5                     ;ADD IT INTO RESULT REG
         ADDK    4,A4                      ;ADD 4 TO SHIFT COUNT
         MOVE    A2,A3                     ;REFRESH NUMERATOR
         JRNZ    DO_BCD_AGAIN

         MOVE    A5,A0                     ;PUT OUT RESULT
BB_RET	MMFM    SP,A1,A2,A3,A4,A5
	RETS

**************************************************************************
*                                                                        *
*          BCDBIN                                                        *
*                                                                        *
*          THIS TURNS A BCD NUMBER (IN A0) INTO A BINARY                 *
*          NUMBER.                                                       *
*                                                                        *
**************************************************************************
BCDBIN   MMTM    SP,A1,A2,A3,A4,A5       ;WORK REGGIES.
         CLR     A2                      ;ACCUMULATE IN A2
         MOVI    1,A3                    ;CURRENT FACTOR IS 1.
         MOVI    10,A4                   ;SAVE SOME MOVI INSTS LATER
         MOVI    16,A5                   ;DIVIDE IT DOWN BY 16 AT A TIME
BCBLOOP  MOVE    A0,A1                   ;DIVIDEND IN <A0><A1>
         JRZ     BCBDONE                 ;ALL UNITS EXHAUSTED!
         CLR     A0
         DIVU    A5,A0                   ;DIVIDE BY 10H...(REMAINDER IN A1)
         MPYU    A3,A1                   ;TIMES POSITION FACTOR
         ADD     A1,A2                   ;INTO ACCUMULATION REGISTER
         MPYU    A4,A3                   ;NEXT DIGIT IS WORTH 10 TIMES THIS ONE
         JRUC    BCBLOOP

BCBDONE  MOVE    A2,A0                   ;RETURN RESULT IN A0
	MMFM    SP,A1,A2,A3,A4,A5       ;WORK REGGIES.
	RETS

**************************************************************************
*                                                                        *
*          SET_X_FOR_ENTRY                                               *
*                                                                        *
*          THIS ROUTINE IS CALLED TO SETUP THE X LOCATION AND            *
*          SCALER VALUE FOR THE CURRENT ENTRY BEING SPRAYED.             *
*                                                                        *
*          IF THE SIZE GETS SMALLER AS YOU GO DOWN, THIS                 *
*          ROUTINE WILL BE RESPONSIBLE.                                  *
*                                                                        *
*          A2 = ZERO FOR ALL TIME                                        *
*               NE FOR TODAYS                                            *
*                                                                        *
**************************************************************************
SET_X_FOR_ENTRY
         MMTM    SP,A0,A1,A2,A3,A4,A5         
         CMPI    1,A0                 ;NUMBER 1?
         JRNE    NXAT                 ;NOPE

         MOVI    SPRAY_WHITE,A0       ;NUMBER 1 IN WHITE
         JRUC    NUM_1                ;DO IT!

NXAT     ANDI    3,A0                 ;USE 4 DIFFERENT COLORS
         SLL     4,A0                 ;INDEX TO WORD TABLE
         ADDI    COLOR_TAB,A0
         MOVE    *A0,A0,W             ;FETCH THE COLOR
NUM_1    CALLR   SET_SPRAY_COLOR      ;CHANGE THE COLOR WITHOUT TOUCHING RAM!

         MOVI    HSTD_ENTRY,A4        ;JSRP IN MIDDLE IS OK IF PROCESS SCRIPT DOESN'T SLEEP!
         JSRP    P_SCRIPT       

**************************************************************************
*                                                                        *
*          MOVE    @TAB_NUM,A4,W           ;GET NUMBER DONE              *
*          INC     A4                   ;THIS MAKES ONE MORE             *
*          MOVE    A4,@TAB_NUM,W                                         *
*                                                                        *
*          CMPI    3,A4                 ;1ST 3 ONLY                      *
*          JRHI    NOT_F_3                                               *
*                                                                        *
*          MOVI    FIRST_THREE,A4                                        *
*          JSRP    P_SCRIPT                                              *
*                                                                        *
* NOT_F_3                                                                *
*                                                                        *
**************************************************************************
         CALLR   TODAY_P              ;TODAYS?
         JRNE    NOT_TOD_X            ;NOPE

         MOVI    X_MARGIN_TODAYS,A0   ;THEN SHIFT X LEFT A LITTLE!
         MOVE    A0,*A13(SPR_X),L

NOT_TOD_X
	MMFM    SP,A0,A1,A2,A3,A4,A5         
	RETS

**************************************************************************
*                                                                        *
*          ADJUST_Y_OVER_A0                                              *
*                                                                        *
*          THIS IS CALLED TO ADJUST OUR CURRENT Y COORDINATE             *
*          TO DRAW FOR THE NEXT ENTRY.  IF THE ENTRY SIZE CHANGES        *
*          ALONG THE WAY THIS WILL HAVE TO BE A VARIABLE AMOUNT,         *
*          HOWEVER, SINCE THE ABOVE ROUTINE CHANGES THE SCALER           *
*          BEFORE WE ARE CALLED, WE WILL PROBABLY BE OK TO               *
*          REMAIN FIXED.                                                 *
*                                                                        *
**************************************************************************
ADJUST_Y_OVER_A0
         MMTM    SP,A2,A3

         CALLR   GET_LINES_PER_ENTRY

         CALLR   TODAY_P              ;TODAYS?
         JRNE    NOT_TOD_Y            ;NOPE

         MOVI    TODAY_Y_SCALER,A2    ;LARGER Y JUMP
         MPYU    A2,A3                ;EXTRA FACTOR FOR TODAYS
         JRUC    TOD_Y

NOT_TOD_Y
         SLL     6,A3                  ;ALIGN W/ 12 BIT FRACTION
TOD_Y
         MOVE    *A13(SPR_Y),A2,L      
         ADD     A2,A3
         MOVE    A3,*A13(SPR_Y),L      ;THIS ADJUST Y
	MMFM    SP,A2,A3
	RETS

**************************************************************************
*                                                                        *
*          GET_LINES_PER_ENTRY                                           *
*                                                                        *
*          THIS RETURNS A Y DISTANCE BETWEEN ENTRIES.  IT IS             *
*          IN Y UNITS WITH A 6 BIT FRACTION.                             *
*                                                                        *
**************************************************************************
GET_LINES_PER_ENTRY
         MMTM    SP,A2
         CALLR   NUMBER_HEIGHT        ;GET THE HEIGHT FOR CHAR SET IN A3
         MOVE    *A13(SPR_SCALER),A2,W ;GET SCALING FACTOR
         MPYU    A2,A3                 ;SCALE THIS TO OUR RELEVANCY
         ANDI    0FFFFFFC0H,A3         ;ZERO FRACTION TO ALIGN SCROLLER
	MMFM    SP,A2
	RETS
**************************************************************************
*                                                                        *
*          TODAY_P                                                       *
*                                                                        *
*          ARE WE WORKING ON TODAY'S TABLE?                              *
*                                                                        *
*          .EQ.   YES                                                    *
*          .NE.   NO                                                     *
*                                                                        *
**************************************************************************
TODAY_P:
         MMTM    SP,A4
         MOVE    *A13(HSTD_TABLE),A4,L     ;GET TABLE
         CMPI    TOD_TAB,A4           ;IS IT TODAYS?
	MMFM    SP,A4
	RETS

COLOR_TAB:       .WORD   SPRAY_RED
                 .WORD   SPRAY_CYAN
                 .WORD   SPRAY_VIOLET
                 .WORD   SPRAY_YELLOW

**************************************************************************
*                                                                        *
*          FETCH_SCORE_A0                                                *
*                                                                        *
*          THIS IS CALLED TO GET THE SCORE FROM THE CURRENT TABLE        *
*          AT OFFSET A0.  IT IS RETURNED IN A1.                          *
*                                                                        *
**************************************************************************
FETCH_SCORE_A0
         MOVE    *A13(HSTD_TABLE),A8,L     ;GET POINTER FROM PROCESS AREA
         CALLA   ROM_PTRS                  ;GET SYSTEM READY TO ACCESS THIS ONE
         CALLA   GET_HSCR                  ;NOW FETCH THE SCORE IN A1.
         RETS

ENTRY_IN_A7
         MOVE    *A13(HSTD_TABLE),A8,L     ;POINTER FOR TABLE TO USE
         CALLA   ROM_PTRS        ;SETUP STUFF
         MOVE    *A13(HSTD_POINTER),A0,W   ;THIS IS THE ENTRY NUMBER
         CALLA   PT_ENTRY            ;POINT A7 AT ENTRY
	RETS

LEAD_BLANKING_TEST
         MOVE    A5,A5
         RETS

LEAD_BLANKING_OFF
         MOVK    1,A5
         RETS

LEAD_BLANKING_ON
         CLR     A5
	RETS

X_PL_SA3
         MMTM    SP,A2
         MOVE    *A13(SPR_SCALER),A2,W     ;GET THE SCALING MULTIPLIER
         MPYU    A2,A3                     ;6 BIT FRACTION IN A3
         SLL     6,A3                      ;NOW ITS ALIGNED WITH X UNIT
         MOVE    *A13(SPR_X),A2,L          ;GET X COORDINATE
         ADD     A2,A3                     ;ADD SCALED VALUE
         MOVE    A3,*A13(SPR_X),L          ;AND PUT BACK
	MMFM    SP,A2
	RETS

**************************************************************************
*                                                                        *
*          DO_SUBROUTINE                                                 *
*                                                                        *
*          THIS IS CALLED TO DO A SCRIPT AS A SUBROUTINE.                *
*          IT PUSHES THE CURRENT A4 ON THE PROCESS STACK                 *
*          AND THEN INVOKES THE SCRIPT PROCESSOR RECURSIVELY.            *
*                                                                        *
**************************************************************************
DO_SUBROUTINE
         CALLR   LONG_FETCH           ;GET THE "SUBROUTINE" ARGUMENT
	MOVE	A4,-*A12,L      	;PUSH RESULTING POINTER
         MOVE    A1,A4                ;MAKE WHAT WE FETCHED THE CURRENT POINTER
         JSRP    P_SCRIPT       ;PROCESS THE SCRIPT REQUESTED
         MOVE    *A12+,A4,L           ;POP THE CALLER'S POINTER
         RETP                         ;AND RETURN TO MAIN LOOP!

**************************************************************************
*                                                                        *
*          DO_WORD                                                       *
*                                                                        *
*          THIS IS CALLED TO STORE A WORD INTO THE PROCESS AREA.         *
*          FIRST COMES THE OFFSET (WORD) FOLLOWED BY THE WORD            *
*          DATA.  THIS IS USED TO CHANGE ATTRIBUTES IN A                 *
*          SCRIPT.                                                       *
*                                                                        *
**************************************************************************
DO_WORD: CALLR   ALIGN_W           ;MAKE SURE WE'RE WORD ALIGNED
         CALLR   STORE_WORD
         RETP

DO_LONG: CALLR   ALIGN_W           
         CALLR   STORE_LONG
         RETP

**************************************************************************
*                                                                        *
*          DO_FORK                                                       *
*                                                                        *
*          THIS IS CALLED TO FORK OFF TO ANOTHER SCRIPT.                 *
*          IT WILL SPAWN A NEW PROCESS WHICH EXECUTES THE                *
*          SCRIPT AND KILLS ITSELF.  ONLY THE ORIGINAL                   *
*          SCRIPT WILL RETURN TO THE CALLER (ASYNCHRONOUSLY).            *
*          THE ENTIRE PDATA AREA WILL BE COPIED FROM THE                 *
*          CREATING PROCESS TO THE SPAWNED OFF PROCESS.                  *
*                                                                        *
**************************************************************************
DO_FORK
         CALLR   LONG_FETCH           ;GET THE ROUTINE TO USE.
         MOVE    A1,A8                ;PASS SCRIPT POINTER IN A8
         MOVI    DUMMY_FORK,A7        ;START IT AS FORKER
         CALLA   P_FORK               ;MAKE THE PROCESS
         JRZ     FORK_X               ;NO PROCCIES EXIT!

         CALLR   COPY_PDATA_AREA

FORK_X   RETP                         ;FORK IS COMPLETE!

**************************************************************************
*                                                                        *
*          COPY_PDATA_AREA                                               *
*                                                                        *
*          COPY ENTIRE PDATA AREA FROM CREATING PROCESS (A13)            *
*          TO NEWLY CREATED PROCESS (A0)                                 *
*                                                                        *
**************************************************************************
COPY_PDATA_AREA
         MMTM    SP,A5,A6
         MOVE    A13,A5               ;COPY PROCESS POINTER
         ADDI    PDATA,A5             ;POINT AT PDATA
         ADDI    PDATA,A0
         MOVI    (PSDATA-PDATA)/WORD_SIZE,A6
DO_F_1
         MOVE    *A5+,*A0+,W          ;COPY TO HIS PROCESS AREA.
         DSJS    A6,DO_F_1
	MMFM    SP,A5,A6
	RETS

CLONE_OURSELVES
         MMTM    SP,A0,A1,A7             ;SAVE THE STUFF WE PASS
         MOVI    HSTD_FORK,A7        ;START IT AS FORKER
         MOVE    *A13(PROCID),A1,W    ;PASS OUR ID TO FORKED PROCESS
         CALLA   GETPRC               ;MAKE THE PROCESS
         JRZ     NO_ONE_HOME          ;NO PROCCIES EXIT!

         CALLR   COPY_PDATA_AREA
NO_ONE_HOME
	MMFM    SP,A0,A1,A7             ;SAVE THE STUFF WE PASS
	RETS

HSTD_FORK
         CMPI    ASCII_COMMA,A8       ;IS THIS A COMMA?
         JRNE    HSTD_F1

         SLEEP   01EH                 ;POP IT IN LAST!

HSTD_F1
         MOVE    A8,A0                ;WE ARE SETUP TO SPRAY
         ANDI    BYTE_MASK,A0         ;JUST IN CASE
         
         JSRP    DO_SPRAY_CHAR_A0     ;DO THE JOB
         JAUC    SUCIDE               ;THEN DIE

**************************************************************************
*                                                                        *
*          DO_SLEEP                                                      *
*                                                                        *
*          ONE BYTE ARGUEMENT FOLLOWING IS SLEEP TIME.                   *
*                                                                        *
**************************************************************************
DO_SLEEP CALLR   BYTE_FETCH
	MOVE	A1,A0
         MOVE    A4,A8           ;MAKE POINTER HEARTY
	CALLA	PRCSLP
         MOVE    A8,A4           ;PUT POINTER BACK
         RETP

DO_BLACK_BLOB
         MOVI    PLOT_ON_BLACK,A0     ;THIS IS THE "PLOT BLOB" ROUTINE FOR BLACK 
         MOVE    A0,*A13(SPR_BLOB_ROUT),L  ;PUT IT OUT THERE.
	RETP

DO_WALL_BLOB
         MOVI    PLOT_BLOB,A0         ;THIS IS THE "PLOT BLOB" ROUTINE FOR WALLS 
         MOVE    A0,*A13(SPR_BLOB_ROUT),L  ;PUT IT OUT THERE.
	RETP

**************************************************************************
*                                                                        *
*          DUMMY_FORK                                                    *
*                                                                        *
*          THIS IS THE ACTUAL PROCESS THAT RUNS AFTER A FORK.            *
*          A8 CONTAINS THE NEW SCRIPT POINTER.                           *
*                                                                        *
*          RUN THE SCRIPT THEN DIE!                                      *
*                                                                        *
**************************************************************************
DUMMY_FORK
         MOVE    A8,A4                ;MOVE TO SCRIPT POINTER
         JSRP    P_SCRIPT       ;PROCESS THE SCRIPT
         JAUC    SUCIDE               ;AND DIE!

ALIGN_W:
         ADDI    0FH,A4               ;IF IT ENDS IN OTHER THAN ZERO..KICK TO 
*                                     ;NEXT WORD
         ANDI    0FFFFFFF0H,A4        ;AND MASK FRACTIONAL WORD
         RETS

**************************************************************************
*                                                                        *
*          DO_CHARACTER                                                  *
*                                                                        *
*          THIS IS CALLED TO SPRAY OUT THE CHARACTER (ASCII)             *
*          THAT FOLLOWS IN THE SCRIPT.                                   *
*                                                                        *
**************************************************************************
DO_SPRAY_CHARACTER
         CALLR   BYTE_FETCH
         MOVE    A1,A0           ;MOVE TO A0

DO_SPRAY_CHAR_A0
SPR_CHAR
         MOVE    A4,*A13(SPR_SCRIPT),L  ;SAVE CURRENT SCRIPT POINTER
         CALLR   FETCH_FIGURE_PTR       ;TURN A0 INTO A FIGURE POINTER
         JSRP    DRAW_FIGURE            ;DRAW THE FIGURE
         MOVE    *A13(SPR_SCRIPT),A4,L  ;RESTORE SCRIPT POINTER
         RETP                           ;AND RETURN TO SENDER

**************************************************************************
*                                                                        *
*                 BYTE_FETCH  WORD_FETCH  LONG_FETCH                     *
*                                                                        *
*          THESE ARE USED TO FETCH SCRIPTING DATA OFF OF A4.             *
*          BYTE_FETCH FETCHES A BYTE AT THE CURRENT LOCATION             *
*          INTO A1 AND INCREMENTS A4 BY THE BYTE QUANTITY.               *
*                                                                        *
*          WORD_FETCH FIRST ALIGNS A4 TO THE NEXT WORD, THEN             *
*          GETS THE WORD INTO A1 AND INCREMENTS A4 TO POINT              *
*          BEYOND THE WORD.                                              *
*                                                                        *
*          LONG_FETCH BEHAVES SIMILARLY TO BYTE_FETCH.                   *
*                                                                        *
**************************************************************************
BYTE_FETCH
         MOVB    *A4,A1               ;FETCH THE BYTE
         ANDI    BYTE_MASK,A1         ;KEEP ONLY THE BYTE
         ADDI    BYTE_SIZE,A4         ;BUMP POINTER
         RETS

WORD_FETCH
         CALLR   ALIGN_W           ;FIRST ALIGN TO WORD IF NECESSARY
         MOVE    *A4+,A1,W            ;MOVE IN A WORD
         ANDI    WORD_MASK,A1         ;MASK TO KEEP WORD.
         RETS                         ;AND RETURN

LONG_FETCH
         CALLR   ALIGN_W           ;FIRST ALIGN TO WORD IF NECESSARY
         MOVE    *A4+,A1,L            ;MOVE IN A LONG WORD
         RETS                         ;AND RETURN

**************************************************************************
*                                                                        *
*          DRAW_FIGURE                                                   *
*                                                                        *
*          This is called to draw a complete figure.  A pointer          *
*          to the figure descriptor is passed in A4.  The X              *
*          and Y, are in the process area as is the brush pointer,       *
*          palette, and scaler.  This routine keeps its pointer          *
*          in  SPR_FIGURE in the process area.                           *
*                                                                        *
*          The structure is simply a vector list:                        *
*                                                                        *
*                   1st word:      8000   next 2 vects are hidden        *
*                                  8001   end of figure                  *
*                                                                        *
*                  else            DX                                    *
*                                                                        *
*                  2nd word:       DY                                    *
*                                                                        *
**************************************************************************

HIDDEN           EQU     8000H
END_OF_FIGURE    EQU     8001H
WORD_IMMEDIATE   EQU     8002H
LONG_IMMEDIATE   EQU     8003H
HIDDEN_EXTENDED  EQU     0FFFF8000H
END_EXTENDED     EQU     0FFFF8001H
WORD_EXTENDED    EQU     0FFFF8002H
LONG_EXTENDED    EQU     0FFFF8003H

DRAW_FIGURE:
         MOVE    *A13(SPR_Y),A1,L        ;GET THE Y AT FIGURE START
         MOVE    A1,*A13(SPR_Y_BASE),L   ;SAVE SO BOTTOM DOESN'T WALK

DO_NEXT_LINE:
         MOVE    *A4+,A1,W       ;FETCH FIRST WORD
         CMPI    END_EXTENDED,A1 ;END?
         JREQ    FIGURE_DONE     ;YEP...RETURN

         CMPI    HIDDEN_EXTENDED,A1        ;HIDDEN?
         JREQ    DO_HIDDEN       ;YEP...DO IT

         CMPI    WORD_EXTENDED,A1
         JRNE    NOT_WE
*
*        WORD EXTENDED.......OP,OFFSET,WORD
*
*        STORE WORD AT OFFSET FROM A13
*
         CALLR   STORE_WORD
         JRUC    DO_NEXT_LINE          ;AND WE'RE DONE

NOT_WE:  CMPI    LONG_EXTENDED,A1
         JRNE    NOT_OP

*
*        LONG EXTENDED.......OP,OFFSET,LONGWORD
*
*        STORE LONGWORD AT OFFSET FROM A13
*
         CALLR   STORE_LONG
         JRUC    DO_NEXT_LINE          ;AND WE'RE DONE

NOT_OP:
         MOVE    *A4+,A2,W              ;FETCH DY
         MOVE    *A13(SPR_SLEEP),A0,W   ;LOAD UP SLEEP TIME
         MOVE    A4,*A13(SPR_FIGURE),L  ;SAVE FIGURE POINTER
         JSRP    DRAW_SCALED_VECTOR     ;DRAW THIS VECTOR
         MOVE    *A13(SPR_FIGURE),A4,L  ;GET BACK FIGURE POINTER
         JRUC    DO_NEXT_LINE

DO_HIDDEN:
         MOVE    *A4+,A1,W            ;GET DX FOR HIDDEN LINE
         MOVE    *A4+,A2,W            ;GET DY FOR HIDDEN LINE
         CALLR   SCALE_DX_DY          ;SCALE THESE BY OUR CURRENT SCALER

         MOVE    *A13(SPR_X),A3,L
         SLL     6,A1                 ;ALIGN 6 BIT FRACTION TO 12 BIT FRACTION 
         ADD     A1,A3                ;FINAL X POSITION 
         MOVE    A3,*A13(SPR_X),L     ;STORE IT BACK

         MOVE    *A13(SPR_Y),A3,L
         SLL     6,A2                 ;12 BIT FRACTION MAKES THIS Y VELOCITY
         ADD     A2,A3                ;FINAL Y POSITION 
         MOVE    A3,*A13(SPR_Y),L     ;STORE IT BACK
         JRUC    DO_NEXT_LINE

FIGURE_DONE:         
         MOVE    *A13(SPR_Y_BASE),A1,L   ;RESTORE BASE FROM FIGURE START
         MOVE    A1,*A13(SPR_Y),L        

         RETP

GET_PTR_IN_A1:
         MOVE    *A4+,A1,W
         ANDI    0FFFFH,A1       ;MAKE SURE SIGN EXTEND DOESN'T SCREW US
         ADD     A13,A1          ;ADD BASE POINTER
         RETS

STORE_WORD
         CALLR   GET_PTR_IN_A1         ; THIS GETS OUR POINTER
         MOVE    *A4+,A2,W             ; GET LONG WORD IN A2
         MOVE    A2,*A1,W              ; STORE THE WORD
         RETS

STORE_LONG
         CALLR   GET_PTR_IN_A1         ; THIS GETS OUR POINTER
         MOVE    *A4+,A2,L             ; GET LONG WORD IN A2
         MOVE    A2,*A1,L              ; STORE THE LONGWORD
         RETS

**************************************************************************
*                                                                        *
*          DRAW_SCALED_VECTOR                                            *
*                                                                        *
*          Routine is called to spray on 1 vector.  It takes             *
*          the following parameters:                                     *
*                                                                        *
*          A0 = sleep time between blots. (0 for no sleep)               *
*          A1 = X_VECT   Letter vector (full scale) (SIGNED TO 32 BITS)  *
*          A2 = Y_VECT                                                   *
*                                                                        *
*          The scaler (to turn vector from full scale to current         *
*          scale is in the process store area.  So it the                *
*          X coordinate, Y coordinate  paintbrush and                    *
*          palette #.                                                    *
*                                                                        *
*          The X_VECT is 16 bit signed.  Distance is pixels for letters  *
*          that are screen high.....smaller letters are scaled down.     *
*                                                                        *
*          The Scaler is a 6 bit binary unsigned fraction.  This         *
*          scales down the letters to the sizes used.                    *
*                                                                        *
*          The Scaler is multiplied by X_VECT giving us                  *
*          X_DIST which is the total X distance in pixels for the        *
*          screen plotted vector.  X_DIST is signed and has              *
*          a 6 bit binary fraction.                                      *
*                                                                        *
*                                2    2    2                             *
*          By using the formula X  + Y  = R ,  we find the total         *
*          length squared of the whole vector.                           *
*                                                                        *
*                               2         2                              *
*                         X_DIST  + Y_DIST   = R2                        *
*                                                                        *
*          This provides us with unsigned R2......an unsigned            *
*          number with a 12 bit fraction which is the square of          *
*          the distance.                                                 *
*                                                                        *
*          By dividing by the square of the unit length (provided        *
*          by the brush descriptor) we get the square of the             *
*          # of frames to divide the vector by.  By looking              *
*          up in a table, we get the frame count.                        *
*                                                                        *
*          We then X_DIST and Y_DIST by this count to get the            *
*          X and Y velocity per frame.  We spray the                     *
*          "frame count" times.                                          *
*                                                                        *
**************************************************************************
DRAW_SCALED_VECTOR:
         CALLR   SCALE_DX_DY

DRAW_ABSOLUTE_VECTOR:
         MOVE    A0,A9               ;A9 = SLEEP REGGIE

         MOVE    *A13(SPR_X),A10,L
         MOVE    A1,A3
         SLL     6,A3                 ;ALIGN 6 BIT FRACTION TO 12 BIT FRACTION 
         ADD     A3,A10               ;FINAL X POSITION = A10

         MOVE    *A13(SPR_Y),A11,L
         MOVE    A2,A3
         SLL     6,A3                 ;12 BIT FRACTION MAKES THIS Y VELOCITY
         ADD     A3,A11               ;FINAL Y POSITION = A11

         MOVE    *A13(SPR_Y_BASE),A3,L   ;GET THE CURRENT Y-BASE
         MOVE    A3,-*A12,L              ;PUSH IT ON STACK.....
*                                        ;WHEN WE'RE DONE THIS WILL
*                                        ;TELL US HOW HIGH THE SCREEN SCROLLED.
*
*                                    ;F=6       ;A1 = SIGNED X_DIST
         MOVE    A1,A3                          ;X_DIST
         MPYS    A3,A3               ;F=12      ;X_DIST*X_DIST (UNSIGNED)
         MOVE    A3,A4                          ;X_DIST*X_DIST IN A4 (UNSIGNED)

         MOVE    A2,A3                          ;A2 = SIGNED Y_DIST
         MPYS    A3,A3               ;F=12      ;Y_DIST*Y_DIST
         ADD     A4,A3               ;F=12      ;A3 = R_SQUARED
         MOVE    *A13(SPR_POINTER),A4,L         ;GET BRUSH POINTER
         MOVE    *A4(UNIT_V),A4,W      ;GET UNIT V SQUARED  (2 BIT FRAC)

         DIVU    A4,A3               ;F=10      ;A7 = SQUARE OF STEPS IN A7
         ADDI    200H,A3                        ;ROUND 10 BITS 
         SRL     10,A3                ;THIS IS NOW STEPS SQUARED.
                                     
         CALLR   SQUARE_ROOT_OF_A3    ;FIND THE SQUARE ROOT OF A3
         MOVE    A3,A3                ;ZERO?
         JRNZ    NOT_ZERO
         MOVK    1,A3                 ;THEN USE 1 BLOT
*
*        NOW     A1 = X_DIST (SIGNED W/ 6 BIT FRACTION)
*                A2 = Y_DIST (SIGNED W/ 6 BIT FRACTION)
*                A3 = NUMBER OF BLOTS TO PAINT.
*
NOT_ZERO:
         DIVS    A3,A1                ;A1 = DX PER BLOT W/ 6 BIT FRAC.
         MOVE    A2,A5                ;USE ODD REGGIE
         DIVS    A3,A5                ;A5 = DX PER BLOT W/ 6 BIT FRAC.

         SLL     6,A1                 ;ALIGN 6 BIT FRACTION TO 12 BIT FRACTION 
         SLL     6,A5                 ;12 BIT FRACTION MAKES THIS Y VELOCITY

         MOVE    A1,*A13(SPR_XV),L    ;STORE VELOCITY
         MOVE    A5,*A13(SPR_YV),L    ;STORE VELOCITY

         MOVE    A3,A8                ;COUNT FRAMES IN RESTORABLE REGGIE

LINE_LOOP:
         MOVE    A9,A0                ;REFRESH SLEEP TIMER
         JRZ     CHECK_TIMER          ;IT SAYS FAST AS POSSIBLE!
         JRNN    NORMAL_SLEEP
*
*        IF THIS NUMBER APPEARS NEGATIVE, WE ARE TRYING TO 
*        SHARE WITH THE DISPLAY SYSTEM.
*
*        THE FORM OF THIS SLEEP REQUEST IS:
*
*           1XXX XXXX FFFF SSSS
*
*        WHICH MEANS TO DRAW FFFF FRAMES, THEN SLEEP
*        FOR SSSS TIME.
*
         SRL     4,A0                   ;MOVE FFFF TO LOW POINT
         ANDI    0FH,A0                 ;KEEP FFFF ONLY
         MOVE    *A13(SPR_DIVIDER),A3,W ;GET THE DIVIDER
         INC     A3                     ;COUNT FRAMES DRAWN!
         MOVE    A3,*A13(SPR_DIVIDER),W  ;PUT IT BACK
         CMP     A0,A3                    ;HAVE WE DRAWN ENOUGH?
         JRLO    SKIP_SLEEP               ;NOPE DRAW ANOTHER!

         CLR     A3
         MOVE    A3,*A13(SPR_DIVIDER),W  ;ZERO OUT FOR NEXT SET!
         MOVE    A9,A0                    ;GET SLEEP TIME BACK IN A0
         ANDI    0FH,A0                    ;TIME ONLY
         JRUC    SLEEP_NOW                 ;NOW SLEEP THAT MANY FRAMES.

NORMAL_SLEEP
         MOVE    *A13(SPR_DIVIDER),A3,W  ;GET ACCUMULATED FRACTION
         ANDI    0FFH,A3                 ;MASK FRACTIONAL PART HERE
         ADD     A3,A0                   ;ADD ACCUM TO AMOUNT TO DO
         MOVE    A0,*A13(SPR_DIVIDER),W  ;PUT "FRACTION" BACK OUT

         SRL     8,A0                 ;NOW LOOK AT SLEEP UNITS.
         JRNZ    SLEEP_NOW            ;ITS TIME TO SLEEP
*
*        NOT YET TIME TO SLEEP
*        CHECK TO SEE IF TIMER HIT......IF SO....SLEEP NOW
*
*        THIS IS PARAMTER OF ZERO...ONLY SLEEP WHEN REST
*        OF SYSTEM IS DUE TO RUN
*
CHECK_TIMER:
         MOVE    @TIMER,A1,W            ;NO SLEEP.....ARE WE RIPE FOR A LOOP?
         JRZ     SKIP_SLEEP           ;NOPE.....KEEP BLOBBING

         MOVK    1,A0                 ;SLEEP 1 FRAME! (LET SYS GO)

SLEEP_NOW:
	CALLA	PRCSLP               ;DO THE SLEEP

SKIP_SLEEP:
         CALLR   UPDATE_POSITION      ;SET NEW POSITIONS

         MOVE    *A13(SPR_BLOB_ROUT),A3,L
         CALLR   DMA_INTERFACE        ;HARD WAIT FOR SYSTEM!
         CALL    A3                   ;CALL THE PLOT_BLOB ROUTINE!
         CALLR   DMA_END              ;TURN DISPLAY SYS BACK ON IF NEC.

         DSJ     A8,LINE_LOOP

         MOVE    *A12+,A8,L           ;FETCH ORIGINAL Y_BASE
         MOVE    *A13(SPR_Y_BASE),A9,L   ;GET CURRENT Y_BASE
         SUB     A8,A9                   ;THIS IS HOW MUCH IT MOVED!
         ADD     A9,A11                  ;MOVE IT IN OUR EXPECTED DESTINATION

         MOVE    A10,*A13(SPR_X),L
         MOVE    A11,*A13(SPR_Y),L

         RETP                         ;THATS ALL WE WROTE!

**************************************************************************
*                                                                        *
*          DMA_INTERFACE                                                 *
*                                                                        *
*          THIS IS CALLED TO SYNC UP WITH THE DISPLAY SYSTEM             *
*          WHEN SPRAYING IS DONE TO ENTER INITIALS.                      *
*                                                                        *
*          IT IS A PROCESS THAT DOES A *HARD* WAIT TILL                  *
*          THE SYSTEM SAY GO.                                            *
*                                                                        *
**************************************************************************
DMA_INTERFACE
*
*        WE CAN USE ANY REGGIES A0-A7 EXCEPT A3
*
         MOVE    @DISPLAYON,A0,W           ;IS DISPLAY SYSTEM RUNNING?
         JRZ     NO_DMA                    ;NO....ZERO IN A0 CHECKED ON RETURN!
*
*        DMA IS RUNNING
*
         CLR     A1                        ;TURN OFF DISPLAY SYSTEM
         MOVE    A1,@DISPLAYON,W           ;THIS DOES IT
*
*        THIS WILL WAIT AND RETURN TO OUR CALLER!
*
         JAUC    DMAQWAIT                  ;WAIT FOR DMA TO BE DONE (IF IN MOTION)
*
NO_DMA
         RETS                              ;RETURN W/ A0 = 0
*
*        NOTE THAT OUR A0 IS HELD TO TURN THE DISPLAY SYSTEM BACK ON!
*
**************************************************************************
*                                                                        *
*          DMA_END                                                       *
*                                                                        *
*          THIS IS CALLED AFTER BLOB TO TURN OBJECT SYSTEM BACK ON       *
*          IF NECESSARY.                                                 *
*                                                                        *
*          A0 HAS THE "DISPLAYON" VALUE FROM WHEN WE WERE CALLED.        *
*                                                                        *
**************************************************************************
DMA_END
         MOVE    A0,@DISPLAYON,W           ;PUT THE VALUE BACK
         RETS                              ;AND RETURN TO OUR CALLER
**************************************************************************
**************************************************************************
**************************************************************************
UPDATE_POSITION
         MMTM    SP,A0,A1
         MOVE    *A13(SPR_X),A0,L
         MOVE    *A13(SPR_XV),A1,L
         ADD     A0,A1
         MOVE    A1,*A13(SPR_X),L

         MOVE    *A13(SPR_Y),A0,L
         MOVE    *A13(SPR_YV),A1,L
         ADD     A0,A1
         MOVE    A1,*A13(SPR_Y),L
	MMFM    SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
*          SQUARE_ROOT_OF_A3                                             *
*                                                                        *
*          THIS ROUTINE MUST FIND THE SQUARE ROOT OF A3.                 *
*                                                                        *
*          CURRENTLY WE INTEND TO SUPPORT UP TO 100 JUMPS...             *
*          THEREFORE A3 IS VALID TO 10000.                               *
*                                                                        *
*          SINCE WE ARE GRAFFITI ARTISTS....WE'LL GO WITH                *
*          ROUNDING UP.                                                  *
*                                                                        *
**************************************************************************
SQUARE_ROOT_OF_A3
         MMTM    SP,A0,A1,A2,A4,A5,A6,A7
         MOVE    A3,A3           ;ZERO AS INPUT?
         JREQ    SQR_EXIT        ;RETURN ZERO
         MOVI    SQUARE_TABLE,A5 ;BASE OF TABLE 
         CLR     A0              ;LAST LOW ONE
         MOVI    101*16,A2       ;LAST HIGH ONE (TABLE IS WORDS!)
         MOVI    50*16,A1        ;START IN THE MIDDLE

NEXT_TRY:
         MOVE    A5,A6           ;COPY TABLE BASE
         ADD     A1,A6           ;FORM POINTER TO WORD
         MOVE    *A6,A7,W        ;GET THE WORD
         CMP     A3,A7           ;ARE WE BIGGER OR SMALLER
         JRHS    TOO_HIGH        ;TABLE NUMBER IS HIGHER
*
*        A7 (TABLE) IS LOWER THAN OUR NUMBER 
*
         MOVE    *A6(WORD_SIZE),A7,W      ;SEE IF ONE AFTER IT IS HIGHER
         CMP     A3,A7
         JRHS    RETURN_A1_PLUS_1

         MOVE    A1,A0                     ;MOVE US TO A0....WE HAVE NEW LOW BOUND
         ADD     A2,A1                     ;AVERAGE A1 AND A2
         SRL     1,A1                      ;
         ANDI    0FFFFFFF0H,A1             ;AND POINT AT NEAREST WORD.
         JRUC    NEXT_TRY
*
*        THE ONE WE POINT AT IS HIGHER
*
TOO_HIGH:
         MOVE    *A6(-WORD_SIZE),A7,W      ;SEE IF ONE BEFORE IT IS LOWER
         CMP     A3,A7
         JRLO    RETURN_A                  ;ONE BEFORE IS LOWER..RETURN THIS ONE

         MOVE    A1,A2                     ;WE DON'T NEED TO GO HIGHER THAN HERE
         ADD     A0,A1                     ;AVERAGE WITH LOW MINIMUM.
         SRL     1,A1                      ;
         ANDI    0FFFFFFF0H,A1             ;AND POINT AT NEAREST WORD.
         JRUC    NEXT_TRY

RETURN_A1_PLUS_1:
         ADDK    WORD_SIZE,A1
RETURN_A:
         SRL     4,A1
         MOVE    A1,A3
SQR_EXIT:
	MMFM    SP,A0,A1,A2,A4,A5,A6,A7
	RETS

         .INCLUDE        "NARCSQT.ASM"           ;TABLE OF SQUARES

**************************************************************************
*                                                                        *
*          SCALE_DX_DY                                                   *
*                                                                        *
*          THIS IS CALLED TO SCALE AN X AND Y (SIGNED) VECTOR            *
*          BY THE CURRENT PROCESSES DRAWING SCALER.                      *
*                                                                        *
**************************************************************************
SCALE_DX_DY:
         MMTM    SP,A3
         MOVE    *A13(SPR_SCALER),A3,W          ;A3=SCALER....6 BITS..ZERO EXT.
         MPYS    A3,A1                          ;A1 = SCALED VECTOR X_DIST
         MPYS    A2,A3                          ;A3 = SCALED VECTOR Y_DIST
         MOVE    A3,A2                          ;A2 = SCALED VECTOR Y_DIST
	MMFM    SP,A3
	RETS

**************************************************************************
*                                                                        *
*          PLOT_BLOB                                                     *
*                                                                        *
*          THIS IS THE BASIC SPRAY PAINT PRIMITIVE.  IT PLOTS A          *
*          BLOB FOR THE CALLING PROCESS.  IT ASSUMES THE FOLLOWING       *
*          IS ALL SETUP:                                                 *
*                                                                        *
*          BRUSH           (STORED IN PROCESS  [SET_BRUSH])              *
*          PALETTE NUMBER  (STORED IN PROCESS  [SET_SPRAY_PALETTE])      *
*          PALETTE         (DATA IN ABOVE PALETTE [SETUP_PALETTE])       *
*          SPRAY COLOR     (DATA IN PROCESS    [SET_SPRAY_COLOR])        *
*          X COORDINATE    (IN PROCESS)                                  *
*          Y COORDINATE    (IN PROCESS)                                  *
*                                                                        *
*          THIS ALGORITHMICALLY ADDS THE CURRENT BRUSH'S COLOR UNITS     *
*          AROUND THE CENTER OF THE PROVIDED X AND Y.                    *
*                                                                        *
*          X AND Y ARE SPECIFIED AS FOLLOWS:                             *
*                                                                        *
*                  0000 0000 000Y YYYY YYYY XXXX XXXX X000               *
*                                                                        *
*          THIS PROVIDES THE SCREEN CENTER.  THE X COORDINATE            *
*          IS A LONG WORD WITH DATA IN BITS 3-11.  THE Y COORDINATE      *
*          IS A LONG WORD WITH DATA IN BITS 12-20.                       *
*          THE BITS THAT ARE NOT SIGNIFICANT TO THE PARTICULAR           *
*          COMPONENT DO NOT NEED TO BE CLEARED OUT AS THEY               *
*          WILL BE MASKED WHEN THE COMPONENTS ARE COMBINED.              *
*                                                                        *
**************************************************************************

**************************************************************************
*                                                                        *
*          GO_RIGHT                                                      *
*                                                                        *
*          THIS IS A MACRO FOR MAIN LOOP IN PLOB_BLOB.                   *
*          THE FIRST ARGUEMENT CONTAINS 2 BYTES OF                       *
*          DATA FOR 2 CONSECUTIVE PIXELS.  THE HIGH                      *
*          PIX INFO (BITS 8-15) SHOULD END UP IN THE                     *
*          LOW 8 BITS OF THIS REGGIE.                                    *
*                                                                        *
*          THE SECOND ARGUMENT IS WHERE THE LOW PIXIE                    *
*          INFO SHOULD END UP.                                           *
*                                                                        *
**************************************************************************
GO_RIGHT:   $MACRO   R1,R2
            MOVE     :R1:,:R2:        ;COPY BOTH PIXIE
            SLL      16,:R1:
            SRL      24,:R1:           ;1ST REGGIE GET HIGH..SHIFT IT DOWN
            SLL      24,:R2:          ;MASK OFF HIGH 24 BITS
            SRL      24,:R2:
            $END 

PLOT_BLOB:
         RETS

*         MMTM    SP,B2,B3,B4,B5
*         MMTM    SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12
*
*         MOVE    *A13(SPR_POINTER),A6,L    ;A6 = ROM STRUCT POINTER
*         MOVE    *A6(WIDTH),A1,W                 ;WIDTH OF BRUSH
*         SRL     1,A1                      ;WIDTH OF BRUSH IN -WORDS-
*         MOVE    A1,B4                   ;***B4 = WIDTH OF BRUSH IN -WORDS-
*         MOVE    *A6(HEIGHT),A2,W                 ;HEIGHT OF BRUSH
*         MOVE    A2,B3                   ;***B3 = HEIGHT OF BRUSH
**
**        NOW WE NEED TO GO FROM CURRENT COORDINATE TO UPPER LEFT OF
**        BRUSH
**
*         MOVE    *A6(DW),A3,L                 ;DX IN A3
*         MOVE    *A13(SPR_X),A4,L          ;GET X
*         SRL     9,A4                      ;MOVE X TO SCREEN COORDINATE
*         ADD     A4,A3                     ;ADD IT INTO DX (A3)
*         ANDI    EVEN_X_MASK,A3            ;UPPER LEFT X
*
*         MOVE    *A6(DH),A4,L                 ;DY IN A4
**                                        ;***A6 = BRUSH DATA POINTER
*         MOVE    *A13(SPR_Y),A5,L          ;GET Y
*         ADD     A5,A4                     ;ADD IT INTO A4
*         ANDI    Y_MASK,A4                 ;UPPER LEFT Y IN A4
*         ADD     A4,A3                   ;***A3 = UPPER LEFT SCREEN POINTER
*         CMPI    PLOT_MAX,A3            ;ARE WE ON SCREEN?
*         JAHS    BLOB_OFF_SCREEN           ;NOPE....EXIT
*
*         MOVE    *A13(SPR_PALETTE),A4,W  ;***A4=PALETTE NUMBER FOR LOW PIX
*         ANDI    BYTE_MASK,A4              ;KEEP LOW PIECE
*         MOVE    A3,A2                     ;SAVE ROW START IN A2
*
*         MOVE    A4,A5                     ;COPY PALETTE TO A5
*         SLL     8,A5                      ;DUPLICATE INTO HIGH BYTE
*         ADD     A4,A5                     ;ADD LOW BACK IN
*         MOVE    A5,@CMAPSEL,W             ;THIS MAKES SURE OUR WRITE USE OUR PAL
*
*         MOVE    *A13(SPR_FUZZ_FLAG),A1,W  ;GET FUZZ PARAMETER
*         MOVE    A1,B2                     ;KEEP FUZZ PAR IN B2
*         ANDI    0FFH,B2                   ;KEEP ONLY A BYTE
*
*         ADDI    S_DATA,A6                 ;POINT AT THE DATA
*
*         MOVK    8,A1                      ;CONSTANTS DEFINED AS SHOWN
*         MOVK    16,A9
*         MOVK    24,A10
*
**
**        AT THIS POINT:
**
**        A0   RANDOM #'S FETCHED HERE.
**
**        A6 = ROM BRUSH POINTER
**        A2 = BEGINNING OF ROW SCREEN POINTER
**        A3 = SCREEN POINTER
**
**        B2 = NON ZERO FOR FUZZING
**        B3 = HEIGHT COUNTER
**        B4 = ROW SIZE
**        B5 = ROW COUNTER
**
**        A4 = PRIMARY COLOR SCRATCH REG
**        A5 = 2 BIT COLOR SCRATCH REG
**        
**
**        A1  = CONSTANT 8....ONCE PRIMARY REACHES 8, 2NDARY CANT BE 3
**        A9  = CONSTANT 16...ONCE PRIMARY REACHES 16, 2NDARY CANT BE 2
**        A10 = CONSTANT 24...ONCE PRIMARY REACHES 24, 2NDARY TURNED OFF.
**                                                    3RD TURNED OFF.
**
***************************************************************************
**                                                                        *
**          THIS IS THE BASIC PROCESSING LOOP                             *
**                                                                        *
***************************************************************************
*
*NEW_ROW_LOOP:
*         MOVE    B4,B5                     ;REFRESH ROW COUNTER
*         CALLA   RANDOM                     ;GET RANDOM NUMBER IN A0 EACH WORD
*
*FINISH_ROW_LOOP:
*         MOVE    *A6+,A7,W                 ;FETCH 2 BRUSH BYTES
*         JRNE    WORK_TO_DO
*         ADDI    WORD_SIZE,A3              ;BOTH DATA ZERO,
*         JAUC    LOOP_BOT                  ;KICK THE SCREEN POINTER
*
**                                          ;**A7,A8..A7 = HIGH PIX A8 = LOW PIX
*WORK_TO_DO:
*	PUSHST
*	DINT
*         MOVE    @Y_CORR,A12,L       ;GET ANY CORRECTION
*         JRZ     NO_Y_COR                 ;NOTHIN THERE
*
*         CLR     A8                        ;AND LETS ZERO OUT THE CORRECTION RAM
*         MOVE    A8,@Y_CORR,L
*	POPST
*
*         ADD     A12,A3                    ;FACTOR IN THE CORRECTION
*         ADD     A10,A2                    ;ALSO TO THE "ROW REMEMBER"
*         MOVE    *A13(SPR_Y_BASE),A8,L     ;GET Y BASE FOR CURRENT OP
*         ADD     A12,A8                    ;ADD CORRECTION
*         MOVE    A8,*A13(SPR_Y_BASE),L     ;STORE IT BACK
*
*         MOVE    *A13(SPR_Y),A8,L          ;GET Y FOR CURRENT BLOB
*         ADD     A12,A8                    ;ADD CORRECTION
*         MOVE    A8,*A13(SPR_Y),L          ;STORE IT BACK
*
*         JRUC    NO_Y_COR3                 ;DON'T POP AGAIN
*
*NO_Y_COR
*	POPST
*NO_Y_COR3
*
*         GO_RIGHT A7,A8                    ;SHIFT THE A DOWN...MASK THE B
*
*         MOVE    *A3,A11         ;***A11 = DATA FROM SCREEN
*         GO_RIGHT A11,A12        ;***A11,A12  A11 = HIGH PIX  A12 = LOW PIX
**
**
**        NOW....WE HAVE:
**
**        HIGH PIXEL                   LOW PIXEL
**        A7  = NEW DATA                A8  = NEW DATA
**        A11 = SCREEN DATA             A12 = SCREEN DATA
**
**        NOW....GET SPRAY IN A4   2NDARY IN A5   THIRD IN A11
*
*         MOVE    A7,A7                ;NO DATA?
*         JREQ    DO_LOW_PIX           ;THEN SKIP PROCESSING.
*
*         CMPI    5,A7                 ;IS HIGH PIXEL SMALL?
*         JRHI    HIGH_1
*
*         RL      2,A0                 ;CHECK A RANDY BIT
*         JRC     DO_LOW_PIX           ;SKIP 3/4 THE TIME
*         JRN     DO_LOW_PIX
*
*HIGH_1:
*         MOVE    A11,A4               ;COPY SCREEN DATA DOWN
*         SRL     3,A4
*
*         JRNZ    NO_FUDGE_1           ;PIX HAS DATA...NO FUZZ                                 
*         MOVE    B2,A5                ;FUZZING IN PROGRESS?
*         JRZ     NO_FUDGE_1           ;NOPE
*         RL      8,A0                 ;BRING A0 AROUND 8 TIMES         
*         MOVE    A0,A11                                                
*         AND     A5,A11               ;MASK DOWN BY FUDGE MASK            
*         MOVE    A11,A4               ;COPY SCREEN DATA DOWN           
*         SRL     3,A4                                                  
*                                                                       
*NO_FUDGE_1:
*         MOVE    A11,A5
*         SLL     29,A5
*         SRL     30,A5                ;BITS 1 AND 2
*
*         SLL     31,A11               ;KEEP 3RD COLOR IN DESTINATION REG
*         SRL     31,A11               ;BIT 0 
*
*         ADD     A7,A4                ;ADD IN NEW COLOR
*         CMPI    31,A4                ;MAXED OUT?
*         JRLS    HIGH_0               ;NO
*         MOVK    31,A4                ;SET TO MAX
*
*HIGH_0:
*         CMP     A1,A4                ;ARE WE IN RANGE TO STOP 2ND FROM 3?
*         JRLO    HIGH_2               ;NO
*
*         CMPI    3,A5                 ;IS 2ND AT 3?
*         JRLO    HIGH_2               ;NOPE...LEAVE IT
*
*         DEC     A5                   ;TAKE 1 AWAY
*
*HIGH_2:  CMP     A9,A4                ;ARE WE IN RANGE TO STOP 2ND FROM 2?
*         JRLO    HIGH_3               ;NO
*
*         CMPI    2,A5
*         JRLO    HIGH_3
*
*         DEC     A5
*
*HIGH_3:  CMP     A10,A4                ;ARE WE IN RANGE TO KILL ALL OTHERS?
*         JRLO    HIGH_4
*         CLR     A5
*         CLR     A11                   ;TRASH OUT 3RD COLOR
*
*HIGH_4:  SLL     3,A4
*         SLL     1,A5
*         ADD     A4,A11
*         ADD     A5,A11
**
**        HIGH BYTE DONE.....WORK ON LOW BYTE
**
*DO_LOW_PIX:
*
*         MOVE    A8,A8                ;NO DATA?
*         JREQ    PUT_PIX_OUT          ;THEN SKIP PROCESSING.
*
*         CMPI    5,A8                 ;IS LOW PIXEL SMALL?
*         JRHI    LOW_1
*
*         RL      2,A0                 ;CHECK A RANDY BIT
*         JRC     PUT_PIX_OUT          ;SKIP 3/4 THE TIME
*         JRN     PUT_PIX_OUT  
*
*LOW_1:
*         MOVE    A12,A4               ;COPY SCREEN DATA DOWN
*         SRL     3,A4
*
*         JRNZ    NO_FUDGE_2           ;PIX HAS DATA...NO FUZZ                                 
*         MOVE    B2,A5                ;FUZZING IN PROGRESS?
*         JRZ     NO_FUDGE_2           ;NOPE
*
*         RL      8,A0                 ;BRING A0 AROUND 8 TIMES         
*         MOVE    A0,A12                                                
*         AND     A5,A12               ;MASK DOWN BY FUZZ MASK             
*         MOVE    A12,A4               ;COPY SCREEN DATA DOWN           
*         SRL     3,A4                                                  
*                                                                       
*NO_FUDGE_2:
*         MOVE    A12,A5
*         SLL     29,A5
*         SRL     30,A5                ;BITS 1 AND 2
*
*         SLL     31,A12
*         SRL     31,A12               ;BIT 0 
*
*         ADD     A8,A4                ;ADD IN NEW COLOR
*         CMPI    31,A4                ;MAXED OUT?
*         JRLS    LOW_0                ;NO
*         MOVK    31,A4                ;SET TO MAX
*
*LOW_0:
*         CMP     A1,A4                ;ARE WE IN RANGE TO STOP 2ND FROM 3?
*         JRLO    LOW_2                ;NO
*
*         CMPI    3,A5                 ;IS 2ND AT 3?
*         JRLO    LOW_2                ;NOPE...LEAVE IT
*
*         DEC     A5                   ;TAKE 1 AWAY
*
*LOW_2:   CMP     A9,A4                ;ARE WE IN RANGE TO STOP 2ND FROM 2?
*         JRLO    LOW_3                ;NO
*
*         CMPI    2,A5
*         JRLO    LOW_3
*
*         DEC     A5
*
*LOW_3:   CMP     A10,A4                ;ARE WE IN RANGE TO KILL ALL OTHERS?
*         JRLO    LOW_4
*         CLR     A5
*         CLR     A12                   ;TRASH OUT THAT COLOR
*
*LOW_4:   SLL     3,A4
*         SLL     1,A5
*         ADD     A4,A12
*         ADD     A5,A12
*
*PUT_PIX_OUT:
**
**        A11,A12 HAVE THE PIXEL DATA
**
*         SLL     8,A11           ;SHIFT HIGH DATA
*         ADD     A12,A11         ;NOW WE HAVE BOTH PIXIES TO WRITE
*         MOVE    A11,*A3+,W      ;PUT THE PIXIES BACK ON THE SCREEN!
*
*LOOP_BOT:
*         DSJ     B5,FINISH_ROW_LOOP  ;1 MORE WORD IN THIS ROW DONE!
*         ADDI    SCREEN_X_UNIT*SCREEN_PITCH,A2     ;GET TO NEXT ROW
*         MOVE    A2,A3
*         DSJ     B3,NEW_ROW_LOOP     ;DECREMENT COLUMN COUNT 
*
*BLOB_OFF_SCREEN:
*	MMFM    SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12
*         MMFM    SP,B2,B3,B4,B5
*	RETS

PLOT_ON_BLACK:
         MMTM    SP,B2,B3,B4,B5
         MMTM    SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A14

         MOVE    *A13(SPR_POINTER),A6,L    ;A6 = ROM STRUCT POINTER
         MOVE    *A6(WIDTH),A1,W                 ;WIDTH OF BRUSH
         SRL     1,A1                      ;WIDTH OF BRUSH IN -WORDS-
         MOVE    A1,B4                   ;***B4 = WIDTH OF BRUSH IN -WORDS-
         MOVE    *A6(HEIGHT),A2,W                 ;HEIGHT OF BRUSH
         MOVE    A2,B3                   ;***B3 = HEIGHT OF BRUSH
*
*        NOW WE NEED TO GO FROM CURRENT COORDINATE TO UPPER LEFT OF
*        BRUSH
*
         MOVE    *A6(DW),A3,L                 ;DX IN A3
         MOVE    *A13(SPR_X),A4,L          ;GET X
         SRL     9,A4                      ;MOVE X TO SCREEN COORDINATE
         ADD     A4,A3                     ;ADD IT INTO A3
         ANDI    EVEN_X_MASK,A3            ;UPPER LEFT X

         MOVE    *A6(DH),A4,L                 ;DY IN A4
*                                        ;***A6 = BRUSH DATA POINTER
         MOVE    *A13(SPR_Y),A5,L          ;GET Y
         ADD     A5,A4                     ;ADD IT INTO A4
         ANDI    Y_MASK,A4                 ;UPPER LEFT Y IN A4
         ADD     A4,A3                   ;***A3 = UPPER LEFT SCREEN POINTER
         CMPI    PLOT_MAX,A3            ;ARE WE ON SCREEN?
         JAHS    BLOB_OFF_SCREEN1           ;NOPE....EXIT

         MOVE    *A13(SPR_PALETTE),A4,W  ;***A4=PALETTE NUMBER FOR LOW PIX
         ANDI    BYTE_MASK,A4              ;KEEP LOW PIECE
         MOVE    A3,A2                     ;SAVE ROW START IN A2

         MOVE    A4,A5                     ;COPY PALETTE TO A5
         SLL     8,A5                      ;DUPLICATE INTO HIGH BYTE
         ADD     A4,A5                     ;ADD LOW BACK IN
         MOVE    A5,@CMAPSEL,W             ;THIS MAKES SURE OUR WRITE USE OUR PAL

         MOVE    *A13(SPR_FUZZ_FLAG),A1,W  ;GET FUZZ PARAMETER
         MOVE    A1,A9                     ;COPY FOR BASE
         ANDI    0FFH,A1                   ;KEEP MASK IN A1
         SRL     8,A9                      ;SHIFT BASE DOWN
         ANDI    0FFH,A9                   ;AND KEEP IT ONLY

         ADDI    S_DATA,A6                 ;POINT AT THE DATA

         MOVE    *A13(SPR_COL_BASE),A4,W     ;RANGE FOR SPRAY COLOR
         MOVE    *A13(SPR_COL_MAX),A5,W

         MOVE    *A13(SPR_Y_SCROLL),A14,L    ;KEEP CURRENT Y HERE

*
*        AT THIS POINT:
*
*        A0   RANDOM #'S FETCHED HERE.
*
*        A6 = ROM BRUSH POINTER
*        A2 = BEGINNING OF ROW SCREEN POINTER
*        A3 = SCREEN POINTER
*
*        B2 = AVAILABLE
*        B3 = HEIGHT COUNTER
*        B4 = ROW SIZE
*        B5 = ROW COUNTER
*
*        A4 = COLOR BASE
*        A5 = COLOR MAX
*        
*        A1 FUZZ MASK
*        A9 FUZZ BASE
*        A10 available
*        A14 = SCROLLING_Y_POSITION
*
**************************************************************************
*                                                                        *
*          THIS IS THE BASIC PROCESSING LOOP                             *
*                                                                        *
**************************************************************************

NEW_ROW_LOOP1:
         MOVE    B4,B5                     ;REFRESH ROW COUNTER
         CALLA   RANDOM

FINISH_ROW_LOOP1:
         MOVE    *A6+,A7,W                 ;FETCH 2 BRUSH BYTES
         JRNE    WORK_TO_DO1
         ADDI    WORD_SIZE,A3              ;BOTH DATA ZERO,
         JAUC    LOOP_BOT1                  ;KICK THE SCREEN POINTER

*                                          ;**A7,A8..A7 = HIGH PIX A8 = LOW PIX
WORK_TO_DO1:
         MOVE    @Y_CORR,A10,L             ;GET ANY CORRECTION
         CMP     A10,A14                   ;THIS IS NEGATIVE OF THE OFFSET
         JRZ     NO_Y_COR1                 ;NO CORRECTION....CONTINUE

         SUB     A10,A14                   ;REMOVE THIS AMOUNT
         NEG     A14                       ;TURN IT POSITIVE (OUR OFFSET)

         ADD     A14,A3                    ;FACTOR IN THE CORRECTION
         ADD     A14,A2                    ;ALSO TO THE "ROW REMEMBER"
         MOVE    *A13(SPR_Y_BASE),A8,L     ;GET Y BASE FOR CURRENT OP
         ADD     A14,A8                    ;ADD CORRECTION
         MOVE    A8,*A13(SPR_Y_BASE),L     ;STORE IT BACK

         MOVE    *A13(SPR_Y),A8,L          ;GET Y FOR CURRENT BLOB
         ADD     A14,A8                    ;ADD CORRECTION
         MOVE    A8,*A13(SPR_Y),L          ;STORE IT BACK

         MOVE    A10,A14                   ;MAKE THIS OUR CURRENT POSITION

NO_Y_COR1
         GO_RIGHT A7,A8                    ;SHIFT THE A DOWN...MASK THE B

         MOVE    *A3,A11,W       ;***A11 = DATA FROM SCREEN
         GO_RIGHT A11,A12        ;***A11,A12  A11 = HIGH PIX  A12 = LOW PIX
*
*
*        NOW....WE HAVE:
*
*        HIGH PIXEL                   LOW PIXEL
*        A7  = NEW DATA                A8  = NEW DATA
*        A11 = SCREEN DATA             A12 = SCREEN DATA
*
*        NOW....GET SPRAY IN A4   2NDARY IN A5   THIRD IN A11

         MOVE    A7,A7                 ;NO DATA?
         JREQ    DO_LOW_PIX1           ;THEN SKIP PROCESSING.

         CMPI    5,A7                  ;IS NEW DATA SMALL?
         JRHI    HIGH_11

         RL      2,A0                 ;CHECK A RANDY BIT
         JRC     DO_LOW_PIX1           ;SKIP 3/4 THE TIME
         JRN     DO_LOW_PIX1

HIGH_11:
         CMP     A4,A11                ;ARE WE IN RANGE?
         JRLO    NO_DATA_1             ;PIX VALUE TOO LOW....START FRESH
         CMP     A5,A11                ;ARE WE TOO HIGH?
         JRLS    NO_FUDGE_11           ;ITS IN OUR RANGE!
*
*        SCREEN DATA HAD NO SPRAY COLOR....WE EITHER NEED TO ESTABLISH
*        DATA IN THE SPRAY RANGE, OR PLOT A FUZZ VALUE. 
*

NO_DATA_1:
         MOVE    A4,A11               ;LOAD NO COLOR IN OUR RANGE FOR NO_FUDGE_11
*         MOVE    A1,A14               ;COPY FUZZ MASK
*         JRZ     NO_FUDGE_11          ;NO FUZZING......SKIP FUZZ
*
*         RL      8,A0                 ;BRING A0 AROUND 8 TIMES FOR NEW RANDY        
*         AND     A0,A14               ;RANDOM MASK IN A14                                 
*         ADD     A9,A14               ;ADD IN THE FUZZ BASE
*         MOVE    A14,A11              ;THIS IS THE PIX....LEAVE IN REGGIE AND SKIP
*
*        Now add the brush compenent at this point
*
NO_FUDGE_11:
         ADD     A7,A11               ;ADD IN THE COLOR TO WHAT'S THERE
         CMP     A5,A11               ;ARE WE BEYOND MAX?
         JRLS    DO_LOW_PIX1          ;NOPE CONTINUE
         MOVE    A5,A11               ;SET TO MAX.

*
*        HIGH BYTE DONE.....WORK ON LOW BYTE
*
DO_LOW_PIX1:
         MOVE    A8,A8                ;NO DATA?
         JREQ    PUT_PIX_OUT1          ;THEN SKIP PROCESSING.

         CMPI    5,A8                 ;IS LOW PIXEL SMALL?
         JRHI    LOW_11

         RL      2,A0                 ;CHECK A RANDY BIT
         JRC     PUT_PIX_OUT1          ;SKIP 3/4 THE TIME
         JRN     PUT_PIX_OUT1  

LOW_11:
         CMP     A4,A12                ;ARE WE IN RANGE?
         JRLO    LOW_DATA_1             ;PIX VALUE TOO LOW....START FRESH
         CMP     A5,A12                ;ARE WE TOO HIGH?
         JRLS    LOW_FUDGE_11           ;ITS IN OUR RANGE!
*
*        SCREEN DATA HAD NO SPRAY COLOR....WE EITHER NEED TO ESTABLISH
*        DATA IN THE SPRAY RANGE, OR PLOT A FUZZ VALUE. 
*

LOW_DATA_1:
         MOVE    A4,A12               ;LOAD NO COLOR IN OUR RANGE FOR NO_FUDGE_11
*         MOVE    A1,A14               ;COPY FUZZ MASK
*         JRZ     LOW_FUDGE_11          ;NO FUZZING......SKIP FUZZ

*         RL      8,A0                 ;BRING A0 AROUND 8 TIMES FOR NEW RANDY        
*         AND     A0,A14               ;RANDOM MASK IN A14                                 
*         ADD     A9,A14               ;ADD IN THE FUZZ BASE
*         MOVE    A14,A12              ;THIS IS THE PIX....LEAVE IN REGGIE AND SKIP
*
*        Now add the brush compenent at this point
*
LOW_FUDGE_11:
         ADD     A8,A12               ;ADD IN THE COLOR TO WHAT'S THERE
         CMP     A5,A12               ;ARE WE BEYOND MAX?
         JRLS    PUT_PIX_OUT1          ;NOPE CONTINUE
         MOVE    A5,A12               ;SET TO MAX.

PUT_PIX_OUT1:
*
*        A11,A12 HAVE THE PIXEL DATA
*
         SLL     8,A11           ;SHIFT HIGH DATA
         ADD     A12,A11         ;NOW WE HAVE BOTH PIXIES TO WRITE
         MOVE    A11,*A3+,W      ;PUT THE PIXIES BACK ON THE SCREEN!

LOOP_BOT1:
         DSJ     B5,FINISH_ROW_LOOP1  ;1 MORE WORD IN THIS ROW DONE!
         ADDI    SCREEN_X_UNIT*SCREEN_PITCH,A2     ;GET TO NEXT ROW
         MOVE    A2,A3
         DSJ     B3,NEW_ROW_LOOP1     ;DECREMENT COLUMN COUNT 

         MOVE    A14,*A13(SPR_Y_SCROLL),L    ;UPDATE OUR SCROLL POSITION.

BLOB_OFF_SCREEN1:
	MMFM    SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A14
         MMFM    SP,B2,B3,B4,B5
	RETS

**************************************************************************
*                                                                        *
*          SET_BRUSH                                                     *
*                                                                        *
*          THIS IS CALLED TO SET A PARTICULAR BRUSH TO BE                *
*          USED FOR SPRAYING.  THE BRUSH IS DEFINED BY                   *
*          A POINTER TO A ROM BRUSH STRUCTURE.  THIS IS                  *
*          PASSED AS A LONG WORD IN A0.                                  *
*                                                                        *
**************************************************************************
SET_BRUSH:
         MOVE    A0,*A13(SPR_POINTER),L    ;STORE POINTER TO BRUSH IN PAREA
         RETS

**************************************************************************
*                                                                        *
*          PALETTE_FOR_BLACK_SPRAY                                       *
*                                                                        *
*          THIS IS CALLED TO INITIALIZE SPRAY ON BLACK FOR THE           *
*          CURRENT PROCESS.   IT TAKES A0 = PALETTE NUMBER.              *
*                                      A1 = SPRAY COLOR 0-7              *
*                                                                        *
*          IT INITIALIZES THE A0 PALETTE, SETS PROCESS AREA              *
*          TO USE THAT PALETTE, AND PARAMETERS FOR                       *
*          SPECIFIED COLOR.  IT ALSO SETS UP A POINTER TO                *
*          THE PLOT_BLOB ROUTINE FOR SPRAY ON BLACK.                     *
*                                                                        *
**************************************************************************
PALETTE_FOR_BLACK_SPRAY
         MMTM    SP,A0
         CALLR   SET_SPRAY_PALETTE        ;SET THE PALETTE FOR PROCESS USE
         CALLR   SETUP_PALETTE_SPR_ON_BLACK

         MOVE    A1,A0                ;COPY COLOR TO A0
         CALLR   SET_SPRAY_COLOR      ;SETUP PROCESS FOR THIS COLOR

         MOVI    PLOT_ON_BLACK,A0     ;THIS IS THE "PLOT BLOB" ROUTINE FOR BLACK 
         MOVE    A0,*A13(SPR_BLOB_ROUT),L  ;PUT IT OUT THERE.
	MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          PALETTE_FOR_WALL_SPRAY                                        *
*                                                                        *
*          THIS IS CALLED FOR SPRAYING OVER BACKGROUND.  THE             *
*          PALETTE NUMBER TO USE IS IN A0.  THE ROM TABLE                *
*          TO INITIALIZE THE PALETTE IS IN A1.  IT ALSO SETS             *
*          THE BLOB ROUTINE TO THE  SPRAY ON WALL HANDLER.               *
*                                                                        *
**************************************************************************
PALETTE_FOR_WALL_SPRAY
         MMTM    SP,A0
         CALLR   SET_SPRAY_PALETTE    ;SET THE PALETTE FOR THIS SPRAY PROC.
         CALLR   SETUP_PALETTE        ;INITIALIZE PALETTE 0 FOR SPRAYING.

         MOVI    PLOT_BLOB,A0         ;THIS IS THE "PLOT BLOB" ROUTINE FOR WALLS 
         MOVE    A0,*A13(SPR_BLOB_ROUT),L  ;PUT IT OUT THERE.
	MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          SET_SPRAY_PALETTE                                             *
*                                                                        *
*          THIS IS CALLED WITH THE 6 BIT PALETTE TO SETUP FOR            *
*          SPRAYING.  THE LOW WORD OF A0 CONTAINS THE PALETTE            *
*          NUMBER.                                                       *
*                                                                        *
**************************************************************************
SET_SPRAY_PALETTE:
         MMTM    SP,A0
         ANDI    MAX_PAL_MASK,A0              ;MASK DOWN TO 6 BITS
         MOVE    A0,*A13(SPR_PALETTE),W   ;INDICATE WHICH PALETTE WE'RE USING
	MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          SETUP_PALETTE                                                 *
*                                                                        *
*          THIS IS CALLED WITH A PALETTE NUMBER IN A0.  IT               *
*          SETS UP THAT PALETTE FOR THE SPRAY PAINTER.                   *
*                                                                        *
*          A1 POINTS TO ROM TABLE DEFINING PALETTE.                      *
*                                                                        *
*          THIS IS FOR WALL PAINTING ONLY                                *
*                                                                        *
*          A1 GETS BASE OF TABLE TO SETUP.                               *
*                                                                        *
**************************************************************************
SETUP_PALETTE:
         MMTM    SP,A0,A1,A2
         CALLR   POINT_AT_PALETTE          ;POINT A0 AT PALETTE
         MOVI    256,A2                    ;COUNT 256 TICKS
SP1:
         MOVE    *A1+,*A0+,W               ;COPY A BYTE
         DSJS    A2,SP1
	MMFM    SP,A0,A1,A2
	RETS

**************************************************************************
*                                                                        *
*          SETUP_PALETTE_SPR_ON_BLACK                                    *
*                                                                        *
*          THIS IS CALLED WITH A PALETTE NUMBER IN A0.  IT               *
*          SETS UP THAT PALETTE FOR THE SPRAY PAINTER.                   *
*                                                                        *
**************************************************************************
SETUP_PALETTE_SPR_ON_BLACK:
         MMTM    SP,A0,A1,A2,A3,A4
*
*        TRY AND WAIT FOR BEAM HERE!
*

WAIT_FOR_BEAM
         MOVE    @VCOUNT,A1,W              ;GET THE VERTICAL COUNTER
         CMPI    8,A1                      ;DO IT WHEN THE BEAM IS HIGH!
         JRLS    BEAM_ME_UP_SCOTTY

         MOVE    @TIMER,A1,W               ;GET ELAPSED TIME
         CMPI    20,A1                     ;ARE WE HANGING?
         JRLO    WAIT_FOR_BEAM
         NOP                               ;PLACE FOR BREAKPOINT TO CHECK TIMEOUT!

BEAM_ME_UP_SCOTTY
         CALLR   POINT_AT_PALETTE

         MOVI    SPRAY_COL_TABLE,A1        ;POINT AT COLOR TABLE

SET_P2:
         MOVE    *A1+,A2,W                 ;GET COLOR COMBINATION

         CLR     A4                        ;ACCUMULATE THE COLOR IN A4
         MOVK    32,A3                     ;COUNT THE 32 COLORS

SET_P1:
         MOVE    A4,*A0+,W                 ;PUT THE CURRENT COLOR OUT
         ADD     A2,A4                     ;ADD SOME COLOR
         DSJS    A3,SET_P1                 ;DO 32

         CMPI    SPRAY_COL_END,A1          ;HAVE WE GOTTEN ALL THE COLORS?
         JRLO    SET_P2
	MMFM    SP,A0,A1,A2,A3,A4
	RETS

POINT_AT_PALETTE
         ANDI    MAX_PAL_MASK,A0           ;MASK DOWN TO 6 BITS
         SLL     LOG_PAL_SIZE,A0           ;FORM POINTER TO BASE OF PALETTE
         ADDI    COLRAM,A0                 ;NOW A0 POINTS AT PALETTE BASE
         RETS

**************************************************************************
*                                                                        *
*          SET_SPRAY_COLOR                                               *
*                                                                        *
*          THIS IS CALLED TO SET THE CURRENT SPRAY COLOR.                *
*          IT IS FOR SPRAYING ON BLACK ONLY!                             *
*          IT IS STORED IN THE CURRENT PROCESS STORE AREA.               *
*          A0 HAS THE 3 BIT QUANTITY.                                    *
*                                                                        *
**************************************************************************
SET_SPRAY_COLOR:
         MMTM    SP,A0
         ANDI    SPRAY_NUM_MASK,A0    ;MASK TO BITS THAT COUNT
         SLL     5,A0                 ;32 PALETTE COLORS PER SPRAY COLOR
         MOVE    A0,*A13(SPR_COL_BASE),W  ;MINIMUM FROM OUR CAN
         ADDK    31,A0                    ;MAXIMUM COLOR
         MOVE    A0,*A13(SPR_COL_MAX),W   ;MAX FROM OUR CAN
	MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          SPRAY_COL_TABLE                                               *
*                                                                        *
*          THIS IS THE SPRAYPAINT TABLE FOR BLACK BACKGROUND             *
*          SPRAYPAINT.  IT GIVES THE ATTRIBUTES FOR THE SPRAY COLORS.    *
*                                                                        *
**************************************************************************
SPRAY_COL_TABLE:
         .WORD   0                              ;SPRAY WORD 0 = BLACK
         .WORD   ONE_BLUE                       ;           1 = BLUE
         .WORD   ONE_GREEN                      ;           2 = GREEN
         .WORD   ONE_GREEN+ONE_BLUE             ;           3 = YELLOW
         .WORD   ONE_RED                        ;           4 = RED
         .WORD   ONE_RED+ONE_BLUE               ;           5 = VIOLET
         .WORD   ONE_RED+ONE_GREEN              ;           6 = ORANGE
         .WORD   ONE_RED+ONE_GREEN+ONE_BLUE     ;           7 = WHITE
SPRAY_COL_END:


**************************************************************************
*                                                                        *
* SP_PAL2:         ;THIS MAKES SP_PAL2 A VALID NARC PALETTE (FOR WALL ET *
*          .WORD            256                                          *
* GREEN_PAL_TABLE:                                                       *
*          .INCLUDE        "SP_PAL2.ASM"           ;USE GREEN SPRAY CAN  *
*                                                                        *
**************************************************************************
*
*        THE LABEL BRUSH_ROM IS USED TO "INITIALIZE" THE
*        SPRAY PALETTE.  IT MUST POINT ANYWHERE IN
*        ROM SPACE.  THE PALETTE WILL LATER BE ALGORITHMICALLY
*        SETUP.
*
BRUSH_ROM        EQU     $

SIZE_6
   .word    >C,>B
   .LONG    -((>C/2)*SCREEN_X_UNIT)
   .LONG    -((>B/2)*SCREEN_Y_UNIT)
   .WORD    30H
I_S_6_25:
   .byte    >00,>00,>00,>00,>05,>05,>05,>00,>00,>00,>00,0
   .byte    >00,>00,>05,>0C,>0C,>0E,>0C,>0C,>05,>00,>00,0
   .byte    >00,>05,>0C,>0E,>11,>11,>11,>0E,>0C,>05,>00,0
   .byte    >00,>0C,>0E,>13,>13,>15,>13,>13,>0E,>0C,>00,0
   .byte    >05,>0C,>11,>13,>15,>15,>15,>13,>11,>0C,>05,0
   .byte    >05,>0E,>11,>15,>15,>16,>15,>15,>11,>0E,>05,0
   .byte    >05,>0C,>11,>13,>15,>15,>15,>13,>11,>0C,>05,0
   .byte    >00,>0C,>0E,>13,>13,>15,>13,>13,>0E,>0C,>00,0
   .byte    >00,>05,>0C,>0E,>11,>11,>11,>0E,>0C,>05,>00,0
   .byte    >00,>00,>05,>0C,>0C,>0E,>0C,>0C,>05,>00,>00,0
   .byte    >00,>00,>00,>00,>05,>05,>05,>00,>00,>00,>00,0

MEDIUM_1:         
   .word    >14,>13
   .LONG    -((>14/2)*SCREEN_X_UNIT)
   .LONG    -((>13/2)*SCREEN_Y_UNIT)
   .WORD    6*6

I_S_10_12:
   .byte    00H,00H,00H,00H,00H,00H,00H,00H,00H,02H,00H,00H,00H,00H,00H,00H
   .byte    00H,00H,00H,0
   .byte    00H,00H,00H,00H,00H,02H,02H,02H,02H,02H,02H,02H,02H,02H,00H,00H
   .byte    00H,00H,00H,0
   .byte    00H,00H,00H,00H,02H,02H,04H,04H,04H,04H,04H,04H,04H,02H,02H,00H
   .byte    00H,00H,00H,0
   .byte    00H,00H,00H,02H,04H,04H,06H,06H,06H,06H,06H,06H,06H,04H,04H,02H
   .byte    00H,00H,00H,0
   .byte    00H,00H,02H,04H,04H,06H,06H,06H,07H,07H,07H,06H,06H,06H,04H,04H
   .byte    02H,00H,00H,0
   .byte    00H,02H,02H,04H,06H,06H,07H,07H,08H,08H,08H,07H,07H,06H,06H,04H
   .byte    02H,02H,00H,0
   .byte    00H,02H,04H,06H,06H,07H,08H,08H,08H,09H,08H,08H,08H,07H,06H,06H
   .byte    04H,02H,00H,0
   .byte    00H,02H,04H,06H,06H,07H,08H,09H,09H,09H,09H,09H,08H,07H,06H,06H
   .byte    04H,02H,00H,0
   .byte    00H,02H,04H,06H,07H,08H,08H,09H,09H,09H,09H,09H,08H,08H,07H,06H
   .byte    04H,02H,00H,0
   .byte    02H,02H,04H,06H,07H,08H,09H,09H,09H,09H,09H,09H,09H,08H,07H,06H
   .byte    04H,02H,02H,0
   .byte    00H,02H,04H,06H,07H,08H,08H,09H,09H,09H,09H,09H,08H,08H,07H,06H
   .byte    04H,02H,00H,0
   .byte    00H,02H,04H,06H,06H,07H,08H,09H,09H,09H,09H,09H,08H,07H,06H,06H
   .byte    04H,02H,00H,0
   .byte    00H,02H,04H,06H,06H,07H,08H,08H,08H,09H,08H,08H,08H,07H,06H,06H
   .byte    04H,02H,00H,0
   .byte    00H,02H,02H,04H,06H,06H,07H,07H,08H,08H,08H,07H,07H,06H,06H,04H
   .byte    02H,02H,00H,0
   .byte    00H,00H,02H,04H,04H,06H,06H,06H,07H,07H,07H,06H,06H,06H,04H,04H
   .byte    02H,00H,00H,0
   .byte    00H,00H,00H,02H,04H,04H,06H,06H,06H,06H,06H,06H,06H,04H,04H,02H
   .byte    00H,00H,00H,0
   .byte    00H,00H,00H,00H,02H,02H,04H,04H,04H,04H,04H,04H,04H,02H,02H,00H
   .byte    00H,00H,00H,0
   .byte    00H,00H,00H,00H,00H,02H,02H,02H,02H,02H,02H,02H,02H,02H,00H,00H
   .byte    00H,00H,00H,0
   .byte    00H,00H,00H,00H,00H,00H,00H,00H,00H,02H,00H,00H,00H,00H,00H,00H
   .byte    00H,00H,00H,0

BIG_BRUSH_1:         
   .word    >1A,>19
   .LONG    -((1AH/2)*SCREEN_X_UNIT)
   .LONG    -((19H/2)*SCREEN_Y_UNIT)
   .word    (8*2)*(8*2)         ;SQUARE OF SPRAY LENGTH W/ 2 BIT FRAC.

   .byte    >00,>00,>00,>00,>00,>00,>00,>00,>01,>02,>02,>03,>03,>03,>02,>02
   .byte    >01,>00,>00,>00,>00,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>00,>00,>01,>02,>04,>04,>05,>05,>06,>05,>05,>04
   .byte    >04,>02,>01,>00,>00,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>00,>02,>04,>05,>06,>07,>08,>08,>08,>08,>08,>07
   .byte    >06,>05,>04,>02,>00,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>03,>04,>06,>08,>09,>0A,>0A,>0B,>0B,>0B,>0A,>0A
   .byte    >09,>08,>06,>04,>03,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>03,>05,>07,>08,>0A,>0B,>0C,>0C,>0D,>0D,>0D,>0C,>0C
   .byte    >0B,>0A,>08,>07,>05,>03,>00,>00,>00,>00
   .byte    >00,>00,>02,>04,>07,>09,>0A,>0C,>0D,>0E,>0E,>0F,>0F,>0F,>0E,>0E
   .byte    >0D,>0C,>0A,>09,>07,>04,>02,>00,>00,>00
   .byte    >00,>01,>04,>06,>08,>0A,>0C,>0D,>0E,>0F,>11,>11,>11,>11,>11,>0F
   .byte    >0E,>0D,>0C,>0A,>08,>06,>04,>01,>00,>00
   .byte    >00,>02,>05,>08,>0A,>0C,>0D,>0F,>11,>11,>13,>13,>13,>13,>13,>11
   .byte    >11,>0F,>0D,>0C,>0A,>08,>05,>02,>00,>00
   .byte    >01,>04,>06,>09,>0B,>0D,>0E,>11,>11,>13,>14,>14,>14,>14,>14,>13
   .byte    >11,>11,>0E,>0D,>0B,>09,>06,>04,>01,>00
   .byte    >02,>04,>07,>0A,>0C,>0E,>0F,>11,>13,>14,>15,>15,>15,>15,>15,>14
   .byte    >13,>11,>0F,>0E,>0C,>0A,>07,>04,>02,>00
   .byte    >02,>05,>08,>0A,>0C,>0E,>11,>13,>14,>15,>15,>16,>16,>16,>15,>15
   .byte    >14,>13,>11,>0E,>0C,>0A,>08,>05,>02,>00
   .byte    >03,>05,>08,>0B,>0D,>0F,>11,>13,>14,>15,>16,>16,>16,>16,>16,>15
   .byte    >14,>13,>11,>0F,>0D,>0B,>08,>05,>03,>00
   .byte    >03,>06,>08,>0B,>0D,>0F,>11,>13,>14,>15,>16,>16,>18,>16,>16,>15
   .byte    >14,>13,>11,>0F,>0D,>0B,>08,>06,>03,>00
   .byte    >03,>05,>08,>0B,>0D,>0F,>11,>13,>14,>15,>16,>16,>16,>16,>16,>15
   .byte    >14,>13,>11,>0F,>0D,>0B,>08,>05,>03,>00
   .byte    >02,>05,>08,>0A,>0C,>0E,>11,>13,>14,>15,>15,>16,>16,>16,>15,>15
   .byte    >14,>13,>11,>0E,>0C,>0A,>08,>05,>02,>00
   .byte    >02,>04,>07,>0A,>0C,>0E,>0F,>11,>13,>14,>15,>15,>15,>15,>15,>14
   .byte    >13,>11,>0F,>0E,>0C,>0A,>07,>04,>02,>00
   .byte    >01,>04,>06,>09,>0B,>0D,>0E,>11,>11,>13,>14,>14,>14,>14,>14,>13
   .byte    >11,>11,>0E,>0D,>0B,>09,>06,>04,>01,>00
   .byte    >00,>02,>05,>08,>0A,>0C,>0D,>0F,>11,>11,>13,>13,>13,>13,>13,>11
   .byte    >11,>0F,>0D,>0C,>0A,>08,>05,>02,>00,>00
   .byte    >00,>01,>04,>06,>08,>0A,>0C,>0D,>0E,>0F,>11,>11,>11,>11,>11,>0F
   .byte    >0E,>0D,>0C,>0A,>08,>06,>04,>01,>00,>00
   .byte    >00,>00,>02,>04,>07,>09,>0A,>0C,>0D,>0E,>0E,>0F,>0F,>0F,>0E,>0E
   .byte    >0D,>0C,>0A,>09,>07,>04,>02,>00,>00,>00
   .byte    >00,>00,>00,>03,>05,>07,>08,>0A,>0B,>0C,>0C,>0D,>0D,>0D,>0C,>0C
   .byte    >0B,>0A,>08,>07,>05,>03,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>03,>04,>06,>08,>09,>0A,>0A,>0B,>0B,>0B,>0A,>0A
   .byte    >09,>08,>06,>04,>03,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>00,>02,>04,>05,>06,>07,>08,>08,>08,>08,>08,>07
   .byte    >06,>05,>04,>02,>00,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>00,>00,>01,>02,>04,>04,>05,>05,>06,>05,>05,>04
   .byte    >04,>02,>01,>00,>00,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>00,>00,>00,>00,>01,>02,>02,>03,>03,>03,>02,>02
   .byte    >01,>00,>00,>00,>00,>00,>00,>00,>00,>00

BIG_ERASER:         
   .word    >1A,>19
   .LONG    -((1AH/2)*SCREEN_X_UNIT)
   .LONG    -((19H/2)*SCREEN_Y_UNIT)
   .word    (8*2)*(8*2)         ;SQUARE OF SPRAY LENGTH W/ 2 BIT FRAC.

   .byte    >00,>00,>00,>00,>00,>00,>00,>00,>10,>10,>10,>10,>10,>10,>10,>10
   .byte    >10,>00,>00,>00,>00,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>00,>00,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10
   .byte    >10,>10,>10,>00,>00,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>00,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10
   .byte    >10,>10,>10,>10,>00,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10
   .byte    >10,>10,>10,>10,>10,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10
   .byte    >10,>10,>10,>10,>10,>10,>00,>00,>00,>00
   .byte    >00,>00,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10
   .byte    >10,>10,>10,>10,>10,>10,>10,>00,>00,>00
   .byte    >00,>10,>10,>10,>10,>10,>10,>10,>10,>10,>11,>11,>11,>11,>11,>10
   .byte    >10,>10,>10,>10,>10,>10,>10,>10,>00,>00
   .byte    >00,>10,>10,>10,>10,>10,>10,>10,>11,>11,>13,>13,>13,>13,>13,>11
   .byte    >11,>10,>10,>10,>10,>10,>10,>10,>00,>00
   .byte    >10,>10,>10,>10,>10,>10,>10,>11,>11,>13,>14,>14,>14,>14,>14,>13
   .byte    >11,>11,>10,>10,>10,>10,>10,>10,>10,>00
   .byte    >10,>10,>10,>10,>10,>10,>10,>11,>13,>14,>15,>15,>15,>15,>15,>14
   .byte    >13,>11,>10,>10,>10,>10,>10,>10,>10,>00
   .byte    >10,>10,>10,>10,>10,>10,>11,>13,>14,>15,>15,>16,>16,>16,>15,>15
   .byte    >14,>13,>11,>10,>10,>10,>10,>10,>10,>00
   .byte    >10,>10,>10,>10,>10,>10,>11,>13,>14,>15,>16,>16,>16,>16,>16,>15
   .byte    >14,>13,>11,>10,>10,>10,>10,>10,>10,>00
   .byte    >10,>10,>10,>10,>10,>10,>11,>13,>14,>15,>16,>16,>18,>16,>16,>15
   .byte    >14,>13,>11,>10,>10,>10,>10,>10,>10,>00
   .byte    >10,>10,>10,>10,>10,>10,>11,>13,>14,>15,>16,>16,>16,>16,>16,>15
   .byte    >14,>13,>11,>10,>10,>10,>10,>10,>10,>00
   .byte    >10,>10,>10,>10,>10,>10,>11,>13,>14,>15,>15,>16,>16,>16,>15,>15
   .byte    >14,>13,>11,>10,>10,>10,>10,>10,>10,>00
   .byte    >10,>10,>10,>10,>10,>10,>10,>11,>13,>14,>15,>15,>15,>15,>15,>14
   .byte    >13,>11,>10,>10,>10,>10,>10,>10,>10,>00
   .byte    >10,>10,>10,>10,>10,>10,>10,>11,>11,>13,>14,>14,>14,>14,>14,>13
   .byte    >11,>11,>10,>10,>10,>10,>10,>10,>10,>00
   .byte    >00,>10,>10,>10,>10,>10,>10,>10,>11,>11,>13,>13,>13,>13,>13,>11
   .byte    >11,>10,>10,>10,>10,>10,>10,>10,>00,>00
   .byte    >00,>10,>10,>10,>10,>10,>10,>10,>10,>10,>11,>11,>11,>11,>11,>10
   .byte    >10,>10,>10,>10,>10,>10,>10,>10,>00,>00
   .byte    >00,>00,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10
   .byte    >10,>10,>10,>10,>10,>10,>10,>00,>00,>00
   .byte    >00,>00,>00,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10
   .byte    >10,>10,>10,>10,>10,>10,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10
   .byte    >10,>10,>10,>10,>10,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>00,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10
   .byte    >10,>10,>10,>10,>00,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>00,>00,>10,>10,>10,>10,>10,>10,>10,>10,>10,>10
   .byte    >10,>10,>10,>00,>00,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>00,>00,>00,>00,>10,>10,>10,>10,>10,>10,>10,>10
   .byte    >10,>00,>00,>00,>00,>00,>00,>00,>00,>00

**************************************************************************
*                                                                        *
*          THESE ARE THE ROUTINES FOR THE NARCSPR1 CHARACTER             *
*          SET.  THEY ARE INCLUDED HERE SO THAT THE                      *
*          CALLR DETECTOR WON'T CONSIDER CALLR TO THESE AN               *
*          ERROR.                                                        *
*                                                                        *
**************************************************************************
NUMBER_WIDTH
         MOVI    160,A3
         RETS

NUMBER_HEIGHT                                                          
         MOVI    352,A3                                                
         RETS                                                          
                                                                       
COMMA_WIDTH                                                            
         MOVI    50,A3
         RETS

**************************************************************************
*                                                                        *
*          FETCH_FIGURE_PTR                                              *
*                                                                        *
*          THIS IS CALLED OUT OF THE SCRIPT PROCESSOR EACH               *
*          TIME A CHARATER NEEDS TO BE DRAWN.  A0 CONTAINS               *
*          THE BYTE (ASCII) TO BE DRAWN.  WE NEED TO                     *
*          RETURN IN A4 A POINTER TO THE CHARACTER SCRIPT.               *
*                                                                        *
**************************************************************************
FETCH_FIGURE_PTR
         SUBI    SPACE,A0             ;WE MUST BE SPACE OR GREATER
         JRNC    FETCH_FIG_1          ;CONTINUE

BAD_ASCII
         .IF DEBUG
            JRUC   $                         ;HANG IN DEVELOPMENT
         .ENDIF

         MOVI    LET_SPACE,A4                ;GIVE BACK A SPACE IN RELEASE
         RETS                                ;AND RETURN

FETCH_FIG_1
         CMPI    UNDERSCORE-SPACE,A0         ;ARE WE BEYOND UNDERSCORE?
         JRHI    BAD_ASCII

         SLL     5,A0                        ;EACH LETTER IS A LONG WORD
         MOVI    SPRAY_1_TABLE,A4
         ADD     A0,A4                       ;A4 POINTS AT OUR POINTER
         MOVE    *A4,A4,L                    ;LOAD UP THE POINTER
         RETS

         .INCLUDE        "NARCSPR1.ASM"  ;1ST CHARACTER SET

TABLE_SCALER     EQU     11                ;SIZE OF INITIALS AND SCORES

HIGHEST_NARCS S_GPAL                            ;USE GLOBAL PALETTE
         S_BRUSH            MEDIUM_1
         S_COLOR            SPRAY_WHITE    ;THIS INITIALIZES PALETTE ECT.
         S_SCALER           20
*         S_Y                50H
         S_Y                6AH
         S_RATE             00H
         S_X                50H
         S_CHAR          "H"                                           
         S_CHAR          "I"                                           
         S_CHAR          "G"                                           
         S_CHAR          "H"                                           
         S_CHAR          "E"                                           
         S_CHAR          "S"                                           
         S_CHAR          "T"                                           

         S_X             88H
         S_Y             0A2H
         S_NEW_C         SPRAY_RED

         S_CHAR          "N"                                           
         S_CHAR          "A"                                           
         S_CHAR          "R"                                           
         S_CHAR          "C"                                           
         S_CHAR          "S"                                           

         S_SCALER         TABLE_SCALER             ;SETUP FOR BOX SPACING!
         S_END

TOP_TODAY S_ON_BLK
         S_GPAL                            ;USE GLOBAL PALETTE
         S_BRUSH            MEDIUM_1
         S_NEW_C            SPRAY_WHITE
         S_SCALER           20
         S_RATE             40H
         S_X                48H

         S_CHAR          "T"                                           
         S_CHAR          "O"                                           
         S_DY            -2000H
         S_CHAR          "D"                                           
         S_CHAR          "A"                                           
         S_DY            -3000H
         S_CHAR          "Y"                                           
         S_CHAR          27H          ;APOSTROPHE                                 
         S_DY            3000H
         S_CHAR          "S"                                           
         S_DY            2000H        ;COMPENSATE AT END FOR REST
         S_END

TOP_5    S_X             80H
         S_NEW_C         SPRAY_VIOLET

         S_CHAR          "T"                                           
         S_CHAR          "O"                                           
         S_DY            -4000H
         S_CHAR          "P"                                           
         S_CHAR          " "                                           
         S_DY            4000H             ;COMPENSATE AT END FOR REST
         S_CHAR          "5"                                           
         S_END

HSTD_ENTRY  S_RATE             100H                ;NOT LIGHT SPEED ON THIS
         S_X                LEFT_MARGIN_X
         S_BRUSH            SIZE_6
         S_SCALER           TABLE_SCALER
         S_END

**************************************************************************
*                                                                        *
* FIRST_THREE                                                            *
*          S_RATE          300H                                          *
*          S_END                                                         *
*                                                                        *
**************************************************************************
*
*        ENTER INITIALS STUFF
*
SC_CRAM  S_ON_BLK
         S_GPAL                            ;USE GLOBAL PALETTE
         S_COLOR         SPRAY_RED
         S_END

P1_SPRAY S_ON_BLK
         S_GPAL                            ;USE GLOBAL PALETTE
         S_BRUSH            BIG_BRUSH_1
         S_NEW_C            P1_SCOL        ;THIS INITIALIZES PALETTE ECT.
         S_SCALER           14H
         S_Y                110H
         S_RATE             8033H              ;3 BLOTS EVERY 3 FRAMES
         S_X                24H
         S_END                                  ;SETUP FOR SPRAY ECHO

P2_SPRAY S_GPAL                            ;USE GLOBAL PALETTE
         S_ON_BLK
         S_BRUSH            BIG_BRUSH_1
         S_NEW_C            P2_SCOL    ;THIS INITIALIZES PALETTE ECT.
         S_SCALER           14H
         S_Y                110H
         S_RATE             8033H              ;3 BLOTS EVERY 3 FRAMES
         S_X                118H
         S_END                                  ;SETUP FOR SPRAY ECHO

E_BRUSH  S_NEW_C         SPRAY_BLACK
         S_BRUSH         BIG_ERASER
         S_END

*****************************************************************************
         .EVEN                             ;AFTER BYTE BLOCK WE EVEN IT OUT!
*****************************************************************************




         .END

