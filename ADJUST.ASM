  	.FILE	'ADJUST.ASM'
	.TITLE	"ROBO GAME ADJUSTMENTS"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

;
; SOFTWARE:
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
	.INCLUDE	"MENU.EQU"		;MENU EQUATES


	.TEXT
;
*        IN THIS MODULE
*
         .DEF GO_ADJ
         .DEF DO_ADJH
	 .DEF BCDBIN
	 .DEF BINBCD
*
*        IN HSTD.ASM
*
         .REF CMOS_VAL
         .REF P_FORK
         .REF INIT_HSR
*
*        IN TEST.ASM
*
         .REF         B_MENU,CYAN_BOX
         .REF         L_MESS,TOP_BOX
         .REF         LM_FINIS
         .REF         LM_SETUP
         .REF         AREUSURE
         .REF         ST_STICK
         .REF         GETSTICK
         .REF         SUR_MESS
         .REF         SURE_BOX
         .REF         GET_FAC
         .REF         MENU_TOP
         .REF         DOBORDER
         .REF         BLNKHELP
         .REF         H_SLAVE
;         .REF         CK_DOOR
         .REF         COL_INST
         .REF         STD_BORD
         .REF         LD_CTAB
*
*        IN MENU.ASM
*
         .REF         ANY_BUT
         .REF         MESS_MM
         .REF         GET_CSPT
*
*        IN AUDIT.ASM
*
         .REF         GET_ADJ,HTOHXASC
         .REF         PUT_ADJ
         .REF         F_ADC_S
         .REF         CS_ENTS           ;NUMBER OF HIGHEST IN COIN TABLE
         .REF         STRCAT
         .REF         NO_CREDS
*

*	 OTHERS

	 .REF		 RD15FONT,RD7FONT,STRCNRM,BLNKAREA,HEXTOASC
	 .REF		 STRRNRM,STRLNRM,CLR_SCRN
*
         .TEXT
*
*        Adjustment menu requested.....make sure CMOS is ok!
*
GO_ADJ:   
	MOVI    MEN_ADJ,A8

GEN_ADJUST:
        MOVE    A8,-*A12,L           ;PUSH MENU ON STACK

        CALLA   CMOS_VAL            ;CHECK OUT THE REGION
        JRZ     SET_OK              ;ITS OK.....CONTINUE....

        JSRP    GET_FAC             ;BRING TO FACTORY SETTINGS OR QUIT.
        JSRP    ANY_BUT

        CALLA   CMOS_VAL             ;CAN'T GO IF WE'RE NOT OK NOW
        JRNZ    GO_ADQ               ;ITS NOT VALID....NO ADJUSTING!

SET_OK:   
	MOVK    1,A0
        MOVE    A0,-*A12,W           ;LIKE GEN_MENU...KEEP NUMBER ON STACK
*
ADJ_LOOP: 
	CALLA   CLR_SCRN             ;CLEAR THE SCREEN!

        MOVI    ADJ_ADV,A8
        JSRP    L_MESS               ;PRINT THE NEW INSTRUCTIONS

        MOVE    *A12(WORD_SIZE),A8,L ;GET THE MENU
        JSRP    MENU_TOP             ;PRINT OUT THE TOP.
        MOVI    ROBO_YELLOW,A9
        CALLA   COL_INST             ;PUT UP A DIFFERENT INSTR. BOX

        MOVE    *A12,A9,W            ;GET INDEX TO USE.
        JSRP    B_MENU               ;FETCH THE ENTRY TO ADJUST.
*
*       EACH ADJUSTMENT HAS A STRUCTURE ASSOCIATED WITH IT.
*       A9 RETURNS A STRUCTURE FOR THE ITEM SELECTED.
*
        MOVE    A9,A9                ;0 IS RETURN TO MAIN MENU
        JRZ     GO_ADJX
*
*       A8 HAS THE MENU NUMBER.....UNLIKE GEN_MENU...DON'T STEP!
*
        MOVE    A8,*A12,W            ;PUT IT SAFELY ON OUR STACK.

        MOVE    *A9(AD_ROUT),A0,L    ;GET THE ROUTINE TO CALL FOR ACTIVATION
        MOVI    ADJ_LOOP,A7
        MOVE    A7,-*A12,L           ;PUSH RETURN ADDRESS
        JUMP    A0                   ;"CALL THE ROUTINE (PASSING STRUCT IN A9)

GO_ADJX:  
	ADDI    WORD_SIZE,A12        ;"POP" THE POSITION INDICATOR
GO_ADQ:   
	ADDI    LONG_SIZE,A12        ;POP MENU
        RETP                         ;OK...RETURN!

**************************************************************************
*                                                                        *
*          PRICE_ADJ                                                     *
*                                                                        *
*          THIS IS EXECUTED WHEN THE "CUSTOM PRICING" ENTRY IS           *
*          SELECTED FOR ADJUSTMENT FROM THE ADJUSTMENT MENU.             *
*                                                                        *
*          IT CREATES A WHOLE NEW ADJUSTMENT MENU CONTIAING:             *
*                                                                        *
*                                                                        *
*                          LEFT SLOT UNITS                               *
*                          CENTER SLOT UNITS                             *
*                          RIGHT SLOT UNITS                              *
*                          UNITS / CREDIT                                *
*                          UNITS / BONUS                                 *
*                          MINIMUM UNITS                                 *
*                          CREDITS TO START                              *
*                          CREDITS TO CONTINUE                           *
*                          SHOW CREDIT FRACTIONS                         *
*                          COINS PER DOLLAR                              *
*                          FREE PLAY                                     *
*                          MAXIMUM CREDITS                               *
*                          COIN PAGE HELP                                *
*                                                                        *
**************************************************************************
PRICE_ADJ:
        MOVI    MEN_CUST,A8           ;HANDLE JUST LIKE MAIN ADJ. MENU
        JAUC    GEN_ADJUST

**************************************************************************
*                                                                        *
*          GEN_ADJ                                                       *
*                                                                        *
*          THIS IS THE ROUTINE THAT IS EXECUTED TO DO                    *
*          THE ADJUSTING ONCE A BUTTON IS CLICKED ON                     *
*          AN ADJUSTMENT.                                                *
*                                                                        *
*          A9 -> ADJUSTMENT STRUCTURE!                                   *
*                                                                        *
**************************************************************************
GEN_ADJ:  
	MOVE    A9,*A13(PDATA),L     ;SAVE THE STRUCTURE POINTER

        MOVE    A9,A8                ;GET TO GENERAL POINTING REGISTER
        JSRP    DO_IN_WHITE          ;GO FROM LF TO WHITE RIGHT AWAY.

;        JSRP    ADJ_DOOR              ;CAN'T DO IT UNLESS DOOR IS OPEN.
        MOVE    A0,A0
        JRNZ    ADJ_CAN              ;CANCELLED
*
        CALLR   CLR_MAIN             ;CLEAR OUT THE MAIN MENU REGION
        CALLR   ADJ_INST             ;PUT INSTRUCTIONS AT BOTTOM.
        JSRP    ST_STICK             ;LOCKOUT STUCK SWITCHES

        SLEEP   2                    ;STOP RACE ON INSTRUCTIONS
ADJ_CHNG: 
	SLEEP   1                    ;NOW LOOP ON STICK...EXIT

        MOVI    31000H,A5                ;TYPOMATIC....BOT HALF SAYS DON'T TIME OUT
*                                         ;TOP HALF IS TICKS PER HIT
        JSRP    GETSTICK                 ;ASK THE STICK HANDLER.......
        MOVE    *A13(PDATA),A8,L         ;GET OUR POINTER
        MOVE    A0,A1                    ;KEEP GETSTICK VALUE
        JRZ     ADJ_CHNG                 ;ITS ZERO....NO MORE WORK NEEDED

        MOVE    *A8(AD_CMOS),A0,W        ;GET ADJ NUMBER
        MOVE    A0,A2                    ;COPY FOR LATER

        CALLR   GET_EADJ                  ;READ IT OUT (FIXING ZERO IF NEC)
        MOVE    A0,A3                     ;SAVE "OLD" VALUE
*
*       A0 = ADJUSTMENT VALUE
*       A1 = GET_STICK VALUE
*       A2 = ADJUSTMENT NUMBER
*       A3 = ADJUSTMENT VALUE READ!
*       A8 = ADJUSTMENT STRUCTURE POINTER
*
        CMPI    3,A1                     ;BUTTON......BACK TO ADJ MENU!
        JRZ     ADJ_BUTT                 ;YEP....WE'RE OUT OF HERE.

        CMPI    2,A1
        JRZ     ADJ_DOWN                 ;ITS DOWN....
*
*       REQUEST TO GO UP....
*
        CALLR   INC_ADJ                   ;INCREMENT IT
        JRUC    ADJ_JOIN

ADJ_DOWN: 
	CALLR   DEC_ADJ                   ;DECREMENT IT
ADJ_JOIN: 
	MOVE    A2,A0                     ;ADJUSTMENT NUMBER
        CALLR   GET_EADJ                  ;READ IT OUT (FIXING ZERO IF NEC)
        CMP     A0,A3                     ;DID IT NOT CHANGE?
        JRZ     ADJ_CHNG                  ;NOPE....NO ACTION!
*
*       IT CHANGED....WE NEED TO BEEP AND RE-PLOT LOWER
*       PORTION TO REFLECT NEW SETTING.
*
        SOUND1  ADJ_BEEP               ;MAKE A BEEP.
        JSRP    DO_IN_WHITE            ;AND UPDATE THE ADJUSTMENT

        JRUC    ADJ_CHNG               ;AND LOOP!

DO_IN_WHITE:
        CALLR   CLR_CUR                ;CLEAR OUT CURRENT SETTING
        MOVI    ROBO_WHITE,A11        ;THEY'RE STARING....NO HEADACHES
        JAUC    AD_CRVAL               ;PRINT THE NEW VALUE

ADJ_BUTT: 
	SOUND1  ADJ_CASH
ADJ_CAN:  
	RETP

**************************************************************************
*                                                                        *
*          DEC_ADJ                                                       *
*                                                                        *
*          THIS IS CALLED TO MOVE TO THE PREVIOUS VALUE.                 *
*          A0 = VALUE READ FROM CMOS                                     *
*          A2 = ADJUSTMENT NUMBER (TO WRITE IT BACK)                     *
*          A8 = ADJUSTMENT STRUCTURE POINTER.                            *
*                                                                        *
*          INC_ADJ IS USED TO STEP TO THE NEXT VALUE                     *
*                                                                        *
**************************************************************************
DEC_ADJ:  
	MMTM    SP,A0,A1,A2,A3
        MOVE    A0,A3                          ;COPY ORIGINAL VALUE
        MOVE    *A8(AD_DELTA),A1,L             ;GET UNITS BETWEEN VALUES
        CALLR   MAKE_BIN_IF_NEC                ;CHANGE RADIX FOR MATH IF NECESSARY
        SUB     A1,A0                          ;REMOVE THIS FROM READ VALUE
        JRUC    FINISH_CHANGE                  ;GO TO COMMON ROUTINE TO WRAP IT UP

INC_ADJ:  
	MMTM    SP,A0,A1,A2,A3
        MOVE    A0,A3                          ;COPY ORIGINAL VALUE
        MOVE    *A8(AD_DELTA),A1,L             ;GET UNITS BETWEEN VALUES
        CALLR   MAKE_BIN_IF_NEC
        ADD      A1,A0                         ;REMOVE THIS FROM READ VALUE

FINISH_CHANGE:
        CALLR   BCD_IF_NEC                     ;BACK TO BCD AFTER THE MATH
        CALLR   PUT_IN_RANGE                   ;ADJUST TO ACCOUNT FOR WRAP AND LIMITS
        MOVE    *A8(AD_ZEQU),A1,L              ;This number becomes zero
        CMP     A0,A1                          ;is this the number?
        JRNZ    FC_NZ                          ;NOPE...STORE IT!
        CLR     A0                             ;USE ZERO IN PLACE OF THIS NUMBER!

FC_NZ:    
	MOVE    A0,A1                          ;WRITING REG
        MOVE    A2,A0                          ;ADJUSTMENT NUMBER
        CALLA   PUT_ADJ                        ;WRITE IT BACK
*
*       SEE IF WE'RE DOING MASTER COINAGE.
*
        CMP     A1,A3                          ;DID THE NUMBER CHANGE?
        JRZ     NOT_COIN                       ;NOPE...DON'T LOAD IT UP!
*
*       AT THIS POINT WE KNOW THAT THE VALUE BEING ADJUSTED CHANGED.
*
        CALLR   DIRTY_IF_NEC                   ;IF ITS A COIN VALUE TAKE NOTE!

        CMPI    ADJPRICE,A0                    ;IS IT?
        JRNZ    NOT_COIN                       ;NOT COIN

        CALLA   LD_CTAB                        ;BATCH WRITE THE VALUES IN!
        CALLA   NO_CREDS                       ;REMOVE CREDITS AND FRACTIONS WHEN
*                                               ;MODE CHANGES

NOT_COIN:
        CALLA   F_ADC_S                        ;MAKE CHECKSUM VALID!
	MMFM    SP,A0,A1,A2,A3
	RETS

**************************************************************************
*                                                                        *
*          DIRTY_IF_NEC                                                  *
*                                                                        *
*          THIS IS CALLED BY ALL ADJUSTMENTS WHEN THEY ACTUALLY          *
*          CHANGE THEIR VALUE.  FOR THE COINAGE ADJUSTMENTS,             *
*          IF ANY OF THE 1ST 6 VALUES ARE TOUCHED WE NEED TO MAKE        *
*                                                                        *
*                          ADJ1ST6 = ZERO.                               *
*                                                                        *
*          IF ANY OF THE 1ST 8 VALUES ARE TOUCHED WE NEED TO MAKE        *
*                                                                        *
*                          ADJVIRGIN = ZERO.                             *
*                                                                        *
*          THE AD_FLAGS FIELD IN THE ADJUSTMENT STRUCTURE HAVE BITS      *
*          INDICATING WHICH (IF ANY) SHOULD BE DIRTYED.                  *
*                                                                        *
**************************************************************************
DIRTY_IF_NEC:
	
        MMTM    SP,A0,A1,A2
        MOVE    *A8(AD_FLAGS),A2,W        ;FETCH THE FLAGS

        BTST    VIRG_BIT,A2               ;DOES CHANGING THIS SAY SET VIRG BIT.
        JRZ     NOT_1ST_8                 ;NOPE

        MOVI    ADJVIRGIN,A0
        CLR     A1
        CALLA   PUT_ADJ

