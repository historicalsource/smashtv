   	.FILE	'MENU.ASM'
	.TITLE	"ROBO TEST MENUS"
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
	.INCLUDE	"LINK.EQU"
	.INCLUDE	"MENU.EQU"		;MENU EQUATES

	.TEXT
;
;        IN THIS MODULE
;
        .DEF         MEN_MAIN,CSELCT,GET_CSPT,CS_POINT
        .DEF         MESS_FAC
        .DEF         ANY_BUT,MEN_YN
        .DEF         STR_OBJ
        .DEF         STR_FREE
        .DEF         CKPROMPT
        .DEF         GO_DIAG           ;ROUTINE FOR DIAGNOSTIC MENU
        .DEF         RTR_LEV,ROM_LEV
        .DEF         MESS_MM
        .DEF         CS_ENTS           ;NUMBER OF HIGHEST IN COIN TABLE
        .DEF         TWO_TS,TWO_TP
        .DEF         CASHBUT
        .DEF         FAC_STUF
        .DEF         G1SEL,F1SEL
        .DEF         BUILD_ST
        .DEF         SCODE             ;SYNTH CODE CURRENTLY BEING MADE
        .DEF         DCODE             ;DIG CODE CURRENTLY BEING MADE
        .DEF         HID_P

;
;        IN TEST.ASM
;
        .REF         GEN_MENU,B_MENU
        .REF         L_MESS,TOP_BOX
;,WT_ADV,WW_ADV
        .REF         GET_AUD
        .REF         LM_FINIS
        .REF         LM_SETUP
        .REF         BAD_AUD
        .REF         MAIN_RET
        .REF         AREUSURE
        .REF         F_TITLE
        .REF         ST_STICK
        .REF         GETSTICK
        .REF         FAC_SET
        .REF         SUR_MESS
        .REF         SURE_BOX
        .REF         RT_RET
        .REF         GET_FAC
        .REF         WAIT_BUT
        .REF         DIGSRT
        .REF         DIAG_EX
;        .REF         GET_ADV
        .REF         STD_BORD
        .REF         SND_MADE
        .REF         NO_CLEAR
        .REF         LAST_BUT
        .REF         G_BORDER
;
;       IN AUDIT.ASM
;
        .REF GET_ADJ
        .REF STRCAT
        .REF CLR_SUBS
        .REF NO_CREDS
        .REF CLR_AUDR
        .REF CLR_AUD
        .REF ADD_DUMP
        .REF DISPDUMP
        .REF CAT_A0
        .REF CK_MAX
        .REF DUMP_FS
        .REF ADJ_PAGE
        .REF F_ADC_S
        .REF WC_BYTEI
        .REF RC_WORD
        .REF DEF_PAGE
        .REF WAIT_MUT
;
;       IN HSTD.ASM
;
        .REF ALL_TAB,INIT_TB,FORM_ADC,WC_WORD,CMOS_VAL
        .REF P_FORK,GET_HSC,INIT_HSR
;
;       IN ADJUST.ASM
;
        .REF GO_ADJ

;
;	IN UTIL.ASM
;
	.REF	FILLAREA

;
;	IN ROBOATT.ASM
;
	.REF	COLRSTRT
	.REF	GAMERASE
;
;DIAG STUFF
;

	.REF	CPU_CHK,SW_CHK,COL_BARS,CROSS_H,BURN_IN,STRNEW1
;
        .REF RD15FONT,SCRCLR,MYOINIT,STRCNRM,GAMSTATE
        .REF STRNGRAM,BLNKAREA,STRLNRM,RD7FONT,HEXTOASC
        .REF CLR_SCRN,STRRNRM
        .REF WARMSET,QSNDRST
*
        .BSS    FAC_FLAG,16          ;FLAG SAYS CLEAR AUDITS AND HSTABLE
*                                     ;IF FACTORY SETTINGS SUCCEED.
        .BSS    SCODE,16             ;SYNTH CODE LAST MADE!
        .BSS    DCODE,16             ;DIG CODE LAST MADE!
        .BSS    TMPOBJ,32            ;TEMPORARY OBJECT FROM STR_OBJ

        .TEXT

INDIAG	.EQU	40H

**************************************************************************
*                                                                        *
*          COIN TABLE                                                    *
*                                                                        *
**************************************************************************
*                                                                        *
*          The coin table is made up of the normal entries from          *
*          the pinball system, as well as some new ones that             *
*          determine start and buy-in cost, and others that              *
*          aid in the determination of a "total collection".             *
*                                                                        *
*          Left Slot Multiplier              word                        *
*          Center Slot Multiplier            word                        *
*          Right Slot Multiplier             word                        *
*          Units for Credit                  word                        *
*          Units for Bonus                   word                        *
*          Minimum Units                     word                        *
*          Credits to start                  word                        *
*          Credits to Continue               word                        *
*          Divisor in money calculation      word   0 means "OFF"        *
*                                                                        *
* --------------------------------------------------------------         *
* The above value get copied as adjustments (and are adjustable).        *
* In addition, the coin table contains help on how to arrive at          *
* the "Total Collection" for the coin audits.                            *
* --------------------------------------------------------------         *
*                                                                        *
*          Count for each Left coin          word                        *
*          Count for each Center coin        word                        *
*          Count for each Right coin         word                        *
*          Pointer to Leading text string    long                        *
*          Pointer to Following text string  long                        *
*                                                                        *
**************************************************************************
*                                                                        *
*          GET_CSPT                                                      *
*                                                                        *
*          THIS IS CALLED TO RETURN IN A6 THE CURRENT                    *
*          CSELCT LINE AS STORED IN THE ADJUSTMENT TABLE.                *
*                                                                        *
**************************************************************************
GET_CSPT:
	MMTM    SP,A0
        MOVI    ADJPRICE,A0
        CALLA   GET_ADJ         ;GET THE COIN SELECT NUMBER BEING USED.
        CALLR   CS_POINT
	MMFM    SP,A0
	RETS
	
**************************************************************************
*                                                                        *
*          CS_POINT                                                      *
*                                                                        *
*          THIS IS CALLED TO POINT AT AN ENTRY IN THE COINAGE            *
*          SELECT TABLE.                                                 *
*                                                                        *
*          IT TAKES OFFSET IN A0.                                        *
*          IT RETURNS POINTER IN A6.                                     *
*                                                                        *
**************************************************************************
CS_POINT:
	MMTM    SP,A0,A1
        MOVE    A0,A0           ;ZERO?
        JRZ     CS1             ;YEP...RETURN FIRST LINE

        CMPI    CS_ENTS,A0      ;IN RANGE?
        JRLS    CS2             ;YEP...CONTINUE
        MOVI    1,A0            ;TOO LARGE.......USE 1ST LINE.

CS2:
	DEC     A0              ;INDEX INTO TABLE
CS1:
        MOVI    CS_SIZE,A1      ;SIZE PER ENTRY
        MPYU    A0,A1           ;OFFSET INTO TABLE
        ADDI    CSELCT,A1
        MOVE    A1,A6           ;RETURN THE POINTER
	MMFM    SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