NOT_1ST_8:
        BTST    SIX_BIT,A2                ;1ST 6?
        JRZ     NOT_1ST_6

        MOVI    ADJ1ST6,A0
        CLR     A1
        CALLA   PUT_ADJ
NOT_1ST_6:
        BTST    HSR_BIT,A2                ;HIGH SCORE RESET NUM?
        JRZ     NOT_HSR                   ;NOPE

        CALLA   INIT_HSR                  ;IT WAS CHANGED....STUFF THE VALUE!

NOT_HSR:
	MMFM    SP,A0,A1,A2
	RETS

**************************************************************************
*                                                                        *
*          MAKE_BIN_IF_NEC                                               *
*                                                                        *
*          THIS IS CALLED AFTER THE A0 HAS THE ADJUSTMENT AND            *
*          A1 HAS THE AMOUNT TO ADD OR SUBTRACT.  IF WE'RE               *
*          DOING BCD MATH THEN CONVERT BOTH A0 AND A1.                   *
*                                                                        *
**************************************************************************
MAKE_BIN_IF_NEC:
        MMTM    SP,A2
        MOVE    *A8(AD_FLAGS),A2,W             ;GET THE FLAGS
        BTST    BCD_BIT,A2                     ;BCD?
        JRZ     MBINX                          ;NOPE

        CALLA   BCDBIN                         ;CONVERT A0 TO BINARY
        MOVE    A0,A2                          ;SAVE
        MOVE    A1,A0                          ;NOW A1
        CALLA   BCDBIN
        MOVE    A0,A1
        MOVE    A2,A0                          ;NOW PUT A0 BACK
MBINX:   
	MMFM    SP,A2
	RETS

**************************************************************************
*                                                                        *
*          BCD_IF_NEC                                                    *
*                                                                        *
*          A0 HAS A RESULT OF THE ADJUSTMENT.....IN BINARY.              *
*          CONVERT BACK TO BCD IF THAT'S THE MODE.                       *
*                                                                        *
**************************************************************************
BCD_IF_NEC:
        MMTM    SP,A2
        MOVE    *A8(AD_FLAGS),A2,W             ;GET THE FLAGS
        BTST    BCD_BIT,A2                     ;BCD?
        JRZ     BINX                           ;NOPE

        CALLA   BINBCD                         ;BACK TO BCD

BINX:    
	MMFM    SP,A2
	RETS

ADJ_CASH
	.WORD 	>F7A5-10H,8,>8080,0   		;CASH REGISTER SOUND 
ADJ_LBEEP  
ADJ_BEEP	.WORD 	>F3F7-10H,>20,>80AF,0		;BEEP TONE

**************************************************************************
*                                                                        *
*          CLR_CUR                                                       *
*                                                                        *
*          THIS IS CALLED TO CLEAR OUT THE AREA WHERE THE                *
*          "CURRENT SETTING" IS BEING DISPLAYED.                         *
*                                                                        *
**************************************************************************
CLR_CUR:  
	MMTM    SP,A3,A4
        MOVI    AM_HX,A3             ;THIS IS LEFT MARGIN OF HELP AREA

        MOVI    CUR_LRX,A4           ;RIGHT X
        SUB     A3,A4                ;A4 HAS X DISTANCE

        ADDI    ADJ_ULY*10000H,A3    ;UPPER LEFT Y
        ADDI    (256-ADJ_ULY)*10000H,A4  ;Y GOES TO BOTTOM OF SCREEN
        CALLA   BLNKAREA                 ;ITS BLANK NOW!
	MMFM    SP,A3,A4
	RETS

**************************************************************************
*                                                                        *
*          CLR_MAIN                                                      *
*                                                                        *
*          THIS IS CALLED TO CLEAR OUT THE ADJUSTMENT MENU AND           *
*          THE CYAN INSTRUCTIONS FOR THIS MENU.                          *
*                                                                        *
**************************************************************************
CLR_MAIN: 
	MMTM    SP,A3,A4
        MOVI    TIT_ULX,A3           ;LEFT EDGE
        MOVI    AM_HX,A4         ;UP TO THIS EDGE
        SUB     A3,A4                ;X'S ARE SET.
        ADDI    INST_ULY*10000H,A3   ;TOP Y
        ADDI    (400-INST_ULY)*10000H,A4  ;Y DISTANCE
        CALLA   BLNKAREA
	MMFM    SP,A3,A4
	RETS

**************************************************************************
*                                                                        *
*          ADJ_DOOR                                                       *
*                                                                        *
*          PRINT MESSAGE THAT DOOR MUST BE OPENED TO CONTINUE.           *
*          HOLD CONTROL TILL BUTTON IS PRESSED (CANCELLING)              *
*          OR DOOR IS OPEN.                                              *
*                                                                        *
*          RETURN A0 = 0 MEANS DOOR GOT OPENED.                          *
*                 A0 .NE 0 FOR BUTTON PRESSED.                           *
*                                                                        *
**************************************************************************
;ADJ_DOOR:
;        CALLA   CK_DOOR              ;IS THE DOOR OPEN?  NZ=OPEN
;        JRNZ    DORET                ;YEP.......RETURN A0=0
;
;        CALLA   CLR_MAIN             ;CLEAR THE SCREEN
;        MOVI    CUR_ULY,A10          ;PLOT TO SQUARE UP WITH "CURRENT SETTING"
;        CALLA   ADINBOX             ;PUT A NICE BOX AROUND IT.
;        MOVI    MESS_OPEN_OR_CANCEL,A8
;        JSRP    L_MESS               ;GIVE INSTRUCTIONS
;        JSRP    ST_STICK             ;GET "STARTING STATE"

;WD1:      
;	SLEEP   1                    ;NAP A BIT

;        CALLA   CK_DOOR
;        JRNZ    DORET                ;ITS OPEN...RETURN OK

;        MOVI    40010H,A5            ;TYPOMATIC PARMS
;        JSRP    GETSTICK             ;CHECK BUTTONS
;        CMPI    3,A0                 ;BUTTON?
;        JRNZ    WD1                  ;NOT YET

;        SOUND1  ADJ_LBEEP            ;MAKE A BEEP.
;        MOVI    3,A0                 ;RETURN A0 .NE. 0
*
*       RETURN A0=3                  
*
;        RETP

*       RETURN A0=0  (CONTINUE)
*
;DORET:    
;	CLR     A0
;        RETP


*         
**************************************************************************
*                                                                        *
*          ADJ_INST                                                      *
*                                                                        *
*          THIS IS CALLED TO PUT AN INSTRUCTION BOX OUT                  *
*          WHILE ADJUSTMENT IS TAKING PLACE.                             *
*                                                                        *
**************************************************************************
ADJ_INST: 
        MOVE    *A13(PDATA),A8,L     ;PASS THE ADJUSTMENT POINTER
        MOVI    ADJ_INST_P,A7
        CALLA   P_FORK               ;START IT UP!
        RETS

**************************************************************************
*                                                                        *
*          ADJ_INST_P                                                    *
*                                                                        *
*          THIS IS CALLED TO PUT INSTRUCTIONS FOR ADJUSTMENT             *
*          MODIFICAITION UP AND FLASH THE ARROW (IF ITS NOT              *
*          TOO ANNOYING)                                                 *
*                                                                        *
**************************************************************************

ADJ_INST_P:
        JSRP   ADJUSTING        ;PUT UP "ADJUSTING DIFFICULTY" MESSAGE

        MOVE    A10,A3          ;STASH # OF ARROWS WHERE IT WILL BE SAFE
        CALLR   ADINBOX         ;PUT THE BOX OUT

        MOVI    INST_TO_ADJ,A8
        JSRP    L_MESS          ;PRINT OUT INSTRUCTIONS

        MOVI    ADJ_ARROW,A8
        JSRP    L_MESS

        JAUC    SUCIDE

**************************************************************************
*                                                                        *
*          ADINBOX                                                       *
*                                                                        *
*          THIS PUTS A BOX AROUND THE ADJUSTMENT INSTRUCTIONS.           *
*                                                                        *
**************************************************************************
*
INBOX_HEIGHT     EQU     7BH

ADINBOX:  
	MMTM    SP,A10
        MOVI    CUR_ULY-2,A10          
        SLL     16,A10
        MOVI    TIT_ULX,A4           ;UPPER RIGHT X
        MOVY    A10,A4               ;UPPER RIGHT

        MOVI    AM_RX,A5
        MOVY    A10,A5               ;START WITH BASE Y
        ADDI    INBOX_HEIGHT*10000H,A5

        CALLR   WH_BORD
	MMFM    SP,A10
	RETS

**************************************************************************
*                                                                        *
*          ADJUSTING                                                     *
*                                                                        *
*          THIS IS CALLED WHEN WE ENTER THE "ADJUSTING" PHASE            *
*          IT PUTS A BOX IN THE LEFT AREA TO SAY WHAT WE ARE ADJUSTING.  *
*                                                                        *
**************************************************************************
ADJUSTING:
        MOVE    A8,A2                ;PUT ADJUSTMENT BLOCK PTR WHERE ITS SAFE
        MOVI    (CUR_ULY-31H)*10000H,A4        ;FOR DO_BORDER
        ADDI    TIT_ULX,A4                     ;A4 IS REASONABLY EASY

        MOVI    ((CUR_ULY-2)+MB_YWID)*10000H,A5    ;OVERLAP THE ONE BELOW IT
        ADDI    AM_RX,A5                       ;THIS IS RIGHT EDGE

        CALLR   WH_BORD                        ;DO A WHITE BORDER

        MOVI    MES_ADNAME,A8                  ;PUT THE ADJUSTMENT NAME UP
        CALLA   LM_SETUP
        MOVE    *A2(AD_MAIN),A8,L              ;GET THE MAIN MENU MESSAGE
        JSRP    LM_FINIS

        MOVI    MES_ADJUSTING,A8
        JSRP    L_MESS
        RETP

**************************************************************************
*                                                                        *
*          PARAM_VAL                                                     *
*                                                                        *
*          This is called to summarize the values of the                 *
*          important adjustments on the parameter page.                  *
*                                                                        *
**************************************************************************
*
*        WE WILL PRING OUT 3 LINES IN A BOX.
*
*        1) Pricing:
*        2) Free Play:   yes/no
*        3) Maximum Credits:
*

PDY      EQU     HELP_DY+(HELP_DY/2)
PMARG    EQU     6

PARAM_VAL:
        MOVI    8,A1                      ;Setup a box for our 3 lines
        CALLR   ADJ_BOX                   ;(a10 is set as y for the 3 lines)

        ADDI    6,A10                     ;PUSH TO CENTER 5 LINES IN BOX

        CALLR   GET_COIN_TITLE            ;COIN MODE
        MOVI    MESS_GP,A8
        JSRP    SMALL_LEFT_RIGHT          ;PRINT THE LINES

        ADDI    PDY,A10               ;PUSH TO NEXT LINE

        MOVI    M_NO,A2                   ;ASSUME "NO"
        MOVI    ADJFREPL,A0
        CALLA   GET_ADJ                   ;GET THE FREE PLAY ADJUSTMENT
        JRZ     NOT_FREE
        MOVI    M_YES,A2

NOT_FREE: 
	MOVI    MESS_FP,A8
        JSRP    SMALL_LEFT_RIGHT          ;PRINT THE LINES

        ADDI    PDY,A10               ;PUSH TO NEXT LINE
         
        MOVI    ADJMAXC,A0
        MOVI    MESS_MAX,A8
        JSRP    ADJ_LEFT_RIGHT       ;A0 = ADJUST  A8 = MESSAGE
*
*       CREDITS TO START AND CONTINUE NEEDS TO HANDLE PLURAL ETC.
*
        ADDI    PDY,A10               ;PUSH TO NEXT LINE
        MOVI    ADJCSTRT,A0          ;GET CREDITS REQUIRED TO START   
        MOVI    M_CTS_PL,A8                                           
        JSRP    ADJ_LEFT_RIGHT       ;A0 = ADJUST  A8 = MESSAGE
*                                                                      
*       NOW THE CREDITS TO CONTINUE                                   
*                                                                      
        ADDI    PDY,A10               ;PUSH TO NEXT LINE
        MOVI    ADJCCONT,A0          ;GET CREDITS REQUIRED TO CONTINU 
        MOVI    M_CTC_PL,A8                                           
        JSRP    ADJ_LEFT_RIGHT       ;A0 = ADJUST  A8 = MESSAGE

        RETP

**************************************************************************
*                                                                        *
*          ADJ_LEFT_RIGHT                                                *
*                                                                        *
*          A8 HAS MESSAGE                                                *
*          A0 HAS ADJUSTMENT                                             *
*          A10 HAS HEIGHT.                                               *
*                                                                        *
*          LEFT JUSTIFY A8 MESSAGE                                       *
*          RIGHT JUSTIFY A0 ADJUSTMENT (AFTER READING IT)                *
*                                                                        *
**************************************************************************
ADJ_LEFT_RIGHT:
        MOVE    A8,A3                ;STASH MESSAGE

        CALLA   GET_ADJ
        MOVE    A0,A8
        CALLA   HEXTOASC             ;A8 POINTS TO NUMBER STRING

        MOVE    A8,A2
        MOVE    A3,A8                ;GET MESSAGE IN A8

        JRUC    SMALL_LEFT_RIGHT

**************************************************************************
*                                                                        *
*          SMALL_LEFT_RIGHT                                              *
*                                                                        *
*          THIS IS CALLED TO PRINT A LEFT AND RIGHT JUSTIFIED            *
*          PAIR OF STRINGS IN THE "CURRENT SETTING BOX"                  *
*                                                                        *
*          A2 = RIGHT JUSTIFIED STRING                                   *
*          A8 = LEFT JUSTIFIED STRING TO PRINT                           *
*          A10 = Y VALUE                                                 *
*                                                                        *
**************************************************************************
SMALL_LEFT_RIGHT:
        MMTM    A12,A11,A6,A10,A9,A3

        MOVI    ROBO_WHITE,A6       ;SOLID WHITE FOR THESE MULTI-LINERS
        MOVI    RD7FONT,A11          ;USE BABY FONT

        MOVI    AM_HX+PMARG,A9    ;LEFT X IS INSIDE LEFT LINE

        MOVE    A10,A3                  ;SAVE Y IN A3
        SLL     16,A3
        MOVY    A3,A9                ;POINTER SET!

        MOVI    SPACING07,A10

        CLR     A0

        JSRP    STRLNRM              ;DO IT!

        MOVE    A2,A8                ;GET RIGHT JUSTIFIED STRING
        MOVI    TIT_LRX-PMARG,A9  ;INSIDE RIGHT MARGIN
        MOVY    A3,A9                ;AT OUR Y
        JSRP    STRRNRM              ;PRINT IT!

	MMFM    A12,A11,A6,A10,A9,A3
	RETP

**************************************************************************
*                                                                        *
*          COIN_SET                                                      *
*                                                                        *
*          THIS IS THE ROUTINE THAT IS CALLED TO DISPLAY THE CURRENT     *
*          COINAGE SETTINGS.                                             *
*                                                                        *
*          A8 HAS POINTER TO ADJUSTMENT BLOCK                            *
*          A11 HAS THE COLOR TO USE                                      *
*                                                                        *
**************************************************************************
COIN_SET:
        CALLR   TAMPEREDP            ;HAS THE 1ST 6 COIN VALUE BEEN TAMPERED WITH?
        JRZ     SBO                  ;YEP....SMALL BOX ONLY!

        MOVI    8,A1                      ;BIG BOX FOR OUTSIDE
        CALLR   ADJ_BOX
SBO:     
	MOVI    1,A1                      ;DRAW A BOX TO HOLD 1 LINE
        CALLR   ADJ_BOX                   ;DRAW THE BOX....PASS BACK 1ST PLOT LINE
*
*       THE ABOVE 2 CALLS SHOULD CREATE A BOX LIKE:
*
*                    ษอออออออออออออออออออป
*                    บ     U.S.A. 1      บ
*                    บอออออออออออออออออออน
*                    บ 1 COIN / 1 CREDIT บ
*                    บ                   บ
*                    บ                   บ
*                    บ 25c   $1.00   25c บ
*                    ศอออออออออออออออออออผ
*
*                A10 HAS THE PLACE TO PLOT THE TITLE LINE.
*
        MOVE    A10,A4               ;KEEP THE Y HANDY.
*
        CALLR   GET_COIN_TITLE       ;GET TITLE FOR BIG BOX IN A2.
*
*       A2 HAS STRING
*       A11 IS COLOR
*       A10 IS Y TO PRINT
*
COIN_TIT:
        JSRP    DO_BIG_LINE               ;PRINT THIS LINE!

        MOVI    ROBO_WHITE,A11      ;DON'T GLOW INSIDE BOX IF THAT'S THE MODE

        CALLR   TAMPEREDP            ;HAS THE 1ST 6 COIN VALUE BEEN TAMPERED WITH?
        JRZ     NO_INFO              ;YEP....JUST GIVE THE STARTS AND CONTINUES

        CALLA   GET_CSPT             ;A6 POINTS AT THE CSELECT BLOCK
        MOVE    *A6(CS_LIST),A2,L    ;FETCH POINTER TO MESSAGE LIST
        JRZ     NO_HEADERS           ;NO LIST!

        MOVI    COIN_HEAD_Y,A10      ;AT THIS HEIGHT

NEXT_HEADER:
        MOVE    *A2+,A8,L            
        JRZ     NO_HEADERS           ;HEADERS ARE OUT...CONTINUE

        JSRP    PRINT_SMALL_LINE     ;PRINT THE LINE
        ADDI    12,A10               ;PUSH TO NEXT LINE
        JRUC    NEXT_HEADER

NO_HEADERS:
        MOVI    MESS_CTS,A10         ;SET Y FOR COIN SLOT LINE.
        MOVI    M_SLOTVAL,A8
        JSRP    PRINT_SMALL_LINE     ;HEADER FOR COIN SLOT VALUE

        ADDI    12,A10               ;PUSH Y UP FOR A GAP             *

        CALLA   GET_CSPT             ;A6 POINTS AT THE CSELECT BLOCK
        MOVE    *A6(CS_SLOTS),A8,L   ;PRINT COIN SLOT INFO
        JSRP    PRINT_SMALL_LINE      ;PRINT THE LINE

NO_INFO:
        RETP                         ;DONE FOR NOW

**************************************************************************
*                                                                        *
*          GET_COIN_TITLE                                                *
*                                                                        *
*          THIS IS CALLED TO FETCH THE CHARACTER STRING MESSAGE          *
*          FOR THE CURRENT COIN MODE.  IF ITS STANDARD, THEN             *
*          IT IS FETCHED BASED ON THE COIN SELECT TABLE.                 *
*                                                                        *
*          IF THE 1ST 6 PARAMETERS HAVE BEEN MODIFIED, THEN              *
*          IT RETURNS THE STRING "NON-STANDARD".                         *
*                                                                        *
**************************************************************************
GET_COIN_TITLE:
        MMTM    SP,A6                ;PRESERVE FOR COIN SELECT TABLE

        CALLA   GET_CSPT             ;A6 POINTS AT THE CSELECT BLOCK

        MOVI    MESS_TAMPERED,A2

        MOVI    ADJ1ST6,A0           ;NON-STANADARD TITLE IF 1ST 6 MODIFIED
        CALLA   GET_ADJ              ;WELL?
        JRZ     GCTX                 ;PUT OUT THE TITLE LINE AS TAMPERED!

        MOVE    *A6(CS_TITLE),A2,L   ;GET THE CSELECT TITLE FOR ITS VALUES

GCTX:	
	MMFM    SP,A6                ;PRESERVE FOR COIN SELECT TABLE
	RETS

**************************************************************************
*                                                                        *
*          TAMPEREDP                                                     *
*                                                                        *
*          HAVE THE COIN PARAMETERS BEEN TAMPERED WITH.                  *
*          THIS IS NON-ZERO IF ANY OF THE 1ST 6 COIN                     *
*          PARAMETERS HAVE BEEN ADJUSTED.                                *
*                                                                        *
**************************************************************************
TAMPEREDP:
        MMTM    SP,A0
        MOVI    ADJ1ST6,A0           ;JUST CHECK THE 1ST 6
        CALLA   GET_ADJ              ;HAS IT BEEN TAMPERED WITH (0 MEANS YES)
	MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          PRINT_SMALL_LINE                                              *
*                                                                        *
*          THIS IS CALLED TO PRINT A LINE IN THE "CURRENT SETTING"       *
*          BOX FOR THE COINAGE.                                          *
*                                                                        *
*          A8 = STRING TO PRINT                                          *
*          A11 = COLOR                                                   *
*          A10 = Y VALUE                                                 *
*                                                                        *
*          PRINT IN THE 7 POINT FONT WITH X CENTERED FOR THE             *
*          HELP SYSTEM.                                                  *
*                                                                        *
**************************************************************************
PRINT_SMALL_LINE:
        MMTM    A12,A11,A6,A10,A9

        MOVE    A11,A6               ;COLOR SET
        MOVI    RD7FONT,A11          ;USE BABY FONT

        MOVI    AM_HX,A9,W           ;GET LEFT X
        CALLR   LEFT_TO_CENTER       ;CONVERT IT

        MOVE    A10,A0
        SLL     16,A0
        MOVY    A0,A9                ;POINTER SET!

        MOVI    SPACING07,A10

        CLR     A0

        JSRP    STRCNRM              ;DO IT!

	MMFM    A12,A11,A6,A10,A9
        RETP

*
*        DO_ADJH
*
*        THIS IS CALLED TO PLOT THE RIGHT HALF OF THE SCREEN
*        FOR EACH ADJUSTMENT AS THE USER SELECTS THEM ON
*        THE ADJUSTMENT MENU.
*
*        THE FORMAT IS AS FOLLOWS:
*
*    ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
*    บ                  A D J U S T M E N T    M E N U                   บ
*    บ                       ROBO  REVISION  1.4                         บ
*    ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*    ษอออออออออออออออออออออออออออออป  ษออออออออออออออออออออออออออออออออออป
*    บ   SELECT BLAH BLAH BLAH     บ  บ          GAME DIFFICULTY         บ
*    ศอออออออออออออออออออออออออออออผ  ศออออออออออออออออออออออออออออออออออผ
*    ษอออออออออออออออออออออออออออออป  ษออออออออออออออออออออออออออออออออออป
*    บ                             บ  บ  THIS CONTROLS THE OVERALL       บ
*    บ        GAME  PRICING        บ  บ  DIFFICULTY OF GAME PLAY.        บ
*    บ=======GAME DIFFICULTY=======บ  บ                                  บ
*    บ       LIVES PER PLAY        บ  บ  RANGE OF SETTINGS:  1-9         บ
*    บ     POWER-UPS PER PLAY      บ  บ                                  บ
*    บ       EXTRA MAN EVERY       บ  บ  EASIEST SETTING: 1              บ
*    บ       LAST EXTRA MAN        บ  บ  HARDEST SETTING: 9              บ
*    บ     ATTRACT-MODE SOUND      บ  บ  FACTORY SETTING: 3              บ
*    บ    AUTO HIGH SCORE RESET    บ  ศออออออออออออออออออออออออออออออออออผ
*    บ       VIOLENCE LEVEL        บ  
*    บ    RETURN TO MAIN MENU      บ
*    บ                             บ  
*    บ                             บ  ษออออออออออออออออออออออออออออออออออป
*    บ                             บ  บ                                  บ
*    บ                             บ  บ          9 - EXTRA HARD          บ
*    บ                             บ  บ                                  บ
*    ศอออออออออออออออออออออออออออออผ  ศออออออออออออออออออออออออออออออออออผ
*
*
*       ON ENTRY....A1 POINTS AT THE 3 WORDS FOR CURRENT
*       MENU ENTRY.
*
DO_ADJH:
*
*       FIRST WE BLANK OUT THE AREA...WE NEED TO DO THIS FROM
*       THE MENU PROCESS SINCE THE RIGHT EDGE IS DETERMINED BY
*       MENU PDATA STUFF.  IT WILL RETURN IN A9 THE MARGIN WE 
*       SHOULD WORK FROM.
*
        CALLA   BLNKHELP             ;BLANK OUT THE AREA WE'RE PLOTTING!
        MOVE    A1,A8                ;PASS THE STRUCTURE POINTER TO NEW PROCESS!
        MOVI    AD_SLAVE,A7
        CALLA   P_FORK               ;THIS CREATES IT!
        RETS                         ;NOW RETURN TO MENU HANDLER!

**************************************************************************
*                                                                        *
*          AD_SLAVE                                                      *
*                                                                        *
*          THIS IS FORKED TO PLOT THE RIGHT SIDE...IT HAS                *
*          ITS OWN PDATA AREA FOR INFO STORAGE.                          *
*                                                                        *
*          A8 = POINTER TO THE MENU SELECTION 3 LONG-WORD ENTRY          *
*          A9 = LEFT X MARGIN FOR OUR WORK.                              *
*                                                                        *
**************************************************************************
ADS_STRUCT       EQU     PDATA                  ;LONG-POINTER TO ADJUSTMENT STRUCTURE
ADS_LX           EQU     ADS_STRUCT+LONG_SIZE   ;WORD-LEFT X TO WORK FROM
ADS_CX           EQU     ADS_LX+WORD_SIZE       ;WORD-CENTER X FOR WORK

AD_SLAVE:
        MOVE    *A8(MENU_ROUTINE),A11,L   ;NOW WE HAVE OUR SPECIAL STRUCTURE!
        MOVE    A11,*A13(ADS_STRUCT),L    ;STASH IT...WE'LL NEED IT
        MOVE    A9,*A13(ADS_LX),W         ;ALSO THE X.....

        MOVE    A9,A4                     ;COPY LEFT FOR BORDER ROUT
        CALLR   LEFT_TO_CENTER

        MOVE    A9,*A13(ADS_CX),W         ;STASH THE CENTER
*
*         A4 = UPPER LEFT Y,X                                           
*         A5 = LOWER RIGHT Y,X                                        
*         A0 = Y,X WIDTH OF BORDER                                     
*         A9 = COLOR OF BORDER.                                         
*
        ADDI    INST_ULY*10000H,A4           ;ADD IN THE Y
        MOVI    (INST_LRY*10000H)+TIT_LRX,A5 ;THIS IS OTHER EDGE. 
        MOVI    ROBO_PURPLE,A9
        CALLA   STD_BORD                       ;ADJUSTMENT BORDER IS UP.
*
        MOVI    ADJT_SETUP,A8
        CALLA   LM_SETUP                       ;SETUP TO PRINT TITLE

        MOVE    *A13(ADS_CX),A2,W              ;GET THE X
        MOVX    A2,A9                          ;SUBSTITUTE OUR X IN.

        MOVE    *A13(ADS_STRUCT),A2,L          ;GET STRUCTURE POINTER
        MOVE    *A2(AD_TITLE),A8,L             ;GET MESSAGE POINTER

        JSRP    LM_FINIS                       ;BOX AND TITLE ARE UP.

        MOVE    *A2(AD_HELP),A8,L              ;HELP STRUCTURE
        MOVE    *A13(ADS_LX),A9,W              ;LEFT X FOR HELP BOX
        MOVI    INST_LRY+BOX_YGAP,A10          ;THIS IS HELP BOX POSITION
        ADDI    10000H,A10                     ;FLAG THAT THIS IS TOP..NOT CENTER!

        MOVI    H_SLAVE,A7           ;FORK OFF SO IT CAN USE PDATA!
        CALLA   P_FORK               ;START UP ANOTHER W/ SAME ID 
*
*       NOW WE NEED TO SHOW THE CURRENT SETTING ON THE LOWER HALF OF
*       THE SCREEN.
*
        MOVE    *A13(ADS_STRUCT),A8,L   ;GET THE ADJUSTMENT STRUCTURE
        MOVI    ROBO_LF,A11           ;INDICATE STANDARD COLOR.
        JSRP    AD_CRVAL                ;PRINT SCREEN SHOWING THE CURRENT VALUE

        JAUC    SUCIDE               ;OUR JOB IS DONE!...EXIT