*          CKPROMPT                                                      *
*                                                                        *
*          IS THERE A PROMPT STRING FOR THE CREDITS PAGE.                *
*                                                                        *
*                                                                        *
*          A0 RETURNS:                                                   *
*                                                                        *
*          YES.....RETURN POINTER TO SOMETHING                           *
*          NO......RETURN ZERO                                           *
*                                                                        *
*          IF A0 HAS A POINTER THEN....                                  *
*                                                                        *
*          IF A1 = 0 THEN A0 IS AN L_MESS STRING THAT SHOULD             *
*          JUST BE SENT OUT.                                             *
*                                                                        *
*          IF A1 .NE. 0 THEN A0 IS A POINTER LIST OF UP TO 2 MESSAGES.   *
*          THAT GIVE PRICING INFO                                        *
*                                                                        *
*        A1 = 0 PLOT THE A0 STRING OUTRIGHT USING L_MESS                 *
*               (IT CONTAINS ALL DATA)                                   *
*                                                                        *
*        A1 = 1  PLOT ONLY THE STRING LIST (1 OR 2 POINTERS              *
*                CENTERED APPROPRIATELY                                  *
*                                                                        *
*        A1 = 2  PLOT THE 1ST LINE OF THE STRING LIST ALONG              *
*                WITH THE 2 CREDITS TO START...1 TO CONTINUE             *
*                                                                        *
*        A1 = 3  PLOT THE 2ND LINE OF THE STRING LIST ALONG              *
*                WITH THE 2 CREDITS TO START...1 TO CONTINUE             *
*                                                                        *
*        A1 = 4  PLOT THE 3RD LINE OF THE STRING LIST ALONG              *
*                WITH THE 2 CREDITS TO START...1 TO CONTINUE             *
*                                                                        *
*        A1 = 5  PLOT THE 1ST LINE OF THE STRING LIST ALONG              *
*                ALONG WITH 2 COINS PER PLAYER                           *
*                                                                        *
*        A1 = 6  PLOT THE 2ND LINE OF THE STRING LIST ALONG              *
*                ALONG WITH 2 COINS PER PLAYER                           *
*                                                                        *
*        A1 = 7  PLOT THE 3RD LINE OF THE STRING LIST ALONG              *
*                ALONG WITH 2 COINS PER PLAYER                           *
*                                                                        *
*        A1 = 8  CUSTOM MESSAGE                                          *
*                                                                        *
**************************************************************************
                                                                       
CKPROMPT:
	MMTM    SP,A6
	MOVI    ADJFREPL,A0           ;FREE PLAY NEEDS NO PROMPT
        CALLA   GET_ADJ
        JRZ     CKP1                 ;NOT FREE PLAY

RET_NO:
	CLR     A0                   ;IT IS FREE PLAY.
        JRUC    CKEXIT               ;RETURN NO TOP PROMPT

CKP1:
	CALLA   CK_MAX                ;ARE WE AT MAX CREDITS?
        JRHS    RET_MAX
*
*       ARE WE ADJUSTED TO NOT BE SPECIFIC?
*
        MOVI    ADJNOCPAG,A0
        CALLA   GET_ADJ              ;CHECK THE ADJUSTMENT
        JRNZ    CKSPCASE             ;WE'RE SET TO SHUT UP...JUST START/CONT

        MOVI    ADJ1ST6,A0           ;HAS OPERATOR MESSED AROUND?
        CALLA   GET_ADJ
        JRZ     CKSPCASE             ;YEP...GO FOR GENERIC "2 TO START"
*
*       OPERATOR IS USING CANNED COINAGE....WE NEED TO USE THE
*       CHECK IF ITS 2/1 OR 2/2
*
        CALLR   CK_2_CRED            ;IS IT A 2 CREDIT MODE?
        JRZ     NOT_2_MODE           ;NOPE...PRINT STOCK STUFF

        MOVE    A0,A1                ;COPY 2/1   2/2 CODE
        CALLA   GET_CSPT             ;POINT A6 AT CSEL FOR US NOW.
        MOVE    *A6(CS_PICK),A0,W    ;GET INDICATION OF WHICH LINE
        JRZ     CKSPCASE             ;IT SAYS JUST ENUMERATE THE MODE!
*
*       NOW....IF ITS 2/1, A0 HAS THE CORRECT RETURN CODE
*       IF ITS 2/2 WE NEED TO ADD 2
*
        CMPI    1,A1                 ;IS IT 2/1?
        JRZ     RET_A0_VAL           ;A0 IS SET   (ITS 2/1)

        ADDI    3,A0
        JRUC    RET_A0_VAL           ;RETURN THIS!

NOT_2_MODE:
        CALLA   GET_CSPT             ;POINT A6 AT CSEL FOR US NOW.
        MOVE    *A6(CS_PROMPT),A0,L  ;FETCH POINTER TO MESSAGE (IF ANY)
        JRZ     CKSPCASE
*
*       WE HAVE SOMETHING STORED AT THE PROMPT.
*
        CMPI    CSM_LAST,A0          ;IS IT LITTLE?
        JRHI    CKEXIT               ;NOPE....ITS A POINTER....RETURN L_MESS STATUE

RET_A0_VAL:
        MOVE    A0,A1                ;ITS LITTLE...RETURN IT AS A CODE
        MOVE    *A6(CS_LIST),A0,L    ;PASS BACK MESSAGE LIST FOR THIS MODE
        JRUC    CK_BYE

CKEXIT:
	CLR     A1                   ;NO FANCIES YET
CK_BYE:
	MOVE    A0,A0                ;FLAG PARM
        MMFM    SP,A6
	RETS
*
*       CONTROL COMES HERE IF IT LOOKS LIKE NO MESSAGE IS
*       APPROPRIATE....CHECK FOR 2 TO START 1 TO CONTINUE
*       GENERIC NEEDED.
*
CKSPCASE:
	CALLR   CK_2_CRED            ;CHECK IF THERE ARE 2 CREDIT MODES.
        JRZ     RET_NO               ;NOT A 2 CREDIT MODE.

        CMPI    1,A0
        JRZ     TWO_ONE         ;YEP...RETURN 2/1
*
*       MUST BE 2/2
*
        MOVI    TWO_CRED_PER_PLAYER,A0
        JRUC    CKEXIT          ;RETURN IT!

TWO_ONE:
	MOVI    TWO_TO_START,A0
        JRUC    CKEXIT

RET_MAX:
	MOVI    MAX_C_M,A0
        JRUC    CKEXIT

**************************************************************************
*                                                                        *
*          CK_2_CRED                                                     *
*                                                                        *
*          THIS IS CALLED TO SEE IF WE'RE IN A 2-CREDIT TO               *
*          START MODE.                                                   *
*                                                                        *
*          A0 = 0     NOT 2/1 OR 2/2 CREDIT MODE                         *
*          A0 = 1     2 TO START 1 TO CONTINUE                           *
*          A0 = 2     2 TO START 2 TO CONTINUE                           *
*                                                                        *
*          .EQ.            NOT 2/1 OR 2/2 CREDIT MODE                    *
*          .NE.            IS 2/1 OR 2/2 CREDIT MODE.                    *
*                                                                        *
**************************************************************************
CK_2_CRED:
        MOVI    ADJCSTRT,A0
        CALLA   GET_ADJ         ;HOW MANY TO START
        CMPI    2,A0
        JRNZ    NOT_2           ;NOT 2....RETURN NO MESSAGE.

        MOVI    ADJCCONT,A0
        CALLA   GET_ADJ         ;GET CONTINUE NUMBER
        CMPI    2,A0            ;1 OR 2 THIS IS WHAT WE RETURN
        JRHI    NOT_2           ;NOT .....CLEAR IT OUT
        MOVE    A0,A0           ;RETURN .NE. (UNLESS ITS 2/0)
        JRUC    IS_2

NOT_2:
	CLR     A0              ;RETURN WRONG MODE
IS_2:
	RETS

**************************************************************************
*                                                                        *
*          MENU HANDLING SOFTWARE                                        *
*                                                                        *
**************************************************************************

**************************************************************************
*                                                                        *
*          FORCE_MAIN                                                    *
*                                                                        *
*          THIS IS CALLED TO GET TO MAIN MENU FROM LEVEL FURTHER         *
*          THAN 1 DOWN.  IT SETS THE GLOBAL FLAG "MAIN_RET"              *
*          NON ZERO.  GEN_MENU WILL KEEP RETURNING UNTIL                 *
*          IT GETS BACK TO THE MAIN MENU.                                *
*                                                                        *
**************************************************************************
FORCE_MAIN:
        MOVK    1,A0                 ;POSITIVE NUMBER FORCES MAIN MENU.
        MOVE    A0,@MAIN_RET,W
        RETP                         ;NOW "RETURN TO THE MENU"

**************************************************************************
*                                                                        *
*         DIAGNOSTIC TESTS SELECTED......SHOW DIAGNOSTIC TEST MENU       *
*                                                                        *
**************************************************************************
GO_DIAG:
	MOVI    MEN_DIAG,A8          ;PUT UP THE MENU AND GO!
        JAUC    GEN_MENU             ;THIS WILL RETURN TO LEVEL ABOVE US!

CASHBUT:
	MOVE	@GAMSTATE,A0,W
	CMPI	INDIAG,A0
	JRNZ	CB_JUMP
	JAUC	SUCIDE               ;EXIT DIAGNOTICS

CB_JUMP:
	
	CALLA   DIGSRT               ;GET US INTO TEST MODE!
        JSRP    GO_BOOK              ;DO THE "COIN BOOKKEEPING STUFF"
        JAUC    DIAG_EX

**************************************************************************
*                                                                        *
*         COIN BOOKKEEPING SELECTED                                      *
*                                                                        *
**************************************************************************
GO_BOOK:
	CALLA   CLR_SCRN
        MOVI    MES_BOOK,A2
        MOVI    ROBO_WHITE,A3
        JSRP    TOP_BOX              ;PRINT TITLE BOX.

        MOVI    COIN_AUDS,A0         ;PUT TABLE UP.
        JSRP    PRNT_AUD

        MOVI    COIN_A2,A0           ;PUT PART 2 OF THE TABLE THERE.
        JSRP    PRNT_AUD

        MOVI    MEN_DETAIL,A8
        MOVI    1,A9                 ;CURSOR ON 1ST ENTRY
        JSRP    B_MENU               ;SEE IF THEY WANT PAGE 2.

        CMPI    1,A8                 ;DID WE GET 1'ST ENTRY?
        JRNZ    NO_DETAIL            ;NOPE...RETURN TO OUR CALLER

DETAIL_SCREEN:
        CALLA   CLR_SCRN             ;CLEAR OUT FOR ACTION!

        MOVI    DT_Y1,A0             ;HEIGHT OF TOP TITLE
        MOVI    ROBO_YELLOW,A9      ;COLOR
        CALLA   F_TITLE              ;FRAME IT

        MOVI    DT_Y2,A0             ;HEIGHT OF 2ND TITLE
        CALLA   F_TITLE              ;FRAME IT

        MOVI    DETAIL_TITLES,A8     ;NO ROOM FOR PRETTY TOP BOX...DO TITLES
        JSRP    L_MESS               ;ESTABLISH THE TITLES.

        MOVI    COIN_D1,A0           ;DETAILED AUDIT 1
        JSRP    PRNT_AUD             ;PRINT IT

        MOVI    AUDLCOIN,A8          ;NOW PRINT MONEY FOR 1ST 3
        JSRP    PRINT_COL          

        MOVI    AUDLCSUB,A8          ;SUB-TOTAL OF TOTAL MONEY
        JSRP    PRINT_SUBTOTAL       ;PRINT IT.

        MOVI    COIN_D2,A0           ;DETAILED AUDIT 2
        JSRP    PRNT_AUD

        MOVI    AUDLCDC,A8           ;NOW PRINT MONEY FOR DOOR CLOSED SET
        JSRP    PRINT_COL

        MOVI    AUDLCDCS,A8          ;NOW PRINT SUB-TOTAL FOR DOOR CLOSED
        JSRP    PRINT_SUBTOTAL       ;THATS IT!

        MOVI    MEN_CLR_SUB,A8       ;CLEAR SUBTOTAL OR RETURN TO MAIN MENU
        MOVI    2,A9                 ;CURSOR ON 2ND ENTRY
        JSRP    B_MENU               

        CMPI    1,A8                 ;CHOICE 1 IS CLEAR.....
        JRNZ    NO_CLEAR_SUB         ;NOPE...RETURN TO CALLER!

        MOVI    MESS_CLEAR_SUBS,A8   ;CLEAR COIN SUB-TOTALS...ARE YOU SURE
        MOVI    CLR_SUBS,A9          ;ROUTINE TO DO IT
        MOVI    MESS_SUBS_CLEAR,A10  ;CONFIRMATION.
        JSRP    AREUSURE             ;ASK EM.
        JRUC    DETAIL_SCREEN        ;NOW PUT THIS SCREEN BACK UP.

NO_CLEAR_SUB:
NO_DETAIL:
        RETP                         ;AND RETURN TO OUR CALLER.

PRINT_SUBTOTAL:
         CALLR   ADD_AUDIT_DY         ;PUSH THE Y 1 LEVEL
         MOVI    T_SUB,A9             ;USE "SUB-TOTAL" MESSAGE
         JAUC    PRINT_MONEY          ;AND NOW PRINT THE REQUESTED SUM.

**************************************************************************
*                                                                        *
*          GAME AUDITS SELECTED                                          *
*                                                                        *
**************************************************************************

**************************************************************************
*                                                                        *
*          AUDITS TO BE SHOWN ON GAME AUDITS PAGE:                       *
*                                                                        *
*          EXTRA MEN                                                     *
*          GAMES COMPLETED                                               *
*          1 PLAYER MINUTES                                              *
*          2 PLAYER MINUTES                                              *
*          TOTAL HOURS PLAYED                                            *
*          AVG "PLAYER" GAME TIME                                        *
*          AVG. ELAPSED TIME / PLAY                                      *
*                                                                        *
**************************************************************************

GO_AUD:
	CALLA   CLR_SCRN
        MOVI    MES_AUD,A2
        MOVI    ROBO_CYAN,A3
        JSRP    TOP_BOX              ;PRINT TITLE BOX.

        MOVI    GAME_AUDS,A0         ;PUT TABLE UP.
        JSRP    PRNT_AUD

        MOVI    MEN_AP1,A8           ;AUDIT PAGE 1 MENU
        MOVI    1,A9                 ;CURSOR ON 1ST ENTRY
        JSRP    B_MENU               ;SEE IF THEY WANT PAGE 2.

        CMPI    1,A8                 ;DID WE GET 1'ST ENTRY?
        JRNZ    NO_AP2               ;NOPE...RETURN TO OUR CALLER
        
        CALLA   CLR_SCRN
        MOVI    MES_AUD,A2
        MOVI    ROBO_CYAN,A3
        JSRP    TOP_BOX              ;PRINT TITLE BOX.

        MOVI    GAME_AUD2,A0         ;PUT TABLE UP.
        JSRP    PRNT_AUD

        MOVI    MEN_AP2,A8
        MOVI    2,A9                 ;CURSOR ON 2ND ENTRY
        JSRP    B_MENU               ;SEE IF THEY WANT PAGE 2.

        CMPI    1,A8                 ;DID WE GET 1'ST ENTRY (RETURN TO PAGE 1)
        JRZ     GO_AUD               ;YEP...PUT IT UP!

NO_AP2:
	RETP

GO_UTIL:
	MOVI    MEN_UTIL,A8
        JAUC    GEN_MENU             ;PROCESS THE UTILITY MENU!
*
*       INDIVIDUAL UTILITY PROGRAMS
*

DO_CLCRED:
        MOVI    MESS_CLCRED,A8       ;CLEAR COIN SUB-TOTALS...ARE YOU SURE
        MOVI    CLR_CREDITS,A9       ;ROUTINE TO DO IT
        MOVI    MESS_CCCONF,A10      ;CONFIRMATION.
        JAUC    AREUSURE             ;ASK EM......THEN RETURN!

**************************************************************************
*                                                                        *
*          CLR_CREDITS                                                   *
*                                                                        *
*          ROUTINE TO CLEAR OUT THE CREDITS POSTED ON THE GAME.          *
*                                                                        *
**************************************************************************
CLR_CREDITS:
        CALLA   NO_CREDS             ;CALL THE ROUTINE THAT DOES IT
        RETP

DO_CLCOIN:
        MOVI    MESS_CLCOIN,A8       ;CLEAR COIN SUB-TOTALS...ARE YOU SURE
        MOVI    CLR_COINS,A9       ;ROUTINE TO DO IT
        MOVI    MESS_CCNCONF,A10      ;CONFIRMATION.
        JAUC    AREUSURE             ;ASK EM......THEN RETURN!

CLR_COINS:
        MOVI    FRST_C,A0
        MOVI    LAST_C,A1
        CALLA   CLR_AUDR
        RETP

DO_CLAUD:
        MOVI    MESS_CLAUD,A8       ;CLEAR COIN SUB-TOTALS...ARE YOU SURE
        MOVI    CLR_AUDITS,A9       ;ROUTINE TO DO IT
        MOVI    MESS_CAUDCONF,A10      ;CONFIRMATION.
        JAUC    AREUSURE             ;ASK EM......THEN RETURN!

CLR_AUDITS:
        MOVI    FRSTGAUD,A0
        MOVI    LASTGAUD,A1
        CALLA   CLR_AUDR
        CALLA   DUMP_FS              ;AND START THE "DUMP" RECORDS OVER
        RETP

DO_HSRES:
        MOVI    MESS_HSRESET,A8
        MOVI    HSSOFT,A9
        MOVI    MESS_HSRCONF,A10
        JAUC    AREUSURE

HSSOFT:
	CALLR   RES_ALL
        RETP                         ;PROGRAM TO DO THE JOB!

**************************************************************************
*                                                                        *
*          RES_ALL                                                       *
*                                                                        *
*          RESET ALL TIME HIGH SCORE TABLE AND THE                       *
*          HIGH SCORE RESET COUNTER.                                     *
*                                                                        *
**************************************************************************
RES_ALL:
	MOVI    ALL_TAB,A8           ;ALWAYS CLEAR OUT TODAYS TABLE
        CALLA   INIT_TB
        CALLA   INIT_HSR             ;RE-SET THE HIGH SCORE RESET COUNTER
        RETS

DO_FACSET:
         MOVI    MESS_FACSET,A8
         MOVK    1,A0
         JRUC    DEF_ADJ_PART

**************************************************************************
*                                                                        *
*          DO_DEF_ADJ      THIS IS CALLED FROM UTILITY MENU TO           *
*                          DO THE DEFAULT ADJUSTMENTS.                   *
*                                                                        *
*          DEF_ADJ_PART    THIS IS CALLED OUT OF THE FULL                *
*                          FACTORY SETTING TO HANDLE THE                 *
*                          ADJUSTMENT PART.                              *
*                                                                        *
*                          A8 MUST HAVE THE MESSAGE FOR "ARE YOU SURE"   *
*                          A0 .NE. 0 FOR FULL FACTORY SETTINGS (ON       *
*                                    SUCCESS OF ADJUSTMENT PART          *
*                                                                        *
**************************************************************************
DO_DEF_ADJ:
        MOVI    MESS_DEF_ADJ,A8
        CLR     A0

DEF_ADJ_PART:
        MOVE    A0,@FAC_FLAG,W       ;INDICATE THIS IS ADJUSTMENTS ONLY
        MOVI    DEFADJSOFT,A9
        MOVI    NULL_ST,A10          ;DON'T PRINT ANYTHING....ROUTINE WILL.
        JSRP    AREUSURE
        RETP

DEFADJSOFT:
*
*       NOW SMASH THE CHECKSUM
*
        CALLA   FORM_ADC               ;FORM THE CKSUM
        MOVE    A1,A0                  ;PUT IN CMOS WRITING REGGIE
        MOVI    ADJ_CKSUM,A7
        INC     A0                     ;THIS SMASHES ADJUSTMENTS
        CALLA   WC_WORD                ;AND STORE IT
*
*       NOW MAKE SURE ITS SMASHED
*
        CALLA   CMOS_VAL
        JRZ     AD_FAIL                ;WE CAN'T DO IT.....PRINT FAILURE.
*
*       NOW SET THE ADJUSTMENTS TO THE FACTORY VALUE.
*
        CALLA   FAC_SET             ;THIS DOES THE DEED!
        CALLA   CMOS_VAL            ;IS IT OK NOW?
        JRNZ    AD_FAIL             ;NOPE...PRINT FAILURE

        MOVI    MESS_DEFCONF,A8     ;THIS IS SINGLE MESSAGE

        MOVE    @FAC_FLAG,A0,W      ;DO WE NEED TO CLEAR THE TABLES?
        JRZ     DAX                 ;NOPE...POST SINGLE MESSAGE

        CALLA   CLR_SCRN        ;CLEAR THE SCREEN FOR OUR MESSAGES.
        CALLR   FAC_STUF        ;DO AUDITS AND HIGH SCORE TABLE

        MOVI    MESS_FFSCONF,A8 ;PRINT THE REST OF THE MESSAGES
        JSRP    L_MESS          ;THAT DOES IT!

NOTABS:
	RETP

*
*       ON A FULL FACTORY SETTING (EITHER REQUESTED OR
*       ADJUSTMENT FAILURE) THIS CLEARS THE AUDITS AND
*       HIGH SCORE TABLE.
*
FAC_STUF:
	CALLA   CLR_AUD         ;CLEAR AUDITS TOO
        CALLR   RES_ALL         ;ALL TIME TABLE
        RETS

AD_FAIL
	MOVI    MESS_FACFAIL,A8
        JRUC    DAX

DEF_CAN:
	MOVI    MESS_CANCELLED,A8
DAX:
	CALLA   CLR_SCRN
        JSRP    SUR_MESS
        RETP
**************************************************************************
*                                                                        *
*          EXIST_LET                                                     *
*                                                                        *
*          IS THE E_INITS PROCESS RUNNING?                               *
*                                                                        *
**************************************************************************
EXIST_LET:
        MOVI    OPMES_PID,A0                   ;SETUP FOR THE EXISTP
        MOVI    0FFFFH,A1
        JAUC   EXISTP
**************************************************************************
*                                                                        *
*          BUILD_ST                                                      *
*                                                                        *
*          THIS IS CALLED TO TAKE THE STRING POINTED TO                  *
*          BY -A10- AND REMOVE LEADING AND TRAILING BLANKS               *
*          AND MOVE THE STRING TO "STRNGRAM".                            *
*                                                                        *
*          RETURN THE NUMBER OF TRAILING BLANKS IN A2.                   *
*          RETURN .EQ. IF ALL BLANK!                                     *
*                                                                        *
**************************************************************************
BUILD_ST:
        MMTM    SP,A0,A1,A3,A4,A5,A10
        CLR     A4                     ;A4 = ZERO UNTIL 1ST NON-BLANK
        MOVI    STRNGRAM-BYTE_SIZE,A5  ;LAST NON-SPACE CHAR
        MOVI    STRNGRAM,A1          ;DESTINATION POINTER
        MOVI    CMESS_CHARS,A2       ;CHAR COUNT

BSLOOP:
	MOVB    *A10,A3              ;FETCH A BYTE
        ANDI    BYTE_MASK,A3         ;KILL SIGN EXTEND.
        JRNZ    BS1                  ;NOT ZERO
        MOVI    SPACE,A3             ;REPLACE ZERO WITH SPACE.

BS1:
	CMPI    SPACE,A3             ;IS IT A SPACE?
        JRZ     BS2                  ;IT IS...
*
*       NON-SPACE CHARACTER
*
        OR      A3,A4                ;INDICATE 1ST NON-BLANK SEEN
        MOVE    A1,A5                ;INDICATE THIS IS CURRENT TERMINATOR.
        JRUC    BS3

BS2:
        MOVE    A4,A4                ;HAS 1ST SPACE BEEN SEEN?
        JRZ     BS4                  ;NOT YET...DON'T STORE
BS3:
        MOVB    A3,*A1               ;STORE IT IN MEMORY
        ADDI    BYTE_SIZE,A1         ;PUSH DESTINATION POINTER
BS4:
        ADDI    BYTE_SIZE,A10        ;PUSH SOURCE POINTER
        DSJS    A2,BSLOOP            ;AND FINISH PARSE
*
*        A5 NOW POINTS AT LAST NON-BLANK CHARACTER
*
        ADDI    BYTE_SIZE,A5         ;THIS IS 1 BEYOND
        CLR     A2
        MOVB    A2,*A5               ;TERMINATE WITH A ZERO.
*
*       FOR OUR RETURN, WE NEED TO COMPUTE THE NUMBER OF 
*       TRAILING SPACES IGNORED.
*
        MOVE    A4,A4                ;ALL BLANK?
        JRNZ    NOT_BLNK
        MOVI    CMESS_CHARS,A2       ;ALL CHARS ARE TRAILING BLANKS
        JRUC    BL_EX                ;RETURN THIS

NOT_BLNK:
        MOVE    A1,A2                ;THIS IS LAST CHAR WE WROTE
        SUB     A5,A2                ;THIS IS NUMBER OF TRAILING SPACES (TIMES 8)
        SRL     3,A2                 ;DIVIDE BY 8 TO GET SPACES
BL_EX:
        MOVE    A4,A4                ;FLAG ZERO FOR ALL BLANK!
	MMFM    SP,A0,A1,A3,A4,A5,A10
	RETS

* A1 = <COLOR><PALETTE>
* A3 = DAG OF AREA [YPOS,XPOS]						 
* A4 = [Y,X] SIZE OF AREA						 

GO_RED:
	MOVI    ROBO_RED,A1
        JAUC    SC_COL

GO_GREEN:
        MOVI    ROBO_GREEN,A1
        JAUC    SC_COL

GO_BLUE:
	MOVI    ROBO_BLUE,A1
SC_COL:
	SLL     16,A1                ;PALETTE 0....COLOR UP HIGH
        CLR     A3                   ;UPPER LEFT 
        MOVI    19001FFH,A4
        CALLA   FILLAREA             ;THIS DOES THE SCREEN
        JAUC    WAIT_BUT             ;NOW WAIT FOR ANY BUTTON!

GO_CPUTEST:
	JAUC	CPU_CHK
	
GO_CROSS:
	CALLA	SCRCLR
	CALLA	CROSS_H
        JAUC    WAIT_BUT             ;NOW WAIT FOR ANY BUTTON!
;	JSRP	WAIT_BUT
;	CALLA	SCRCLR
;	CALLA	MYOINIT
;	RETP

GO_SWTEST:  
	CALLA	SCRCLR
	JSRP	SW_CHK
;	CALLA	SCRCLR
;	CALLA	MYOINIT
	RETP
	
;GO_ROMTEST:
;	JAUC	ROM_CHK

GO_BARS:
;	MOVI	8000H,A1
;	CLR	A0
;	CALLA	KILALL
	CALLA	SCRCLR
	MMTM	SP,A12,A13
	CALLA	COL_BARS
	MMFM	SP,A12,A13
        JAUC    WAIT_BUT             ;NOW WAIT FOR ANY BUTTON!
;	JSRP	WAIT_BUT
;	CALLA	SCRCLR
;	CALLA	MYOINIT
;	CALLA	COLRSTRT
;	RETP

DO_BURN:  
        MOVI    MESS_BURN,A8         ;CLEAR COIN SUB-TOTALS...ARE YOU SURE
        MOVI    BURN_IN,A9           ;ENTRY POINT
        MOVI    MESS_BURN,A10        ;THIS WILL NEVER BE SEEN!
        JAUC    AREUSURE             ;ASK EM.

ANY_BUT:
        MOVI    ANY_MENU,A8          ;ANY BUTTON TO CONTINUE
        MOVI    1,A9                 ;CURSOR ON ENTRY 1
        JAUC    B_MENU               ;DO IT....RETURN WHEN PRESSED.

*
*       DIAGNOSTIC TESTS
*
*
*SOUND TEST STUFF
*
NCHAN		EQU	4	;DECLARE NUMBER OF ALLOWED CHANNELS
MUSICHAN	EQU	3	;THIS CHANNEL IS FOR THE TUNES

*THESE STROBE EQUATES ARE FOR THE PINBALL SOUND CARD
RESETBIT	EQU	0FE00H	;THIS IS THE ^RESET BIT
MUSICBIT	EQU	0FD00H	;THIS IS THE YAMAHA SIDE STROBE
SOUNDBIT	EQU	0FD00H	;THIS IS THE SOUND SIDE STROBE

GO_STEST:
SNDTST
	MOVI	SNDMES,A8 	;MESSAGE POINTER
SNDTLP
	CALLA	SCRCLR
	MOVI	M_STEST,A0 	;SOUND TEST MESSAGE
	MOVI	>6080,A1
	CLR	A2
	MOVI	ROBO_WHITE,A3
	CALLA	STRNEW1
	MOVI	>B080,A1	;SCREEN ADDRESS
	MOVE	A8,A0
	CALLA	STRNEW1
	ADDK	8,A0
	MOVB	*A0,A5
	ADDK	8,A0
	MOVB	*A0,A3
	ADDK	8,A0
	CALLA	SNDSND
	MOVE	A0,A8
	SLEEP	120
	
	MOVB	*A8,A5
	JRNE	SNDTLP
	RETP
*
*SOUND TABLE
*MESSAGE,CHANNEL,SOUNDCODE
*
SNDMES	
	.STRING	"TUNE 1  SOUND 01",0
	.BYTE  	MUSICHAN,>01
	.STRING	"NO WAY SOUND 3F",0
	.BYTE	0,>3F
	.STRING	"ELECTROSHOCK SOUND CF",0
	.BYTE   0,>CF
	.STRING	"TUNE 2 SOUND 09",0
	.BYTE  	MUSICHAN,>09
	.STRING "MUSIC OFF SOUND 00",0
	.BYTE	MUSICHAN,>00
	.BYTE	0		;THE END OF TABLE
	.EVEN

**************************************************************************
*                                                                        *
*          MONITOR PATTERNS                                              *
*                                                                        *
**************************************************************************
GO_PATTERNS:
        MOVI    MEN_PATTERNS,A8      ;PUT UP THE MENU AND GO!
        JAUC    GEN_MENU             ;THIS WILL RETURN TO LEVEL ABOVE US!

*******************************************************************************
*******************************************************************************
*******************************************************************************
*
*              A   U   D   I   T        D   I   S   P   L   A   Y   S
*
*******************************************************************************
*******************************************************************************
*******************************************************************************
**************************************************************************
*                                                                        *
*          AUDIT TABLE STRUCTURE                                         *
*                                                                        *
**************************************************************************
AUD_MESS         EQU     0                      ;LONG-PTR TO TEXT
AUD_ROUTINE      EQU     AUD_MESS+LONG_SIZE     ;LONG - NON ZERO MEANS CALL FOR NUMBER
AUD_NUMBER       EQU     AUD_ROUTINE+LONG_SIZE  ;WORD - IF ABOVE ZERO, THEN AUDIT NUMBER
AUD_T_SIZE       EQU     AUD_NUMBER+WORD_SIZE

AMAC     $MACRO  MESS,ROUT,AUDIT
         .LONG   :MESS:
         .LONG   :ROUT:
         .WORD   :AUDIT:
         $END

AUD_LM           EQU     TIT_ULX      ;SQUARE OFF AUDITS W/ HEADER.
AUD_RM           EQU     TIT_LRX
AUD_Y_START      EQU     39H
AUD_DY           EQU     11H

CP2_Y            EQU     142           ;PART 2 OF COIN AUDIT PAGE.
*
*        TOP HALF OF COIN AUDIT PAGE 1 TABLE
*
COIN_AUDS:      
         .WORD   AUD_Y_START           ;Y START
         .WORD   AUD_DY                ;Y BETWEEN ENTRIES
         .WORD   AUD_LM                ;LEFT MARGIN X
         .WORD   AUD_RM                ;RIGHT MARGIN X
         AMAC    M_LCOIN,0,AUDLCOIN
         AMAC    M_CCOIN,0,AUDCCOIN
         AMAC    M_RCOIN,0,AUDRCOIN
         AMAC    M_PAIDC,0,AUDPAIDC
         .LONG   0
*
*        BOTTOM HALF OF COIN AUDIT PAGE 1 TABLE
*
COIN_A2  .WORD   CP2_Y                 ;Y START
         .WORD   AUD_DY                ;Y BETWEEN ENTRIES
         .WORD   AUD_LM                ;LEFT MARGIN X
         .WORD   AUD_RM                ;RIGHT MARGIN X
         AMAC    M_START,STARTS,0
         AMAC    M_CONT,CONTINS,0
         AMAC    M_PLAYS,DOPLAYS,0
         AMAC    M_HSLEFT,DOHSLEFT,0
         .LONG   0

**************************************************************************
*                                                                        *
*          COIN_D1                                                       *
*                                                                        *
*          THIS IS TOP HALF OF DETAILED COIN AUDIT PAGE                  *
*          ITS THE SAME AS THE OTHER COIN PAGE WITH THE Y POSITIONING    *
*          A LITTLE DIFFERENT                                            *
*                                                                        *
**************************************************************************
COIN_D1:
         .WORD   39H                   ;Y START
         .WORD   11H                   ;Y BETWEEN ENTRIES
         .WORD   AUD_LM                ;LEFT MARGIN X
         .WORD   AUD_RM                ;RIGHT MARGIN X
         AMAC    M_LCOIN,0,AUDLCOIN
         AMAC    M_CCOIN,0,AUDCCOIN
         AMAC    M_RCOIN,0,AUDRCOIN
         .LONG   0
*
*        DOOR CLOSED AUDITS.
*
COIN_D2:
         .WORD   090H                  ;Y START
         .WORD   11H                   ;Y BETWEEN ENTRIES
         .WORD   AUD_LM                ;LEFT MARGIN X
         .WORD   AUD_RM                ;RIGHT MARGIN X
         AMAC    M_LCOIN,0,AUDLCDC
         AMAC    M_CCOIN,0,AUDCCDC
         AMAC    M_RCOIN,0,AUDRCDC
         .LONG   0

**************************************************************************
*                                                                        *
*          GAME PLAY AUDIT SCREEN                                        *
*                                                                        *
**************************************************************************
GAME_AUDS:
         .WORD   3DH                   ;Y START
         .WORD   15H                   ;Y BETWEEN ENTRIES
         .WORD   AUD_LM                ;LEFT MARGIN X
         .WORD   AUD_RM                ;RIGHT MARGIN X
         AMAC    M_PLAYS,DOPLAYS,0     ;PLAYS ON TOP
         AMAC    M_EXTRA,0,AUDEXTRA    ;EXTRA MEN EARNED
         AMAC    M_P1MIN,DO_P1MIN,0
         AMAC    M_P2MIN,DO_P2MIN,0
         AMAC    M_HOURS,DO_HOURS,0
         AMAC    M_AVGT,DO_AVGT,0
         AMAC    M_ELAPSE,DO_ELAPSE,0
         .LONG   0

GAME_AUD2
         .WORD   35H                   ;Y START
         .WORD   10H                   ;Y BETWEEN ENTRIES
         .WORD   AUD_LM                ;LEFT MARGIN X
         .WORD   AUD_RM                ;RIGHT MARGIN X
         AMAC    M_START2,0,AUDWAVE1    ;SHOULD BE WAVE 1 CIRCUIT 1 STARTS
         AMAC    M_WAVE1,0,AUDWAVE2	;REACHED WAVE 2 OF CIRCUIT 1
         AMAC    M_WAVE2,0,AUDMUTOID	;REACHED MUTOID MAN
         AMAC    M_WAVE3,0,AUDCIRC2	;REACHED CIRCUIT 2 WAVE 1
         AMAC    M_WAVE4,0,AUDSCAR	;REACHED SCAR FACE
         AMAC    M_WAVE5,0,AUDCIRC3	;REACHED CIRCUIT 3 WAVE 1
         AMAC    M_WAVE6,0,AUDTEMPL	;REACHED TEMPLE WAVES
         AMAC    M_WAVE7,0,AUDSNAKES	;REACHED SNAKE BOSS MONSTERS
         AMAC    M_WAVE8,0,AUDEND	;REACHED END OF GAME
         AMAC    M_MRBIG,0,AUDLOCK	;WATCHDOG LOCKUP
         .LONG   0


MISC_AUD
         .WORD   3DH                   ;Y START
         .WORD   15H                   ;Y BETWEEN ENTRIES
         .WORD   AUD_LM                ;LEFT MARGIN X
         .WORD   AUD_RM                ;RIGHT MARGIN X
         AMAC    M_LOCKUP,0,AUDLOCK
         AMAC    M_HIDB,0,AUDBONE	;GAMES NOT FINISHED
         AMAC    M_PLAYS,DOPLAYS,0     ;TOTAL PLAYS
         AMAC    M_P1MIN,DO_P1MIN,0
         AMAC    M_P2MIN,DO_P2MIN,0
         AMAC    M_AVGT,DO_AVGT,0
         AMAC    M_ELAPSE,DO_ELAPSE,0
         .LONG   0

*
*        THIS HAS THE OCTOPUSS STUFF SO WE CAN SHOW OUR ADJUSTMENTS
*        AND CRASH TABLE.
*
*
*        FIRST CHECK JOYSTICKS FOR LEFT ONE UP AND
*        AND RIGHT ONE RIGHT
*
HID_P:
	CALLA	MYOINIT              ;MAKE SURE A13 IS OK BEFORE ANY ACTIONS!
        CALLA   DIGSRT               ;RE-INIT THE WORLD!

        MOVI    MES_DEST,A2
        MOVI    ROBO_LF,A3
        JSRP    TOP_BOX              ;PRINT TITLE BOX.

*       A4 = UPPER LEFT Y,X                                           *
*       A5 = LOWER RIGHT Y,X                                          *
*       A6 = NUMBER OF SLICES GOING IN.                               *

        MOVI    [4EH,TIT_ULX],A4
        MOVI    [190H,TIT_LRX],A5
        MOVI    16,A6
        CALLA   G_BORDER

        MOVI    M_TEAM,A8            ;PUT UP THE DESIGN TEAM!
        JSRP    L_MESS

        JSRP    WAIT_BUT

        CALLA   CLR_SCRN             ;CLEAR IT OUT
        MOVI    MISC_AUD,A0
        JSRP    PRNT_AUD             ;PRINT IT

        JSRP    WAIT_BUT

        JSRP    DISPDUMP                                              
                                                                        
        JSRP    WAIT_MUT
        JAUC    DIAG_EX              ;NOW GET OUT!

**************************************************************************
*                                                                        *
*          PRNT_AUD                                                      *
*                                                                        *
*          THIS IS CALLED TO PRINT OUT AN AUDIT TABLE.                   *
*                                                                        *
**************************************************************************
AT_PTR   EQU     PDATA                ;LONG
AT_Y     EQU     PDATA+LONG_SIZE      ;WORD
AT_DY    EQU     AT_Y+WORD_SIZE       ;WORD
AT_LX    EQU     AT_DY+WORD_SIZE      ;WORD   LEFT MARGIN X
AT_RX    EQU     AT_LX+WORD_SIZE      ;WORD   RIGHT MARGIN X
AT_OBJ   EQU     AT_RX+WORD_SIZE      ;LONG   OBJECT POINTER FOR COLLECTION ROUT
AT_MESS  EQU     AT_OBJ+LONG_SIZE     ;LONG   PRINT_MONEY MESSAGE STASH
	
PRNT_AUD:
        MOVE    *A0+,A1,W            ;GET STARTING HEIGHT
        MOVE    A1,*A13(AT_Y),W      ;STORE

        MOVE    *A0+,A1,W            ;GET DY TO USE
        MOVE    A1,*A13(AT_DY),W     ;STASH IT AWAY

        MOVE    *A0+,A1,W            ;GET LEFT MARGIN
        MOVE    A1,*A13(AT_LX),W     ;STORE

        MOVE    *A0+,A1,W            ;GET RIGHT MARGIN
        MOVE    A1,*A13(AT_RX),W     ;STASH IT AWAY

        MOVE    A0,*A13(AT_PTR),L     ;SAVE POINTER INTO AREA

PA1:   
  	JSRP    DO_AN_AUDIT           ;PRINT OUT THE CURRENT AUDIT

        MOVE    *A13(AT_PTR),A0,L     ;GET POINTER
        ADDI    AUD_T_SIZE,A0
        MOVE    A0,*A13(AT_PTR),L     ;PUT BACK

        CALLR   ADD_AUDIT_DY

        MOVE    *A0,A1,L              ;ARE WE DONE?
        JRNZ    PA1

        RETP

**************************************************************************
*                                                                        *
*          ADD_AUDIT_DY                                                  *
*                                                                        *
*          THIS IS CALLED TO MOVE THE AUDIT Y (STORE IN                  *
*          PROCESS AREA) TO THE NEXT AUDIT BY ADDING THE                 *
*          CURRENT DY (ALSO STORED IN PROCESS AREA).                     *
*                                                                        *
**************************************************************************
ADD_AUDIT_DY:
        MMTM    SP,A1,A2
        MOVE    *A13(AT_Y),A1,W
        MOVE    *A13(AT_DY),A2,W      ;GET DELTA Y
        ADD     A2,A1                 ;MOVE THE Y DOWN
        MOVE    A1,*A13(AT_Y),W
	MMFM    SP,A1,A2
	RETS

BEGIN_AUDIT:
        MMTM    SP,A0
        CLR     A0
        MOVE    A0,@BAD_AUD,W            ;MONITOR CORRUPTION.
	MMFM    SP,A0
	RETS

DO_AN_AUDIT:
        CALLR   BEGIN_AUDIT
        MOVE    *A13(AT_PTR),A3,L        ;GET POINTER
        MOVE    *A3(AUD_ROUTINE),A4,L    ;ROUTINE TO CALL?
        JRZ     DO_BY_NUMBER             ;NOPE....DO IT BY NUMBER

        MOVI    DAA_RET,A7
	MOVE	A7,-*A12,L	;PUSH RET ADDR
        JUMP    A4              ;"CALL" THE ROUTINE

DO_BY_NUMBER:
        MOVE    *A3(AUD_NUMBER),A0,W    ;FETCH THE AUDIT NUMBER
        CALLA   GET_AUD                 ;TURN INTO AUDIT COUNT!
        MOVE    A1,A3                   ;PROTECT FOR A SECOND.

        JSRP    NUMBER_WORK             ;GET THE NUMBER IN A3 UP THERE!

DAA_RET:
  	MOVI    MESS_AUD_LINE,A8
        CALLA   LM_SETUP        ;SETUP FOR AUDIT PRINTING.

        MOVE    *A13(AT_PTR),A3,L   ;GET AUDIT POINTER
        MOVE    *A3(AUD_MESS),A8,L  ;GET TEXT POINTER

        JSRP    LEFT_FINISH
        RETP                        ;THAT'S ALL WE DO!

*
*       LEFT_FINISH   AND    RIGHT_FINISH
*
*       THESE ARE CALLED TO PUT AUDIT INFO
*       ON THE LEFT OR RIGHT SIDE ONCE A8 POINTS AT
*       THE CORRECT DATA TO PRINT
*
LEFT_FINISH:
        CALLR   TURN_RED_IF_NEC
        CALLR   SET_FOR_Y       ;SET FOR AUDIT'S Y
        CALLR   SET_LEFT_X      ;SET FOR LEFT X
        JSRP    LM_FINIS            ;AND TYPE UP THE MESSAGE!
        RETP

RIGHT_FINISH:
        CALLR   TURN_RED_IF_NEC         ;CHANGE COLOR IF CORRUPTED.
        CALLR   SET_FOR_Y               ;SET FOR AUDIT'S Y
        CALLR   SET_RIGHT_X
        JSRP    LM_FINIS               ;FINISH THE JOB!

        MOVE    @BAD_AUD,A0,W          ;IS IT CORRUPTED?
        JRZ     RFX                    ;NOPE....RETURN

        MOVI    MESS_ERROR,A8
        CALLA   LM_SETUP               ;SETUP "ERROR"

        CALLR   SET_FOR_Y              ;SET FOR AUDIT'S Y
        ADDI    40000H,A9              ;PUSH 4 Y UNITS TO CENTER 
        CALLR   SET_RIGHT_X
        JSRP    LM_FINIS               ;FINISH THE JOB!

RFX:    
  	RETP

TURN_RED_IF_NEC:
        MMTM    SP,A3
        MOVE    @BAD_AUD,A3,W   ;CHANGE TO RED?
        JRZ     DAA_1           ;NOPE...ITS OK!

        MOVI    ROBO_RED,A6    ;CHANGE COLOR TO RED
	                              
DAA_1:
	MMFM    SP,A3
	RETS
                              
SET_FOR_Y:
        MMTM    SP,A3
        MOVE    *A13(AT_Y),A3,W   ;GET Y COORDINATE
        SLL     16,A3             ;PUT IT IN POSITION
        MOVY    A3,A9             ;PUT IT IN PLACE
	MMFM    SP,A3
	RETS

SET_LEFT_X:
        MMTM    SP,A3
        MOVE    *A13(AT_LX),A3,W
        MOVX    A3,A9             ;PUT THE X IN PLACE
	MMFM    SP,A3
	RETS

SET_RIGHT_X:
        MMTM    SP,A3
        MOVE    *A13(AT_RX),A3,W
        MOVX    A3,A9             ;PUT THE X IN PLACE
	MMFM    SP,A3
	RETS

**************************************************************************
*                                                                        *
*          NUMBER_WORK                                                   *
*                                                                        *
*          A3 HAS THE NUMBER TO DISPLAY.....DO IT!                       *
*                                                                        *
**************************************************************************
NUMBER_WORK:
        MOVI    MESS_AUD_NUM,A8         ;SETUP FOR AUDIT NUMBER
        CALLA   LM_SETUP

        MOVE    A3,A8                   ;NOW WE HAVE BINARY NUMBER
        CALLA   HEXTOASC                ;NOW WE POINT TO THE STRING.

        JSRP    RIGHT_FINISH

        RETP

**************************************************************************
*                                                                        *
*          GET_STARTS                                                    *
*                                                                        *
*          TOTAL GAME STARTS IN A2.                                      *
*                                                                        *
**************************************************************************
GET_STARTS:
        MMTM    SP,A0,A1
        MOVI    AUD1STRT,A0
        CALLA   GET_AUD
        MOVE    A1,A2

        MOVI    AUD2STRT,A0
        CALLA   GET_AUD
        ADD     A1,A2
	MMFM    SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
*          GET_CONTS                                                     *
*                                                                        *
*          TOTAL GAME CONTINUES IN A2.                                   *
*                                                                        *
**************************************************************************
GET_CONTS:
        MMTM    SP,A0,A1
        MOVI    AUD1CONT,A0
        CALLA   GET_AUD
        MOVE    A1,A2

        MOVI    AUD2CONT,A0
        CALLA   GET_AUD
        ADD     A1,A2
	MMFM    SP,A0,A1
	RETS


**************************************************************************
*                                                                        *
*          GET_PLAYS                                                     *
*                                                                        *
*          RETURN TOTAL PLAYS (STARTS + CONTINUES) IN A2                 *
*                                                                        *
**************************************************************************
GET_PLAYS:
        MMTM    SP,A0
        CALLR   GET_STARTS
        MOVE    A2,A0
        CALLR   GET_CONTS
        ADD     A0,A2
	MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          PRINT_MONEY                                                   *
*                                                                        *
*          THIS IS CALLED TO PRINT OUT THE "MONEY" ON THE MONEY          *
*          LINE OF THE AUDIT TABLE.                                      *
*                                                                        *
*          AUDIT X AND Y IS SET FOR THE LINE TO DISPLAY IT ON.           *
*                                                                        *
*          A8 HAS THE 1ST OF 3 AUDITS TO USE FOR THE CALCULATION         *
*          A9 HAS THE MESSAGE TO LEFT JUSTIFY ON THE CURRENT LINE        *
*                                                                        *
**************************************************************************
PRINT_COL:
        MOVI    T_MONEY,A9           ;THIS ENTRYPOINT IS FOR COLLECTION MESSAGE
	
PRINT_MONEY:    
        MOVE    A9,*A13(AT_MESS),L   ;HOLD MESSAGE FOR WHEN WE NEED IT!
        MOVI    ADJCDIV,A0           ;IF DIVISOR IS ZERO..THEN ITS OFF!
        CALLA   GET_ADJ
        JRZ     NO_MONEY             ;THAT'S ALL FOLKS!

        CALLR   BEGIN_AUDIT          ;KEEP TRACK OF SANITY OF CALC.
*
*       ROUTINE IN A2 FORMS STRING BASED ON 3 AUDITS STARTING
*       WITH THE NUMBER IN A8.
*
        CALLR   STR_OBJ              ;GET AN OBJECT FOR STRINGING
        JRC     NO_MONEY             ;COULDN'T GET AN OBJECT!

        CALLR   SUM_COINS            ;ADD UP THE COIN PARTS IN A2

*
*       WE'RE DOING A PREFIX STRING...NO PREFIX IF ITS BEEN TAMPERED
*
        CALLR   SIXP                 ;HAVE THE 6 BEEN TAMPERED 
        JRZ     NO_PREFIX
        CALLR   GET_CSPT             ;A6 POINTS AT CSECECT DATA.
        MOVE    *A6(CS_LMES),A8,L    ;LEFT STRING FOR MONEY TOTAL
        CALLA   STRCAT               ;SHOVE THE STRING IN!

NO_PREFIX:
        MOVK    1,A0                 ;DIVIDE COINS BY 1 IF ITS BEEN TAMPERED WITH
        CALLR   SIXP
        JRZ     DIV_BY_1             ;TAMPERED WITH...DIVIDE BY 1 FOR "COINS"

        MOVI    ADJCDIV,A0           ;GET THE COIN PARTS PLEASE
        CALLA   GET_ADJ
*
*       GET QUOTIENT IN A2
*       REMAINDER IN A3
*
DIV_BY_1:
        MOVE    A2,A3                ;SETUP <A2><A3> AS DIVIDEND
        CLR     A2
        DIVU    A0,A2                ;DIVIDE UNITS/DIVISOR

        MOVE    A2,A8                ;WE NEED TO PUT QUOTIENT IN STRING
        CALLA   HEXTOASC             ;THIS FORMS STRING FOR QUOTIENT

        CALLA   STRCAT               ;ADD QUOTIENT TO PRINTOUT

        CMPI    1,A0                 ;IS DIVISOR ONE??????
        JRZ     NOFRAC               ;YEP.......NO DECIMAL!
*
*       WE HAVE A DIVISOR.....WE NEED TO DISPLAY CENTS.
*
        MOVI    ME_DECIMAL,A8        ;ADD DECIMAL POINT
        CALLA   STRCAT               ;ITS THERE!
*
*       REMAINDER IS IN A3....TURN IT TO 100THS.
*
        MOVI    100,A2
        MPYU    A2,A3                ;REMAINDER TIMES 100
        MOVE    A3,A2                ;DIVIDEND IN A2

        CALLR   ROUNDED_A0_INTO_A2
        CALLR   A2_100TH             ;CAT THE 100THS IN A2 TO THE A7 STRING.

NOFRAC:
   	MOVI    COINS_TRAIL,A8           ;ASSUME IT WILL BE "COINS"
        CALLR   SIXP                 ;TAMPERED?
        JRZ     COIN_SUF             ;YEP....USE " COINS"
        MOVE    *A6(CS_RMES),A8,L    ;FINISH IT OFF WITH RIGHT STRING

COIN_SUF:
	CALLA   STRCAT               ;SHOVE THE STRING IN!
        MOVI    M_MONEY,A8                ;MESSAGE FOR THIS LINE PASSED IN A9
        CALLA   LM_SETUP

        MOVE    @TMPOBJ,A8,L         ;POINTER TO MONEY STRING
        JSRP    RIGHT_FINISH            ;PUT ON RIGHT MARGIN

        CALLR   STR_FREE

        MOVE    *A13(AT_MESS),A8,L      ;SETUP PASSED MESSAGE
        CALLA   LM_SETUP
        JSRP    LEFT_FINISH             ;PUT UP PASSED MESSAGE.
NO_MONEY:
        RETP

**************************************************************************
*                                                                        *
*          STR_OBJ                                                       *
*                                                                        *
*          THIS IS CALLED TO GET AN OBJECT FOR                           *
*          CONCATONATING STRINGS TOGETHER.                               *
*                                                                        *
*          A7 POINTS AT NULL STRING                                      *
*                                                                        *
*          NOTE THAT THIS IS NO LONGER RE-ENTRANT!                       *
*                                                                        *
*          YOU MUST CALL STR_FREE BEFORE SLEEPING!                       *
*                                                                        *
**************************************************************************
STR_OBJ:
        MMTM    SP,A0
        CALLA   GETOBJ               ;USE AN OBJECT BLOCK FOR STRING MANIPULATION
        JRNZ    STR_O1
*
*       NO OBJECTS DURING TEST MODE
*
        SETC    
        JRUC    STR_OFAIL

STR_O1:
   	MOVE    A0,@TMPOBJ,L         ;SAVE TO FREE LATER
        MOVE    A0,A7                ;THIS IS WHERE IT BELONGS.
        CLR     A0
        MOVB    A0,*A7               ;MAKE STRING NULL
        CLRC                         ;RETURN SUCCESS
STR_OFAIL:
	MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          ROUNDED_A0_INTO_A2                                            *
*                                                                        *
*          THIS DIVIDES A0 INTO A2.  IT LEAVES THE RESULT IN A2          *
*          AND ROUNDS UP IF NECESSARY.                                   *
*                                                                        *
**************************************************************************
ROUNDED_A0_INTO_A2:
        MMTM    SP,A3
        MOVE    A0,A0                ;DIVIDE BY ZERO?
        JRNZ    NDZ
        MOVE    A0,A2                ;RETURN ZERO
        JRUC    NOROUND
NDZ:
      	MOVE    A2,A3
        CLR     A2                   ;<A2> <A3> AS DIVIDEND
        DIVU    A0,A2                ;DIVIDE AND A2 = PENNIES....A3 = REMAINDER
        SLL     1,A3                 ;SHIFT REMAINDER
        CMP     A0,A3                ;COMPARE TO DIVISOR
        JRLO    NOROUND              ;TOO LOW TO ROUND UP
        INC     A2                   ;A2 HAS CORRECT PENNIES
NOROUND:
 	MMFM    SP,A3
	RETS

**************************************************************************
*                                                                        *
*          A2_100TH                                                      *
*                                                                        *
*          A7 HAS A STRING TO BE PRINTED.  WE HAVE THE                   *
*          LAST TWO NUMBERS (NOT TO BE LEAD ZERO BLANKED) IN             *
*          A2.  CONCATONATE THEM ONTO THE A7 STRING.                     *
*                                                                        *
*          THIS IS USED FOR PENNIES, HOURS AND MINUTES.                  *
*                                                                        *
**************************************************************************
A2_100TH:
        MMTM    SP,A8
        CMPI    9,A2                 ;9 OR LESS REQUIES LEAD ZERO.
        JRHI    NOLEAD

        MOVI    ME_ZERO,A8           ;THROW IN THE LEAD ZERO
        CALLA   STRCAT               ;THIS DOES IT!

NOLEAD:
   	MOVE    A2,A8
	CALLA   HEXTOASC             ;MAKE STRING
        CALLA   STRCAT               ;PUT IT IN!
	MMFM    SP,A8
	RETS

**************************************************************************
*                                                                        *
*          SUM_COINS                                                     *
*                                                                        *
*          A8 HAS FIRST OF THE 3 AUDIT NUMBERS OF INTEREST               *
*                                                                        *
*          RETURN COINS TIMES THEIR FACTORS IN A2.                       *
*                                                                        *
**************************************************************************
SUM_COINS:            
        MMTM    SP,A0,A1,A3,A6,A4

        MOVE    A8,A0                     ;POINT AT AUDIT NUMBER
        CLR     A2                        ;SUM = ZERO

        CALLR   GET_CSPT                  ;A6 POINTS AT CSELECT TABLE
        ADDI    CS_LVAL,A6                ;POINT AT 1ST MULTIPLIER

        MOVI    CHUTES,A4                 ;NOW...ITERATE OVER THE CHUTES

NEXT_CHUTE:
        MOVE    *A6+,A3,W                 ;GET MULTPLIER FOR THIS CHUTE
        CALLR   FIX_A3                    ;REPLACE A3 WITH 1 (MULTIPLIER) IF 
*                                          ;ITS SOME CUSTOM MODE.
        CALLR   ADD_AUD_A0_TIMES_A3_TO_A2 
        INC     A0                        ;NEXT AUDIT
        DSJS    A4,NEXT_CHUTE

	MMFM    SP,A0,A1,A3,A6,A4
	RETS

ADD_AUD_A0_TIMES_A3_TO_A2:
        CALLA   GET_AUD                   ;FETCH THE AUDIT
        MPYU    A1,A3                     ;TIME THE FACTOR
        ADD     A3,A2
        RETS

**************************************************************************
*                                                                        *
*          FIX_A3                                                        *
*                                                                        *
*          THIS IS CALLED BY THE LOW LEVEL MONEY TOTALIZER.              *
*          THE MULTIPLIER FOR THE COIN SLOT THAT ITS WORKING             *
*          ON IS IN A3.  WE REPLACE IT WITH "1" TO SUM "TOTAL COINS"     *
*          IF ITS IN A NON-STANDARD COIN MODE.                           *
*                                                                        *
**************************************************************************
FIX_A3:   
	CALLR   SIXP                 ;HAS IT BEEN TAMPERED WITH?
        JRNZ    FIX_A3X              ;NOPE...LEAVE A3

        MOVK    1,A3
FIX_A3X:	
	RETS

**************************************************************************
*                                                                        *
*          SIXP                                                          *
*                                                                        *
*          THIS IS CALLED TO SEE IF THE 1ST 6 COIN PARAMETERS HAVE       *
*          BEEN TAMPERED WITH.                                           *
*                                                                        *
*          .EQ.            YES                                           *
*          .NE.            NO                                            *
*                                                                        *
**************************************************************************
SIXP:     
	MMTM    SP,A0
        MOVI    ADJ1ST6,A0
        CALLA   GET_ADJ              ;HAS IT BEEN TAMPERED WITH?
	MMFM    SP,A0
	RETS

STARTS:   
	CALLR   GET_STARTS
        MOVE    A2,A3           ;GET IN PRINTOUT REG.
        JAUC    NUMBER_WORK     ;AND PRINT IT

CONTINS:  
	CALLR   GET_CONTS
        MOVE    A2,A3           ;GET IN PRINTOUT REG.
        JAUC    NUMBER_WORK     ;AND PRINT IT

DOPLAYS:  
	CALLR   GET_PLAYS
        MOVE    A2,A3           ;PUT IN PLACE
        JAUC    NUMBER_WORK

DOHSLEFT:
        MOVI    ADJHSRES,A0
        CALLA   GET_ADJ         ;IS IF OFF?
        JRZ     DOHSOFF         ;YEP...PRINT IT

        CALLA   GET_HSC         ;GET THE COUNTER VALUE
        MOVE    A0,A3
        JAUC    NUMBER_WORK     ;AND SHOW IT!

DOHSOFF:  
	MOVI    MESS_AUD_NUM,A8
        CALLA   LM_SETUP        ;SETUP FOR AUDIT PRINTING.

        MOVI    M_HSOFF,A8     ;THIS EFFECTIVELY ERASES LINE!
        JAUC    RIGHT_FINISH

DO_P1MIN: 
	MOVI    AUD1TIME,A0
P1MJ:     
	CALLA   GET_AUD         ;TURN INTO NUMBER
        MOVE    A1,A4           ;MOVE NUMBER TO "HOUR" COMPUTATION REGGIE
        JRUC    DH11            ;AND DO LIKE THE HOURS!


DO_P2MIN: 
	MOVI    AUD2TIME,A0
        JRUC    P1MJ

DO_HOURS: 
	CALLR   TOT_TIME        ;READ OUT THE TOTAL TIME.
DH11:     
	MOVE    A4,A5           ;A5 HAS RUNNING PLAY TIME
        CLR     A4              ;<A4><A5> READY FOR DIVISION
        MOVI    12,A0
        DIVU    A0,A4           ;A4 HAS MINUTES
        CMPI    6,A5            ;ROUND PROPERLY
        JRLO    DH1             ;NOT ENOUGH
        INC     A4
DH1:     
	MOVE    A4,A1           ;NOW THIS DIVIDED BY 60 IS WHAT WE NEED
        JAUC    P_TIME          ;DO IT!

DO_AVGT:  
	CALLR   TOT_TIME        ;A3 HAS WEIGHTED TIME

DOAVC:    
	CALLR   GET_PLAYS       ;GET TOTAL PLAYS IN A2
        MOVE    A2,A0           ;STASH IN A0.
        MOVI    5,A1            ;TURN INTO SECONDS
        MPYU    A1,A3           ;A3 HAS SECONDS OF INTEREST
        MOVE    A3,A2
        CALLR   ROUNDED_A0_INTO_A2   ;DIVIDE A2 BY PLAYS (AND ROUND)
        MOVE    A2,A1           ;NOW GET IN PLACE FOR P_TIME
        JAUC    P_TIME          ;DO IT!

DO_ELAPSE:
        CALLR   TOT_TIME
        MOVE    A4,A3           ;USE ELAPSED TIME
        JRUC    DOAVC           ;AND THE REST IS IDENTICAL.


**************************************************************************
*                                                                        *
*          P_TIME                                                        *
*                                                                        *
*          THIS IS CALLED TO DISPLAY AN AUDIT IN TIME (0:00)             *
*          FORMAT.  THE NUMBER TO BE USED IS PASSED IN A1.               *
*                                                                        *
**************************************************************************
P_TIME:   
	CALLR   STR_OBJ              ;USE AN OBJECT BLOCK FOR STRING MANIPULATION
        JRC     NO_OBJS              ;NO OBJECTS....PRINT NOTHING

        CLR     A0              ;DIVIDEND IN <A0><A1>
        MOVI    60,A2
        DIVU    A2,A0           ;A0 = "MINUTES"....A1 = "SECONDS

        CALLA   CAT_A0          ;ADD A0 STRING TO A7 BUILD
        MOVI    ME_COLON,A8
        CALLA   STRCAT          ;PUT THE COLON IN.

        MOVE    A1,A2           ;GET "SECONDS" IN A2
        CALLR   A2_100TH        ;AND GET THE 100THS IN.

        MOVI    MESS_AUD_NUM,A8      ;SETUP FOR AUDIT NUMBER
        CALLA   LM_SETUP

        MOVE    A7,A8           ;PUT STRING CORRECT REGGIE
        JSRP    RIGHT_FINISH    ;PRINT THE LINE

        CALLR   STR_FREE        ;FREE UP THE OBJECT!

NO_OBJS:
        RETP                         ;NOW RETURN TO CALLER

STR_FREE:
        MOVE    @TMPOBJ,A0,L       ;GET OBJECT BACK

        JRNZ    FREE_IT_NOW

        .IF     DEBUG
        JRUC    $
        .ENDIF
        RETS                         ;NO OBJECT...RETURN!

FREE_IT_NOW:
        CALLA   FREEOBJ            ;AND LET IT GO.
        RETS
	
**************************************************************************
*                                                                        *
*         TOT_TIME                                                       *
*                                                                        *
*          (1 * P1TIME) + (2 * P2TIME) IN A3                             *
*          ELAPSED TIME IN A4                                            *
*                                                                        *
**************************************************************************
TOT_TIME:
        MMTM    SP,A0,A1
        MOVI    AUD1TIME,A0
        CALLA   GET_AUD
        MOVE    A1,A3
        MOVE    A1,A4
        MOVI    AUD2TIME,A0
        CALLA   GET_AUD
        ADD     A1,A4                ;A4 HAS SIMPLE SUM NOW
        SLL     1,A1                 ;DOUBLE THE PLAYER 2 TIME
        ADD     A1,A3
	MMFM    SP,A0,A1
	RETS

**** DATA SECTION BEGINS ****

	.DATA

CSELCT:  
*
*        USA 1    25 CENTS PER CREDIT 
*
         .WORD   1,0,1,1,0,0                    ;WILLY PRICING
         .WORD   4                              ;4 COINS PER DOLLAR (FOR CALC)
         .WORD   1                              ;DISPLAY COIN FRACTIONS
         .WORD   1,0,1                          ;COIN VALUE
         .LONG   DOLLAR_LEAD,NULL_ST            ;CHARACTER STRINGS.
         .LONG   OCOP                           ;ONE COIN ONE PLAY
         .LONG   USA_1                          ;TITLE OF COIN MODE
         .LONG   Q_Q                            ;1 COIN PER CREDIT (SERIES OF STRINGS)
         .WORD   SHOW_NONE                      ;NO PRICING LINE ON 2/1
         .LONG   USA_QQ                         ;QUARTER
*
*        USA 2    50 PER CREDIT
*
;         .WORD   1,0,1,2,0,0                    ;WILLY PRICING
;         .WORD   4                              ;4 COINS PER DOLLAR (FOR CALC)
;         .WORD   1                              ;DISPLAY COIN FRACTIONS
;         .WORD   1,0,1                          ;COIN VALUE
;         .LONG   DOLLAR_LEAD,NULL_ST            ;CHARACTER STRINGS.
;         .LONG   TWO_PER_PLAYER                 ;2 COINS PER PLAYER
;         .LONG   USA_2                          ;TITLE OF COIN MODE
;         .LONG   C2_PERC                        ;2 COINS PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_1                         ;SHOW LINE 1
;         .LONG   USA_QQ                         ;QUARTER
*                                               
*        USA 3    COINAGE IS 50 CENT   3/$1.00
*
;         .WORD   1,0,1,2,4,0                    ;WILLY PRICING
;         .WORD   4                              ;4 COINS PER DOLLAR (FOR CALC)
;         .WORD   1                              ;DISPLAY COIN FRACTIONS
;         .WORD   1,0,1                          ;COIN VALUE
;         .LONG   DOLLAR_LEAD,NULL_ST            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST                       ;PRINT THE 2 THE OP SEES
;         .LONG   USA_3                          ;TITLE OF COIN MODE
;         .LONG   DOLLAR_3                       ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2                         ;SHOW LINE 2
;         .LONG   USA_QQ                         ;QUARTER
*                                               
*        USA 4    COINAGE IS 50 CENT   4/$1.00
*
;         .WORD   3,0,3,4,12,6                   ;WILLY PRICING
;         .WORD   4                              ;4 COINS PER DOLLAR (FOR CALC)
;         .WORD   0                              ;NO COIN FRACTIONS
;         .WORD   1,0,1                          ;COIN VALUE
;         .LONG   DOLLAR_LEAD,NULL_ST            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST                       ;PRINT THE 2 THE OP SEES
;         .LONG   USA_4                          ;TITLE OF COIN MODE
;         .LONG   DOLLAR_4                       ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2                         ;SHOW LINE 2
;         .LONG   USA_QQ                         ;QUARTER
;*
;*        USA 5    25 CENTS PER CREDIT 
;*
;         .WORD   1,4,1,1,0,0                    ;WILLY PRICING
;         .WORD   4                              ;4 COINS PER DOLLAR (FOR CALC)
;         .WORD   1                              ;DISPLAY COIN FRACTIONS
;         .WORD   1,4,1                          ;COIN VALUE
;         .LONG   DOLLAR_LEAD,NULL_ST            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST                       ;ONE COIN ONE PLAY
;         .LONG   USA_5                          ;TITLE OF COIN MODE
;         .LONG   U1Q4D                          ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2                         ;NO PRICING LINE ON 2/1
;         .LONG   USA_QDQ                         ;QUARTER
;*
;*        USA 6    50 PER CREDIT
;*
;         .WORD   1,4,1,2,0,0                    ;WILLY PRICING
;         .WORD   4                              ;4 COINS PER DOLLAR (FOR CALC)
;         .WORD   1                              ;DISPLAY COIN FRACTIONS
;         .WORD   1,4,1                          ;COIN VALUE
;         .LONG   DOLLAR_LEAD,NULL_ST            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST                       ;2 COINS PER PLAYER
;         .LONG   USA_6                          ;TITLE OF COIN MODE
;         .LONG   UFS2D                          ;2 COINS PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_1                         ;SHOW LINE 1
;         .LONG   USA_QDQ                         ;QUARTER
;*                                               
;*        USA 7    COINAGE IS 50 CENT   3/$1.00
;*
;         .WORD   1,4,1,2,4,0                    ;WILLY PRICING
;         .WORD   4                              ;4 COINS PER DOLLAR (FOR CALC)
;         .WORD   1                              ;DISPLAY COIN FRACTIONS
;        .WORD   1,4,1                          ;COIN VALUE
;         .LONG   DOLLAR_LEAD,NULL_ST            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST                       ;PRINT THE 2 THE OP SEES
;         .LONG   USA_7                          ;TITLE OF COIN MODE
;         .LONG   UFS3D                          ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2                         ;SHOW LINE 2
;         .LONG   USA_QDQ                         ;QUARTER
;*                                               
;*        USA 8    COINAGE IS 50 CENT   4/$1.00
;*
;         .WORD   3,12,3,4,12,6                  ;WILLY PRICING
;         .WORD   4                              ;4 COINS PER DOLLAR (FOR CALC)
;         .WORD   0                              ;NO COIN FRACTIONS
;         .WORD   1,4,1                          ;COIN VALUE
;         .LONG   DOLLAR_LEAD,NULL_ST            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST                       ;PRINT THE 2 THE OP SEES
;         .LONG   USA_8                          ;TITLE OF COIN MODE
;         .LONG   UFS4D                          ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2                         ;SHOW LINE 2
;         .LONG   USA_QDQ                         ;QUARTER
*
*        GERMAN 1    COINAGE IS 6 PLAYS FOR 5 DM
*
         .WORD   6,12,30,5,0,0                  ;WILLY PRICING
         .WORD   1                              ;DMS HAVE NO FRACTIONS
         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
         .WORD   1,2,5                          ;COIN VALUE
         .LONG   NULL_ST,DM_TRAIL               ;CHARACTER STRINGS.
         .LONG   CSM_LIST
         .LONG   GERMAN_1                       ;TITLE OF COIN MODE
         .LONG   DM_6                           ;1 COIN PER CREDIT (SERIES OF STRINGS)
         .WORD   SHOW_2
         .LONG   GERMAN_15                      ;1 DM / 5 DM

G1SEL    EQU     ($-CSELCT)/CS_SIZE             ;COIN SELECT VALUE FOR GERMAN 1
*
*        GERMAN 2    COINAGE IS 7 PLAYS FOR 5 DM
*
;         .WORD   6,12,30,5,30,0                 ;WILLY PRICING
;         .WORD   1                              ;DMS HAVE NO FRACTIONS
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   1,2,5                          ;COIN VALUE
;         .LONG   NULL_ST,DM_TRAIL               ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   GERMAN_2                       ;TITLE OF COIN MODE
;         .LONG   DM_7                           ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2
;         .LONG   GERMAN_15                      ;1 DM / 5 DM
*
*        GERMAN 3    COINAGE IS 8 PLAYS FOR 5 DM
*
;         .WORD   7,14,35,5,35,0                 ;WILLY PRICING
;         .WORD   1                              ;DMS HAVE NO FRACTIONS
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   1,2,5                          ;COIN VALUE
;         .LONG   NULL_ST,DM_TRAIL               ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   GERMAN_3                       ;TITLE OF COIN MODE
;         .LONG   DM_8                           ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2
;         .LONG   GERMAN_15                      ;1 DM / 5 DM
*
*        GERMAN 4    COINAGE IS 5 PLAYS FOR 5 DM
*
;         .WORD   1,2,5,1,0,0                    ;WILLY PRICING
;         .WORD   1                              ;DMS HAVE NO FRACTIONS
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   1,2,5                          ;COIN VALUE
;         .LONG   NULL_ST,DM_TRAIL               ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   GERMAN_4                       ;TITLE OF COIN MODE
;         .LONG   DM_5                           ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2
;         .LONG   GERMAN_15                      ;1 DM / 5 DM

****************************************************************************
****************************************************************************
*******  THE FOLLOWING NUMBERS ARE FIGURED FOR THE FRENCH SETTINGS
*******  REQUESTED BY DIMITRI K. OF P.S.D.
*******
*******                          1F   5F   10F   U/C   U/B  M/U
*******                         --------------------------------
*******  1/2F  3/5F    7/10F     3    15    30    5    30    0
*******  1/3F  2/5F    5/10F     2    10    20    5    20    0
*******  1/5F  3/10F             1     5    10    5    10    0
*******  1/5F  3/10F   7/20F     3    15    30   10    60   15
*******  2/5F  4/10F   9/20F     2    10    20    5    40   10
*******  2/5F  5/10F  11/20F     1     5    10    2    20    5
*******
*
*
*        FRENCH 1               2/5F    5/10F
*
*
         .WORD   2,0,4,1,4,0      ; 2/5F    5/10F
         .WORD   1                              ;1 FRANC PER FRANC
         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
         .WORD   5,0,10                         ;COIN VALUE
         .LONG   NULL_ST,FRANC_TRAIL            ;CHARACTER STRINGS.
         .LONG   CSM_LIST                       ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
         .LONG   FRENCH_1                       ;TITLE OF COIN MODE
         .LONG   FIVE_10                        ;1 COIN PER CREDIT (SERIES OF STRINGS)
         .WORD   SHOW_2
         .LONG   FRENCH510

F1SEL    EQU     ($-CSELCT)/CS_SIZE             ;COIN SELECT VALUE FOR FRENCH 1

*
*        FRENCH 2               2/5F    4/10F
*
*
;         .WORD   2,0,4,1,0,0      ; 2/5F    4/10F
;         .WORD   1                              ;1 FRANC PER FRANC
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   5,0,10                         ;COIN VALUE
;         .LONG   NULL_ST,FRANC_TRAIL            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST                       ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
;         .LONG   FRENCH_2                       ;TITLE OF COIN MODE
;         .LONG   FOUR_10                        ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2
;         .LONG   FRENCH510
*
*        FRENCH 3               1/5F  3/10F        
*
*
;         .WORD   1,0,2,1,2,0       ;1/5F  3/10F        
;         .WORD   1                              ;1 FRANC PER FRANC
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   5,0,10                         ;COIN VALUE
;         .LONG   NULL_ST,FRANC_TRAIL            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST                       ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
;         .LONG   FRENCH_3                       ;TITLE OF COIN MODE
;         .LONG   THREE_10                       ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2
;         .LONG   FRENCH510
;*
;*        FRENCH 4               1/5F  2/10F   
;*
;*
;         .WORD   1,0,2,1,0,0    ;1/5F  2/10F
;         .WORD   1                              ;1 FRANC PER FRANC
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   5,0,10                         ;COIN VALUE
;         .LONG   NULL_ST,FRANC_TRAIL            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST                       ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
;         .LONG   FRENCH_4                       ;TITLE OF COIN MODE
;         .LONG   TWO_10                        ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_1
;         .LONG   FRENCH510
;*
;*
;*        FRENCH 5               2/5F    5/10F    11/2 X 10F
;*
;*
;         .WORD   5,0,10,2,20,0                  ;2/5F  5/10F  11/20F
;         .WORD   1                              ;1 FRANC PER FRANC
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   5,0,10                         ;COIN VALUE
;         .LONG   NULL_ST,FRANC_TRAIL            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST                       ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
;         .LONG   FRENCH_5                       ;TITLE OF COIN MODE
;         .LONG   FIVE_10_11                     ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_3                         ;USE LINE 3 WHEN ONLY 1 WILL FIT
;         .LONG   FRENCH510
;*
;*        FRENCH 6               2/5F    4/10F    9/2 X 10F
;*
;*
;         .WORD   2,0,4,1,8,0                    ;2/5F  4/10F   9/20F
;         .WORD   1                              ;1 FRANC PER FRANC
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   5,0,10                         ;COIN VALUE
;        .LONG   NULL_ST,FRANC_TRAIL            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST                       ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
;         .LONG   FRENCH_6                       ;TITLE OF COIN MODE
;         .LONG   FOUR_10_9                      ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_3                         ;USE LINE 3 WHEN ONLY 1 WILL FIT
;         .LONG   FRENCH510
;*
;*        FRENCH 7               1/5F    3/10F    7/2 X 10F
;*
;*
;         .WORD   3,0,6,2,12,0                   ;1/5F  3/10F   7/20F
;         .WORD   1                              ;1 FRANC PER FRANC
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   5,0,10                         ;COIN VALUE
;         .LONG   NULL_ST,FRANC_TRAIL            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST                       ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
;         .LONG   FRENCH_7                       ;TITLE OF COIN MODE
;         .LONG   THREE_10_7                     ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_3                         ;USE LINE 3 WHEN ONLY 1 WILL FIT
;        .LONG   FRENCH510
;*
;*        FRENCH 8               1/5F    2/10F    5/2 X 10F
;*
;*
;         .WORD   1,0,2,1,4,0                    ;1/5F  2/10F  5/20F
;         .WORD   1                              ;1 FRANC PER FRANC
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   5,0,10                         ;COIN VALUE
;         .LONG   NULL_ST,FRANC_TRAIL            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST                       ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
;         .LONG   FRENCH_8                       ;TITLE OF COIN MODE
;         .LONG   TWO_10_5                       ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_3                         ;USE LINE 3 WHEN ONLY 1 WILL FIT
;         .LONG   FRENCH510
;*
;*        FRENCH 9               1/3 X 1F      2/5F
;*
;*        COIN SLOTS ARE  1F -- 5F
;*
;*
;         .WORD   2,0,10,5,0,0                   ;1/3x1F  2/5F  
;         .WORD   1                              ;1 FRANC PER FRANC
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   1,0,5                          ;COIN VALUE
;         .LONG   NULL_ST,FRANC_TRAIL            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST                       ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
;         .LONG   FRENCH_9                       ;TITLE OF COIN MODE
;         .LONG   F1325                          ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2                         ;USE LINE 2 WHEN ONLY 1 WILL FIT
;         .LONG   FRENCH1F5F
;*
;*        FRENCH 10               1/2 X 1F      3/5F
;*
;*        COIN SLOTS ARE  1F -- 5F
;*
;*
;         .WORD   3,0,15,5,0,0                   ;1/2x1F  3/5F  
;         .WORD   1                              ;1 FRANC PER FRANC
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   1,0,5                          ;COIN VALUE
;         .LONG   NULL_ST,FRANC_TRAIL            ;CHARACTER STRINGS.
;        .LONG   CSM_LIST                       ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
;         .LONG   FRENCH_10                      ;TITLE OF COIN MODE
;         .LONG   F1235                          ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2                         ;USE LINE 2 WHEN ONLY 1 WILL FIT
;         .LONG   FRENCH1F5F
;*
;*        FRENCH 11               1/3 X 1F      2/5F    5/2 X 5F
;*
;*        COIN SLOTS ARE  1F -- 5F
;*
;*
;         .WORD   2,0,10,5,20,0                  ;1/3x1F  2/5F  5/10F
;         .WORD   1                              ;1 FRANC PER FRANC
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   1,0,5                          ;COIN VALUE
;         .LONG   NULL_ST,FRANC_TRAIL            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST                       ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
;         .LONG   FRENCH_11                      ;TITLE OF COIN MODE
;         .LONG   F13255                          ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_3                         ;USE LINE 2 WHEN ONLY 1 WILL FIT
;         .LONG   FRENCH1F5F
;*
;*        FRENCH 12               1/2 X 1F      3/5F      7 / 2 X 5F
;*
;*        COIN SLOTS ARE  1F -- 5F
;*
;*
;         .WORD   3,0,15,5,30,0                  ;1/2x1F  3/5F  7/10F
;         .WORD   1                              ;1 FRANC PER FRANC
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;        .WORD   1,0,5                          ;COIN VALUE
;         .LONG   NULL_ST,FRANC_TRAIL            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST                       ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
;         .LONG   FRENCH_12                      ;TITLE OF COIN MODE
;         .LONG   F12355                          ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_3                         ;USE LINE 2 WHEN ONLY 1 WILL FIT
;         .LONG   FRENCH1F5F
;*
*        SWISS 1    COINAGE IS 6 PLAYS FOR 5 FRANC
*
;        .WORD   6,0,30,5,0,0                  ;WILLY PRICING
;         .WORD   1                              ;FRANCS HAVE NO FRACTIONS
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   1,0,5                          ;COIN VALUE
;         .LONG   NULL_ST,FRANC_TRAIL               ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   SWISS_1                        ;TITLE OF COIN MODE
;         .LONG   SFRANC_6                       ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2
;         .LONG   SWISS15
;*
;*        SWISS 2    COINAGE IS 7 PLAYS FOR 5 FRANC
;*
;         .WORD   6,0,30,5,30,0                 ;WILLY PRICING
;         .WORD   1                              ;FRANCS HAVE NO FRACTIONS
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   1,0,5                          ;COIN VALUE
;         .LONG   NULL_ST,FRANC_TRAIL               ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   SWISS_2                        ;TITLE OF COIN MODE
;         .LONG   SFRANC_7                       ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2
;         .LONG   SWISS15
;*
;*        SWISS 3     COINAGE IS 8 PLAYS FOR 5 FRANC
;*
;         .WORD   7,0,35,5,35,0                 ;WILLY PRICING
;         .WORD   1                              ;FRANCS HAVE NO FRACTIONS
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   1,0,5                          ;COIN VALUE
;         .LONG   NULL_ST,FRANC_TRAIL               ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   SWISS_3                        ;TITLE OF COIN MODE
;         .LONG   SFRANC_8                       ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2
;         .LONG   SWISS15
;*
;*        ITALY COINAGE IS 1 PLAYS FOR 500 LIRE
;*
;         .WORD   1,0,1,1,0,0                 ;WILLY PRICING
;         .WORD   1                              ;LIRE HAVE NO FRACTIONS
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   500,0,500                          ;COIN VALUE
;         .LONG   NULL_ST,LIRE_TRAIL               ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   ITALY_1                        ;TITLE OF COIN MODE
;         .LONG   P1500L                         ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_1
;         .LONG   ITALYLIRE
;*
;*        U.K. 1   COINAGE IS 1 PLAY FOR 20P   3 FOR 50P
;*
;         .WORD   6,0,15,5,0,0                   ;WILLY PRICING
;         .WORD   10                             ;PENCE ARE FRACTIONS!
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   2,0,5                          ;COIN VALUE
;         .LONG   POUND_LEAD,NULL_ST             ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   UK_1                           ;TITLE OF COIN MODE
;         .LONG   UK_120                         ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2
;         .LONG   UK2050
;*
;*        U.K. 2   COINAGE IS 2 PLAY FOR 20P   5 FOR 50P
;*
;         .WORD   2,0,5,1,0,0                    ;WILLY PRICING
;         .WORD   10                             ;PENCE ARE FRACTIONS!
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   2,0,5                          ;COIN VALUE
;         .LONG   POUND_LEAD,NULL_ST             ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   UK_2                           ;TITLE OF COIN MODE
;         .LONG   UK_220                         ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_1
;         .LONG   UK2050
;*
;*        U.K. ELECTRONIC 1   
;*
;*        CENTER = 10P  XTRA = 20P  LEFT = 50P  RIGHT = POUND
;*        1 PLAY / 30 P
;*        2 PLAY / 50 P
;*        4 PLAY / 1 POUND
;*
;*         .WORD   2,10,20,5,0,0                 ;NUMBERS FOR 10/50/100
;         .WORD   10,2,20,5,0,0                  ;NUMBERS FOR 50/10/100
;         .WORD   10                             ;PENCE ARE FRACTIONS!
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   5,1,10                         ;COIN VALUE
;         .LONG   POUND_LEAD,NULL_ST             ;CHARACTER STRINGS.
;         .LONG   UK_ELECTRONIC                  ;SPECIAL TITLE W/ POUND
;         .LONG   UK_3                           ;TITLE OF COIN MODE
;         .LONG   UK_320                         ;1/30P  2/50P  4/1L
;         .WORD   SHOW_2
;         .LONG   UK_ELEC
;*
;*        U.K. ELECTRONIC 2  (CCU) 
;*
;*        CREDITS ARE AWARDED 1 COIN / 1 PLAY.....
;*
;*        CCU ACCUMULATES 4 COINS AND STROKES US AS FOLLOWS:
;*
;*        1 PLAY / 30 P
;*        2 PLAY / 50 P
;*        4 PLAY / 1 POUND
;*
;         .WORD   1,0,0,1,0,0                    ;NUMBERS FOR 
;         .WORD   1                              ;PENCE ARE FRACTIONS!
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   1,0,0                          ;COIN VALUE
;         .LONG   NULL_ST,COINS_TRAIL            ;CHARACTER STRINGS.
;         .LONG   UK_ELECTRONIC                  ;SPECIAL TITLE W/ POUND
;         .LONG   UK_4                           ;TITLE OF COIN MODE
;         .LONG   UK_320                         ;1/30P  2/50P  4/1L
;         .WORD   SHOW_2
;         .LONG   UK_CCU     
;*
;*        SPAIN 1     1 play / 25 Peseta   5 play / 100 Peseta
;*
;         .WORD   1,0,4,1,4,0                    ;WILLY PRICING
;         .WORD   1                              ;no fractions
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   25,0,100                       ;COIN VALUE
;         .LONG   NULL_ST,PESETA_TRAIL           ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   SP_1                           ;TITLE OF COIN MODE
;         .LONG   SP_5100                        ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2
;         .LONG   PESETA25
;
;*
;*        SPAIN 2     1 play / 25 Peseta   4 play / 100 Peseta
;*
;         .WORD   1,0,4,1,0,0                    ;WILLY PRICING
;         .WORD   1                              ;no fractions
;         .WORD   0                              ;DON'T DISPLAY COIN FRACTIONS
;         .WORD   25,0,100                       ;COIN VALUE
;         .LONG   NULL_ST,PESETA_TRAIL           ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   SP_2                           ;TITLE OF COIN MODE
;         .LONG   SP_4100                        ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2
;         .LONG   PESETA25
;*
;*        AUSTRALIA 1   1 play / 3 X 20 CENTS    2 FOR $1.00
;*
;         .WORD   2,0,10,5,0,0                   ;WILLY PRICING
;         .WORD   5                              ;DOLLARS
;         .WORD   0                              ;DON'T SHOW FRACTIONS FOR THE 3 COINS
;         .WORD   1,0,5                          ;COIN VALUE
;         .LONG   DOLLAR_LEAD,NULL_ST           ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   AUS_1                          ;TITLE OF COIN MODE
;         .LONG   AU_60                          ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2
;         .LONG   AUST20C
;*
;*        AUSTRALIA 2   1 play / $1.00    3 plays for $2.00
;*
;         .WORD   1,0,5,5,10,0                   ;WILLY PRICING
;         .WORD   5                              ;DOLLARS
;         .WORD   1                              ;SHOW FRACTIONS FOR THE 3 COINS
;         .WORD   1,0,5                          ;COIN VALUE
;         .LONG   DOLLAR_LEAD,NULL_ST           ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   AUS_2                          ;TITLE OF COIN MODE
;         .LONG   AU_100                         ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_3
;         .LONG   AUST20C
;*
;*        JAPAN 1  1 play / 100 yen    
;*
;         .WORD   1,1,1,1,0,0                    ;WILLY PRICING
;         .WORD   1                              ;DOLLARS
;         .WORD   1                              ;FRACTIONS OK
;         .WORD   100,100,100                    ;COIN VALUE
;         .LONG   NULL_ST,YEN_TRAIL              ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   JAP_1                          ;TITLE OF COIN MODE
;         .LONG   JAP_100                        ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_1
;         .LONG   YEN100
;*
;*        JAPAN 2  2 play / 100 yen    
;*
;         .WORD   2,2,2,1,0,0                    ;WILLY PRICING
;         .WORD   1                              ;DOLLARS
;         .WORD   1                              ;FRACTIONS OK
;         .WORD   100,100,100                    ;COIN VALUE
;         .LONG   NULL_ST,YEN_TRAIL              ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   JAP_2                          ;TITLE OF COIN MODE
;         .LONG   JAP_200                        ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_1
;         .LONG   YEN100
;*
;*        AUSTRIA  1   1 Play / 5 Schilling  2 Play / 10 Schilling  
;*
;         .WORD   1,0,2,1,0,0                    ;WILLY PRICING
;         .WORD   1                              ;DOLLARS
;         .WORD   1                              ;FRACTIONS OK
;         .WORD   5,0,10                        ;COIN VALUE
;         .LONG   NULL_ST,SHILL_TRAIL            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   ASTA_1                          ;TITLE OF COIN MODE
;         .LONG   ASTA_15                         ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_1
;         .LONG   SHILL510
;*
;*        AUSTRIA  2   1 Play / 2 X 5 Schilling  3 Play / 10 Schilling  
;*
;         .WORD   1,0,2,2,4,0                    ;WILLY PRICING
;         .WORD   1                              ;DOLLARS
;         .WORD   1                              ;FRACTIONS OK
;         .WORD   5,0,10                        ;COIN VALUE
;         .LONG   NULL_ST,SHILL_TRAIL            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   ASTA_2                          ;TITLE OF COIN MODE
;         .LONG   ASTA_10                         ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2
;         .LONG   SHILL510
;*
;*        BELGIUM 1  1 play / 20F    
;*
;         .WORD   1,0,1,1,0,0                    ;WILLY PRICING
;         .WORD   1                              ;DOLLARS
;         .WORD   1                              ;FRACTIONS OK
;         .WORD   20,0,20                       ;COIN VALUE
;         .LONG   NULL_ST,FRANC_TRAIL            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   BEL_1                          ;TITLE OF COIN MODE
;         .LONG   BEL_120                        ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_1
;         .LONG   FRANC20
;*
;*        BELGIUM 2  3 play / 20F    
;*
;         .WORD   3,0,3,1,0,0                    ;WILLY PRICING
;         .WORD   1                              ;DOLLARS
;         .WORD   1                              ;FRACTIONS OK
;         .WORD   20,0,20                       ;COIN VALUE
;         .LONG   NULL_ST,FRANC_TRAIL            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   BEL_2                          ;TITLE OF COIN MODE
;         .LONG   BEL_320                        ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_1
;         .LONG   FRANC20
;*
;*        BELGIUM 3  2 play / 20F    
;*
;         .WORD   2,0,2,1,0,0                    ;WILLY PRICING
;         .WORD   1                              ;DOLLARS
;         .WORD   1                              ;FRACTIONS OK
;         .WORD   20,0,20                       ;COIN VALUE
;         .LONG   NULL_ST,FRANC_TRAIL            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   BEL_3                          ;TITLE OF COIN MODE
;         .LONG   BEL_220                        ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_1
;         .LONG   FRANC20
;*
;*        SWEDEN        1 play / 3 X 1 KRONA   2 PLAY  5 KRONA    
;*
;         .WORD   2,0,10,5,0,0                  ;WILLY PRICING
;         .WORD   1                              ;DOLLARS
;         .WORD   0                              ;DON'T SHOW FRACTIONS FOR THE 3 COINS
;         .WORD   1,0,5                          ;COIN VALUE
;         .LONG   NULL_ST,KRONA_TRAIL            ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   SWED_1                         ;TITLE OF COIN MODE
;         .LONG   SWED_2X5                       ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_1
;         .LONG   KRONA5
;*
;*        NEW ZEALAND 1        1 play / 3 X 20 CENT       
;*
;         .WORD   1,0,1,3,0,0                    ;WILLY PRICING
;         .WORD   5                              ;FIVE PER
;         .WORD   1                              ;SHOW FRACTIONS FOR THE 3 COINS
;         .WORD   1,0,1                          ;COIN VALUE
;         .LONG   DOLLAR_LEAD,NULL_ST           ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   NZ_1                           ;TITLE OF COIN MODE
;         .LONG   NZ_13                          ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_1
;         .LONG   NZ20
;
;*
;*        NEW ZEALAND 2        1 play / 2 X 20 CENT       
;*
;         .WORD   1,0,1,2,0,0                    ;WILLY PRICING
;         .WORD   5                              ;FIVE PER
;         .WORD   1                              ;SHOW FRACTIONS FOR THE 3 COINS
;         .WORD   1,0,1                          ;COIN VALUE
;         .LONG   DOLLAR_LEAD,NULL_ST           ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   NZ_2                           ;TITLE OF COIN MODE
;         .LONG   NZ_12                          ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_1
;         .LONG   NZ20
;*
;*        NETHERLANDS        1 PLAY / 1 HFL.   3 PLAY / 2.5 HFL.       
;*
;         .WORD   1,0,3,1,0,0                    ;WILLY PRICING
;         .WORD   2                              ;FIVE PER
;         .WORD   0                              ;SHOW FRACTIONS FOR THE 3 COINS
;         .WORD   2,0,5                          ;COIN VALUE
;         .LONG   NULL_ST,HFL_TRAIL              ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   NETH                           ;TITLE OF COIN MODE
;         .LONG   NETH_HF                        ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2
;         .LONG   HFSLOT
;
;*
;*        FINLAND        1 PLAY / 1 MARKKA       
;*
;         .WORD   1,0,1,1,0,0                    ;WILLY PRICING
;         .WORD   1                              ;FIVE PER
;         .WORD   0                              ;SHOW FRACTIONS FOR THE 3 COINS
;         .WORD   1,0,1                          ;COIN VALUE
;         .LONG   NULL_ST,MARKKA_TRAIL           ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   FINLAND                        ;TITLE OF COIN MODE
;         .LONG   FINMKA                         ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_1
;         .LONG   MKSLOT
;*
;*        NORWAY        1 PLAY / 2 X 1 KRONE    3/ 5 X 1 KRONE       
;*
;         .WORD   3,0,3,5,0,0                    ;WILLY PRICING
;         .WORD   1                              ;FIVE PER
;         .WORD   0                              ;SHOW FRACTIONS FOR THE 3 COINS
;         .WORD   1,0,1                          ;COIN VALUE
;         .LONG   NULL_ST,KRONE_TRAIL           ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   NORWAY                        ;TITLE OF COIN MODE
;         .LONG   KR_LIST                       ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_2
;         .LONG   NKRSLOT
;*
;*        DENMARK        1 PLAY / 2 X 1 KRONE    3/ 5 KRONE    7 / 10 KRONE     
;*
;         .WORD   3,0,15,5,30,0                  ;WILLY PRICING
;         .WORD   1                              ;FIVE PER
;         .WORD   0                              ;SHOW FRACTIONS FOR THE 3 COINS
;         .WORD   1,0,5                          ;COIN VALUE
;         .LONG   NULL_ST,KRONE_TRAIL           ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   DENMARK                        ;TITLE OF COIN MODE
;         .LONG   DKR_LIST                       ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_3
;         .LONG   DKRSLOT
;
;*
;*        ANTILLES      1 PLAY / 25 CENTS   4 PLAYS / 1 GUILDER     
;*
;         .WORD   1,0,4,1,0,0                    ;WILLY PRICING
;         .WORD   4                              ;FIVE PER
;         .WORD   0                              ;SHOW FRACTIONS FOR THE 3 COINS
;         .WORD   1,0,4                          ;COIN VALUE
;         .LONG   NULL_ST,GUILDER_TRAIL           ;CHARACTER STRINGS.
;         .LONG   CSM_LIST
;         .LONG   ANTILLES                       ;TITLE OF COIN MODE
;         .LONG   ANT_LIST                       ;1 COIN PER CREDIT (SERIES OF STRINGS)
;         .WORD   SHOW_1
;         .LONG   ANTSLOT
;
CS_ENTS  EQU     ($-CSELCT)/CS_SIZE             ;NUMBER OF ENTRIES IN TABLE

*
*        AUDIT TEXT
*

MESS_ERROR
         MESS_MAC  RD7FONT,SPACING07,0,0,ROBO_RED,STRLNRM,0
         .STRING   "  ERROR"
         .BYTE     0
         .EVEN

MESS_AUD_NUM
         MESS_MAC  RD7FONT,SPACING20,367,227,ROBO_YELLOW,STRRNRM,0

MESS_AUD_LINE
         MESS_MAC  RD7FONT,SPACING20,23,227,ROBO_YELLOW,STRLNRM,0

MES_AUD  .STRING "GAME AUDITS"
         .BYTE   0
         .EVEN

MES_BOOK
         .STRING "COIN  BOOKKEEPING"
         .BYTE   0
         .EVEN

M_LCOIN  .STRING "LEFT SLOT COINS"
         .BYTE   0
         .EVEN

M_CCOIN  .STRING "CENTER SLOT COINS"
         .BYTE   0
         .EVEN

M_RCOIN  .STRING "RIGHT SLOT COINS"
         .BYTE   0
         .EVEN

M_PAIDC  .STRING "PAID CREDITS"
         .BYTE   0
         .EVEN

M_START  .STRING "GAMES STARTED (FROM ANYWHERE)"
         .BYTE   0
         .EVEN

M_START2  .STRING "GAMES STARTED (ALWAYS FROM WAVE 1)"
         .BYTE   0
         .EVEN

M_CONT   .STRING "GAMES CONTINUED"
         .BYTE   0
         .EVEN

M_PLAYS  .STRING "TOTAL PLAYS"
         .BYTE   0
         .EVEN

M_HSLEFT .STRING "PLAYS UNTIL H.S. RESET"
         .BYTE   0
         .EVEN
M_HSOFF  .STRING "OFF"
         .BYTE   0
         .EVEN

M_EXTRA  .STRING "EXTRA MEN COLLECTED/EARNED"
         .BYTE   0
         .EVEN
M_P1MIN  .STRING "HOURS OF SINGLE PLAY"
         .BYTE   0
         .EVEN
M_P2MIN  .STRING "HOURS OF DUAL PLAY"
         .BYTE   0
         .EVEN
M_HOURS  .STRING "TOTAL HOURS OF PLAY"
         .BYTE   0
         .EVEN
M_AVGT   .STRING "AVG. "
         .BYTE   ASCII_DQ        ;DOUBLE QUOTE
         .STRING "PLAYER"
         .BYTE   ASCII_DQ        ;DOUBLE QUOTE
         .STRING " GAME TIME (MIN.)"
         .BYTE   0
         .EVEN
M_ELAPSE .STRING "AVG. ELAPSED TIME/PLAY"
         .BYTE   0
         .EVEN

M_WAVE1  .STRING "REACHED WAVE 2"
         .BYTE   0
         .EVEN
M_WAVE2  .STRING "REACHED MUTOID MAN"
         .BYTE   0
         .EVEN
M_WAVE3  .STRING "REACHED CIRCUIT 2 WAVE 1"
         .BYTE   0
         .EVEN
M_WAVE4  .STRING "REACHED SCAR FACE"
         .BYTE   0
         .EVEN
M_WAVE5  .STRING "REACHED CIRCUIT 3 WAVE 1"
         .BYTE   0
         .EVEN
M_WAVE6  .STRING "REACHED TEMPLE WAVES"
         .BYTE   0
         .EVEN
M_WAVE7  .STRING "REACHED BOSS SNAKES"
         .BYTE   0
         .EVEN
M_WAVE8  .STRING "REACHED END OF GAME"
         .BYTE   0
         .EVEN
M_MRBIG  .STRING "WATCHDOG LOCKUPS"
         .BYTE   0
         .EVEN

M_MONEY
         MESS_MAC  RD7FONT,SPACING20,367,227,ROBO_WHITE,STRRNRM,0

T_MONEY 
         MESS_MAC  RD7FONT,SPACING20,23,227,ROBO_WHITE,STRLNRM,0
         .STRING "TOTAL COLLECTION"
         .BYTE   0
         .EVEN

T_SUB     MESS_MAC  RD7FONT,SPACING20,23,227,ROBO_WHITE,STRLNRM,0
         .STRING "SUBTOTAL"
         .BYTE   0
         .EVEN

DT_Y1    EQU     15
DT_Y2    EQU     160H

DETAIL_TITLES
         MESS_MAC  RD7FONT,SPACING20,0C5H,DT_Y1,ROBO_ORANGE,STRCNRM,0
         .STRING "TOTAL COLLECTION"
         .BYTE   0,1
         .EVEN
         MESS_MAC  RD7FONT,SPACING20,0C5H,DT_Y2,ROBO_ORANGE,STRCNRM,0
         .STRING "COLLECTED WITH COIN DOOR CLOSED"
         .BYTE   0,0
         .EVEN

MESS_OPEN_OR_CANCEL
         MESS_MAC  RD7FONT,SPACING20,200,128,ROBO_RED,STRCNRM,0
         .STRING   "OPEN COIN DOOR, OR"
         .BYTE   0,1
         .EVEN
         MESS_MAC  RD7FONT,SPACING20,200,147,ROBO_RED,STRCNRM,0
         .STRING   "PRESS ANY BUTTON"
         .BYTE   0,1
         .EVEN
         MESS_MAC  RD7FONT,SPACING20,200,166,ROBO_RED,STRCNRM,0
         .STRING   "TO CANCEL"
         .BYTE   0,0
         .EVEN

**************************************************************************
*                                                                        *
*          COLLECTION MESSAGES                                           *
*                                                                        *
**************************************************************************
ME_ZERO          .STRING "0"
         .BYTE   0
         .EVEN

ME_DECIMAL       .STRING "."
         .BYTE   0
         .EVEN

ME_COLON .STRING ":"
         .BYTE   0
         .EVEN

DOLLAR_LEAD      .STRING "$  "
         .BYTE   0
         .EVEN

POUND_LEAD
         .BYTE   FONT_EPOUND
         .STRING "  "
         .BYTE   0
         .EVEN

NULL_ST       
         .BYTE   0
         .EVEN

DM_TRAIL         
	 .STRING "  DM"
         .BYTE   0
         .EVEN

FRANC_TRAIL
         .STRING "  FRANC"
         .BYTE   0
         .EVEN

LIRE_TRAIL 
         .STRING "  LIRE"
         .BYTE   0
         .EVEN

PESETA_TRAIL
	 .STRING "  PESETA"
         .BYTE   0
         .EVEN

YEN_TRAIL
         .STRING "  YEN"
         .BYTE   0
         .EVEN

SHILL_TRAIL
         .STRING "  SCHILLINGS"
         .BYTE   0
         .EVEN

KRONA_TRAIL
         .STRING "  KRONA"
         .BYTE   0
         .EVEN

COINS_TRAIL
         .STRING "  COINS"
         .BYTE   0
         .EVEN

HFL_TRAIL
         .STRING "  HFI."
         .BYTE   0
         .EVEN

MARKKA_TRAIL
         .STRING "  MARKKA"
         .BYTE   0
         .EVEN

KRONE_TRAIL
         .STRING "  KRONE"
         .BYTE 0
         .EVEN

GUILDER_TRAIL
         .STRING "  GUILDER"
         .BYTE 0
         .EVEN

M_LOCKUP .STRING "LOCKUP"
         .BYTE   0
         .EVEN
M_DOG    .STRING "WATCHDOG"
         .BYTE   0
         .EVEN
M_TRAP   .STRING "UNUSED TRAP"
         .BYTE   0
         .EVEN
M_SURV   .STRING "SURVIVED LOCKUPS"
         .BYTE   0
         .EVEN
M_HIDB   .STRING "GAMES NOT FINISHED"
         .BYTE   0
         .EVEN
M_LOOP   .STRING "LOOP-AROUND BUY-IN"
         .BYTE   0
         .EVEN

TWO_PER_PLAYER
         MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_11,ROBO_LASER,STRCNRM,0
         .STRING   "2 COINS PER PLAYER"
         .BYTE     0,0
         .EVEN

OCOP     MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_11,ROBO_LASER,STRCNRM,0
         .STRING   "1 COIN / 1 PLAY"
         .BYTE     0,0
         .EVEN

UK_ELECTRONIC
         MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_13,ROBO_LASER,STRCNRM,0
         .STRING   "1 CREDIT / 30 P"
         .BYTE     0,1
         .EVEN
         MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_23,ROBO_LASER,STRCNRM,0
         .STRING   "2 CREDITS / 50 P"
         .BYTE     0,1
         .EVEN
         MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_33,ROBO_LASER,STRCNRM,0
         .STRING         "4 CREDITS / "
         .BYTE           FONT_EPOUND
         .STRING         "1.00"
         .BYTE     0,0
         .EVEN
*
*        THE FOLLOWING 2 MESSAGES ARE GENERIC AND WILL
*        BE DISPLAYED IF THE MODE MATCHES AND NO 
*        APPROPRIATE MESSAGE EXISTS
*
*        THIS IS FOR THIS BEING THE ONLY MESSAGE DISPLAYED ON
*        THE SCREEN
*
TWO_TO_START
         MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_12,ROBO_LASER,STRCNRM,0
         .STRING   "2 CREDITS TO START"
         .BYTE     0,1
         .EVEN
         MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_22,ROBO_LASER,STRCNRM,0
         .STRING   "1 CREDIT TO CONTINUE"
         .BYTE     0,0
         .EVEN
*
*        THIS IS FOR LINES TWO AND 3 WITH AN ADDITIONAL LINE ABOVE
*

TWO_TS
         MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_23,ROBO_LASER,STRCNRM,0
         .STRING   "2 CREDITS TO START"
         .BYTE     0,1
         .EVEN
         MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_33,ROBO_LASER,STRCNRM,0
         .STRING   "1 CREDIT TO CONTINUE"
         .BYTE     0,0
         .EVEN

TWO_TP
         MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_22,ROBO_LASER,STRCNRM,0
         .STRING   "2 CREDITS PER PLAYER"
         .BYTE     0,0
         .EVEN

TWO_CRED_PER_PLAYER
         MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_11,ROBO_LASER,STRCNRM,0
         .STRING   "2 CREDITS PER PLAYER"
         .BYTE     0,0
         .EVEN

MAX_C_M  MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_11,ROBO_LF,STRCNRM,0
         .STRING   "MAXIMUM CREDITS!"
         .BYTE     0,0
         .EVEN
*
*        FOR CUSTOM MESSAGE ECHO
*
*
MESS_CMESS
         MESS_MAC  RD7FONT,SPACING20,CIN_X,CP_11,ROBO_YELLOW,STRCNRM,0

M_CMES_CURSOR
         MESS_MAC  RD7FONT,SPACING20,CIN_X,CP_11,ROBO_LF,STRLNRM,0
         .STRING   "_"
         .BYTE 0
         .EVEN
*
*        FOR THE COINAGE ADJUSTMENT MODE:
*
*
*        THIS SET IS TITLES FOR THE CANNED MODES.
*
USA_1    .STRING "U.S.A. 1"
         .BYTE   0
         .EVEN
;USA_2    .STRING "U.S.A. 2"
;         .BYTE   0
;         .EVEN
;USA_3    .STRING "U.S.A. 3"
;         .BYTE   0
;         .EVEN
;USA_4    .STRING "U.S.A. 4"
;         .BYTE   0
;         .EVEN
;USA_5    .STRING "U.S.A. 5"
;         .BYTE   0
;         .EVEN
;USA_6    .STRING "U.S.A. 6"
;         .BYTE   0
;         .EVEN
;USA_7    .STRING "U.S.A. 7"
;         .BYTE   0
;         .EVEN
;USA_8    .STRING "U.S.A. 8"
;         .BYTE   0
         .EVEN

GERMAN_1 .STRING "GERMAN 1"
         .BYTE   0
         .EVEN
;GERMAN_2 .STRING "GERMAN 2"
;         .BYTE   0
;         .EVEN
;GERMAN_3 .STRING "GERMAN 3"
;         .BYTE   0
;         .EVEN
;GERMAN_4 .STRING "GERMAN 4"
;         .BYTE   0
         .EVEN
FRENCH_1 .STRING "FRANCE 1"
         .BYTE   0
         .EVEN
;FRENCH_2 .STRING "FRANCE 2"
;         .BYTE   0
;         .EVEN
;FRENCH_3 .STRING "FRANCE 3"
;         .BYTE   0
;         .EVEN
;FRENCH_4 .STRING "FRANCE 4"
;         .BYTE   0
;         .EVEN
;FRENCH_5 .STRING "FRANCE 5"
;         .BYTE   0
;         .EVEN
;FRENCH_6 .STRING "FRANCE 6"
;         .BYTE   0
;         .EVEN
;FRENCH_7 .STRING "FRANCE 7"
;         .BYTE   0
;         .EVEN
;FRENCH_8 .STRING "FRANCE 8"
;         .BYTE   0
;         .EVEN
;FRENCH_9 .STRING "FRANCE 9"
;         .BYTE   0
;         .EVEN
;FRENCH_10 .STRING "FRANCE 10"
;         .BYTE   0
;         .EVEN
;FRENCH_11 .STRING "FRANCE 11"
;         .BYTE   0
;         .EVEN
;FRENCH_12 .STRING "FRANCE 12"
;         .BYTE   0
;         .EVEN
;SWISS_1 .STRING "SWISS 1"
;         .BYTE   0
;         .EVEN
;SWISS_2 .STRING "SWISS 2"
;         .BYTE   0
;         .EVEN
;SWISS_3 .STRING "SWISS 3"
;         .BYTE   0
;         .EVEN
;ITALY_1 .STRING "ITALY"
;         .BYTE   0
;         .EVEN
;UK_1     .STRING "U.K. 1"
;         .BYTE   0
;         .EVEN
;UK_2     .STRING "U.K. 2"
;         .BYTE   0
;         .EVEN
;UK_3     .STRING "U.K. ELECTRONIC"
;         .BYTE   0
;         .EVEN
;UK_4     .STRING "U.K. ELEC W/CCU"
;         .BYTE   0
;         .EVEN
;SP_1     .STRING "SPAIN 1"
;         .BYTE   0
;         .EVEN
;SP_2     .STRING "SPAIN 2"
;         .BYTE   0
;         .EVEN
;AUS_1    .STRING "AUSTRALIA 1"
;         .BYTE   0
;         .EVEN
;AUS_2    .STRING "AUSTRALIA 2"
;         .BYTE   0
;         .EVEN
;JAP_1    .STRING "JAPAN 1"
;         .BYTE   0
;         .EVEN
;JAP_2    .STRING "JAPAN 2"
;         .BYTE   0
;         .EVEN
;ASTA_1   .STRING "AUSTRIA 1"
;         .BYTE   0
;         .EVEN
;ASTA_2   .STRING "AUSTRIA 2"
;         .BYTE   0
;         .EVEN
;BEL_1    .STRING "BELGIUM 1"
;         .BYTE   0
;         .EVEN
;BEL_2    .STRING "BELGIUM 2"
;         .BYTE   0
;         .EVEN
;BEL_3    .STRING "BELGIUM 3"
;         .BYTE   0
;         .EVEN
;SWED_1   .STRING "SWEDEN"
;         .BYTE   0
;         .EVEN
;NZ_1     .STRING "NEW ZEALAND 1"
;         .BYTE   0
;         .EVEN
;NZ_2     .STRING "NEW ZEALAND 2"
;         .BYTE   0
;         .EVEN
;NETH     .STRING "NETHERLANDS"
;         .BYTE   0
;         .EVEN
;
;FINLAND  .STRING "FINLAND"
;         .BYTE 0
;         .EVEN
;
;NORWAY   .STRING "NORWAY"
;         .BYTE 0
;         .EVEN
;
;DENMARK  .STRING "DENMARK"
;         .BYTE 0
;         .EVEN
;
;ANTILLES .STRING "ANTILLES"
;         .BYTE 0
         .EVEN
*
*        THIS SECTION IS A POINTER TO STRING LISTS
*        FOR THE "CURRENT SETTING" BOX.
*
*
*        1 COIN / 1 CREDIT
Q_Q      .LONG   C11                  ;THIS POINTS AT MESSAGE
         .LONG   0                    ;THIS ENDS LIST
*
*         2 COINS / 1 CREDIT
*
C2_PERC  .LONG   C21
         .LONG   0
*
*        2 COINS / 1 CREDIT
*        4 COINS / 3 CREDITS
*
DOLLAR_3 .LONG   C21
         .LONG   C43
         .LONG   0
*
*        2 COINS / 1 CREDIT
*        4 COINS / 4 CREDITS
*
DOLLAR_4 .LONG   C21
         .LONG   C44
         .LONG   0

U1Q4D    .LONG   C11                  ;THIS POINTS AT MESSAGE
         .LONG   DOLL4                ;4 FOR A DOLLAR
         .LONG   0

UFS2D    .LONG   C21                  ;THIS POINTS AT MESSAGE
         .LONG   DOLL2                ;2 FOR A DOLLAR
         .LONG   0

UFS3D    .LONG   C21                  ;THIS POINTS AT MESSAGE
         .LONG   DOLL3                ;3 FOR A DOLLAR
         .LONG   0

UFS4D    .LONG   C21                  ;THIS POINTS AT MESSAGE
         .LONG   DOLL4                ;4 FOR A DOLLAR
         .LONG   0
*
*        1 PLAY 1/DM
*        5 PLAY 5/DM
*
DM_5     .LONG   DM11
         .LONG   DM55
         .LONG   0

DM_6     .LONG   DM11
         .LONG   DM65
         .LONG   0

DM_7     .LONG   DM11
         .LONG   DM75
         .LONG   0

DM_8     .LONG   DM11
         .LONG   DM85
         .LONG   0

SFRANC_6     .LONG   SFRANC11
         .LONG   SFRANC65
         .LONG   0

SFRANC_7     .LONG   SFRANC11
         .LONG   SFRANC75
         .LONG   0

SFRANC_8     .LONG   SFRANC11
         .LONG   SFRANC85
         .LONG   0
*
*        2 PLAYS 5F / 5 PLAYS 10F
*
FIVE_10  .LONG   F25
         .LONG   F510
         .LONG   0

FIVE_10_11
         .LONG   F25
         .LONG   F510
         .LONG   F1120
         .LONG   0

FOUR_10  .LONG   F25  
         .LONG   F410
         .LONG   0

FOUR_10_9
         .LONG   F25  
         .LONG   F410
         .LONG   F4109
         .LONG   0

THREE_10 .LONG   F15  
         .LONG   F310
         .LONG   0

THREE_10_7
         .LONG   F15  
         .LONG   F310
         .LONG   F4107
         .LONG   0

TWO_10   .LONG   F15  
         .LONG   F210
         .LONG   0

TWO_10_5 .LONG   F15  
         .LONG   F210
         .LONG   F4105
         .LONG   0

F1325    .LONG   F3X1F
         .LONG   F2F5
         .LONG   0

F13255   .LONG   F3X1F
         .LONG   F2F5
         .LONG   F52X5
         .LONG   0

F1235    .LONG   F2X1F
         .LONG   F3F5
         .LONG   0

F12355   .LONG   F2X1F
         .LONG   F3F5
         .LONG   F72X5
         .LONG   0

*
*        500 LIRE
*
P1500L   .LONG   P1500L_P
         .LONG   0
*
*        1 PLAY / 20 P    3 PLAYS 50 P
*
UK_120   .LONG   UK_1201
         .LONG   UK_1202
         .LONG   0

UK_220   .LONG   UK_2201
         .LONG   UK_2202
         .LONG   0

UK_320   .LONG   UK_3201
         .LONG   UK_3202
         .LONG   UK_3203
         .LONG   0

SP_4100  .LONG   SP_11
         .LONG   SP_44
         .LONG   0

SP_5100  .LONG   SP_11
         .LONG   SP_54
         .LONG   0

AU_60    .LONG   AU_36
         .LONG   AU_2D
         .LONG   0

AU_100   .LONG   AU_520
         .LONG   AU_1D
         .LONG   AU_32D
         .LONG   0

JAP_100  .LONG   JAP_101
         .LONG   0

JAP_200  .LONG   JAP_201
         .LONG   0

ASTA_10  .LONG   ASTA101
         .LONG   ASTA102
         .LONG   0

ASTA_15  .LONG   ASTA151
         .LONG   ASTA152
         .LONG   0

BEL_120  .LONG   BEL_1201
         .LONG   0
BEL_220  .LONG   BEL_2201
         .LONG   0
BEL_320  .LONG   BEL_3201
         .LONG   0

SWED_2X5 .LONG   SWED_S51
         .LONG   SWED_S52
         .LONG   0

NZ_12    .LONG   NZ_121
         .LONG   0

NZ_13    .LONG   NZ_131
         .LONG   0

NETH_HF  .LONG   HF_11
         .LONG   HF_32
         .LONG   0

FINMKA   .LONG   FIN_1
         .LONG   0

KR_LIST  .LONG   NOR_12
         .LONG   NOR_35
         .LONG   0

DKR_LIST .LONG   DEN_12
         .LONG   DEN_35
         .LONG   DEN_710
         .LONG   0

ANT_LIST .LONG   ANT1P25
         .LONG   ANT4DOL
         .LONG   0

C11      .STRING  "1 CREDIT / 1 COIN"
         .BYTE 0
         .EVEN
C21      .STRING  "1 CREDIT / 2 COINS"
         .BYTE 0
         .EVEN
C43      .STRING  "3 CREDITS / 4 COINS"
         .BYTE 0
         .EVEN
C44      .STRING  "4 CREDITS / 4 COINS"
         .BYTE 0
         .EVEN

DOLL2    .STRING  "2 CREDITS / $1.00"
         .BYTE 0
         .EVEN

DOLL3    .STRING  "3 CREDITS / $1.00"
         .BYTE 0
         .EVEN

DOLL4    .STRING  "4 CREDITS / $1.00"
         .BYTE 0
         .EVEN

DM11     .STRING  "1 CREDIT / 1 DM"
         .BYTE 0
         .EVEN
DM55     .STRING  "5 CREDITS / 5 DM"
         .BYTE 0
         .EVEN
DM65     .STRING  "6 CREDITS / 5 DM"
         .BYTE 0
         .EVEN
DM75     .STRING  "7 CREDITS / 5 DM"
         .BYTE 0
         .EVEN
DM85     .STRING  "8 CREDITS / 5 DM"
         .BYTE 0
         .EVEN

F3F5     .STRING  "3 CREDITS / 5F"
         .BYTE 0
         .EVEN
F2F5
F25      .STRING  "2 CREDITS / 5F"
         .BYTE 0
         .EVEN
F15      .STRING  "1 CREDIT / 5F"
         .BYTE 0
         .EVEN
F510     .STRING  "5 CREDITS / 10F"
         .BYTE 0
         .EVEN
F1120    .STRING  "11 CREDITS / 2 X 10F"
         .BYTE 0
         .EVEN
F4109    .STRING  "9 CREDITS / 2 X 10F"
         .BYTE 0
         .EVEN
F4107    .STRING  "7 CREDITS / 2 X 10F"
         .BYTE 0
         .EVEN
F4105    .STRING  "5 CREDITS / 2 X 10F"
         .BYTE 0
         .EVEN
F410     .STRING  "4 CREDITS / 10F"
         .BYTE 0
         .EVEN
F310     .STRING  "3 CREDITS / 10F"
         .BYTE 0
         .EVEN
F210     .STRING  "2 CREDITS / 10F"
         .BYTE 0
         .EVEN

F3X1F    .STRING  "1 CREDIT / 3 X 1F"
         .BYTE   0
         .EVEN

F2X1F    .STRING  "1 CREDIT / 2 X 1F"
         .BYTE   0
         .EVEN

F52X5    .STRING  "5 CREDITS / 2 X 5F"
         .BYTE   0
         .EVEN

F72X5    .STRING  "7 CREDITS / 2 X 5F"
         .BYTE   0
         .EVEN

SFRANC11     
	 .STRING  "1 CREDIT / 1F"
         .BYTE 0
         .EVEN
SFRANC65 
	 .STRING  "6 CREDITS / 5F"
         .BYTE 0
         .EVEN
SFRANC75
	 .STRING  "7 CREDITS / 5F"
         .BYTE 0
         .EVEN
SFRANC85
	 .STRING  "8 CREDITS / 5F"
         .BYTE 0
         .EVEN

P1500L_P .STRING      "1 CREDIT / 500 LIRE"
         .BYTE 0
         .EVEN

UK_1201  .STRING         "1 CREDIT / 20 P"
         .BYTE 0
         .EVEN
UK_1202  .STRING         "3 CREDITS / 50 P"
         .BYTE 0
         .EVEN

UK_2201  .STRING         "2 CREDITS / 20 P"
         .BYTE 0
         .EVEN
UK_2202  .STRING         "5 CREDITS / 50 P"
         .BYTE 0
         .EVEN

UK_3201  .STRING         "1 CREDIT / 30 P"
         .BYTE 0
         .EVEN
UK_3202  .STRING         "2 CREDITS / 50 P"
         .BYTE 0
         .EVEN
UK_3203  .STRING         "4 CREDITS / L1.00"
         .BYTE 0
         .EVEN

SP_11    .STRING         "1 CREDIT / 25 PESETA"
         .BYTE   0
         .EVEN

SP_44    .STRING         "4 CREDITS / 100 PESETA"
         .BYTE   0
         .EVEN

SP_54    .STRING         "5 CREDITS / 100 PESETA"
         .BYTE   0
         .EVEN
NZ_131
AU_36    .STRING         "1 CREDIT / 3 X 20 CENTS"
         .BYTE   0
         .EVEN
AU_2D    .STRING         "2 CREDITS / $ 1.00"
         .BYTE   0
         .EVEN
AU_520   .STRING         "1 CREDIT / 5 X 20 CENTS"
         .BYTE   0
         .EVEN
AU_1D    .STRING         "1 CREDIT / $ 1.00"
         .BYTE   0
         .EVEN
AU_32D   .STRING         "3 CREDITS / $ 2.00"
         .BYTE   0
         .EVEN
JAP_101  .STRING         "1 CREDIT / 100 YEN"
         .BYTE   0
         .EVEN
JAP_201  .STRING         "2 CREDITS / 100 YEN"
         .BYTE   0
         .EVEN
ASTA101  .STRING         "1 CREDIT / 2 X 5 SCHILLING"
         .BYTE   0
         .EVEN
ASTA102  .STRING         "3 CREDITS / 2 X 10 SCHILLING"
         .BYTE   0
         .EVEN
ASTA151  .STRING         "1 CREDIT / 5 SCHILLING"
         .BYTE   0
         .EVEN
ASTA152  .STRING         "2 CREDITS / 10 SCHILLING"
         .BYTE   0
         .EVEN

BEL_1201 .STRING         "1 CREDIT / 2OF"
         .BYTE   0
         .EVEN
BEL_2201 .STRING         "2 CREDITS / 2OF"
         .BYTE   0
         .EVEN
BEL_3201 .STRING         "3 CREDITS / 2OF"
         .BYTE   0
         .EVEN

SWED_S51 .STRING         "1 CREDIT / 3 X 1 KRONA"
         .BYTE   0
         .EVEN
SWED_S52 .STRING         "2 CREDITS / 5 KRONA"
         .BYTE   0
         .EVEN

NZ_121   .STRING         "1 CREDIT / 2 X 20 CENTS"
         .BYTE   0
         .EVEN

HF_11    .STRING         "1 CREDIT / 1 HFI"
         .BYTE   0
         .EVEN

HF_32    .STRING         "3 CREDITS / 2.5 HFI"
         .BYTE   0
         .EVEN

FIN_1    .STRING         "1 CREDIT / 1 MARKKA"
         .BYTE   0
         .EVEN

DEN_12
NOR_12   .STRING         "1 CREDIT / 2 X 1 KRONE"
         .BYTE 0
         .EVEN

NOR_35   .STRING         "3 CREDITS / 5 X 1 KRONE"
         .BYTE 0
         .EVEN

DEN_35   .STRING         "3 CREDITS / 5 KRONE"
         .BYTE 0
         .EVEN

DEN_710  .STRING         "7 CREDITS / 2 X 5 KRONE"
         .BYTE 0
         .EVEN

ANT1P25  .STRING         "1 CREDIT / 25 CENTS"
         .BYTE 0
         .EVEN

ANT4DOL  .STRING         "4 CREDITS / 1 GUILDER"
         .BYTE 0
         .EVEN

**************************************************************************
*                                                                        *
*          COIN SLOT TITLES                                              *
*                                                                        *
**************************************************************************
USA_QQ       .STRING   "25 CENT       25 CENT"
             .BYTE 0
             .EVEN
USA_QDQ       .STRING   "25 CENT     $1.00     25 CENT"
             .BYTE 0
             .EVEN
GERMAN_15    .STRING   "1 DM          5 DM"
             .BYTE 0
             .EVEN
FRENCH510    .STRING   "5 F           10 F"
             .BYTE 0
             .EVEN
FRENCH1F5F
SWISS15      .STRING   "1 F           5 F"
             .BYTE 0
             .EVEN
ITALYLIRE    .STRING   "500 LIRE      500 LIRE"
             .BYTE 0
             .EVEN
UK2050       .STRING   "20 P          50 P"   
             .BYTE 0
             .EVEN
UK_ELEC      .STRING   "50P    10P   L1.00"   
             .BYTE 0
             .EVEN
UK_CCU       .STRING   "CCU ON LEFT SLOT            "   
             .BYTE 0
             .EVEN
PESETA25     .STRING   "25 PESETA     100 PESETA"
             .BYTE 0
             .EVEN
AUST20C      .STRING   "20 CENT       $ 1.00"
             .BYTE 0
             .EVEN
YEN100       .STRING   "100 YEN       100 YEN"
             .BYTE 0
             .EVEN
SHILL510     .STRING   "5 SCHILLING   10 SCHILLING"
             .BYTE 0
             .EVEN
FRANC20      .STRING   "20 F          20 F"
             .BYTE 0
             .EVEN
KRONA5       .STRING   "1 KRONA       5 KRONA"
             .BYTE 0
             .EVEN
NZ20         .STRING   "20 CENT       20 CENT"
             .BYTE 0
             .EVEN
HFSLOT       .STRING   "1 HFI         2.5 HFI"
             .BYTE 0
             .EVEN

MKSLOT       .STRING   "1 MARKKA      1 MARKKA"
             .BYTE 0
             .EVEN

NKRSLOT      .STRING   "1 KRONE       1 KRONE"
             .BYTE 0
             .EVEN

DKRSLOT      .STRING   "1 KRONE       5 KRONE"
             .BYTE 0
             .EVEN

ANTSLOT      .STRING   "25 CENTS      1 GUILDER"
             .BYTE 0
             .EVEN

**************************************************************************
*                                                                        *
*          MENU DESCRIPTORS                                              *
*                                                                        *
**************************************************************************
*
*        MAIN TEST MENU
*
MEN_MAIN
         .LONG   RD7FONT         ;FONT  
         .LONG   STRCNRM         ;CENTER PLEASE
         .LONG   MESSMAIN        ;TITLE
         .WORD   ROBO_WHITE     ;COLOR OF TITLE
         .WORD   MENU_X          ;UL X
         .WORD   MENU_Y-3        ;UL Y
         .WORD   MENU_DY         ;VERTICAL SPACING
         .WORD   ROBO_WHITE     ;COLOR WHEN NOT SELECTED
         .WORD   16              ;HEIGHT OF SELECTION BAR
         .WORD   -4              ;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
         .WORD   BAR_DX          ;EXTRA X ON EACH SIDE.
         .WORD   BAR_WID         ;WIDTH OF BAR!
         .WORD   ROBO_DECAY     ;TEXT COLOR OF SELECTED ITEM
         .LONG   MESS_DIAG,GO_DIAG,DIAG_HELP
         .LONG   MESS_COIN_AUD,GO_BOOK,COIN_HELP
         .LONG   MESS_GAME_AUD,GO_AUD,AUDIT_HELP
         .LONG   MESS_GAME_ADJ,GO_ADJ,ADJUST_HELP
         .LONG   MESS_UTIL,GO_UTIL,UTIL_HELP
         .LONG   MESS_EXIT,0,EXIT_HELP       ;SPECIAL CASE!
         .LONG   0               ;END
*
*        UTILITES MENU GOES LEFT OF CENTER
*
UM_WID   EQU     206
UM_X     EQU     TIT_ULX+GAP+MB_XWID+(UM_WID/2)+C_KLUDGE

MEN_UTIL .LONG   RD7FONT        ;FONT
         .LONG   STRCNRM         ;CENTER PLEASE
         .LONG   MESSUTIL        ;TITLE
         .WORD   ROBO_PINK      ;COLOR OF TITLE
         .WORD   UM_X            ;UL X
         .WORD   MENU_Y-3        ;UL Y
         .WORD   20              ;VERTICAL SPACING
         .WORD   ROBO_PINK       ;COLOR WHEN NOT SELECTED
         .WORD   16              ;HEIGHT OF SELECTION BAR
         .WORD   -4              ;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
         .WORD   BAR_DX          ;EXTRA X ON EACH SIDE.
         .WORD   UM_WID          ;WIDTH OF BAR!
         .WORD   ROBO_DECAY      ;TEXT COLOR OF SELECTED ITEM
;         .LONG   MESS_OPMESS,DO_OPMESS,OPMESS_HELP
         .LONG   MESS_CLCRED,DO_CLCRED,CLCRED_HELP
         .LONG   MESS_CLCOIN,DO_CLCOIN,CLCOIN_HELP
         .LONG   MESS_CLAUD,DO_CLAUD,CLAUD_HELP
         .LONG   MESS_HSRES,DO_HSRES,HSRES_HELP
         .LONG   MESS_DEF_ADJ,DO_DEF_ADJ,DEF_ADJ_HELP
         .LONG   MESS_FACSET,DO_FACSET,FACSET_HELP
         .LONG   MESS_MM,0,BLNK_HELP        ;RETURN TO MAIN MENU
         .LONG   0               ;END
*
*        DIAGNOSTIC TESTS MENU
*
MEN_DIAG
         .LONG   RD7FONT         ;FONT
         .LONG   STRCNRM         ;CENTER PLEASE
         .LONG   MESSDIAG        ;TITLE
         .WORD   ROBO_RED       ;COLOR OF TITLE
         .WORD   200             ;UL X
         .WORD   MENU_Y-3        ;UL Y
         .WORD   20              ;VERTICAL SPACING
         .WORD   ROBO_RED       ;COLOR WHEN NOT SELECTED
         .WORD   16              ;HEIGHT OF SELECTION BAR
         .WORD   -4              ;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
         .WORD   BAR_DX          ;EXTRA X ON EACH SIDE.
         .WORD   195             ;WIDTH OF BAR!  (A LITTLE FATTER)
         .WORD   ROBO_DECAY      ;TEXT COLOR OF SELECTED ITEM
         .LONG   MESS_SWTEST,GO_SWTEST,BLNK_HELP   
;         .LONG   MESS_ROMTEST,GO_ROMTEST,BLNK_HELP  
ROM_LEV  EQU     3               ;TEST NUMBER FOLLOWING ROM TEST
         .LONG   MESS_CPUTEST,GO_CPUTEST,BLNK_HELP  
RTR_LEV  EQU     4               ;TEST NUMBER FOLLOWING CPU TEST (FOR RETURN)
         .LONG   M_STEST,GO_STEST,BLNK_HELP
         .LONG   MESS_PATTERNS,GO_PATTERNS,BLNK_HELP
         .LONG   MESS_BURN,DO_BURN,BLNK_HELP
         .LONG   MESS_MM,0,BLNK_HELP        ;RETURN TO MAIN MENU
         .LONG   0

STM_WID   EQU     250

;MEN_STEST
;         .LONG   RD7FONT        ;FONT
;         .LONG   STRCNRM         ;CENTER PLEASE
;         .LONG   M_STEST         ;TITLE
;         .WORD   ROBO_PURPLE    ;COLOR OF TITLE
;         .WORD   200             ;UL X
;         .WORD   MENU_Y-3        ;UL Y
;         .WORD   18              ;VERTICAL SPACING
;         .WORD   ROBO_PURPLE     ;COLOR WHEN NOT SELECTED
;         .WORD   16              ;HEIGHT OF SELECTION BAR
;         .WORD   -4              ;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
;         .WORD   BAR_DX          ;EXTRA X ON EACH SIDE.
;         .WORD   STM_WID          ;WIDTH OF BAR!
;         .WORD   ROBO_DECAY      ;TEXT COLOR OF SELECTED ITEM
;         .LONG   M_SYNT,GO_SYNT,SND_HELP
;         .LONG   M_DIGT,GO_DIGT,SND_HELP
;         .LONG   M_SYNP,GO_SYNP,SND_PLAY
;         .LONG   M_DIGP,GO_DIGP,SND_PLAY
;         .LONG   MESS_DIAGM,0,SND_HELP
;         .LONG   MESS_MM,FORCE_MAIN,NO_HELP        ;RETURN TO MAIN MENU
;        .LONG   0
*
*        PRESS ANY BUTTON TO CONTINUE
*
ANY_MENU
         .LONG   RD7FONT        ;FONT
         .LONG   STRCNRM         ;CENTER PLEASE
         .LONG   0               ;TITLE
         .WORD   0               ;COLOR OF TITLE
         .WORD   200             ;UL X
         .WORD   200             ;UL Y
         .WORD   MENU_DY         ;VERTICAL SPACING
         .WORD   ROBO_CYAN      ;COLOR WHEN NOT SELECTED
         .WORD   BAR_HITE        ;HEIGHT OF SELECTION BAR
         .WORD   -12              ;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
         .WORD   BAR_DX          ;EXTRA X ON EACH SIDE.
         .WORD   234             ;WIDTH OF BAR!
         .WORD   ROBO_DECAY      ;TEXT COLOR OF SELECTED ITEM
         .LONG   MESS_ANY,0,NO_HELP   
         .LONG   0
*
*        MONITOR PATTERNS
*
MEN_PATTERNS
         .LONG   RD7FONT        ;FONT
         .LONG   STRCNRM         ;CENTER PLEASE
         .LONG   MESSPAT         ;TITLE
         .WORD   ROBO_YELLOW    ;COLOR OF TITLE
         .WORD   200             ;UL X      (CENTER IT!)
         .WORD   MENU_Y-3        ;UL Y
         .WORD   23              ;VERTICAL SPACING
         .WORD   ROBO_YELLOW    ;COLOR WHEN NOT SELECTED
         .WORD   16              ;HEIGHT OF SELECTION BAR
         .WORD   -4              ;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
         .WORD   BAR_DX          ;EXTRA X ON EACH SIDE.
         .WORD   234             ;WIDTH OF BAR!
         .WORD   ROBO_DECAY      ;TEXT COLOR OF SELECTED ITEM
         .LONG   MESS_RED,GO_RED,BLNK_HELP
         .LONG   MESS_GREEN,GO_GREEN,BLNK_HELP
         .LONG   MESS_BLUE,GO_BLUE,BLNK_HELP
         .LONG   MESS_BARS,GO_BARS,BLNK_HELP
         .LONG   MESS_CROSS,GO_CROSS,BLNK_HELP
         .LONG   MESS_DIAGM,0,BLNK_HELP
         .LONG   MESS_MM,FORCE_MAIN,NO_HELP        ;RETURN TO MAIN MENU
         .LONG   0
*
*        DETAILED COINAGE AVAILABLE (ON 1ST COINAGE PAGE)
*
MEN_DETAIL
         .LONG   RD7FONT         ;FONT
         .LONG   STRCNRM         ;CENTER PLEASE
         .LONG   MESSPAT         ;TITLE
         .WORD   ROBO_YELLOW       ;COLOR OF TITLE
         .WORD   200             ;UL X      (CENTER IT!)
         .WORD   224             ;UL Y
         .WORD   12              ;VERTICAL SPACING
         .WORD   ROBO_CYAN      ;COLOR WHEN NOT SELECTED
         .WORD   10              ;HEIGHT OF SELECTION BAR
         .WORD   -1              ;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
         .WORD   BAR_DX          ;EXTRA X ON EACH SIDE.
         .WORD   157             ;WIDTH OF BAR!
         .WORD   ROBO_DECAY     ;TEXT COLOR OF SELECTED ITEM
         .LONG   MESS_DETAIL,0,NO_HELP               ;DETAILED SECTION
         .LONG   MESS_MM,FORCE_MAIN,NO_HELP   ;RETURN TO MAIN MENU
         .LONG   0
*
*        CLEAR SUB-TOTALS (ON DETAILED COINAGE PAGE)
*
MEN_CLR_SUB
         .LONG   RD7FONT         ;FONT
         .LONG   STRCNRM         ;CENTER PLEASE
         .LONG   MESSPAT         ;TITLE
         .WORD   ROBO_YELLOW       ;COLOR OF TITLE
         .WORD   200             ;UL X      (CENTER IT!)
         .WORD   0E6H            ;UL Y
         .WORD   10              ;VERTICAL SPACING
         .WORD   ROBO_CYAN      ;COLOR WHEN NOT SELECTED
         .WORD   10              ;HEIGHT OF SELECTION BAR
         .WORD   -1              ;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
         .WORD   BAR_DX          ;EXTRA X ON EACH SIDE.
         .WORD   157             ;WIDTH OF BAR!
         .WORD   ROBO_DECAY     ;TEXT COLOR OF SELECTED ITEM
         .LONG   MESS_CLEAR_SUBS,0,NO_HELP           ;CLEAR SUB-TOTALS
         .LONG   MESS_MM,FORCE_MAIN,NO_HELP   ;RETURN TO MAIN MENU
         .LONG   0
*
*        YES/NO   (FOR ARE YOU SURE?)
*
MEN_YN   .LONG   RD7FONT        ;FONT
         .LONG   STRCNRM         ;CENTER PLEASE
         .LONG   MESSDIAG        ;TITLE
         .WORD   ROBO_RED       ;COLOR OF TITLE
         .WORD   200             ;UL X
         .WORD   166             ;UL Y
         .WORD   19              ;VERTICAL SPACING
         .WORD   ROBO_YELLOW    ;COLOR WHEN NOT SELECTED
         .WORD   16              ;HEIGHT OF SELECTION BAR
         .WORD   -4              ;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
         .WORD   BAR_DX          ;EXTRA X ON EACH SIDE.
         .WORD   78              ;WIDTH OF BAR!  (A LITTLE FATTER)
         .WORD   ROBO_DECAY      ;TEXT COLOR OF SELECTED ITEM
         .LONG   MESS_YES,0,NO_HELP
         .LONG   MESS_NO,0,NO_HELP
         .LONG   0
*
*        NEXT AUDIT PAGE
*
MEN_AP1  .LONG   RD7FONT         ;FONT
         .LONG   STRCNRM         ;CENTER PLEASE
         .LONG   MESSPAT         ;TITLE
         .WORD   ROBO_YELLOW       ;COLOR OF TITLE
         .WORD   200             ;UL X      (CENTER IT!)
         .WORD   226    	 ;UL Y
         .WORD   12               ;VERTICAL SPACING
         .WORD   ROBO_CYAN      ;COLOR WHEN NOT SELECTED
         .WORD   10              ;HEIGHT OF SELECTION BAR
         .WORD   -1              ;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
         .WORD   BAR_DX          ;EXTRA X ON EACH SIDE.
         .WORD   157             ;WIDTH OF BAR!
         .WORD   ROBO_DECAY     ;TEXT COLOR OF SELECTED ITEM
         .LONG   MESS_TOPAGE2,0,NO_HELP               ;DETAILED SECTION
         .LONG   MESS_MM,FORCE_MAIN,NO_HELP   ;RETURN TO MAIN MENU
         .LONG   0
*
*        PREVIOUS AUDIT PAGE?  (ON 2ND GAME AUDIT PAGE)
*
MEN_AP2  .LONG   RD7FONT         ;FONT
         .LONG   STRCNRM         ;CENTER PLEASE
         .LONG   MESSPAT         ;TITLE
         .WORD   ROBO_YELLOW    ;COLOR OF TITLE
         .WORD   200             ;UL X      (CENTER IT!)
         .WORD   226       	 ;UL Y
         .WORD   12        	 ;VERTICAL SPACING
         .WORD   ROBO_CYAN      ;COLOR WHEN NOT SELECTED
         .WORD   10              ;HEIGHT OF SELECTION BAR
         .WORD   -1   		 ;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
         .WORD   BAR_DX          ;EXTRA X ON EACH SIDE.
         .WORD   157             ;WIDTH OF BAR!
         .WORD   ROBO_DECAY     ;TEXT COLOR OF SELECTED ITEM
         .LONG   MESS_BACKP1,0,NO_HELP               ;DETAILED SECTION
         .LONG   MESS_MM,FORCE_MAIN,NO_HELP   ;RETURN TO MAIN MENU
         .LONG   0

**************************************************************************
*                                                                        *
*         HELP MENUS FOR MAIN MENU                                       *
*                                                                        *
**************************************************************************
*        HM_JUST         0 = CENTER   1 = LEFT
*        HM_COLOR
*        HM_ENTS 
*
DIAG_HELP
         .WORD   0               ;CENTER JUSTIFY
         .WORD   ROBO_PINK      ;COLOR
         .WORD   5               ;# ENTRIES
         .LONG   MESS_SWTEST
;         .LONG   MESS_ROMTEST
         .LONG   MESS_CPUTEST
         .LONG   M_STEST
         .LONG   MESS_PATTERNS
         .LONG   U_BURNIN

COIN_HELP
         .WORD   0               ;CENTER JUSTIFY
         .WORD   ROBO_PINK      ;COLOR
         .WORD   3               ;2 ENTRIES
         .LONG   CH_0
         .LONG   CH_1
         .LONG   CH_2

AUDIT_HELP
         .WORD   0               ;CENTER JUSTIFY
         .WORD   ROBO_PINK      ;COLOR
         .WORD   2               ;2 ENTRIES
         .LONG   AH_1
         .LONG   AH_2

ADJUST_HELP
         .WORD   0               ;CENTER JUSTIFY
         .WORD   ROBO_PINK      ;COLOR
         .WORD   3               ;3 ENTRIES
         .LONG   AD_1
         .LONG   AD_2
         .LONG   AD_3

UTIL_HELP
         .WORD   0               ;CENTER JUSTIFY
         .WORD   ROBO_PINK      ;COLOR
         .WORD   5               ;6 ENTRIES
;         .LONG   U_OPMESS
         .LONG   U_CLR_CRED
         .LONG   U_CLR_COIN
         .LONG   U_CLR_AUD
         .LONG   U_HSRESET
         .LONG   U_FACTORY

EXIT_HELP
         .WORD   0               ;CENTER JUSTIFY
         .WORD   ROBO_PINK      ;COLOR
         .WORD   1               ;1 ENTRY
         .LONG   U_END

*
*        HELP FOR UTILITY MENU
*
CLCRED_HELP
         .WORD   0               ;CENTER JUSTIFY
         .WORD   ROBO_CYAN      ;COLOR
         .WORD   3               ;2 ENTRIES
         .LONG   MEH_CLCRED1
         .LONG   MEH_CLCRED2
         .LONG   MEH_CLCRED3

CLCOIN_HELP
         .WORD   0               ;CENTER JUSTIFY
         .WORD   ROBO_CYAN      ;COLOR
         .WORD   4               ;2 ENTRIES
         .LONG   MEH_CLCOIN1
         .LONG   MEH_CLCOIN2
         .LONG   MEH_CLCOIN3
         .LONG   MEH_CLCOIN4

CLAUD_HELP
         .WORD   0               ;CENTER JUSTIFY
         .WORD   ROBO_CYAN      ;COLOR
         .WORD   2               ;2 ENTRIES
         .LONG   MEH_CLAUD1
         .LONG   MEH_CLAUD2

HSRES_HELP
         .WORD   0               ;CENTER JUSTIFY
         .WORD   ROBO_CYAN      ;COLOR
         .WORD   3               ;2 ENTRIES
         .LONG   MEH_RESHS1
         .LONG   MEH_RESHS2
         .LONG   MEH_RESHS3

;OPMESS_HELP
;         .WORD   0               ;CENTER JUSTIFY
;         .WORD   ROBO_CYAN      ;COLOR
;         .WORD   4               ;2 ENTRIES
;         .LONG   MEH_CUSM1
;         .LONG   MEH_CUSM2
;         .LONG   MEH_CUSM3
;         .LONG   MEH_CUSM4

DEF_ADJ_HELP
         .WORD   0               ;CENTER JUSTIFY
         .WORD   ROBO_CYAN      ;COLOR
         .WORD   4               ;2 ENTRIES
         .LONG   MEH_DEFA1
         .LONG   MEH_DEFA2
         .LONG   MEH_DEFA3
         .LONG   MEH_DEFA4

FACSET_HELP
         .WORD   0               ;CENTER JUSTIFY
         .WORD   ROBO_CYAN      ;COLOR
         .WORD   6               ;2 ENTRIES
         .LONG   MEH_FAC1
         .LONG   MEH_FAC2
         .LONG   MEH_FAC3
         .LONG   MEH_FAC4
         .LONG   MEH_FAC5
         .LONG   MEH_FAC6

**************************************************************************
*                                                                        *
*          TEXT STRINGS                                                  *
*                                                                        *
**************************************************************************
MESS_YES
         .STRING         "YES"
         .BYTE           0
         .EVEN

MESS_NO  .STRING         "NO"
         .BYTE           0
         .EVEN

MESS_CLEAR_SUBS
         .STRING         "CLEAR SUBTOTALS"
         .BYTE           0
         .EVEN

MESS_SUBS_CLEAR
         .STRING         "SUBTOTALS CLEARED"
         .BYTE           0
         .EVEN

MESS_DETAIL
         .STRING         "MORE DETAILED DATA"
         .BYTE           0
         .EVEN

MESS_TOPAGE2
         .STRING         "NEXT AUDIT PAGE"
         .BYTE           0
         .EVEN

MESS_BACKP1
         .STRING         "PREVIOUS AUDIT PAGE"
         .BYTE           0
         .EVEN

MESS_ANY
         .STRING         "ANY BUTTON TO CONTINUE"
         .BYTE           0
         .EVEN

MESS_MM
         .STRING         "RETURN TO MAIN MENU"
         .BYTE           0
         .EVEN

MESSDIAG                                      ;THIS IS TITLE OF PAGE
MESS_DIAG
         .STRING         "DIAGNOSTIC TESTS"
         .BYTE     0
         .EVEN
MESS_COIN_AUD
         .STRING         "COIN BOOKKEEPING"
         .BYTE     0
         .EVEN
MESS_GAME_AUD
         .STRING         "GAME AUDITS"
         .BYTE     0
         .EVEN

MESS_GAME_ADJ
         .STRING         "GAME ADJUSTMENT"
         .BYTE     0
         .EVEN
MESS_UTIL
         .STRING         "UTILITIES"
         .BYTE     0
         .EVEN

MESS_EXIT
         .STRING         "EXIT TO GAME OVER"
         .BYTE     0
         .EVEN

CH_0     .STRING         "VIEW COINBOX"
         .BYTE   0
         .EVEN
CH_1     .STRING         "TOTALS AND"
         .BYTE   0
         .EVEN
CH_2     .STRING         "GAMEPLAY COUNTERS"
         .BYTE   0
         .EVEN

AH_1     .STRING         "VIEW GAME"
         .BYTE   0
         .EVEN
AH_2     .STRING         "PLAY STATISTICS"
         .BYTE   0
         .EVEN

AD_1     .STRING         "MAKE CHANGES"
         .BYTE   0
         .EVEN
AD_2     .STRING         "TO PRICING AND"
         .BYTE   0
         .EVEN
AD_3     .STRING         "GAME DIFFICULTY"
         .BYTE   0
         .EVEN

MESS_CLCRED
U_CLR_CRED       .STRING "CLEAR CREDITS"
         .BYTE   0
         .EVEN

MESS_CCCONF      .STRING "CREDITS CLEARED"
         .BYTE   0
         .EVEN

MESS_CLCOIN
U_CLR_COIN       .STRING "CLEAR COIN COUNTERS"
         .BYTE   0
         .EVEN

MESS_CLAUD
U_CLR_AUD        .STRING "CLEAR GAME AUDITS"
         .BYTE   0
         .EVEN

MESS_HSRESET
U_HSRESET        .STRING "RESET HIGH SCORES"
         .BYTE   0
         .EVEN

MESS_HSRES
         .STRING "RESET HIGH SCORES"
         .BYTE   0
         .EVEN

;M_OPMESS_TIT
;U_OPMESS         .STRING "OPERATOR MESSAGE"
;         .BYTE   0
;         .EVEN

;M_SET_OMESS
;;MESS_OPMESS      .STRING "SET OPERATOR MESSAGE"
;         .BYTE   0
;         .EVEN

U_BURNIN         .STRING "BURN-IN TEST"
         .BYTE   0
         .EVEN

MESS_BURN        .STRING "RUN BURN-IN TEST"
         .BYTE   0
         .EVEN


MESS_DEF_ADJ     .STRING "DEFAULT ADJUSTMENTS"
         .BYTE   0
         .EVEN

U_FACTORY        .STRING "FACTORY SETTINGS"
         .BYTE   0
         .EVEN

MESS_FACSET      .STRING "FULL FACTORY RESTORE"
         .BYTE   0
         .EVEN

U_END            .STRING "END TESTING"
         .BYTE   0
         .EVEN

MESS_SWTEST           .STRING "SWITCH TEST"
         .BYTE   0
         .EVEN
;MESS_ROMTEST          .STRING "ROM BOARD TEST"
;         .BYTE   0
;         .EVEN
MESS_CPUTEST          .STRING "CPU BOARD TEST"
         .BYTE   0
         .EVEN
M_STEST               .STRING "SOUND BOARD TEST"
         .BYTE   0
         .EVEN

MESSPAT                                    ;HEADER TITLE
MESS_PATTERNS         .STRING "MONITOR PATTERNS"
         .BYTE   0
         .EVEN

MESS_RED         .STRING "RED SCREEN"
         .BYTE   0
         .EVEN
MESS_GREEN       .STRING "GREEN SCREEN"
         .BYTE   0
         .EVEN
MESS_BLUE        .STRING "BLUE SCREEN"
         .BYTE   0
         .EVEN
MESS_BARS        .STRING "COLOR BARS"
         .BYTE   0
         .EVEN
MESS_CROSS       .STRING "CROSSHATCH  PATTERN"
         .BYTE   0
         .EVEN
MESS_DIAGM       .STRING "BACK TO DIAGNOSTICS MENU"
         .BYTE   0
         .EVEN

M_SYNT   .STRING "SYNTHESIZER TEST"
         .BYTE   0
         .EVEN
M_DIGT   .STRING "DIGITIZER TEST"
         .BYTE   0
         .EVEN
M_SYNP   .STRING "PLAY SYNTHESIZER"
         .BYTE   0
         .EVEN
M_DIGP   .STRING "PLAY DIGITIZER"
         .BYTE   0
         .EVEN
*
*        ON FULL RESTORE....THE FOLLOWING IS PRINTED.
*
MESS_FFSCONF
MESS_FAC MESS_MAC  RD7FONT,SPACING20,200,96,ROBO_WHITE,STRCNRM,0
MESS_DEFCONF
         .STRING   "DEFAULT ADJUSTMENTS RESTORED."
         .BYTE     0,1
         .EVEN
         MESS_MAC  RD7FONT,SPACING20,200,112,ROBO_YELLOW,STRCNRM,0
MESS_CCNCONF
         .STRING  "COIN COUNTERS CLEARED."
         .BYTE   0,1                  ;0 = END OF STRING...1 = MORE MESSAGES!
         .EVEN
         MESS_MAC  RD7FONT,SPACING20,200,128,ROBO_ORANGE,STRCNRM,0
MESS_CAUDCONF
         .STRING  "GAME AUDITS CLEARED."
         .BYTE    0,1
         .EVEN
         MESS_MAC  RD7FONT,SPACING20,200,144,ROBO_CYAN,STRCNRM,0
MESS_HSRCONF
         .STRING  "HIGH SCORE TABLE RESET."
         .BYTE    0,0
         .EVEN

MESS_FACFAIL
         .STRING  "FAILURE IN CMOS RAM"
         .BYTE    0
         .EVEN

MESS_CANCELLED
         .STRING "CANCELLED"
         .BYTE   0
         .EVEN

MESS_SUCCESS
         .STRING "MESSAGE SUCCESSFULLY STORED"
         .BYTE   0
         .EVEN

;MESS_OPFAIL
;         .STRING "OPERATOR MESSAGE CLEARED"
;         .BYTE   0
;         .EVEN

*        HOW ABOUT:      USE PLAYER 1 CONTROLS TO ENTER A MESSAGE
*                        OF UP TO 3 LINES OF 25 CHARACTERS.
*
*                        PRESS "ADVANCE" TO CLEAR OUT MESSAGE.
*
*                        SELECT "CR" TO END EACH LINE.

*        CENTER OF CUSTOM MESSAGE ENTRY Y IS BASED ON TITLE BLOCK
*
CIN_X     EQU    (TIT_ULX+TIT_LRX)/2
CR_X      EQU    CIN_X-34
CIN_Y     EQU    86

CIY1     EQU     CIN_Y+14
CIY2     EQU     CIY1+15
CIY3     EQU     CIY2+25
CIY4     EQU     CIY3+25

;CMES_INSTR
;         MESS_MAC  RD7FONT,SPACING07,CIN_X,CIY1,ROBO_WHITE,STRCNRM,0
;         .STRING   "USE PLAYER 1 CONTROLS TO ENTER A"
;         .BYTE      0,1
;         .EVEN
;         MESS_MAC  RD7FONT,SPACING07,CIN_X,CIY2,ROBO_WHITE,STRCNRM,0
;         .STRING   "MESSAGE OF UP TO 3 LINES OF 25 LETTERS."
;         .BYTE      0,1
;         .EVEN
;         MESS_MAC  RD7FONT,SPACING07,CIN_X,CIY3,ROBO_YELLOW,STRCNRM,0
;         .STRING   "SELECT "
;         .BYTE     ASCII_DQ
;         .STRING   "   "              ;MAKE ROOM FOR "CR" CRARACTER
;         .BYTE     ASCII_DQ
;         .STRING   " TO END EACH LINE."
;         .BYTE      0,1
;         .EVEN
;         MESS_MAC  RD7FONT,SPACING07,CIN_X,CIY4,ROBO_ORANGE,STRCNRM,0
;         .STRING   "PRESS "
;         .BYTE     ASCII_DQ
;         .STRING   "ADVANCE"
;         .BYTE     ASCII_DQ
;         .STRING   " TO CLEAR OUT MESSAGE."
;         .BYTE      0,1
;         .EVEN
;         MESS_MAC  RD7FONT,SPACING20,CR_X,CIY3,ROBO_YELLOW,STRCNRM,0
;         .BYTE   FONT_CR
;         .BYTE   0,0
         .EVEN

**************************************************************************
*                                                                        *
*          STRINGS FOR SOUND TEST                                        *
*                                                                        *
**************************************************************************

;DAC_LX   EQU     125
;
;DAC_ERR
;         MESS_MAC  RD7FONT,SPACING20,200,80,ROBO_LF,STRCNRM,0
;         .STRING   "LISTEN FOR TONES:"
;         .BYTE   0,1
;         .EVEN
;         MESS_MAC  RD7FONT,SPACING07,DAC_LX,105,ROBO_YELLOW,STRLNRM,0
;         .STRING   "0 TONES - CHECK U38 OR SYNTHESIZER."
;         .BYTE   0,1
;         .EVEN
;         MESS_MAC  RD7FONT,SPACING07,DAC_LX,115,ROBO_YELLOW,STRLNRM,0
;         .STRING   "1 TONE"
;         .BYTE   0,1
;         .EVEN
;DAC_LX2  EQU     DAC_LX+56
;
;         MESS_MAC  RD7FONT,SPACING07,DAC_LX2,115,ROBO_YELLOW,STRLNRM,0
;         .STRING   "- DIGITIZER OK"
;         .BYTE   0,1
;         .EVEN
;
;         MESS_MAC  RD7FONT,SPACING07,DAC_LX,125,ROBO_YELLOW,STRLNRM,0
;         .STRING   "2 TONES - RAM ERROR  U34"
;         .BYTE   0,1
;         .EVEN
;         MESS_MAC  RD7FONT,SPACING07,DAC_LX,134,ROBO_YELLOW,STRLNRM,0
;         .STRING   "3 TONES - ROM ERROR  U38 "
;         .BYTE   0,1
;         .EVEN
;         MESS_MAC  RD7FONT,SPACING07,DAC_LX,144,ROBO_YELLOW,STRLNRM,0
;         .STRING   "4 TONES - ROM ERROR  U37 "
;         .BYTE   0,1
;         .EVEN
;         MESS_MAC  RD7FONT,SPACING07,DAC_LX,153,ROBO_YELLOW,STRLNRM,0
;         .STRING   "5 TONES - ROM ERROR  U36 "
;         .BYTE   0,1
;         .EVEN
;         MESS_MAC  RD7FONT,SPACING07,DAC_LX,163,ROBO_YELLOW,STRLNRM,0
;         .STRING   "6 TONES - ROM ERROR  U35 "
;         .BYTE   0,0
;         .EVEN
;
;YAM_ERR_TAB
;         .LONG   YERR0
;         .LONG   YERR1
;         .LONG   YERR2
;         .LONG   YERR3
;         .LONG   YERR4
;         .LONG   YERR0
;
;LAST_Y_CODE EQU  (($-YAM_ERR_TAB)/LONG_SIZE)-1
;
;M_TESTING        .STRING "TESTING..."
;                 .BYTE 0
;                 .EVEN
;
;M_CKU5   MESS_MAC  RD7FONT,SPACING20,200,80,ROBO_LF,STRCNRM,0
;         .STRING   "NO RESPONSE - LISTEN FOR TONES:"
;         .BYTE   0,1
;         .EVEN
;         MESS_MAC  RD7FONT,SPACING07,DAC_LX,105,ROBO_YELLOW,STRLNRM,0
;         .STRING   "0 TONES - NO RESPONSE, CHECK U5"
;         .BYTE   0,1
;         .EVEN
;         MESS_MAC  RD7FONT,SPACING07,DAC_LX,115,ROBO_YELLOW,STRLNRM,0
;         .STRING   "1 TONE"
;         .BYTE   0,1
;         .EVEN
;         MESS_MAC  RD7FONT,SPACING07,DAC_LX2,115,ROBO_YELLOW,STRLNRM,0
;         .STRING   "- SYNTH OK, CHECK J2 CABLE."
;         .BYTE   0,1
;         .EVEN
;
;         MESS_MAC  RD7FONT,SPACING07,DAC_LX,125,ROBO_YELLOW,STRLNRM,0
;         .STRING   "2 TONES - RAM ERROR  U2 "
;         .BYTE   0,1
;         .EVEN
;         MESS_MAC  RD7FONT,SPACING07,DAC_LX,134,ROBO_YELLOW,STRLNRM,0
;         .STRING   "3 TONES - ROM ERROR  U5 "
;         .BYTE   0,1
;         .EVEN
;         MESS_MAC  RD7FONT,SPACING07,DAC_LX,144,ROBO_YELLOW,STRLNRM,0
;         .STRING   "4 TONES - ROM ERROR  U4 "
;         .BYTE   0,0
         .EVEN

MES_DEST .STRING   "ROBO DESIGN TEAM"
         .BYTE   0
         .EVEN

M_TEAM   MESS_MAC  RD7FONT,SPACING20,200,67,ROBO_WHITE,STRCNRM,0
         .STRING   "FROM THE WEST COAST OFFICE"
         .BYTE     0,1
         MESS_MAC  RD7FONT,SPACING20,200,97,ROBO_WHITE,STRCNRM,0
         .STRING   "MARK TURMELL "
         .BYTE      0,1
         MESS_MAC  RD7FONT,SPACING20,200,107,ROBO_WHITE,STRCNRM,0
         .STRING   "JOHN TOBIAS "
         .BYTE      0,1
         MESS_MAC  RD7FONT,SPACING20,200,117,ROBO_WHITE,STRCNRM,0
         .STRING   "TIM COMAN "
         .BYTE      0,1
         MESS_MAC  RD7FONT,SPACING20,200,127,ROBO_WHITE,STRCNRM,0
         .STRING   "EUGENE JARVIS "
         .BYTE      0,1
         MESS_MAC  RD7FONT,SPACING20,200,137,ROBO_WHITE,STRCNRM,0
         .STRING   "JON HEY "
         .BYTE      0,0

;YERR0    .STRING "SYNTHESIZER DOES NOT RESPOND."
;         .BYTE 0
;         .EVEN
;YERR1    .STRING "SYNTHESIZER OK"
;         .BYTE 0
;         .EVEN
;YERR2    .STRING "RAM ERROR  U2"
;         .BYTE 0
;         .EVEN
;YERR3    .STRING "ROM ERROR  U5"
;         .BYTE 0
;         .EVEN
;YERR4    .STRING "ROM ERROR  U4"
;         .BYTE 0
;         .EVEN

**************************************************************************
*                                                                        *
*          STRINGS FOR UTILITY HELP MENUS                                *
*                                                                        *
**************************************************************************
MEH_CLCRED1      .STRING "REMOVE ANY" 
                 .BYTE   0
                 .EVEN
MEH_CLCRED2      .STRING "POSTED CREDITS"
                 .BYTE   0
                 .EVEN
MEH_CLCRED3      .STRING "FROM THE GAME"
                 .BYTE   0
                 .EVEN
MEH_CLCOIN1      .STRING "CLEAR OUT PAID"
                 .BYTE   0
                 .EVEN
MEH_CLCOIN2      .STRING "CREDITS TOTAL"
                 .BYTE   0
                 .EVEN
MEH_CLCOIN3      .STRING "AND THE COIN"
                 .BYTE   0
                 .EVEN
MEH_CLCOIN4      .STRING "SLOT COUNTERS"
                 .BYTE   0
                 .EVEN
MEH_CLAUD1       .STRING "CLEAR GAMEPLAY"
                 .BYTE   0
                 .EVEN
MEH_CLAUD2       .STRING "STATISTICS"
                 .BYTE   0
                 .EVEN
MEH_RESHS1       .STRING "RESET HIGH SCORE"
                 .BYTE   0
                 .EVEN
MEH_RESHS2       .STRING "TABLE TO FACTORY"
                 .BYTE   0
                 .EVEN
MEH_RESHS3       .STRING "DEFAULT VALUES"
                 .BYTE   0
                 .EVEN
;MEH_CUSM1        .STRING "ENTER YOUR OWN"
;                 .BYTE   0
;                 .EVEN
;MEH_CUSM2        .STRING "MESSAGE TO"
;                 .BYTE   0
;                 .EVEN
;MEH_CUSM3        .STRING "APPEAR IN THE"
;                 .BYTE   0
;                 .EVEN
;MEH_CUSM4        .STRING "ATTRACT MODE"
;                 .BYTE   0
;                 .EVEN
MEH_DEFA1        .STRING "SET ALL GAME"
                 .BYTE   0
                 .EVEN
MEH_DEFA2        .STRING "ADJUSTMENTS TO"
                 .BYTE   0
                 .EVEN
MEH_DEFA3        .STRING "THEIR FACTORY"
                 .BYTE   0
                 .EVEN
MEH_DEFA4        .STRING "DEFAULT VALUE"
                 .BYTE   0
                 .EVEN
MEH_FAC1         .STRING "CLEAR AUDITS"
                 .BYTE   0
                 .EVEN
MEH_FAC2         .STRING "COUNTERS."
                 .BYTE   0
                 .EVEN
MEH_FAC3         .STRING "RESET"
                 .BYTE   0
                 .EVEN
MEH_FAC4         .STRING "ADJUSTMENTS"
                 .BYTE   0
                 .EVEN
MEH_FAC5         .STRING "THE HIGH SCORE"
                 .BYTE   0
                 .EVEN
MEH_FAC6         .STRING "TABLE"
                 .BYTE   0
                 .EVEN
**************************************************************************
*                                                                        *
*         MAIN MENU NAMES                                                *
*                                                                        *
**************************************************************************
MESSMAIN
         .STRING   "SMASH TV TEST MENU"
         .BYTE     0
         .EVEN

MESSUTIL .STRING   "UTILITY MENU"
         .BYTE     0
         .EVEN

         .END 