**************************************************************************
*                                                                        *
*          LEFT_TO_CENTER                                                *
*                                                                        *
*          THIS IS CALLED TO FIND THE CENTER POINT FOR A BOX BASED ON    *
*          THE LEFT PASSED IN A9.  CENTER X RETURNED IN A9.              *
*                                                                        *
**************************************************************************
LEFT_TO_CENTER:
        ADDI    TIT_LRX,A9                ;FIND BOX CENTER
        SRL     1,A9                      ;NOW WE HAVE THE CENTER
        ADDI    C_KLUDGE,A9               ;MAKE IT CENTER CORRECTLY
        RETS

**************************************************************************
*                                                                        *
*          AD_CRVAL                                                      *
*                                                                        *
*          THIS IS CALLED TO PRINT THE CURRENT VALUE FOR ANY             *
*          ADJUSTMENT.  THE VALUE SHOULD BE PRINTED AND BOXED            *
*          IN THE LOWER RIGHT REGION UNDER THE "CURRENT SETTING"         *
*          HEADER.                                                       *
*                                                                        *
*          A8 -> ADJUSTMENT STRUCTURE                                    *
*          A11  -> COLOR TO USE                                          *
*          ADJ_LEFX (GLOBAL RAM) CONTAINS LEFT MARGIN FOR THIS.          *
*                                                                        *
**************************************************************************

AD_CRVAL: 
	MOVE    *A8(AD_NAMEIT),A0,L       ;FETCH THE "NAME-IT" ROUTINE
        JUMP    A0                        ;AND "JSRP" THAT ROUTINE

**************************************************************************
*                                                                        *
*          HEX_OR_MESS                                                   *
*                                                                        *
*          THIS IS CALLED FOR THE EXTRA MAN EVERY...AND                  *
*          "LAST EXTRA MAN" ADJUSTMENTS.  IT PRINTS OUT                  *
*          THE HEX ADJUSTMENT WITH COMMAS, OR PRINTS                     *
*          THE MESSAGE STORED AT A8(AD_NAMPTR) ON ITS LOWEST VALUE.      *
*                                                                        *
*          ****** NOTE THAT "BIN_OR_MESS" (BELOW) USES PARTS OF THIS!    *
*                                                                        *
**************************************************************************
HEX_OR_MESS:
	MMTM    SP,A8                     ;PRESERVE A8 PLEASE

        CALLR   ADJ_STUFF                 ;GET THE REGGIES FIXED UP.
*
*       NOW A0 HAS THE ADJUSTMENT....FORM THE C-STRING
*
        MOVE    *A8(AD_MIN),A1,L          ;GET MINIMUM VALUE
        CMP     A0,A1                     ;ARE WE AT MINIMUM?
        JRNZ    NOT_MIN                   ;NOPE

AT_MIN:   
	MOVE    *A8(AD_NAMPTR),A8,L       ;GET THE MESSAGE POINTER
        JRUC    PRT_MIN

NOT_MIN:  
	MOVE    A0,A8
        MOVK    1,A3                      ;INDICATE COMMAS ARE DESIRED
        CALLA   HTOHXASC                  ;CONVERT A8 TO THIS NUMBER

PRT_MIN:  
	MOVE    A8,A2
	MMFM    SP,A8                     ;PRESERVE A8 PLEASE

        JSRP    DO_BIG_LINE               ;NOW PRINT IT OUT
        RETP                              ;AND RETURN

**************************************************************************
*                                                                        *
*          BIN_OR_MESS                                                   *
*                                                                        *
*          THIS IS CALLED TO PRINT A BINARY NUMBER OR                    *
*          A MESSAGE AT A8(AD_NAMPTR) IF IT IS AT MINIMUM.               *
*                                                                        *
**************************************************************************
BIN_OR_MESS:
        MMTM    SP,A8                     ;PRESERVE A8 PLEASE

        CALLR   ADJ_STUFF                 ;GET THE REGGIES FIXED UP.
*
*       NOW A0 HAS THE ADJUSTMENT....FORM THE C-STRING
*
        MOVE    *A8(AD_MIN),A1,L          ;GET MINIMUM VALUE
        CMP     A0,A1                     ;ARE WE AT MINIMUM?
        JRZ     AT_MIN                    ;YEP.....PRINT "OFF"

        CALLA   BINBCD                    ;TURN TO BCD PLEASE
        JRUC    NOT_MIN                   ;AND NOW PRINT WITH COMMAS.

**************************************************************************
*                                                                        *
*          JUST_BIN                                                      *
*                                                                        *
*          THIS IS CALLED TO PRINT OUT THE ADJUSTMENT                    *
*          (STORED IN BINARAY) IN DECIMAL.                               *
*                                                                        *
**************************************************************************
JUST_BIN:
        MMTM    SP,A8                     ;PRESERVE A8 PLEASE

        CALLR   ADJ_STUFF                 ;GET THE REGGIES FIXED UP.
*
*       NOW A0 HAS THE ADJUSTMENT....FORM THE C-STRING
*
        CALLA   BINBCD                    ;TURN IT TO BCD!
        JRUC    NOT_MIN

**************************************************************************
*                                                                        *
*          LIST_1LINE                                                    *
*                                                                        *
*          THIS IS CALLED TO DO A 1 LINE LISTING OF MESSAGES             *
*          ASSOCAITED WITH THE CURRENT ADJUSTMENT.                       *
*          A8 = STRUCTURE                                                *
*          A11 = COLOR OF TEXT INSIDE BOX.                               *
*                                                                        *
**************************************************************************
LIST_1LINE:
        CALLR   ADJ_STUFF                 ;GET THE REGGIES FIXED UP.

        MOVE    *A8(AD_MAX),A1,L          ;IS IT TOO HIGH?
        CMP     A1,A0                     ;COMPARE TO ADJUSTMENT
        JRLS    L1L1                      ;IN RANGE.....
*
*       ADJUSTMENT IS TOO HIGH...DON'T GO THROUGH TABLE!
*
        MOVI    M_NULL,A2                 ;USE NULL POINTER
        JRUC    L1L2

L1L1:     
	MOVE    *A8(AD_MIN),A1,L          ;GET THE LOWEST VALUE
        SUB     A1,A0                     ;THIS IS OFFSET
        MOVI    LONG_SIZE,A1              ;THIS MANY LONG WORDS
        MPYU    A0,A1                     ;THIS IS OFFSET INTO TABLE
        MOVE    *A8(AD_NAMPTR),A0,L       ;THIS IS TABLE BASE
        ADD     A1,A0                     ;A0 HAS THE TEXT OF THE SINGLE LINE
        MOVE    *A0,A2,L                  ;GET THE VECTOR
*
*       TEXT POINTER IN A2
*       COLOR IN A11
*       Y IN A10
*
L1L2:     
	JSRP    DO_BIG_LINE               ;PRINT OUT THIS LINE
        RETP                              ;NOW RETURN

**************************************************************************
*                                                                        *
*          ADJ_STUFF                                                     *
*                                                                        *
*          THIS IS CALLED BY THE ROUTINES THAT DISPLAY                   *
*          ADJUSTMENTS.  IT PLOTS THE BOX AND RETURNS:                   *
*                                                                        *
*                  A10 = HEIGHT FOR 15 POINT SINGLE TEXT LINE            *
*                  A0 =  ADJUSTMENT WITH ZERO SUBSTITUTION COMPLETED.    *
*                                                                        *
**************************************************************************
ADJ_STUFF:
        MOVI    1,A1                      ;INDICATE 2 PUNY LINES (FOR OUR BIG ONE)
        CALLR   ADJ_BOX                   ;DRAW THE BOX....PASS BACK 1ST PLOT LINE
*
*       A10 HAS Y HEIGHT OF 1ST ENTRY.
*
        MOVE    *A8(AD_CMOS),A0,W         ;GET ADJUSTMENT NUMBER
        CALLR   GET_EADJ                  ;FETCH THE CURRENT VALUE.

        CALLR   PUT_IN_RANGE              ;IF ITS OUT OF RANGE, FIX IT!
        RETS

**************************************************************************
*                                                                        *
*          DO_BIG_LINE                                                   *
*                                                                        *
*          THIS IS CALLED TO DO A SINGLE LINE FOR AN ADJUSTMENT          *
*          "CURRENT ADJUSTMENT" BOX.                                     *
*                                                                        *
*          A2 = POINTER TO TEXT                                          *
*          A10 = Y COORDINATE                                            *
*          A11 = COLOR                                                   *
*                                                                        *
*          X LEFT COORDINATE IS IN GLOBAL "ADJ_LEFX"                     *
*                                                                        *
**************************************************************************
DO_BIG_LINE:
        MMTM    A12,A10,A11,A8       ;SAVE STUFF FOR CALLER
        MOVE    A11,A6
        MOVI    AM_HX,A9,W           ;GET LEFT X
        CALLR   LEFT_TO_CENTER       ;CONVERT IT
        SLL     16,A10               ;SHIFT Y DOWN
        MOVY    A10,A9               ;X,Y SET
        MOVE    A2,A8                ;TEXT POINTER
        CLR     A0                   ;NO SLEEP
        MOVI    SPACING20,A10
        MOVI    RD7FONT,A11
        JSRP    STRCNRM              ;DO IT!
	MMFM    A12,A10,A11,A8       ;POP THE STUFF.
	RETP

**************************************************************************
*                                                                        *
*          GET_EADJ                                                      *
*                                                                        *
*          THIS IS LIKE GET_ADJ, HOWEVER IF ZERO COMES OUT,              *
*          WE CHECK TO SEE IF THERE IS A LOGICAL NUMBER TO               *
*          PASS OUT IN PLACE OF THE ZERO.                                *
*                                                                        *
*          A8 POINTS AT THE ADJUSTMENT STRUCTURE.                        *
*                                                                        *
**************************************************************************
GET_EADJ:
        MMTM    SP,A1
        CALLA   GET_ADJ              ;FETCH THE ADJUSTMENT
        JRNZ    GET_EA1              ;ITS NOT ZERO....RETURN
*
*       ITS ZERO....SEE IF THERE'S A VALUE TO SUB
*
        MOVE    *A8(AD_ZEQU),A1,L    ;IS THERE A SUB VALUE?
        JRZ     GET_EA1              ;NOPE...RETURN THE ZERO (AND FLAG)

        MOVE    A1,A0                ;RETURN THE SUBSTITUTE VALUE
GET_EA1:	
	MMFM    SP,A1
	RETS

**************************************************************************
*                                                                        *
*          PUT_IN_RANGE                                                  *
*                                                                        *
*          THIS IS CALLED TO TAKE AN ADJUSTMENT AND MAKE SURE            *
*          IT HAS A VALID VALUE.  IF ITS BETWEEN THE MIN AND MAX         *
*          (INCLUSIVE) ALLOWED, THEN WE RETURN WITH NO ACTION.           *
*                                                                        *
*          IF ITS OUTSIDE, THEN WE SET IT ACCORDING TO THE               *
*          "WRAP_AROUND" PARAMETER.                                      *
*                                                                        *
*          A0 HAS ADJUSTMENT VALUE                                       *
*          A8 POINTS AT ADJUSTMENT STRUCTURE.                            *
*                                                                        *
*          RETURN NEW VALUE IN A0.                                       *
*                                                                        *
**************************************************************************
PUT_IN_RANGE:
        MMTM    SP,A1,A2,A3
        MOVE    *A8(AD_MIN),A1,L          ;GET MINIMUM
        MOVE    *A8(AD_MAX),A2,L          ;GET MAXIMUM
        MOVE    *A8(AD_FLAGS),A3,W        ;ARE WE WRAPPING AROUND
        BTST    WRAP_BIT,A3               ;WELL?
        JRNZ    CK_WRAP                   ;YEP....USE A FANCY HANDLER.

        CMP     A1,A0                     ;ARE WE TOO LOW?
        JRHS    NOT_LO
*
*       ITS TOO LOW.....USE MINIMUM
*
USE_LO:   
	MOVE    A1,A0

*
*       WE'RE NOT WRAPPING AROUNG....IF ITS MEGA-HIGH....KEEP IT
*       AT THE LOW BOUNDARY.
*
NOT_LO:   
	CMPI    090000000H,A0            
        JRHI    USE_LO                    ;USE THE LOW VALUE!

        CMP     A2,A0
        JRLS    PIRX

USE_HI:   
	MOVE    A2,A0
        JRUC    PIRX
*
*       WE NEED TO WRAP FROM LOWEST TO HIGHEST
*
CK_WRAP: 
        CMPI    090000000H,A0             ;IN THIS RANGE, WE MUST HAVE WRAPPED DOWN
        JRHI    USE_HI                    ;SO USE HIGH VALUE

        CMP     A1,A0                     ;IS IT LOWER THAN LO?
        JRLO    USE_HI                    ;IT IS ....USE THE HIGH ONE.

        CMP     A2,A0                     ;IS IT TOO HIGH?
        JRHI    USE_LO                    ;IT IS....USE THE LOW ONE.

PIRX:  	
	MMFM    SP,A1,A2,A3
	RETS

**************************************************************************
*                                                                        *
*          ADJ_BOX                                                       *
*                                                                        *
*          A1 HAS NUMBER OF LINES FOR ADJUSTMENT                         *
*          RETURN A10 AT Y IF 1ST LINE OF BOX.                           *
*                                                                        *
**************************************************************************
ADJ_BOX:  
	MMTM    SP,A4,A5,A0,A9
*
        MOVI    HELP_DY,A5                ;DISTANCE PER ENTRY
        MPYU    A1,A5                     ;DISTANCE FOR ALL ENTRIES
        ADDI    HELP_Y_MARGIN+(MB_YWID*2)+HELP_YLO_MARGIN,A5
*
*       A5 NOW CONTAINS FULL HEIGHT OF BOX
*
        MOVI    ADJ_ULY,A10               ;THIS IS TOP OF BOX
*
*       NOW FORM UPPER LEFT IN A4
*
        MOVE    A10,A4                    ;MOVE Y OVER
        SLL     16,A4                     ;MAKE ROOM FOR X
        ADDI    AM_HX,A4                     ;PUT IN THE X...THIS IS UPPER LEFT!

        ADD     A10,A5                    ;ADD BASE TO OFFSET
        SLL     16,A5                     ;PUT IN Y POSITION
        ADDI    TIT_LRX,A5                ;ADD IN THE X FOR THE CORNER
*
*       NOW ADJUST FROM TOP OF BOX TO POSITION OF 
*       1ST ENTRY.
*
        ADDI    MB_YWID+HELP_Y_MARGIN,A10  ;Y OF 1ST ENTRY
*
*       A10 IS NOW SET FOR RETURN VALUE
*
        MOVI    ROBO_YELLOW,A9            ;MAKE THESE BOXES YELLOW

        CALLA   STD_BORD       
	MMFM    SP,A4,A5,A0,A9
	RETS

WH_BORD:  
	MMTM    SP,A9
        MOVI    ROBO_WHITE,A9
        CALLA   STD_BORD
	MMFM    SP,A9
	RETS
;
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
**** DATA SECTION BEGINS ****

	.DATA
*
*        GAME ADJUSTMENT
*
*        THE FOLLOWING STRUCTURES ARE FOR EACH ADJUSTMENT
*
*        AD_ROUT  EQU     0                         ;LONG...ROUTINE TO RUN WHEN SELECTED.
*        AD_TITLE EQU     AD_ROUT+LONG_SIZE         ;LONG...POINTER TO TITLE FOR RIGHT COLUMN
*        AD_HELP  EQU     AD_TITLE+LONG_SIZE        ;LONG...POINT TO HELP STRUCT FOR EXPLANATION
*        AD_CMOS  EQU     AD_HELP+LONG_SIZE         ;WORD...GET_ADJ / PUT_ADJ NUMBER.
*        AD_MIN   EQU     AD_CMOS+WORD_SIZE         ;LONG...MINIMUM VALUE FOR ADJ.
*        AD_MAX   EQU     AD_MIN+LONG_SIZE          ;LONG...MAXIMUM VALUE FOR ADJ.
*        AD_DELTA EQU     AD_MAX+LONG_SIZE          ;LONG...UNITS BETWEEN VALUES.
*        AD_ZEQU  EQU     AD_DELTA+LONG_SIZE        ;LONG...NUMBER TO STORE IN MEMORY AS ZERO
*        AD_NAMEIT EQU    AD_HYPER+LONG_SIZE        ;LONG...ROUTINE TO PRINT VALUES.
*        AD_WRAP  EQU     AD_NAMEIT+LONG_SIZE       ;WORD...NON ZERO TO WRAP FROM HIGHEST TO LOWEST 
*        AD_NAMPTR EQU    AD_WRAP+WORD_SIZE         ;LONG...POINTER TO DATA FOR NAMEIT ROUTINE
*
DO_PRICE:
        .LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   MESS_PRICE           ;POINTER TO HEADER MESSAGE
        .LONG   HELP_PRICE           ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJPRICE             ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   1                    ;MINIMUM VALUE
        .LONG   CS_ENTS              ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   COIN_SET             ;MESSAGE LIST USED FOR VALUES.
        .WORD   WRAP_VAL             ;WRAP AROUND ON COIN MODES
        .LONG   0                    ;LIST OF MESSAGES FOR THIS ADJ.
        .LONG   MESS_PRICE           ;POINTER TO HEADER MESSAGE

DO_PARAM:
        .LONG   PRICE_ADJ            ;ROUTINE TO RUN
        .LONG   MESS_PARAM           ;POINTER TO HEADER MESSAGE
        .LONG   HELP_PARAM           ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJPRICE             ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   1                    ;MINIMUM VALUE
        .LONG   CS_ENTS              ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   PARAM_VAL            ;Routine for showing current value
        .WORD   WRAP_VAL             ;WRAP AROUND ON COIN MODES
        .LONG   0                    ;LIST OF MESSAGES FOR THIS ADJ.
        .LONG   MESS_PARAM           ;POINTER TO HEADER MESSAGE

*MECHANICAL COIN COUNTER ADJUST

DO_CNTR:
        .LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   MESS_CNTR            ;POINTER TO HEADER MESSAGE
        .LONG   HELP_CNTR            ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJCNTR              ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   1                    ;MINIMUM VALUE
        .LONG   3                    ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   LIST_1LINE           ;MESSAGE LIST USED FOR VALUES.
        .WORD   0                    ;DON'T WRAP AROUND
        .LONG   LIST_CNTR            ;JUST SHOW THE NUMBER
        .LONG   MESS_CNTR            ;POINTER TO HEADER MESSAGE

DO_DIFF:
        .LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   MESS_DIFF            ;POINTER TO HEADER MESSAGE
        .LONG   HELP_DIFF            ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJDIFF              ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   1                    ;MINIMUM VALUE
        .LONG   10                    ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   LIST_1LINE           ;MESSAGE LIST USED FOR VALUES.
        .WORD   0                    ;DON'T WRAP AROUND
        .LONG   LIST_DIFF            ;LIST OF MESSAGES FOR THIS ADJ.
        .LONG   MESS_DIFF            ;POINTER TO HEADER MESSAGE

;DO_EASY:  
;	.LONG   GEN_ADJ              ;ROUTINE TO RUN
;        .LONG   MESS_EASY            ;POINTER TO HEADER MESSAGE
;        .LONG   HELP_EASY            ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
;        .WORD   ADJBUYIN             ;CMOS ADJUSTMENT WE'RE SETTING
;        .LONG   0                    ;MINIMUM VALUE
;        .LONG   1                    ;MAXIMUM VALUE
;        .LONG   1                    ;MOVE UP AND DOWN BY 250'S
;        .LONG   0                    ;DON'T SUB ZERO FOR ANY
;        .LONG   LIST_1LINE           ;MESSAGE LIST USED FOR VALUES.
;        .WORD   WRAP_VAL             ;WRAP AROUND
;        .LONG   LIST_NOYES           ;LIST OF MESSAGES FOR THIS ADJ.
;        .LONG   MESS_EASY            ;POINTER TO HEADER MESSAGE

DO_LIVES:
        .LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   MESS_LIVES           ;POINTER TO HEADER MESSAGE
        .LONG   HELP_LIVES           ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJLIVES             ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   1                    ;MINIMUM VALUE
        .LONG   7                    ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   LIST_1LINE           ;MESSAGE LIST USED FOR VALUES.
        .WORD   0                    ;DON'T WRAP AROUND
        .LONG   LIST_LIVES           ;LIST OF MESSAGES FOR THIS ADJ.
        .LONG   MESS_LIVES           ;POINTER TO HEADER MESSAGE

;DO_ROCKS:
;        .LONG   GEN_ADJ              ;ROUTINE TO RUN
;        .LONG   MESS_ROCKS           ;POINTER TO HEADER MESSAGE
;        .LONG   HELP_ROCKS           ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
;        .WORD   ADJROCKS             ;CMOS ADJUSTMENT WE'RE SETTING
;        .LONG   1                    ;MINIMUM VALUE
;        .LONG   10                    ;MAXIMUM VALUE
;        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
;        .LONG   0                    ;DON'T SUB ZERO FOR ANY
;        .LONG   LIST_1LINE           ;MESSAGE LIST USED FOR VALUES.
;        .WORD   0                    ;DON'T WRAP AROUND
;        .LONG   LIST_ROCKS           ;LIST OF MESSAGES FOR THIS ADJ.
;        .LONG   MESS_ROCKS           ;POINTER TO HEADER MESSAGE

;DO_EXTRA:
;        .LONG   GEN_ADJ              ;ROUTINE TO RUN
;        .LONG   MESS_EXTRA           ;POINTER TO HEADER MESSAGE
;        .LONG   HELP_EXTRA           ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
;        .WORD   ADJEXTRA             ;CMOS ADJUSTMENT WE'RE SETTING
;        .LONG   25000H               ;MINIMUM VALUE (25000 IS "OFF" 50000 IS MIN)
;        .LONG   500000H              ;MAXIMUM VALUE
;        .LONG   25000H               ;MOVE UP AND DOWN BY 25K AT A CRACK'S
;        .LONG   25000H               ;SUBSTITUTE ZERO FOR 25000H
;        .LONG   HEX_OR_MESS          ;HEX WITH COMMAS...OR OFF IF SET TO LOWEST VALUE
;        .WORD   WRAP_VAL+BCD_VAL     ;ALLOW WRAP AROUND
;        .LONG   MESS_OFF             ;NO ANCILLARY INFO.
;        .LONG   MESS_EXTRA           ;POINTER TO HEADER MESSAGE

;DO_LAST:
;        .LONG   GEN_ADJ              ;ROUTINE TO RUN
;        .LONG   MESS_LAST            ;POINTER TO HEADER MESSAGE
;        .LONG   HELP_LAST            ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
;        .WORD   ADJLAST              ;CMOS ADJUSTMENT WE'RE SETTING
;        .LONG   00H                  ;MINIMUM VALUE (0 IS "OFF" 100000 IS MIN)
;        .LONG   5000000H             ;MAXIMUM VALUE  5 MIL
;        .LONG   100000H              ;MOVE UP AND DOWN BY 100K AT A CRACK'S
;        .LONG   00H                  ;SUBSTITUTE ZERO FOR ZERO
;        .LONG   HEX_OR_MESS          ;HEX WITH COMMAS...OR OFF IF SET TO LOWEST VALUE
;        .WORD   WRAP_VAL+BCD_VAL     ;ALLOW WRAP AROUND
;        .LONG   MESS_OFF             ;NO ANCILLARY INFO.
;        .LONG   MESS_LAST            ;POINTER TO HEADER MESSAGE

DO_AMODE:
        .LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   MESS_AMOD2           ;POINTER TO HEADER MESSAGE
        .LONG   HELP_AMODE           ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJMUSIC             ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   0                    ;MINIMUM VALUE
        .LONG   1                    ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   LIST_1LINE           ;MESSAGE LIST USED FOR VALUES.
        .WORD   WRAP_VAL             ;WRAP AROUND
        .LONG   LIST_AMODE           ;LIST OF MESSAGES FOR THIS ADJ.
        .LONG   MESS_AMODE           ;POINTER TO HEADER MESSAGE

DO_AHSRES:
        .LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   MESS_HSR2            ;POINTER TO HEADER MESSAGE
        .LONG   HELP_AHSRES          ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJHSRES             ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   0                    ;MINIMUM VALUE
        .LONG   25000                ;MAXIMUM VALUE
        .LONG   250                  ;MOVE UP AND DOWN BY 250'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   BIN_OR_MESS          ;MESSAGE LIST USED FOR VALUES.
        .WORD   WRAP_VAL^HSR_VAL     ;WRAP AROUND AND RESET HSC IF TOUCHED
        .LONG   MESS_OFF             ;LIST OF MESSAGES FOR THIS ADJ.
        .LONG   MESS_AHSRES          ;POINTER TO HEADER MESSAGE

DO_GORE: 
        .LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   MESS_GORE            ;POINTER TO HEADER MESSAGE
        .LONG   HELP_GORE            ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJGORE              ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   0                    ;MINIMUM VALUE
        .LONG   1                    ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   LIST_1LINE           ;MESSAGE LIST USED FOR VALUES.
        .WORD   WRAP_VAL             ;WRAP AROUND
        .LONG   LIST_GORE            ;LIST OF MESSAGES FOR THIS ADJ.
        .LONG   MESS_GORE            ;POINTER TO HEADER MESSAGE
*
*       THESE ARE ALL FOR THE CUSTOM PRICING MENU
*
COINBITS:       EQU     WRAP_VAL+VIRG_VAL+SIX_VAL

DO_LCOIN:
        .LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   M_LCU                ;POINTER TO HEADER MESSAGE
        .LONG   HELP_LCU             ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJLMULT             ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   0                    ;MINIMUM VALUE
        .LONG   99                   ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   JUST_BIN             ;JUST SHOW THE NUMBER
        .WORD   COINBITS             ;WRAP AROUND
        .LONG   0                    ;NO EXTRA INFO NEEDED
        .LONG   M_LCU                ;POINTER TO HEADER MESSAGE

DO_CCOIN:
        .LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   M_CCU               ;POINTER TO HEADER MESSAGE
        .LONG   HELP_CCU             ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJCMULT             ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   0                    ;MINIMUM VALUE
        .LONG   99                   ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   JUST_BIN             ;JUST SHOW THE NUMBER
        .WORD   COINBITS             ;WRAP AROUND
        .LONG   0                    ;NO EXTRA INFO NEEDED
        .LONG   M_CCU                ;POINTER TO HEADER MESSAGE

DO_RCOIN:
        .LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   M_RCU                ;POINTER TO HEADER MESSAGE
        .LONG   HELP_RCU             ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJRMULT             ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   0                    ;MINIMUM VALUE
        .LONG   99                   ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   JUST_BIN             ;JUST SHOW THE NUMBER
        .WORD   COINBITS             ;WRAP AROUND
        .LONG   0                    ;NO EXTRA INFO NEEDED
        .LONG   M_RCU                ;POINTER TO HEADER MESSAGE
DO_XCOIN:
        .LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   M_XCU                ;POINTER TO HEADER MESSAGE
        .LONG   HELP_XCU             ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJXMULT             ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   0                    ;MINIMUM VALUE
        .LONG   99                   ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   JUST_BIN             ;JUST SHOW THE NUMBER
        .WORD   COINBITS             ;WRAP AROUND
        .LONG   0                    ;NO EXTRA INFO NEEDED
        .LONG   M_XCU                ;POINTER TO HEADER MESSAGE

DO_UC:    
	.LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   M_UC                 ;POINTER TO HEADER MESSAGE
        .LONG   HELP_UC              ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJCUNIT             ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   1                    ;MINIMUM VALUE
        .LONG   99                   ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   JUST_BIN             ;JUST SHOW THE NUMBER
        .WORD   COINBITS             ;WRAP AROUND
        .LONG   0                    ;NO EXTRA INFO NEEDED
        .LONG   M_UC                 ;POINTER TO HEADER MESSAGE

DO_UB:    
	.LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   M_UB                 ;POINTER TO HEADER MESSAGE
        .LONG   HELP_UB              ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJBUNIT             ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   0                    ;MINIMUM VALUE
        .LONG   99                   ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   BIN_OR_MESS          ;JUST SHOW THE NUMBER
        .WORD   COINBITS             ;WRAP AROUND
        .LONG   M_NOBONUS            ;NO EXTRA INFO NEEDED
        .LONG   M_UB                 ;POINTER TO HEADER MESSAGE
    
DO_UM:    
	.LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   M_UM2                ;POINTER TO HEADER MESSAGE
        .LONG   HELP_UM              ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJMUNIT             ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   0                    ;MINIMUM VALUE
        .LONG   99                   ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   BIN_OR_MESS          ;JUST SHOW THE NUMBER
        .WORD   COINBITS             ;WRAP AROUND
        .LONG   M_NOMIN              ;NO EXTRA INFO NEEDED
        .LONG   M_UM                 ;POINTER TO HEADER MESSAGE

CREDBITS:       EQU     VIRG_VAL

DO_CST:   
	.LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   M_CST                ;POINTER TO HEADER MESSAGE
        .LONG   HELP_CS              ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJCSTRT             ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   1                    ;MINIMUM VALUE
        .LONG   4                    ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   JUST_BIN            ;JUST SHOW THE NUMBER
        .WORD   CREDBITS             ;WRAP AROUND
        .LONG   0                    ;NO EXTRA INFO NEEDED
        .LONG   M_CST                ;POINTER TO HEADER MESSAGE

DO_CONT:  
	.LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   M_CONT2               ;POINTER TO HEADER MESSAGE
        .LONG   HELP_CC              ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJCCONT             ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   1                    ;MINIMUM VALUE
        .LONG   4                    ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   JUST_BIN             ;JUST SHOW THE NUMBER
        .WORD   CREDBITS             ;WRAP AROUND
        .LONG   0                    ;NO EXTRA INFO NEEDED
        .LONG   M_CONT               ;POINTER TO HEADER MESSAGE

DO_CRFR:
        .LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   M_CRFR2              ;POINTER TO HEADER MESSAGE
        .LONG   HELP_CRFR            ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJFRAC              ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   0                    ;MINIMUM VALUE
        .LONG   1                    ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   LIST_1LINE           ;MESSAGE LIST USED FOR VALUES.
        .WORD   WRAP_VAL             ;WRAP AROUND
        .LONG   LIST_NOYES           ;LIST OF MESSAGES FOR THIS ADJ.
        .LONG   M_CRFR               ;POINTER TO HEADER MESSAGE

DO_CPD:   
	.LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   M_CPD                ;POINTER TO HEADER MESSAGE
        .LONG   HELP_CPD             ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJCDIV              ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   0                    ;MINIMUM VALUE
        .LONG   20                   ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   BIN_OR_MESS             ;JUST SHOW THE NUMBER
        .WORD   0                    ;NO WRAP AROUND
        .LONG   M_NO_COL             ;NO EXTRA INFO NEEDED
        .LONG   M_CPD                ;POINTER TO HEADER MESSAGE

DO_MAX:   
	.LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   M_MAX                ;POINTER TO HEADER MESSAGE
        .LONG   HELP_MAX             ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJMAXC              ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   5                    ;MINIMUM VALUE
        .LONG   99                   ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   JUST_BIN             ;JUST SHOW THE NUMBER
        .WORD   WRAP_VAL             ;WRAP AROUND
        .LONG   0                    ;NO EXTRA INFO NEEDED
        .LONG   M_MAX                ;POINTER TO HEADER MESSAGE

DO_FREE:
        .LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   MESS_FREE            ;POINTER TO HEADER MESSAGE
        .LONG   HELP_FREE            ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJFREPL             ;CMOS ADJUSTMENT WE'RE SETTING
*
*	G_FREE:	 REPLACE  ".LONG 0"   WITH  ".LONG 1"	
*
 	.LONG   0                    ;MINIMUM VALUE
        .LONG   1                    ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 250'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   LIST_1LINE           ;MESSAGE LIST USED FOR VALUES.
        .WORD   WRAP_VAL             ;WRAP AROUND
*
*	G_FREE:	 REPLACE  ".LONG LIST_NOYES"   WITH  ".LONG LIST_YESNO"	
*
        .LONG   LIST_NOYES           ;LIST OF MESSAGES FOR THIS ADJ.
        .LONG   MESS_FREE            ;POINTER TO HEADER MESSAGE

DO_CTIT:
        .LONG   GEN_ADJ              ;ROUTINE TO RUN
        .LONG   MESS_CTIT            ;POINTER TO HEADER MESSAGE
        .LONG   CTIT_HELP            ;POINTER TO HELP MESSAGES FOR RIGHT SIDE
        .WORD   ADJNOCPAG            ;CMOS ADJUSTMENT WE'RE SETTING
        .LONG   0                    ;MINIMUM VALUE
        .LONG   1                    ;MAXIMUM VALUE
        .LONG   1                    ;MOVE UP AND DOWN BY 1'S
        .LONG   0                    ;DON'T SUB ZERO FOR ANY
        .LONG   LIST_1LINE           ;MESSAGE LIST USED FOR VALUES.
        .WORD   WRAP_VAL             ;WRAP AROUND
        .LONG   LIST_YESNO           ;LIST OF MESSAGES FOR THIS ADJ.
        .LONG   MESS_CTIT            ;POINTER TO HEADER MESSAGE

*
*       ADJUSTMENT MENU IS SKINNY..LEAVING ROOM FOR EXPLANATION.
*
AM_BDY  EQU     -2
AM_WID  EQU     0A7H
AM_X    EQU     TIT_ULX+GAP+MB_XWID+(AM_WID/2)+C_KLUDGE
AM_Y    EQU     INST_LRY+BOX_YGAP+MB_YWID+GAP-AM_BDY
*
*       RIGHT MARGIN OF ADJUST MENU BOX
*
AM_RX   EQU     TIT_ULX+(2*GAP)+AM_WID+(2*MB_XWID)
*
*       LEFT MARGIN OF HELP BOX
*
AM_HX   EQU     AM_RX+BOX_XGAP

MEN_ADJ: 
	.LONG   RD7FONT         ;FONT
        .LONG   STRCNRM         ;CENTER PLEASE
        .LONG   M_GADJ          ;TITLE
        .WORD   ROBO_PURPLE    ;COLOR OF TITLE
        .WORD   AM_X            ;UL X
        .WORD   AM_Y            ;UL Y
        .WORD   12
        .WORD   ROBO_WHITE     ;COLOR WHEN NOT SELECTED
        .WORD   12              ;HEIGHT OF SELECTION BAR
        .WORD   AM_BDY          ;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
        .WORD   BAR_DX          ;EXTRA X ON EACH SIDE.
        .WORD   AM_WID          ;WIDTH OF BAR!
        .WORD   ROBO_DECAY     ;TEXT COLOR OF SELECTED ITEM
        .LONG   MESS_MM,0,BLNK_HELP        ;RETURN TO MAIN MENU
        .LONG   MESS_PRICE,DO_PRICE,ADJ_HELP
        .LONG   MESS_PARAM,DO_PARAM,ADJ_HELP
        .LONG   MESS_CNTR,DO_CNTR,ADJ_HELP     
        .LONG   MESS_DIFF,DO_DIFF,ADJ_HELP     
;        .LONG   MESS_EASY,DO_EASY,ADJ_HELP
        .LONG   MESS_LIVES,DO_LIVES,ADJ_HELP    
;        .LONG   MESS_ROCKS,DO_ROCKS,ADJ_HELP
;        .LONG   MESS_EXTRA,DO_EXTRA,ADJ_HELP
;        .LONG   MESS_LAST,DO_LAST,ADJ_HELP
        .LONG   MESS_AMODE,DO_AMODE,ADJ_HELP
        .LONG   MESS_AHSRES,DO_AHSRES,ADJ_HELP
        .LONG   MESS_GORE,DO_GORE,ADJ_HELP
        .LONG   MESS_MM,0,BLNK_HELP        ;RETURN TO MAIN MENU
        .LONG   0               ;END

MEN_CUST:
        .LONG   RD7FONT         ;FONT
        .LONG   STRCNRM         ;CENTER PLEASE
        .LONG   M_CUSPRI        ;TITLE
        .WORD   ROBO_CYAN       ;COLOR OF TITLE
        .WORD   AM_X            ;UL X
        .WORD   AM_Y            ;UL Y
        .WORD   11              ;VERTICAL SPACING
        .WORD   ROBO_CYAN       ;COLOR WHEN NOT SELECTED
        .WORD   12              ;HEIGHT OF SELECTION BAR
        .WORD   AM_BDY          ;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
        .WORD   BAR_DX          ;EXTRA X ON EACH SIDE.
        .WORD   AM_WID          ;WIDTH OF BAR!
        .WORD   ROBO_DECAY     ;TEXT COLOR OF SELECTED ITEM
        .LONG   MESS_AM,0,BLNK_HELP        ;RETURN TO MAIN MENU
        .LONG   M_LCU,DO_LCOIN,ADJ_HELP     ;LEFT SLOT UNITS
        .LONG   M_RCU,DO_RCOIN,ADJ_HELP     ;RIGHT SLOT UNITS
        .LONG   M_CCU,DO_CCOIN,ADJ_HELP     ;CENTER SLOT UNITS
        .LONG   M_XCU,DO_XCOIN,ADJ_HELP     ;RIGHT SLOT UNITS
        .LONG   M_UC,DO_UC,ADJ_HELP         ;UNITS FOR CREDIT
        .LONG   M_UB,DO_UB,ADJ_HELP         ;UNITS FOR BONUS
        .LONG   M_UM,DO_UM,ADJ_HELP         ;MINIMUM UNITS
        .LONG   M_CST,DO_CST,ADJ_HELP       ;CREDITS REQUIRED TO START
        .LONG   M_CONT,DO_CONT,ADJ_HELP     ;CREDITS REQUIRED TO CONTINUE
        .LONG   MESS_CTIT,DO_CTIT,ADJ_HELP     ;COIN PAGE HELP LINE
        .LONG   M_CRFR,DO_CRFR,ADJ_HELP        ;SHOW CREDIT FRACTIONS
        .LONG   M_CPD,DO_CPD,ADJ_HELP          ;COINS PER DOLLAR
        .LONG   MESS_FREE,DO_FREE,ADJ_HELP     ;FREE PLAY
        .LONG   M_MAX,DO_MAX,ADJ_HELP          ;MAXIMUM CREDITS
;        .LONG   MESS_AM,0,BLNK_HELP        ;RETURN TO MAIN MENU
        .LONG   0

M_GADJ  
	.STRING         "GAME ADJUSTMENT"
        .BYTE     0
        .EVEN

M_CUSPRI: 
	.STRING         "CUSTOM PRICING"
        .BYTE     0
        .EVEN

MESS_FREE:        
	.STRING "FREE PLAY"
        .BYTE 0
        .EVEN

MESS_PRICE:
        .STRING "STANDARD PRICING"
        .BYTE 0
        .EVEN
MESS_PARAM:
	.STRING "CUSTOM PRICING"  
        .BYTE 0
        .EVEN
MESS_DIFF:
        .STRING "GAME DIFFICULTY"
        .BYTE 0
        .EVEN
MESS_CNTR:
        .STRING "COIN COUNTER MODE"
        .BYTE 0
        .EVEN
MESS_CTIT:
        .STRING "COIN PAGE HELP"
        .BYTE 0
        .EVEN
MESS_LIVES:       
	.STRING "LIVES PER PLAY"
        .BYTE 0
        .EVEN
;MESS_EASY:        
;	.STRING "EASY BUY-IN"
;        .BYTE 0
;        .EVEN
;MESS_ROCKS:
;        .STRING "POWER-UPS PER PLAY"
;        .BYTE 0
;        .EVEN
;MESS_EXTRA:
;        .STRING "EXTRA MAN EVERY"
;        .BYTE 0
;        .EVEN
;MESS_LAST:        
;	.STRING "LAST EXTRA MAN"
;        .BYTE 0
;        .EVEN
MESS_AMODE:       
	.STRING "ATTRACT-MODE SOUND"   ;FOR MENU
        .BYTE 0
        .EVEN
MESS_AMOD2:       
	.STRING "A-MODE SOUND"        ;FOR TITLE BOX (SHORTER VER.)
        .BYTE 0
        .EVEN
MESS_AHSRES:       
	.STRING "AUTO HIGH SCORE RESET"    ;FOR MENU
        .BYTE 0
        .EVEN
MESS_HSR2:
        .STRING "AUTO H.S. RESET"
        .BYTE 0
        .EVEN
MESS_GORE:        
	.STRING "VIOLENCE LEVEL"
        .BYTE 0
        .EVEN

M_LCU:    
	.STRING "LEFT CHUTE (1) UNITS"
        .BYTE 0
        .EVEN
M_CCU:    
	.STRING "CHUTE (3) UNITS"
        .BYTE 0
        .EVEN
M_RCU:   
	.STRING "RIGHT CHUTE (2) UNITS"
        .BYTE 0
        .EVEN
M_XCU:   
	.STRING "CHUTE (4) UNITS"
        .BYTE 0
        .EVEN
M_UC:     
	.STRING "UNITS / CREDIT"
        .BYTE 0
        .EVEN
M_UB:     
	.STRING "UNITS / BONUS"
        .BYTE 0
        .EVEN
M_UM:     
	.STRING "MIN. UNITS REQUIRED"
        .BYTE 0
        .EVEN
M_UM2:    
	.STRING  "MINIMUM UNITS"
        .BYTE 0
        .EVEN
M_CST:    
	.STRING "CREDITS TO START"
        .BYTE 0
        .EVEN
M_CONT:   
	.STRING "CREDITS TO CONTINUE"
        .BYTE 0
        .EVEN
M_CONT2:  
	.STRING "CRED. TO CONTINUE"
        .BYTE 0
        .EVEN
M_CRFR:   
	.STRING "SHOW CREDIT FRACTIONS"
        .BYTE 0
        .EVEN
M_CRFR2:  
	.STRING "CREDIT FRACTIONS"
        .BYTE 0
        .EVEN
M_CPD:    
	.STRING "COINS PER DOLLAR"
        .BYTE 0
        .EVEN
M_MAX:    
	.STRING "MAXIMUM CREDITS"
        .BYTE 0
        .EVEN
MESS_AM:  
	.STRING "RETURN TO ADJ. MENU"
        .BYTE 0
        .EVEN
*
*       THIS IS THE ADJUSTMENT NAME IN THE UPPER RIGHT
*       BOX
*
ADJT_Y  EQU     INST_ULY+9                ;CENTER IN THE BOX
ADJT_SETUP:
        MESS_MAC  RD7FONT,SPACING20,200,ADJT_Y,ROBO_LF,STRCNRM,0

CSET_Y	EQU     CUR_ULY+7
        .EVEN

MOC_Y1   EQU     CSET_Y+20
MOC_Y2   EQU     MOC_Y1+10
MOC_Y3   EQU     MOC_Y2+10

MESS_OPEN_OR_CANCEL
         MESS_MAC  RD7FONT,SPACING20,AM_X,MOC_Y1,ROBO_LF,STRCNRM,0
         .STRING   "OPEN COIN DOOR, OR"
         .BYTE   0,1
         .EVEN
         MESS_MAC  RD7FONT,SPACING20,AM_X,MOC_Y2,ROBO_LF,STRCNRM,0
         .STRING   "PRESS ANY BUTTON"
         .BYTE   0,1
         .EVEN
         MESS_MAC  RD7FONT,SPACING20,AM_X,MOC_Y3,ROBO_LF,STRCNRM,0
         .STRING   "TO CANCEL"
         .BYTE   0,0
         .EVEN

IN_Y1    EQU     CUR_ULY+12
IN_Y2    EQU     IN_Y1+12
IN_Y3    EQU     IN_Y2+39
IN_Y4    EQU     IN_Y3+12

INST_TO_ADJ
          MESS_MAC  RD7FONT,SPACING07,AM_X,IN_Y1,ROBO_WHITE,STRCNRM,0
         .STRING   "MODIFY VALUE WITH"
         .BYTE   0,1  
         .EVEN
          MESS_MAC  RD7FONT,SPACING07,AM_X,IN_Y2,ROBO_WHITE,STRCNRM,0
         .STRING   "ANY STICK"
         .BYTE   0,1  
         .EVEN
         MESS_MAC  RD7FONT,SPACING07,AM_X,IN_Y3,ROBO_WHITE,STRCNRM,0
         .STRING   "PRESS ANY BUTTON"
         .BYTE   0,1 
         .EVEN
         MESS_MAC  RD7FONT,SPACING07,AM_X,IN_Y4,ROBO_WHITE,STRCNRM,0
         .STRING   "WHEN VALUE IS CORRECT."
         .BYTE   0,0 
         .EVEN
*
*        FOR THE WORD UNDER "ADJUSTING" WHILE THE ADJUSTING
*        IS ACTUALLY BEING DONE
*
ADNOW_Y1 EQU     CUR_ULY-35
ADNOW_Y2 EQU     ADNOW_Y1+12

MES_ADJUSTING
         MESS_MAC  RD7FONT,SPACING07,AM_X,ADNOW_Y1,ROBO_LF,STRCNRM,0
         .STRING   "ADJUSTING"
         .BYTE   0,0
         .EVEN

MES_ADNAME
         MESS_MAC  RD7FONT,SPACING07,AM_X,ADNOW_Y2,ROBO_LF,STRCNRM,0

INSTR_Y  EQU     INST_ULY+5
INSTR_2Y EQU     INSTR_Y+10

ADJ_ADV
          MESS_MAC  RD7FONT,SPACING07,AM_X,INSTR_Y,ROBO_CYAN,STRCNRM,0
         .STRING   "SELECT WITH ANY STICK"
         .BYTE   0,1  
         .EVEN
         MESS_MAC  RD7FONT,SPACING07,AM_X,INSTR_2Y,ROBO_CYAN,STRCNRM,0
         .STRING   "PRESS A BUTTON TO MODIFY"
         .BYTE   0,0 
         .EVEN

AAY      EQU     IN_Y1+19H

ADJ_ARROW
         MESS_MAC  RD7FONT,0FFFDH,AM_X,AAY,ROBO_LASER,STRCNRM,0
         .STRING   "----->    ----->    ----->    ----->    ----->"
         .BYTE   0,0
         .EVEN
*
*        IF COIN SETTINGS DON'T NEATLY FIT INTO
*        A MODE
*
MESS_TAMPERED
         .STRING "NON-STANDARD"
         .BYTE   0
         .EVEN

M_SLOTVAL
         .STRING "COIN SLOT VALUE"
         .BYTE   0
         .EVEN

MESS_GP  .STRING "GAME PRICING:"
         .BYTE   0
         .EVEN
MESS_FP  .STRING "FREE PLAY:"
         .BYTE   0
         .EVEN
MESS_MAX .STRING "MAXIMUM CREDITS:"
         .BYTE   0
         .EVEN

M_CTS_PL         .STRING "CREDITS TO START:"
         .BYTE 0
         .EVEN
M_CTC_PL         .STRING "CREDITS TO CONTINUE:"
         .BYTE 0
         .EVEN

**************************************************************************
*                                                                        *
*          HELP STRUCTURES FOR MAIN ADJUSTMENT MENU!                     *
*                                                                        *
**************************************************************************
HELP_DIFF
         .WORD   1               ;CENTER JUSTIFY
         .WORD   ROBO_YELLOW    ;COLOR
         .WORD   6               ;6 ENTRIES
         .LONG   DH_0
         .LONG   DH_1
         .LONG   M_NULL
         .LONG   DH_3
         .LONG   DH_4
         .LONG   DH_5
HELP_CNTR
         .WORD   1               ;CENTER JUSTIFY
         .WORD   ROBO_YELLOW    ;COLOR
         .WORD   6               ;6 ENTRIES
         .LONG   CNTRH_0
         .LONG   CNTRH_1
         .LONG   M_NULL
         .LONG   CNTRH_3
         .LONG   CNTRH_4
         .LONG   CNTRH_5

HELP_PRICE
         .WORD   0               ;CENTER JUSTIFY
         .WORD   ROBO_YELLOW    ;COLOR
         .WORD   4               ;5 ENTRIES
         .LONG   PH_0
         .LONG   PH_1
         .LONG   PH_2
         .LONG   PH_3

HELP_PARAM
         .WORD   0               ;CENTER JUSTIFY
         .WORD   ROBO_YELLOW    ;COLOR
         .WORD   6               ;5 ENTRIES
         .LONG   PP_0
         .LONG   PP_1
         .LONG   PP_2
         .LONG   PP_3
         .LONG   PP_4
         .LONG   PP_5

;HELP_EASY
;         .WORD   0               ;CENTER JUSTIFY
;         .WORD   ROBO_YELLOW    ;COLOR
;         .WORD   4               ;4 ENTRIES
;         .LONG   EH_0
;         .LONG   EH_1
;         .LONG   M_NULL
;         .LONG   EH_2

HELP_LIVES
         .WORD   0               ;CENTER JUSTIFY
         .WORD   ROBO_YELLOW    ;COLOR
         .WORD   6               ;6 ENTRIES
         .LONG   LH_0
         .LONG   LH_1
         .LONG   LH_2
         .LONG   LH_3
         .LONG   M_NULL
         .LONG   LH_4

;HELP_ROCKS
;         .WORD   0               ;CENTER JUSTIFY
;         .WORD   ROBO_YELLOW    ;COLOR
;         .WORD   6               ;6 ENTRIES
;         .LONG   RH_0            ;UNIQUE LINE FOR ROCKETS
;         .LONG   LH_1            ;SAME WORDING AS LIVES
;         .LONG   LH_2
;         .LONG   LH_3
;         .LONG   M_NULL
;         .LONG   RH_5            ;FACTORY OF 5

;HELP_EXTRA
;         .WORD   0               ;CENTER JUSTIFY
;         .WORD   ROBO_YELLOW    ;COLOR
;         .WORD   6               ;6 ENTRIES
;         .LONG   EXH_0            ;UNIQUE LINE FOR ROCKETS
;         .LONG   EXH_1            ;SAME WORDING AS LIVES
;         .LONG   EXH_2
;         .LONG   EXH_3
;         .LONG   M_NULL
;         .LONG   EXH_4            ;FACTORY OF 100,000

;HELP_LAST
;         .WORD   0               ;CENTER JUSTIFY
;         .WORD   ROBO_YELLOW    ;COLOR
;         .WORD   6               ;6 ENTRIES
;         .LONG   LMH_0
;         .LONG   LMH_1
;         .LONG   LMH_2
;         .LONG   M_NULL
;         .LONG   LMH_3
;         .LONG   LMH_4

HELP_AMODE
         .WORD   0               ;CENTER JUSTIFY
         .WORD   ROBO_YELLOW    ;COLOR
         .WORD   5               ;6 ENTRIES
         .LONG   HAM_1
         .LONG   HAM_2
         .LONG   HAM_3
         .LONG   M_NULL
         .LONG   HAM_4

HELP_AHSRES
         .WORD   0               ;CENTER JUSTIFY
         .WORD   ROBO_YELLOW    ;COLOR
         .WORD   6               ;6 ENTRIES
         .LONG   HAH_1
         .LONG   HAH_2
         .LONG   HAH_3
         .LONG   HAH_4
         .LONG   M_NULL
         .LONG   HAH_5

HELP_GORE
         .WORD   0               ;CENTER JUSTIFY
         .WORD   ROBO_YELLOW    ;COLOR
         .WORD   5               ;6 ENTRIES
         .LONG   HG_1
         .LONG   HG_2
         .LONG   HG_3
         .LONG   M_NULL
         .LONG   HG_4

HELP_FREE
         .WORD   0
         .WORD   ROBO_WHITE
         .WORD   6
         .LONG   FP_M1
         .LONG   FP_M2
         .LONG   FP_M3
         .LONG   FP_M4
         .LONG   M_NULL
         .LONG   FP_M5

CTIT_HELP
         .WORD   0
         .WORD   ROBO_WHITE
         .WORD   5
         .LONG   CT_M1
         .LONG   CT_M2
         .LONG   CT_M3
         .LONG   CT_M4
         .LONG   CT_M5

HELP_LCU
         .WORD   0
         .WORD   ROBO_WHITE
         .WORD   6
         .LONG   LC_M1
         .LONG   LC_M2
         .LONG   LC_M3
         .LONG   LC_M4
         .LONG   LC_M5
         .LONG   LC_M6

HELP_CCU
         .WORD   0
         .WORD   ROBO_WHITE
         .WORD   6
         .LONG   LC_M1
         .LONG   LC_M2
         .LONG   LC_M3
         .LONG   LC_M4
         .LONG   CC_M5
         .LONG   LC_M6

HELP_RCU
         .WORD   0
         .WORD   ROBO_WHITE
         .WORD   6
         .LONG   LC_M1
         .LONG   LC_M2
         .LONG   LC_M3
         .LONG   LC_M4
         .LONG   RC_M5
         .LONG   LC_M6
HELP_XCU
         .WORD   0
         .WORD   ROBO_WHITE
         .WORD   6
         .LONG   LC_M1
         .LONG   LC_M2
         .LONG   LC_M3
         .LONG   LC_M4
         .LONG   XC_M5
         .LONG   LC_M6

HELP_UC  .WORD   0
         .WORD   ROBO_WHITE
         .WORD   3
         .LONG   UC_M1
         .LONG   UC_M2
         .LONG   UC_M3

HELP_UB  .WORD   0
         .WORD   ROBO_WHITE
         .WORD   3
         .LONG   UB_M1
         .LONG   UB_M2
         .LONG   UB_M3

HELP_UM  .WORD   0
         .WORD   ROBO_WHITE
         .WORD   3
         .LONG   UM_M1
         .LONG   UM_M2
         .LONG   UM_M3


HELP_CS  .WORD   0
         .WORD   ROBO_WHITE
         .WORD   3
         .LONG   CS_M1
         .LONG   CS_M2
         .LONG   CS_M3

HELP_CC  .WORD   0
         .WORD   ROBO_WHITE
         .WORD   3
         .LONG   CS_M1
         .LONG   CS_M2
         .LONG   CC_M3

HELP_CRFR 
         .WORD   0
         .WORD   ROBO_WHITE
         .WORD   6
         .LONG   FR_M1
         .LONG   FR_M2
         .LONG   FR_M3
         .LONG   M_NULL
         .LONG   FR_M4
         .LONG   FR_M5

HELP_CPD .WORD   0
         .WORD   ROBO_WHITE
         .WORD   6
         .LONG   CPD_M1
         .LONG   CPD_M2
         .LONG   CPD_M3
         .LONG   CPD_M4
         .LONG   CPD_M5
         .LONG   CPD_M6

HELP_MAX .WORD   0
         .WORD   ROBO_WHITE
         .WORD   6
         .LONG   MC_M1
         .LONG   MC_M2
         .LONG   MC_M3
         .LONG   MC_M4
         .LONG   M_NULL
         .LONG   MC_M5

**************************************************************************
*                                                                        *
*          HELP MESSAGES FOR MAIN ADJUSTMENT MENU!                       *
*                                                                        *
**************************************************************************

CNTRH_0     .STRING "THIS CONTROLS MECHANICAL"
         .BYTE 0
         .EVEN
CNTRH_1     .STRING "COIN COUNTER MODE"
	   .BYTE 0
         .EVEN
CNTRH_3     .STRING "CNTR1 = MULT OF LOW COIN: 1"
         .BYTE 0
         .EVEN
CNTRH_4     .STRING "CNTR1 = 1 COUNT/COIN:     2"
         .BYTE 0		   
         .EVEN
CNTRH_5     .STRING "CNTR1=LCOIN, CNTR2=RCOIN: 3"
         .BYTE 0
         .EVEN


DH_0     .STRING "THIS CONTROLS THE OVERALL"
         .BYTE 0
         .EVEN
DH_1     .STRING "DIFFICULTY OF GAME PLAY."
M_NULL   .BYTE 0
         .EVEN
DH_3     .STRING "EASIEST  SETTING: 1"
         .BYTE 0
         .EVEN
DH_4     .STRING "HARDEST SETTING: 10"
         .BYTE 0
         .EVEN
DH_5     .STRING "FACTORY SETTING: 3"
         .BYTE 0
         .EVEN

PH_0     .STRING "SELECT BUILT-IN PRICING"
         .BYTE 0
         .EVEN
PH_1     .STRING "MODE, SELECTING COINS"
         .BYTE 0
         .EVEN
PH_2     .STRING "PER CREDIT, AND"
         .BYTE 0
         .EVEN
PH_3     .STRING "COIN SLOT VALUE."
         .BYTE 0
         .EVEN
*
*
;RH_0     .STRING "THE NUMBER OF POWER-UPS"
;         .BYTE 0
;         .EVEN

;RH_5     .STRING "FACTORY SETTING: 5"
;         .BYTE 0
;         .EVEN

LH_0     .STRING "THE NUMBER OF LIVES"
         .BYTE 0
         .EVEN
LH_1     .STRING "A PLAYER RECEIVES"
         .BYTE 0
         .EVEN
LH_2     .STRING "EACH TIME HE STARTS"
         .BYTE 0
         .EVEN
LH_3     .STRING "OR CONTINUES A GAME."
         .BYTE 0
         .EVEN
LH_4     .STRING "FACTORY SETTING: 3"
         .BYTE 0
         .EVEN

;EXH_0    .STRING "PLAYERS RECEIVE AN"
;         .BYTE 0
;         .EVEN
;EXH_1    .STRING "EXTRA LIFE EACH"
;         .BYTE 0
;         .EVEN
;EXH_2    .STRING "TIME THEY SCORE"
;         .BYTE 0
;         .EVEN
;EXH_3    .STRING "THIS MANY POINTS."
;         .BYTE 0
;         .EVEN
;EXH_4    .STRING "FACTORY SETTING: 100,000"
;         .BYTE 0
;         .EVEN

;LMH_0    .STRING "ONCE A SCORE REACHES"
;         .BYTE 0
;         .EVEN
;LMH_1    .STRING "THIS LEVEL, NO EXTRA"
;         .BYTE 0
;         .EVEN
;LMH_2    .STRING "MEN WILL BE AWARDED."
;         .BYTE 0
;         .EVEN
;LMH_3    .STRING "FACTORY SETTING: OFF"
;         .BYTE 0
;         .EVEN
;LMH_4    .STRING "(NO LIMIT ON EXTRA MEN)" 
;         .BYTE 0
;         .EVEN

HAM_1    .STRING "THIS DETERMINES WHETHER"
         .BYTE 0
         .EVEN
HAM_2    .STRING "THE GAME WILL MAKE SOUNDS"
         .BYTE 0
         .EVEN
HAM_3    .STRING "IN THE ATTRACT MODE."
         .BYTE 0
         .EVEN
HAM_4    .STRING "FACTORY SETTING: ON"
         .BYTE 0
         .EVEN
HAH_1    .STRING "THE ALL TIME HIGH SCORE"
         .BYTE 0
         .EVEN
HAH_2    .STRING "TABLE WILL BE RESET TO"
         .BYTE 0
         .EVEN
HAH_3    .STRING "FACTORY VALUES EACH TIME"
         .BYTE 0
         .EVEN
HAH_4    .STRING "THIS MANY PLAYS OCCURS."
         .BYTE 0
         .EVEN
HAH_5    .STRING "FACTORY SETTING: 5000"
         .BYTE 0
         .EVEN
HG_1     .STRING "THIS ALLOWS THE GRAPHIC"
         .BYTE 0
         .EVEN
HG_2     .STRING "VIOLENCE SHOWN ON SCREEN"
         .BYTE 0
         .EVEN
HG_3     .STRING "TO BE ADJUSTED."
         .BYTE 0
         .EVEN
HG_4     .STRING "FACTORY SETTING: NORMAL"
         .BYTE 0
         .EVEN

FP_M1    .STRING "SETTING FREE PLAY TO"
         .BYTE 0
         .EVEN
FP_M2    .BYTE   ASCII_DQ
         .STRING "YES"
         .BYTE   ASCII_DQ
         .STRING " ALLOWS UNLIMITED"
         .BYTE 0
         .EVEN
FP_M3    .STRING "PLAY WITHOUT INSERTING"
         .BYTE 0
         .EVEN
FP_M4    .STRING "ANY COINS."
         .BYTE 0
         .EVEN
FP_M5    .STRING "FACTORY SETTING: NO"
         .BYTE 0
         .EVEN
CT_M1    .STRING "WHENEVER STANDARD PRICING"
         .BYTE 0
         .EVEN
CT_M2    .STRING "IS USED, A CORRESPONDING"
         .BYTE 0
         .EVEN
CT_M3    .STRING "MESSAGE IS DISPLAYED ON THE"
         .BYTE 0
         .EVEN
CT_M4    .STRING "CREDITS SCREEN.  SETTING THIS"
         .BYTE 0
         .EVEN
CT_M5    .STRING "TO "
         .BYTE ASCII_DQ
         .STRING "NO"
         .BYTE ASCII_DQ
         .STRING " DISABLES THE MESSAGE."
         .BYTE 0
         .EVEN

PP_0     .STRING "THIS ALLOWS ADJUSTMENT"
         .BYTE 0
         .EVEN
PP_1     .STRING "OF PRICING PARAMETERS"
         .BYTE 0
         .EVEN
PP_2     .STRING "(FOR NON-STANDARD MODES),"
         .BYTE 0
         .EVEN
PP_3     .STRING "FREE PLAY, MAXIMUM CREDITS,"
         .BYTE 0
         .EVEN
PP_4     .STRING "CREDITS REQUIRED TO START"
         .BYTE 0
         .EVEN
PP_5     .STRING "AND CREDITS TO CONTINUE."
         .BYTE 0
         .EVEN

;EH_0     .STRING   "SETTING NOT YET"
;         .BYTE 0
;         .EVEN
;EH_1     .STRING   "ESTABLISHED"
;         .BYTE 0
;         .EVEN
;EH_2     .STRING   "FACTORY SETTING: ???"
;         .BYTE 0
;         .EVEN

LC_M1    .STRING "EACH COIN INSERTED ADDS TO"
         .BYTE 0
         .EVEN
LC_M2    .STRING "COIN UNITS.  THIS ADJUSTMENT"
         .BYTE 0
         .EVEN
LC_M3    .STRING "SPECIFIES THE NUMBER OF COIN"
         .BYTE 0
         .EVEN
LC_M4    .STRING "UNITS GIVEN FOR EACH"
         .BYTE 0
         .EVEN
LC_M5    .STRING "COIN IN LEFT COIN CHUTE."
         .BYTE 0
         .EVEN
LC_M6    .STRING "(SEE "
         .BYTE ASCII_DQ
         .STRING "UNITS / CREDIT"
         .BYTE ASCII_DQ
         .STRING ")"
         .BYTE 0
         .EVEN
CC_M5    .STRING "COIN IN THIRD COIN CHUTE."
         .BYTE 0
         .EVEN
RC_M5    .STRING "COIN IN RIGHT COIN CHUTE."
         .BYTE 0
         .EVEN
XC_M5    .STRING "COIN IN FOURTH COIN CHUTE."
         .BYTE 0
         .EVEN
UC_M1    .STRING "THIS IS THE NUMBER OF COIN"
         .BYTE 0
         .EVEN
UC_M2    .STRING "UNITS REQUIRED TO BUY ONE"
         .BYTE 0
         .EVEN
UC_M3    .STRING "CREDIT."
         .BYTE 0
         .EVEN
UB_M1    .STRING "1 BONUS CREDIT IS AWARDED"
         .BYTE 0
         .EVEN
UB_M2    .STRING "AFTER THIS MANY COIN UNITS"
         .BYTE 0
         .EVEN
UB_M3    .STRING "HAVE ACCUMULATED."
         .BYTE 0
         .EVEN

UM_M1    .STRING "NO CREDITS WILL BE AWARDED"
         .BYTE 0
         .EVEN
UM_M2    .STRING "UNTIL THIS MANY COIN"
         .BYTE 0
         .EVEN
UM_M3    .STRING "UNITS HAVE ACCUMULATED."
         .BYTE 0
         .EVEN

CS_M1    .STRING "EACH PLAYER NEEDS THIS"
         .BYTE 0
         .EVEN
CS_M2    .STRING "MANY CREDITS TO"
         .BYTE 0
         .EVEN
CS_M3    .STRING "BEGIN PLAY."
         .BYTE 0
         .EVEN

CC_M3    .STRING "CONTINUE A GAME."
         .BYTE 0
         .EVEN

FR_M1    .STRING "WHEN SET TO YES,"
         .BYTE 0
         .EVEN
FR_M2    .STRING "FRACTIONAL CREDITS WILL BE"
         .BYTE 0
         .EVEN
FR_M3    .STRING "SEEN ON THE CREDITS SCREEN."
         .BYTE 0
         .EVEN
FR_M4    .STRING "FRACTION SHOWN IS:"
         .BYTE 0
         .EVEN
FR_M5    .STRING "(COIN UNITS / "
         .BYTE ASCII_DQ
         .STRING "UNITS/CREDIT"
         .BYTE ASCII_DQ
         .STRING ")"
         .BYTE 0
         .EVEN

CPD_M1   .STRING "THE DETAILED BOOKKEEPING"
         .BYTE 0
         .EVEN
CPD_M2   .STRING "SCREEN SHOWS TOTAL"
         .BYTE 0
         .EVEN
CPD_M3   .STRING "COLLECTIONS BASED ON THIS"
         .BYTE 0
         .EVEN
CPD_M4   .STRING "MANY COINS PER DOLLAR."
         .BYTE 0
         .EVEN
CPD_M5   .STRING "(SET TO ZERO TO DISABLE THE"
         .BYTE 0
         .EVEN
CPD_M6   .STRING "DISPLAY OF MONEY TOTALS.)"
         .BYTE 0
         .EVEN

MC_M1    .STRING "THIS IS THE LIMIT FOR"
         .BYTE 0
         .EVEN
MC_M2    .STRING "THE CREDITS COUNTER."
         .BYTE 0
         .EVEN
MC_M3    .STRING "ADDITIONAL COINS INSERTED"
         .BYTE 0
         .EVEN
MC_M4    .STRING "WILL BE LOST."
         .BYTE 0
         .EVEN
MC_M5    .STRING "FACTORY SETTING: 30"
         .BYTE 0
         .EVEN

*
*        ADJUSTMENT ENUMERATION STRINGS
*
LIST_CNTR        
         .LONG   CNTR_1,CNTR_2,CNTR_3
LIST_DIFF        
         .LONG   DIFF_1,DIFF_2,DIFF_3,DIFF_4,DIFF_5
         .LONG   DIFF_6,DIFF_7,DIFF_8,DIFF_9,DIFF_10

LIST_LIVES
         .LONG   LIVE_1,LIVE_2,LIVE_3,LIVE_4,LIVE_5
         .LONG   LIVE_6,LIVE_7

;LIST_ROCKS
;         .LONG   ROCK_1,ROCK_2,ROCK_3,ROCK_4,ROCK_5
;         .LONG   ROCK_6,ROCK_7,ROCK_8,ROCK_9,ROCK_10

LIST_AMODE
         .LONG   M_AMS,M_NOAMS

LIST_GORE
         .LONG   M_NORM,M_LESS

LIST_NOYES
         .LONG   M_NO,M_YES

LIST_YESNO
         .LONG   M_YES,M_NO

M_NO     .STRING "NO"
         .BYTE   0
         .EVEN

M_YES    .STRING "YES"
         .BYTE   0
         .EVEN

CNTR_1   .STRING "1 (PROPORTIONAL)"
         .BYTE   0
         .EVEN
CNTR_2   .STRING "2 (1 COUNT/COIN)"
         .BYTE   0
         .EVEN
CNTR_3   .STRING "3 (2 COUNTERS)"
         .BYTE   0
         .EVEN

DIFF_1   .STRING "1 (EXTRA EASY)"
         .BYTE   0
         .EVEN
DIFF_2   .STRING "2 (EASIER)"
         .BYTE   0
         .EVEN
DIFF_3   .STRING "3 (EASY)"
         .BYTE   0
         .EVEN
DIFF_4   .STRING "4 (MEDIUM-EASY)"
         .BYTE   0
         .EVEN
DIFF_5   .STRING "5 (MEDIUM)"
         .BYTE   0
         .EVEN
DIFF_6   .STRING "6 (MEDIUM-HARD)"
         .BYTE   0
         .EVEN
DIFF_7   .STRING "7 (HARD)"
         .BYTE   0
         .EVEN
DIFF_8   .STRING "8 (HARDER)"
         .BYTE   0
         .EVEN
DIFF_9   .STRING "9 (EXTRA HARD)"
         .BYTE   0
         .EVEN
DIFF_10  .STRING "10 (EXTRA HARD)"
         .BYTE   0
         .EVEN

LIVE_1   .STRING "1 LIFE"
         .BYTE 0
         .EVEN
LIVE_2   .STRING "2 LIVES"
         .BYTE 0
         .EVEN
LIVE_3   .STRING "3 LIVES"
         .BYTE 0
         .EVEN
LIVE_4   .STRING "4 LIVES"
         .BYTE 0
         .EVEN
LIVE_5   .STRING "5 LIVES"
         .BYTE 0
         .EVEN
LIVE_6   .STRING "6 LIVES"
         .BYTE 0
         .EVEN
LIVE_7   .STRING "7 LIVES"
         .BYTE 0
         .EVEN

;ROCK_1   .STRING "1 POWER-UP"
;         .BYTE 0
;         .EVEN
;ROCK_2   .STRING "2 POWER-UPS"
;         .BYTE 0
;         .EVEN
;ROCK_3   .STRING "3 POWER-UPS"
;         .BYTE 0
;         .EVEN
;ROCK_4   .STRING "4 POWER-UPS"
;         .BYTE 0
;         .EVEN
;ROCK_5   .STRING "5 POWER-UPS"
;         .BYTE 0
;         .EVEN
;ROCK_6   .STRING "6 POWER-UPS"
;         .BYTE 0
;         .EVEN
;ROCK_7   .STRING "7 POWER-UPS"
;         .BYTE 0
;         .EVEN
;ROCK_8   .STRING "8 POWER-UPS"
;         .BYTE 0
;         .EVEN
;ROCK_9   .STRING "9 POWER-UPS"
;         .BYTE 0
;         .EVEN
;ROCK_10  .STRING "10 POWER-UPS"
;         .BYTE 0
;         .EVEN

M_AMS    .STRING "ON"
         .BYTE 0
         .EVEN
M_NOAMS  .STRING "OFF"
         .BYTE 0
         .EVEN
M_NORM   .STRING "NORMAL"
         .BYTE 0
         .EVEN
M_LESS   .STRING "LESS VIOLENT"
         .BYTE 0
         .EVEN
*
*        FOR EXTRA MAN EVERY AND LAST EXTRA MAN
*
MESS_OFF .STRING "OFF"
         .BYTE 0
         .EVEN

M_NOBONUS  .STRING "NO BONUS CREDIT"
         .BYTE 0
         .EVEN

M_NOMIN  .STRING "NO MINIMUM"
         .BYTE 0
         .EVEN

M_NO_COL .STRING "NO MONEY TOTALS"
         .BYTE 0
         .EVEN

         .END
