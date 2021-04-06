	.FILE	'ENT.ASM'
	.TITLE	"ROBO ENTER YOUR INITIALS AND CUSTOM OPERATOR MESSAGE"
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
        .INCLUDE        "LINK.EQU"	        ;LINKY EQUATES

         .BSS            SPRAYS,16           ;HOW MANY SPRAYERS ARE RUNNING

         .TEXT
         .INCLUDE        "NARCENT.TBL"       ;CONTAINS OUR UNIQUE IMAGES
*
*        DEFINED IN THIS MODULE
*
         .GLOBAL         P1_INITS, P2_INITS, E_INITS, OP_INITS
         .GLOBAL         SPRAYS, KIL_SPRY
*
*        SPRAY MODULE
*
         .GLOBAL         RES_SCRL, P_SCRIPT, X_PL_SA3, SPR_CHAR
         .GLOBAL         P1_SPRAY, P2_SPRAY, E_BRUSH, SC_CRAM
*
         .GLOBAL         P_FORK

OP_BLOB
         .LONG   0,0,0,0                        ;XV, YV, XP, YP
         .WORD   0,0                            ;Z POS 0....NO Z VEL
         .LONG   BLANK_OP,1,DUMCOLL            ;IMG, Z SIZE, COLLISION VECT
         .WORD   DMACAL,BLANK_ID                ;WRITE CONSTANT FOR EVERYONE, OBJECT ID
         .LONG   0                              ;NO SCANNER BLIP

BLANK_BLOB
         .LONG   0,0,0,0                        ;XV, YV, XP, YP
         .WORD   0,0                            ;Z POS 0....NO Z VEL
         .LONG   BLANK_IMG,1,DUMCOLL            ;IMG, Z SIZE, COLLISION VECT
         .WORD   DMACAL,BLANK_ID                ;WRITE CONSTANT FOR EVERYONE, OBJECT ID
         .LONG   0                              ;NO SCANNER BLIP

LETTER_TEMPLATE
         .LONG   0,0,0,0                        ;XV, YV, XP, YP
         .WORD   0,10                           ;Z VEL 10....Z POS 0
         .LONG   BLANK_IMG,1,DUMCOLL            ;IMG, Z SIZE, COLLISION VECT
         .WORD   DMACNZ,0                       ;WRITE NON-ZERO CONSTANT, OBJECT ID
         .LONG   0                              ;NO SCANNER BLIP

*FROB     .LONG   0,0,0,0                        ;WE'LL SET IT UP
*         .WORD   0,10                           ;SAME Z AS LETTERS
*         .LONG   INIT_BOX,1,DUMCOLL             ;THIS IS LETTER SIZE BOX
*         .WORD   DMACNZ,FROB_ID                 ;USE SPECIAL ID FOR BOX
*         .LONG   0                              ;NO SCANNER BLIP!

P1_HAND  .LONG   0,0,0,0
         .WORD   0,22                           ;HAND IS CLOSER THAN LETTERS

         .IF     BLUE_P1
         .LONG   fing,1,DUMCOLL             ;THIS IS LETTER SIZE BOX
         .ELSE
         .LONG   b_fing,1,DUMCOLL             ;THIS IS LETTER SIZE BOX
         .ENDIF

         .WORD   DMAWNZ,HAND_ID
         .LONG   0
P1_H2    .LONG   0,0,0,0
         .WORD   0,22

         .IF     BLUE_P1
         .LONG   hand,1,DUMCOLL
         .ELSE
         .LONG   b_hand,1,DUMCOLL
         .ENDIF

         .WORD   DMAWNZ,HAND_ID
         .LONG   0

P2_HAND  .LONG   0,0,0,0
         .WORD   0,21                           ;HAND IS CLOSER THAN LETTERS
          .IF     BLUE_P1
         .LONG   b_fing,1,DUMCOLL             ;THIS IS LETTER SIZE BOX
         .ELSE
         .LONG   fing,1,DUMCOLL             ;THIS IS LETTER SIZE BOX
         .ENDIF

         .WORD   DMAWNZ,HAND_ID
         .LONG   0
P2_H2    .LONG   0,0,0,0
         .WORD   0,21

         .IF     BLUE_P1
         .LONG   b_hand,1,DUMCOLL
         .ELSE
         .LONG   hand,1,DUMCOLL
         .ENDIF

         .WORD   DMAWNZ,HAND_ID
         .LONG   0

*
*        OBJECTS IN OUR LIST ARE SUCH THAT
*        ASCII CHARACTERS HAVE THEIR ASCII LETTER AS
*        THEIR ID'S
*        THE HAND HAND AND FROB HAVE THE FOLLOWING
*        OBJECT ID'S
*
*FROB_ID  EQU     1
HAND_ID  EQU     2
BLANK_ID EQU     3


BLOB_DX  EQU     -1CH*TABLE_UNIT            ;START BLOB THIS FAR LEFT
BLANK_X  EQU     013CH                      ;SIZE OF "AUTOERASE" BLOB
BLANK_Y  EQU     100
BLANK_OP_X       EQU     1FCH              ;WIDTH OF BLANK FOR OPERATOR
BLOB_OP_DX       EQU     -12*TABLE_UNIT    ;BRING TO ZERO
*
*        ALPHA CONSTANTS.
*        THIS DETERMINES LAYOUT OF THE LETTERS ON THE
*        SCREEN.
*
ALPHA_X  EQU     5*TABLE_UNIT                   ;X OFFSET OF ALPHA BLOCK
ALPHA_Y  EQU     5*TABLE_UNIT                   ;Y OFFSET OF ALPHA BLOCK
ALPHA_ROWS EQU   3                              ;26 LETTERS, SPACE, RUB, END
ALPHA_COLS EQU   10                              
ALPHA_DX EQU     20*TABLE_UNIT                  ;X UNITS BETWEEN LETTERS
ALPHA_DY EQU     22*TABLE_UNIT                  ;Y UNITS BETWEEN LETTERS

HAND_X   EQU     7BH*TABLE_UNIT
HAND_Y   EQU     40H*TABLE_UNIT

HAND_END_X       EQU     0B0H*TABLE_UNIT
HAND_END_Y       EQU     42H*TABLE_UNIT

END_MIN_X        EQU     8CH*TABLE_UNIT
END_MIN_Y        EQU     34H*TABLE_UNIT

END_MIN_OP_X     EQU     190H*TABLE_UNIT
HAND_END_OP_X    EQU     1B6H*TABLE_UNIT

HAND_HOT_DX      EQU     18H*TABLE_UNIT          ;X FROM UPPER LEFT OF HAND TO HOT SPOT
HAND_HOT_DY      EQU     -2*TABLE_UNIT

CLOSE_FOR_RUB    EQU     ALPHA_DX+(8*TABLE_UNIT)  ;RUB AND SPACE HAVE LARGER REGIONS.
CLOSE_X          EQU     ALPHA_DX               ;DISTANCE FROM HAND TO BE TIED TO THAT LETTER
CLOSE_Y          EQU     ALPHA_DY

HAND_X_ADJ       EQU     13*TABLE_UNIT          ;X DIFFERENCE FROM CENTER OF
*                                               ;LETTER TO CENTER OF FINGER

HAND_MIN_X       EQU     4*TABLE_UNIT
HAND_MIN_Y       EQU     16*TABLE_UNIT
HAND_MAX_X       EQU     0B8H*TABLE_UNIT
HAND_MAX_Y       EQU     42H*TABLE_UNIT

OP_MAX_X         EQU     1B8H*TABLE_UNIT        ;X TRAVEL FOR OPERATOR!
HAND_MIN_OP_Y    EQU     19*TABLE_UNIT

Z_TO_SPACE       EQU     (20*TABLE_UNIT)-ALPHA_DX  ;X DISTANCE BEFORE PUTTING SPACE OUT
SPACE_TO_RUB     EQU     25*TABLE_UNIT          ;X DISTANCE BETWEEN SPACE AND RUB
RUB_TO_END       EQU     29*TABLE_UNIT          ;X DISTANCE BETWEEN RUB AND END
SPACE_DY         EQU     2*TABLE_UNIT

FROB_COLOR       EQU     0F5F5H                 ;LASER FLASH FOR FROB

BLANK_IMG
         .WORD   BLANK_X,BLANK_Y,0,0            ;WIDTH, HEIGHT, OFFSET,OFFSET
         .LONG   IROM,NARCS                     ;SOURCE, PALETTE

BLANK_OP
         .WORD   BLANK_OP_X,BLANK_Y,0,0            ;WIDTH, HEIGHT, OFFSET,OFFSET
         .LONG   IROM,NARCS                     ;SOURCE, PALETTE

P1_INITS
         .LONG   20*TABLE_UNIT                  ;UPPER LEFT X
         .LONG   PLYR_Y                         ;UPPER LEFT Y
         .WORD   BYTE_SIZE                      ;1 BYTE BETWEEN INITIALS
         .WORD   3                              ;GET TOTAL OF 3
         .WORD   3                              ;3 LEFT TO GET
         .WORD   P1_COLOR                       ;CONSTANT COLOR
         .LONG   RD15FONT                       ;FONT BASE POINTER
         .WORD   0                              ;ZERO SHIFTS TO GET STICK
*
*        DATA NOT COPIED TO PROCESS AREA
*
         .WORD   END_GAME_PID+1                 ;ID FOR THE PROCESS GETTING LETTERS
         .LONG   P1_HAND
         .LONG   P1_SPRAY                       ;SPRAY PAINT SCRIPT INITIALIZER
         .LONG   E_BRUSH                        ;SCRIPT TO CHANGE BRUSH TO ERASE
         .LONG   0D0H                           ;WIDTH IN PIXELS
         .LONG   MESS_1                         ;PLAYER 1 TITLE STRING

P2_INITS
         .LONG   114H*TABLE_UNIT                 ;UPPER LEFT X
         .LONG   PLYR_Y                          ;UPPER LEFT Y
         .WORD   BYTE_SIZE                      ;1 BYTE BETWEEN INITIALS
         .WORD   3                              ;GET TOTAL OF 3
         .WORD   3                              ;3 LEFT TO GET
         .WORD   P2_COLOR                       ;CONSTANT COLOR
         .LONG   RD15FONT                       ;FONT BASE POINTER
         .WORD   8                              ;8 SHIFTS TO GET STICK
*
*        DATA NOT COPIED TO PROCESS AREA
*
         .WORD   END_GAME_PID+2                 ;ID FOR THE PROCESS GETTING LETTERS
         .LONG   P2_HAND
         .LONG   P2_SPRAY                       ;SPRAY PAINT SCRIPT INITIALIZER
         .LONG   E_BRUSH                        ;SCRIPT TO CHANGE BRUSH TO ERASE
         .LONG   0D0H                           ;WIDTH IN PIXELS
         .LONG   MESS_2                         ;PLAYER 2 MESSAGE

OP_INITS
         .LONG   18*TABLE_UNIT                  ;UPPER LEFT X
         .LONG   OP_Y                           ;UPPER LEFT Y
         .WORD   BYTE_SIZE                      ;1 BYTE BETWEEN INITIALS
         .WORD   CMESS_CHARS                    ;GET TOTAL OF 30
         .WORD   CMESS_CHARS                    ;30 LEFT TO GET
         .WORD   P2_COLOR                       ;use red
         .LONG   RD15FONT                       ;FONT BASE POINTER
         .WORD   0                              ;ZERO SHIFTS TO GET STICK
*
*        DATA NOT COPIED TO PROCESS AREA
*
         .WORD   END_GAME_PID+1                 ;ID FOR THE PROCESS GETTING LETTERS
         .LONG   P1_HAND
         .LONG   P1_SPRAY                       ;SPRAY PAINT SCRIPT INITIALIZER
         .LONG   E_BRUSH                        ;SCRIPT TO CHANGE BRUSH TO ERASE
         .LONG   0D0H                           ;WIDTH IN PIXELS
         .LONG   MESS_1                         ;PLAYER 1 TITLE STRING

**************************************************************************
*                                                                        *
*          Parameters on input are:                                      *
*                                                                        *
*          Upper left of Region to conduct the entry.                    *
*                                                                        *
*          Spray paint script pointer for spray of first                 *
*          echo (This should setup brush size, color,                    *
*          x,y rate etc.)                                                *
*                                                                        *
*          Pointer to place to store initials (bytes)                    *
*                                                                        *
*          Distance in memory between successive initials.               *
*                                                                        *
*          Number of Initials to get.                                    *
*                                                                        *
*          ON ENTRY, A8 POINTS AT STRUCTURE HOLDING THE ABOVE DATA       *
*                    A9 POINTS TO PLACE TO STORE INITIALS                *
*                                                                        *
**************************************************************************
E_INITS:
         MOVE    A8,*A13(ENT_DATA),L   ;STUFF OUR ROM DATA POINTER
         CLR     A1                    ;NULLIFY MY LIST OF OBJECTS
         MOVE    A1,@WORLDTLX,L        ;MAKE SURE OUR SCREEN IS THEIR SCREEN
         MOVE    A1,@WORLDTLY,L        ;

         MOVE    A1,*A13(ENT_OLIST),L     ;WE HAVE NO OBJECTS
         MOVE    A1,*A13(ENT_FROB_OBJ),L  ;NO FROB LETTER YET
         MOVE    A1,*A13(ENT_ANI_TIMER),L ;NO DEBOUNCE TILL WE SAY SO.
         MOVE    A1,*A13(ENT_Y_OFFSET),L  ;NO HAND ANIMATION TILL WE SAY SO
         MOVE    A1,*A13(ENT_PRESSED),W   ;NOTHING PRESSED YET
         MOVE    A1,*A13(ENT_TIMEOUT),W   ;NOT TIMED OUT YET!

         MOVE    A9,*A13(ENT_INIT_PTR),L  ;STORE INITIAL STORAGE POINTER

         CALLR   STUFF_ENT_PDATA

         CALLR   E_TITLES             ;PUT UP TITLES FOR THIS PLAYER

         MOVI    LET_A,A0             ;SAFETY.....ALWAYS HAVE VALID LETTER
         MOVE    A0,*A13(ENT_FROB_ASCII),W

         CALLR   OP_P                 ;OPERATOR?
         JRZ     NO_SP_PROC

         MOVI    SPRAY_PROC,A7        ;POINT AT OUR SPRAYER (A8 IS IN TACT)
         CALLA   P_FORK               ;START IT UP (W/ OUR ID)
         MOVE    A0,*A13(ENT_SPRAY_PROC),L   ;SAVE HIS ID......WE WILL
*                                            ;NEED TO LET HIM FINISH
*                                            ;WHEN WE DIE.
*
*        WE NEED A LARGER BLOB FOR OPERATOR!
*
NO_SP_PROC
         MOVI    OP_BLOB,A14
         MOVI    BLOB_OP_DX,A1
         CALLR   OP_P                 ;IS IT OPERATOR MESSAGE?
         JRZ     USE_OP_BLOB          ;YEP...USE LARGER BLOB!
         MOVI    BLANK_BLOB,A14       ;DATA FOR BLANK BLOB
         MOVI    BLOB_DX,A1           ;BLOB MUST GO TO LEFT TO GET HAND!
USE_OP_BLOB
         CLR     A2

         CALLR   NEW_OBJ              ;SETUP THE OBJECT
         JREQ    ENTRY_FAIL           ;NOBODY HOME...EXIT

         MOVI    0,A1                 ;CONSTANT IS ZERO WE CAN PATCH!
         MOVE    A1,*A0(OCONST),W     ;CONSTANT COLOR IS ZERO!

         CALLA   INSOBJ               ;NOW PUT IT ON THE REAL LIST
*
*        OK....WE HAVE THE BLOB
*        NOW WE NEED TO SUPERIMPOSE THE ALPHABET ON TOP OF IT
*
         CALLR   ADD_ALPHABET         ;GET US THE ALPHABET
*
*        Now we have to create a hand
*
         MOVE    *A8(LET_HAND_PTR),A14,L     ;FETCH POINTER FOR HAND
         MOVI    HAND_X,A1                   ;OFFSETS
         MOVE    A1,A9                       ;OUR RELATIVE HAND X IN A9
         MOVI    HAND_Y,A2
         MOVE    A2,A10                      ;OUR RELATIVE HAND Y IN A10

         CALLR   NEW_OBJ                   ;DO THE WORK
         JREQ    ENTRY_FAIL                ;CAN'T GET THE OBJECT

         CALLA   INSOBJ                    ;NOW PUT IT ON THE REAL LIST

         MOVE    A0,A8                     ;A8 HAS HAND PICTURE

         CALLR   NEW_OBJ                   ;GET 2ND PART OF HAND
         JREQ    ENTRY_FAIL

         MOVE    A0,*A13(ENT_HAND_OBJ),L   ;PUT IN PROCESS AREA
         CALLR   HAND_PART_2               ;FOLLOW MAIN HAND
         CALLA   INSOBJ                    ;AND ON OBJECT LIST
*
*        NOW WE NEED TO MOVE HAND AROUND, HYPERING FROB
*        AND WATCHING FOR BUTTONS AS WE GO ALONG
*
         CALLR   FETCH_BUTTONS             ;SCAN THE BUTTONS INTO PROCESS

LETTER_LOOP
         CLR     A1                        ;ASSUME HAND IS "PRESSING"
         CLR     A2                        ;NO MOVEMENT WHEN THIS IS THE CASE
         MOVE    *A13(ENT_Y_OFFSET),A0,L   ;IS HAND IN THE AIR?
         JRNZ    HAND_IN_AIR               ;YEP....DON'T LET EM MOVE
*
*        AT THIS POSITION WE CAN DETECT THE "HYPER TO END" CONDITION
*        WHERE THE HAND HAS SUFFICIENTLY LET GO OF THE LAST LETTER.
*        IF THE COUNT TO GET IS ZERO, AND THE X OR Y IS TOO LOW
*        WE HYPER HERE!
*
         MOVE    *A13(ENT_COUNTDOWN),A0,W  ;NO LETTERS TO GO?
         JRNZ    NOT_END_YET               ;LETTERS TO GO.

         CALLR   GET_E_MIN_X               ;GET THE MINIMUM X TO NOT HYPER
         CMP     A0,A9                     ;IF ITS NOT IN TERMI-BOX
         JRLO    HYPER_TO_TERMI            ;THEN HYPER THERE

         CMPI    END_MIN_Y,A10
         JRHS    NOT_END_YET               ;ITS IN THERE...LET HIM MOVE

HYPER_TO_TERMI
         MOVI    HAND_END_X,A9             ;PUT X ON END
         CALLR   OP_P                      ;OPERATOR?
         JRNZ    NORMAL_END
         MOVI    HAND_END_OP_X,A9             ;USE THE OPERATOR VERSION.
NORMAL_END
         MOVI    HAND_END_Y,A10            ;AND Y ON A10
         JRUC    HAND_IN_AIR

NOT_END_YET
         CALLR   GET_DY_DX                 ;GET MOVEMENT FOR HAND (A1,A2)

HAND_IN_AIR
         ADD     A9,A1                     ;ADD OUR X TO THE DX
         CALLR   GET_MIN_X                 ;GET THE MINIMUM X IN A3 BASED ON DATA
         CALLR   GET_HAND_MAX_X
         MOVE    A1,A0                     ;COPY COORDINATE
         CALLR   LIMIT_RANGE               ;GIVE CORRECTED COORDINATE BACK
         MOVE    A0,A1                     ;THIS IS COORDINATE TO USE

         ADD     A10,A2                    ;ADD OUR Y TO THE DY
         CALLR   GET_MIN_Y                 ;GET MINIMUM Y IN A3
         MOVI    HAND_MAX_Y,A4
         MOVE    A2,A0                     ;COPY COORDINATE
         CALLR   LIMIT_RANGE               ;GIVE CORRECTED COORDINATE BACK
         MOVE    A0,A2                     ;THIS IS COORDINATE TO USE

         MOVE    A1,A9                     ;BACK TO DURABLE REGISTERS
         MOVE    A2,A10
         
         MOVE    A8,A0                     ;POINT WITH OBJECT BLOCK
         MOVE    *A13(ENT_Y_OFFSET),A3,L   ;GET ANIMATION EXTRA
         ADD     A3,A2                     ;OFFSET WHERE WE DRAW BY THIS
         CALLR   STUFF_OBJECT_OFFSET       ;PUT THE HAND WHERE WE LANDED
         CALLR   HAND_PART_2               ;FINISH HAND

         CALLR   DO_FROB                   ;MOVE THE FROB, AND HIGHLIGHT
*                                          ;LETTER FROB IS ON.

         CALLR   HANDLE_BUTTONS            ;DO ACTIONS WARRANTED BY BUTTONS
         JRC     ENTRY_FINISHED            ;NOT FINISHED!

         SLEEP   1

         MOVE    *A13(ENT_TIMEOUT),A0,W    ;HAVE WE TIMED OUT?
         JRNZ    ENTRY_FINISHED            ;YEP.....GET OUT OF HERE!
         JRUC    LETTER_LOOP

ENTRY_FINISHED
ENTRY_FAIL
         MOVE    *A13(ENT_OLIST),A8,L      ;GET 1ST ON LIST
         JRZ     NOTHING_THERE             ;NOTHING THERE...THAT'S ODD!
*
*        THIS FREES UP THE LIST AND RETURNS THE BLOB OBJECT 
*        (IF FOUND) IN A8)
*
         CALLR   FREE_A8                   ;FREE THE LIST OF OBJECTS IN A8
         MOVE    A8,*A13(ENT_OLIST),L      ;THIS IS NOW A VALID LIST

NOTHING_THERE
         CLR     A0
         MOVE    A0,*A13(ENT_CONST),W      ;MAKE OUR CONSTANT ZERO
         CALLR   E_TITLES                  ;THIS WILL ERASE THE TITLES

*
*        NOW WE NEED TO KILL THE SPRAYER PROCESS ONCE ITS FINISHED
*        WRITING
*
         MOVE    *A13(ENT_SPRAY_PROC),A8,L      ;GET HIS ID
WAIT_SP_LOOP
         SLEEP   8

         CALLR   OP_P                           ;OPERATOR?
         JRZ     NO_SP_WAIT                     ;THEN NO SPRAY TO WAIT FOR

         MOVE    *A8(SPIN_BUSY),A0,W
         JRNZ    WAIT_SP_LOOP                   ;WAIT WHILE HE FINISHES

NO_SP_WAIT
         MOVE    *A13(PROCID),A0,W              ;NOW KILL HIM
         MOVI    0FFFFH,A1
         CALLA   KILALL                         ;THIS WILL DO IT!
*
*        LASTLY....GET RID OF THE AUTOERASE BLOB
*
         MOVE    *A13(ENT_OLIST),A0,L      ;GET THE BLOB
         JRZ     NO_BLOB                   ;IT WASN'T FOUND!

         CALLA   DELPAL                    ;TRASH IT!
         CALLA   DELOBJ

NO_BLOB
         JAUC    SUCIDE               ;DIE WHEN WE'RE DONE...OUR ID IS MONITORED


**************************************************************************
*                                                                        *
*          GET_HAND_MAX_X                                                *
*                                                                        *
*          THIS IS CALLED TO STUFF THE MAXIMUM DISTANCE THE HAND         *
*          MAY TRAVEL INTO A4.  IT USES DIFFERENT NUMBERS BASED          *
*          ON BEING OPERATOR MESSAGE OR PLAYER.                          *
*                                                                        *
**************************************************************************
GET_HAND_MAX_X
         MOVI    HAND_MAX_X,A4        ;ASSUME PLAYER.
         CALLR   OP_P                 ;OPERATOR?
         JRNZ    GHMXX                ;NOPE
         MOVI    OP_MAX_X,A4
GHMXX    RETS

GET_E_MIN_X     
         MOVI    END_MIN_X,A0         ;ASSUME PLAYER.
         CALLR   OP_P                 ;OPERATOR?
         JRNZ    GMXX                ;NOPE
         MOVI    END_MIN_OP_X,A0
GMXX     RETS


**************************************************************************
*                                                                        *
*          FREE_A8                                                       *
*                                                                        *
*          THIS IS CALLED TO FREE UP THE OBJECT LIST PASSED IN           *
*          A8.  IT RETURNS IN A8 THE BLANKING OBJECT (NOT                *
*          FREED UP) IF FOUND.                                           *
*                                                                        *
**************************************************************************
FREE_A8
         MMTM    SP,A0,A9,A10

         CLR     A9                        ;PLACE FOR THE BLOB OBJ

         MOVE    A8,A8                     ;LIST NULL?
         JREQ    FREE_A8_X                 ;YEP...WE'RE DONE!

TRASH_LOOP
         MOVE    *A8(OSLINK),A10,L         ;GET NEXT IN LIST

         MOVE    *A8(OID),A0               ;CHECK ID
         CMPI    BLANK_ID,A0               ;DON'T TRASH BLANK IMMEDIATELY
         JRNE    TRASH_IT

         MOVE    A8,A9                     ;SAVE THE BLANKER
         JRUC    NEXOBJ

TRASH_IT
         MOVE    A8,A0                     ;DELETE THIS ONE
         CALLA   DELPAL
         CALLA   DELOBJ

NEXOBJ   MOVE    A10,A8                    ;ANY MORE ON LIST?
         JRNZ    TRASH_LOOP                ;YEP...DO ANOTHER

FREE_A8_X
         MOVE    A9,A8                     ;RETURN THE BLOB IF FOUND
         JREQ    FREE_X                    ;NOT THERE...QUIT

         CLR     A0                        ;NULL OUT ITS FWD LINK
         MOVE    A0,*A8(OSLINK),L          ;THIS DOES IT

FREE_X
	MMFM    SP,A0,A9,A10
	RETS

GET_MIN_X
         MMTM    SP,A4,A0
         MOVI    HAND_MIN_X,A3        ;ASSUME NORMAL
         CALLR   GET_E_MIN_X
         MOVE    A0,A4                ;OTHER POSSIBILITY IS CURRENT MIN
         CALLR   CHOOSE_MIN
	MMFM    SP,A4,A0
	RETS

GET_MIN_Y
         MMTM    SP,A4
         MOVI    HAND_MIN_OP_Y,A3
         CALLR   OP_P                 ;OPERATOR?
         JRZ     GMYO                 ;YEP
         MOVI    HAND_MIN_Y,A3        ;ASSUME NORMAL
GMYO     MOVI    END_MIN_Y,A4         ;THIS IS OTHER POSSIBILITY
         CALLR   CHOOSE_MIN
	MMFM    SP,A4
	RETS

CHOOSE_MIN
         MMTM    SP,A0
         MOVE    *A13(ENT_COUNTDOWN),A0,W  ;ALL LETTERS EXHAUSTED?
         JRNZ    CHOOSE_NORMAL             ;CHOOSE THE NORMAL ONE
         MOVE    *A13(ENT_Y_OFFSET),A0,L      ;ANIMATION?
         JRNZ    CHOOSE_NORMAL              ;DON'T HYPER TILL HE LETS GO
         MOVE    A4,A3                     ;CHOOSE ALTERNATE
CHOOSE_NORMAL
	MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          SPRAY_PROC                                                    *
*                                                                        *
*          THIS IS THE PROCESS THAT RUNS THE SPRAY PAINTER IN            *
*          STEP WITH THE ENTER INITIALS "HAND MOVING" PROCESS.           *
*                                                                        *
*          IT GETS THE "ENTER SCRIPT" IN A8.                             *
*                                                                        *
*          A9 POINTS TO WHERE INITALS ARE GOING TO BE STUFFED            *
*                                                                        *
*          THE PROCESS THAT WE ARE WATCHING IS PASSED IN A10.            *
*                                                                        *
*          WE WILL HAVE OUR OWN STORAGE AREA THAT CONTAINS               *
*          OUR OWN COPY OF THE INITIALS ENTERED.                         *
*                                                                        *
*          WE WILL SPAWN A PROCESS TO DO OUR SPRAYING.  IT WILL          *
*          DO A COMPLETE SETUP WITH THE SCRIPTS PROVIDED.                *
*          WE WILL GIVE IT AN X OFFSET FOR THE CURRENT DIGIT.            *
*                                                                        *
*          WE WILL HAVE A WORD THAT INDICATES WE ARE NOT UP TO           *
*          DATE.  THE OTHER PROCESS WILL MAKE SURE WE HAVE               *
*          GOTTEN UP TO DATE BEFORE KILLING US.                          *
*                                                                        *
**************************************************************************
SPIN_BUSY        EQU     PDATA                     ;WORD - NON ZERO MEANS WE'RE BUSY
SPIN_SCRIPT_1    EQU     SPIN_BUSY+WORD_SIZE       ;LONG - SETUP SCRIPT                                                   
SPIN_ERASE_SCR   EQU     SPIN_SCRIPT_1+LONG_SIZE   ;LONG - SCRIPT FOR ERASE BRUSH
SPIN_LET_POINT   EQU     SPIN_ERASE_SCR+LONG_SIZE  ;LONG - POINTER TO FETCHED INITS
SPIN_LETTERS     EQU     SPIN_LET_POINT+LONG_SIZE  ;WORD - NUMBER OF LETTERS TO FETCH
SPIN_DX          EQU     SPIN_LETTERS+WORD_SIZE    ;LONG - DISTANCE BETWEEN LETTERS
SPIN_DRONE_DONE  EQU     SPIN_DX+LONG_SIZE         ;WORD - FLAG FROM OUR DRONE
SPIN_DISTANCE    EQU     SPIN_DRONE_DONE+WORD_SIZE ;WORD - DISTANCE BETWEEN HIS LETTERS
SPIN_OUR_DATA    EQU     SPIN_DISTANCE+WORD_SIZE ;1 BYTE PER.....OUR VERSION
                                                                       
SPRAY_PROC
         MOVI    PALETTE_SETUP_PROC,A7             ;FORK TO GUY TO FIX PALETTES
         CALLA   P_FORK

         MOVE    A9,*A13(SPIN_LET_POINT),L         ;SAVE LETTER POINTER

         MOVE    *A8(LET_SCRIPT),A0,L              ;FETCH OUR SCRIPT POINTER
         MOVE    A0,*A13(SPIN_SCRIPT_1),L          ;SAVE IT

         MOVE    *A8(LET_ERASE),A0,L               ;FETCH SCRIPT FOR ERASE BRUSH
         MOVE    A0,*A13(SPIN_ERASE_SCR),L         ;SAVE IT

         MOVE    *A8(LET_WIDTH),A0,L               ;X UNITS PER SPRAY LETTER
         MOVE    A0,*A13(SPIN_DX),L                ;SAVE THIS

         MOVE    *A8(ENT_COUNT-PDATA),A0,W         ;GET NUMBER OF LETTERS 
*                                        (THIS IS FROM ROM NOT PROCESS STORE)
         MOVE    A0,*A13(SPIN_LETTERS),W           ;SAVE LETTER COUNT.

         MOVE    *A8(ENT_INIT_SIZE-PDATA),A0,W     ;STORE LETTER TO LETTER DISTANCE
         MOVE    A0,*A13(SPIN_DISTANCE),W
*
*        NOW SET OUR DATA TO ALL SPACES
*
         MOVE    A13,A1                              ;POINT IN OUR PROCESS AREA
         ADDI    SPIN_OUR_DATA,A1                    ;POINT AT OUR COPY OF LETTERS
         CLR     A2                                  ;NOT YET ENTERED = 0
*
SP_LOOP_1
         MOVB    A2,*A1                              ;PUT ONE OUT
         ADDI    BYTE_SIZE,A1
         DSJS    A0,SP_LOOP_1                        ;NOW WE HAVE ALL SPACES
*
*        THIS IS THE TOP OF OUR STEADY LOOP
*        FIRST INDICATE WE'RE IN SYNC WITH THE
*        OTHER GUY
*
STEADY_LOOP
         CLR     A0
         MOVE    A0,*A13(SPIN_BUSY),W                

         SLEEP   1                                   ;WAIT A FRAME
*
*        NOW THAT WE'RE UP.....SCAN THROUGH THE 2 COPIES OF THE
*        LETTERS.
*
*        FIRST LOOK FROM RIGHT TO LEFT FOR ERASURES NECESSARY
*
CHANGE_LOOP
         MOVE    *A13(SPIN_LETTERS),A3,W             ;NUMBER OF LETTERS TO LOOK AT
         MOVE    A3,A0                               ;OFFSET OF FIRST IS 1 LESS
         DEC     A0                                  ;A0 HAS OFFSET

         MOVI    BYTE_SIZE,A1                        ;THIS IS DISTANCE IN OUR P-STORE
         MPYU    A0,A1                               ;THIS IS OFFSET OF LAST BYTE
         MOVE    A13,A2
         ADDI    SPIN_OUR_DATA,A2                    ;POINT A2 AT OUR DATA
         ADD     A1,A2                               ;ADD OFFSET TO GET TO END

         MOVE    *A13(SPIN_DISTANCE),A6,W            ;memory distance between hit bytes
         MOVE    A6,A1
         MPYU    A0,A1                               ;GET TO LAST

         MOVE    *A13(SPIN_LET_POINT),A4,L           ;HIS POINTER IN A1
         ADD     A4,A1                               ;POINT AT LAST

CHECK_FOR_RUB
         MOVB    *A1,A4                              ;PLAYERS
         MOVB    *A2,A5                              ;SPRAYED
         CMP     A4,A5
         JRZ     LETS_MATCH                          ;DIFFERENT ONE!
*
*        IF A5 IS ZERO, THIS REQUIRES SPARYING....LET OTHER LOOP CATCH IT!
*
         MOVE    A5,A5
         JRNZ    CHANGED_LETTER                      ;WE NEED TO REMOVE OUR PAINT

LETS_MATCH
         SUB     A6,A1
         SUBI    BYTE_SIZE,A2
         DEC     A0                                  ;KICK OFFSET
         DSJS    A3,CHECK_FOR_RUB
*
*        NO RUBOUTS....LOOK FROM RIGHT TO LEFT FOR LETTERS TO SPRAY
*
         CLR     A0                                  ;THIS IS OFFSET
         MOVE    *A13(SPIN_LET_POINT),A1,L           ;HIS POINTER IN A1
         MOVE    A13,A2
         ADDI    SPIN_OUR_DATA,A2                    ;POINT A2 AT OUR DATA
         MOVE    *A13(SPIN_LETTERS),A3,W             ;NUMBER OF LETTERS TO LOOK AT
         MOVE    *A13(SPIN_DISTANCE),A6,W            ;memory distance between hit bytes

CHECK_LETS
         MOVB    *A1,A4                              ;PLAYERS
         MOVB    *A2,A5                              ;SPRAYED
         CMP     A4,A5
         JRNZ    CHANGED_LETTER                      ;DIFFERENT ONE!

         ADD     A6,A1
         ADDI    BYTE_SIZE,A2
         INC     A0                                  ;KICK OFFSET
         DSJS    A3,CHECK_LETS

         JRUC    STEADY_LOOP                         ;ALL MATCH....SLEEP NOW!
*
*        WE HAVE A DIFFERENCE.  IF THE SPRAY THERE IS NOT A SPACE
*        WE MUST ERASE DOWN TO A SPACE.  THE NEXT ITERATION WILL
*        CAUSE US TO DRAW OVER THE SPACE.
*
*        IF THE SPRAY THERE IS A SPACE, WE DRAW THE NEW LETTER.  
*        

CHANGED_LETTER
         MOVI    1,A6
         MOVE    A6,*A13(SPIN_BUSY),W           ;INDICATE WE'RE CATCHING UP     
*
*        A5 HAS WHAT IS SPRAYED WHERE WE'RE INTERESTED IN
*
         MOVE    A5,A5                          ;IS OUR COPY BLANK?
         JRZ     PLOT_LETTER                    ;YEP...PLOT THE LETTER
*
*        A5 IS NOT A SPACE....WE MUST ERASE THE ASCII A5
*
*         MOVI    SPACE,A6                       ;INIDICATE IN OUR PROCESS
         CLR     A6                             ;INDICATE THAT *NOW* THERE'S NOTHING
         MOVB    A6,*A2                         ;THAT WE HAVE PUT A SPACE THERE

         JSRP    ERASE_A5                       ;ERASE THAT LETTER
         JRUC    CHANGE_LOOP                    ;NOW COMPARE WHAT RESULTS
*
*        A5 HAS NEW LETTER TO PLOT
*
PLOT_LETTER
         MOVE    A4,A5                          ;GET NEW LETTER IN A5
         MOVB    A5,*A2                         ;INDICATE THAT THIS IS WHAT IS SPRAYED
         JSRP    DRAW_A5                        ;PLOT THE CHARACTER IN A5
         JRUC    CHANGE_LOOP

**************************************************************************
*                                                                        *
*          DRAW_A5                                                       *
*          ERASE_A5                                                      *
*                                                                        *
*          LETTER IS IN A5.                                              *
*          LETTER NUMBER (1ST IS ZERO) IN A0.                            *
*          FORK TO SPRAYER TO MAKE THE LETTER AND WAIT FOR IT TO         *
*          FINISH.                                                       *
*                                                                        *
**************************************************************************
ERASE_A5
         MOVE    *A13(SPIN_ERASE_SCR),A8,L      ;INDICATE ERASE
         JRUC    DRAW_A5_1

DRAW_A5
         CLR     A8
DRAW_A5_1
         CMPI    SPACE,A5                       ;USE UNDERSCORE FOR SPACE.
         JRNZ    NOT_SPACE
         MOVI    UNDERSCORE,A5
NOT_SPACE
         MOVE    A5,A9                          ;PASS CHAR IN A9
         MOVE    A13,A10                        ;PASS OUR PROCESS STORE IN A10
         MOVE    A0,A11                         ;PASS X OFFSET IN A11

         MOVI    SPRAY_DRONE,A7
         CALLA   P_FORK                         ;START UP THE PROCESS

         CLR     A0
         MOVE    A0,*A13(SPIN_DRONE_DONE),W     ;NOW WAIT FOR DRONE TO FINISH
DRAW_2   SLEEP   4
         MOVE    *A13(SPIN_DRONE_DONE),A0,W
         JREQ    DRAW_2
         RETP

**************************************************************************
*                                                                        *
*          SPRAY_DRONE                                                   *
*                                                                        *
*          THIS PROCESS IS CREATED TO SPRAY OUT A CHARACTER.             *
*          A8 = ERASE SCRIPT (ZERO FOR NONE)                             *
*          A9 = ASCII CHARACTER                                          *
*          A10 = OTHER PROCESS WITH SOME RELEVANT DATA                   *
*          A11 = CHARACTER NUMBER (X OFFSET AFTER SETUP SCRIPT)          *
*                                                                        *
*                                                                        *
**************************************************************************
SPRAY_DRONE
         CALLA   RES_SCRL             ;MAKE SURE OUR Y IS IN SYNC
         MOVE    *A10(SPIN_SCRIPT_1),A4,L       ;GET SETUP SCRIPT
         MMTM    SP,A8,A9,A10,A11               ;SAVE OUR DATA
         JSRP    P_SCRIPT
	MMFM    SP,A8,A9,A10,A11               ;SAVE OUR DATA

         MOVE    A8,A4                          ;CHANGE BRUSHES IF NEEDED
         JREQ    NO_BLANK_BRUSH

         MMTM    SP,A8,A9,A10,A11               ;SAVE OUR DATA
         JSRP    P_SCRIPT
	MMFM    SP,A8,A9,A10,A11               ;SAVE OUR DATA

NO_BLANK_BRUSH
*
*        NOW WE'RE READY TO DRAW...EXCEPT....THAT WE MUST
*        MOVE THE X OVER BY THE NUMBER OF CHARCTERS WE'RE DRAWING
*
         MOVE    *A10(SPIN_DX),A0,L             ;THIS IS X UNITS PER CHAR
         MPYU    A0,A11                         ;MULT INTO CHAR COUNT
         MOVE    A11,A3                         ;FOR ADD SCALED A3 TO X
         CALLA   X_PL_SA3                       ;CALL THE MODULE THAT KNOWS OFFSETS

         MOVE    @SPRAYS,A0,W
         INC     A0                             ;1 MORE SPRAY GOING
         MOVE    A0,@SPRAYS,W                   ;STORE IT!

         CMPI    1,A0                           ;TURN ON TIME?
         JRNZ    ALREADY_ON                     ;NOPE
         SOUND1  START_SPRAY                    ;START SPRAY SOUND

ALREADY_ON
         MOVE    A9,A0                          ;GET SET FOR SPRAY
         ANDI    BYTE_MASK,A0                   ;CUZ I'M PARANOID
         MOVE    A10,A4                         ;SAVE OTHER PROCESS PTR
*
*        WE'RE ABOUT TO START A SPRAY...START SOUND
*
         JSRP    SPR_CHAR

         MOVE    @SPRAYS,A0,W
         DEC     A0                             ;1 MORE SPRAY GOING
         MOVE    A0,@SPRAYS,W                   ;STORE IT!
         JRNZ    DONT_SHUTOFF

         SOUND1  KIL_SPRY                     ;TURN IT OFF!

DONT_SHUTOFF
         MOVI    1,A0
         MOVE    A0,*A4(SPIN_DRONE_DONE),W
         JAUC    SUCIDE                         ;AND DIE!

START_SPRAY
         .WORD	>F3DE,>10,>80AD,0		;START SPRAY PAINT
KIL_SPRY
         .WORD	>F3DE,>10,>807F,0		;KILL SPRAY PAINT

**************************************************************************
*                                                                        *
*          PALETTE_SETUP_PROC                                            *
*                                                                        *
*          THIS PROCESS IS CREATED TO SETUP THE PALETTES                 *
*          FOR THE SPRAYERS....THIS WILL KEEP ANTS OFF                   *
*          THE SCREEN EACH LETTER.                                       *
*                                                                        *
**************************************************************************
PALETTE_SETUP_PROC
         MOVI    SC_CRAM,A4
         JSRP    P_SCRIPT
         JAUC    SUCIDE             ;THIS IS ALL WE DO!

**************************************************************************
*                                                                        *
*          HAND_PART_2                                                   *
*                                                                        *
*          THIS IS CALLED TO CHANGE THE POSITION OF THE 2ND PART         *
*          OF THE HAND BASED ON THE POSITION OF THE 1ST PART OF THE      *
*          HAND.  THE 1ST PART IN POINTED TO BY A8.                      *
*                                                                        *
*          THE 2ND PART IS IN THE PROCESS STORE AREA AT ENT_HAND_OBJ     *
*                                                                        *
**************************************************************************
HAND_PART_2
         MMTM    SP,A0,A1
         MOVE    *A13(ENT_HAND_OBJ),A0,L        ;GET PART 2 POINTER
         MOVE    *A8(OXVAL),A1,L                ;GET X OF MAIN PART
         ADDI    -21*TABLE_UNIT,A1
         MOVE    A1,*A0(OXVAL),L

         MOVE    *A8(OYVAL),A1,L                ;GET Y OF MAIN PART
         ADDI    32H*TABLE_UNIT,A1
         MOVE    A1,*A0(OYVAL),L
	MMFM    SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
*          HANDLE_BUTTONS                                                *
*                                                                        *
*          THIS IS CALLED TO WATCH FOR AND ACT ON THE BUTTONS FOR        *
*          DOING THE ENTERING.                                           *
*                                                                        *
**************************************************************************
HANDLE_BUTTONS
         MOVE    *A13(ENT_ANI_TIMER),A0,W       ;ARE WE DEBOUNCING?
         JREQ    NOT_BOUNCING
         DEC     A0                             ;COUNT DOWN DEBOUNCE TIMER
         MOVE    A0,*A13(ENT_ANI_TIMER),W
         CALLR   FETCH_BUTTONS                  ;KEEP READING BUTTONS TO
*                                               ;NUMB OUT BOUNCING STATES
         JRUC    NO_BUT_WORK                    ;RETURN NOT FINISHED YET.
*
*        FIRST ESTABLISH IF WE'RE LOOKING FOR OPEN OR CLOSE.
*        IF ENT_PRESSED ZERO WE'RE LOOKING FOR CLOSE.  
*        IF ITS NON-ZERO WE'RE LOOKING FOR OPEN ON THAT BUTTON
*
NOT_BOUNCING
         MOVE    *A13(ENT_PRESSED),A2,W         ;WELL?
         JREQ    HB_OPEN                        ;WE'RE OPEN.....HANDLE 1 WAY
*
*        WE'RE CLOSED....WATCH THE SWITCH INDICATE BY A2 FOR OPEN.
*
         CALLR   FETCH_BUTTONS                  ;A0 HAS CURRENT BUTTONS

         AND     A2,A0                          ;IS THE ONE WE WANT CLOSED?
         JRNZ    NO_BUT_WORK                    ;STILL CLOSED....HANG STATE.
*
*        BUTTON WENT FROM CLOSED TO OPEN.
*
         CLR     A0
         MOVE    A0,*A13(ENT_PRESSED),W         ;INDIATE WE'RE LOOKING AGAIN!

         JRUC    START_DEBOUNCE                 ;AND NULLIFY QUICK HIT
*
*        WE'RE LOOKING FOR CLOSURES
*
HB_OPEN 
         MOVE    *A13(ENT_Y_OFFSET),A0,L        ;DECAY HAND BACK TO BASE
         JRNN    NO_HAND_ANI                    ;ITS THERE!
         ADDI    5*TABLE_UNIT,A0                ;ADD A UNIT
         JRN     STORE_AS_IS                    ;STILL NEGATIVE?
         CLR     A0                             ;WENT POSITIVE...MAKE ZERO
STORE_AS_IS
         MOVE    A0,*A13(ENT_Y_OFFSET),L

NO_HAND_ANI
         CALLR   FETCH_BUTTONS                  ;LOOK FOR CLOSED THIS FRAME
         NOT     A1                             ;OPEN LAST FRAME
         AND     A1,A0                          ;CLOSED THIS FRAME
         ANDI    BUTTON_BITS,A0                 ;JUST IN THESE BITS.
         JREQ    NO_BUT_WORK                    ;NO ONE CLOSED....EXIT

         MOVI    1,A1                           ;WALK OUT TO THE 1ST ONE
LOOK_FOR_BIT
         RL      1,A1
         MOVE    A1,A2
         AND     A0,A2
         JREQ    LOOK_FOR_BIT
*
*        A1 HAS THE BUTTON THAT'S PRESSED
*
         MOVE    A1,*A13(ENT_PRESSED),W         ;TELL PROCESS THIS IS THE ONE

         MOVI    -10*TABLE_UNIT,A0
         MOVE    A0,*A13(ENT_Y_OFFSET),L        ;THIS WILL PUNCH BUTTON

         MOVE    *A13(ENT_FROB_OBJ),A0,L        ;GET OBJECT WE'RE PRESSING
         JRZ     SKIP_X_ADJ                     ;NONE THERE....SKIP

         MOVE    *A0(OXVAL),A2,L                ;GET X POSITION OF LETTER
         MOVE    *A0(OIMG),A1,L                 ;GET IMAGE POINTER
         MOVE    *A1,A1,W                       ;GET WIDTH
         SLL     15,A1                          ;HALF WIDTH
         ADD     A1,A2                          ;ADD THIS IN.
         SUBI    HAND_X_ADJ,A2                  ;MOVE DISTANCE SO HAND LINES UP
         MOVE    *A13(ENT_X_COR),A1,L           ;GET BASE UPPER LEFT
         SUB     A1,A2                          ;FORM X OFFSET FROM THIS
         MOVE    A2,A9                          ;AND PLACE THIS IN X OFFSET REG!

SKIP_X_ADJ
         CALLR   ACT_ON_BUTTON                  ;DO AN ACTION

START_DEBOUNCE
         MOVI    2,A0                           ;3 FRAME DEBOUNCE
         MOVE    A0,*A13(ENT_ANI_TIMER),W       ;STORE IT
         MOVE    *A13(ENT_COUNT),A0,W           ;DID ACTION SAY EXIT?
         JREQ    EXIT_DETECTED

NO_BUT_WORK
         CLRC                    ;RETURN "LOOP"
         RETS

EXIT_DETECTED
         SETC                    ;RETURN EXIT CODE
         RETS

**************************************************************************
*                                                                        *
*          ACT_ON_BUTTON                                                 *
*                                                                        *
*          THIS IS CALLED ON THE FOREWARD PRESS OF ANY BUTTON            *
*          DURING ENTER YOUR INITIALS.   ITS JOB IS TO                   *
*          MAKE NECESSARY ADJUSTMENTS TO THE PROCESS AREA                *
*          TO REFLECT THE BUTTON PRESS.  THIS IS INVOLOVED               *
*          ONLY WITH DATA CHANGES AND NOT THE PHYSICAL ANIMATION         *
*          AND DEBOUNCE.                                                 *
*                                                                        *
**************************************************************************
ACT_ON_BUTTON
         CALLR   OP_P                           ;OPERATOR?
         JRNZ    AB00                           ;NOPE

         SOUND1  BEEP_1               ;MAKE A BEEP.

AB00     MOVE    *A13(ENT_FROB_ASCII),A0,W      ;GET THE "LETTER"
         CMPI    FONT_SPACE,A0                  ;IS IT A SPACE?
         JRNE    AB1                            ;NOPE
         MOVI    SPACE,A0                       ;REPLACE WITH A SPACE
         JRUC    AB2                            ;AND CONTINUE

AB1      CMPI    FONT_RUB,A0                       ;RUB?
         JREQ    DO_RUBOUT                      ;NO

         CMPI    FONT_END,A0                       ;END?
         JREQ    DO_END

         CMPI    FONT_CR,A0                     ;CR FOR OPERATOR IS "END"
         JREQ    DO_END
*
*        A0 HAS A CHARACTER TO ENTER
*
AB2      MOVE    *A13(ENT_COUNTDOWN),A1,W       ;ANY LEFT TO GET?
         JREQ    NO_ACTION                      ;NOPE....WE HAVE A PROBLEM

         MOVE    *A13(ENT_INIT_PTR),A2,L        ;GET PLACE TO PUT INITIAL
         MOVB    A0,*A2                         ;PUT IT OUT
         MOVE    *A13(ENT_INIT_SIZE),A3,W
         ADD     A3,A2                          ;PUSH POINTER TO NEXT INITIAL
         MOVE    A2,*A13(ENT_INIT_PTR),L        ;PUT POINTER BACK IN MEMORY

         DEC     A1                             ;1 LESS IN COUNTER
         MOVE    A1,*A13(ENT_COUNTDOWN),W       ;PUT COUNTER BACK

NO_ACTION
         RETS                                   ;AND WE'RE DONE!

DO_RUBOUT
         MOVE    *A13(ENT_COUNTDOWN),A1,W       ;GET NUMBER WE NEED
         MOVE    *A13(ENT_COUNT),A2,W           ;IS THIS NUMBER WE STARTED NEEDING?
         CMP     A1,A2
         JREQ    NO_ACTION                      ;YEP....NO ACTION!

         MOVE    *A13(ENT_INIT_PTR),A3,L        ;GET POINTER TO WHERE WE STASHED
         MOVE    *A13(ENT_INIT_SIZE),A4,W       ;GET DISTANCE BETWEEN
         SUB     A4,A3                          ;MOVE POINTER TO LAST LETTER
         CLR     A4                             ;PUT "NULL" AT CURRENT LETTER
         MOVB    A4,*A3                         
         MOVE    A3,*A13(ENT_INIT_PTR),L        ;PUT POINTER BACK
         INC     A1
         MOVE    A1,*A13(ENT_COUNTDOWN),W       ;PUT NEW COUNT BACK
         RETS

DO_END
         CLR     A0
         MOVE    A0,*A13(ENT_COUNT),W           ;SET START COUNT TO ZERO TO
         RETS                                   ;SIGNAL END RECEIVED.

BEEP_1   .WORD	>F3DF,>10,>80A2,0		;LOW BEEP 

**************************************************************************
*                                                                        *
*          DO_FROB                                                       *
*                                                                        *
*          THIS IS CALLED TO TAKE CARE OF THE FROB AND THE THING         *
*          THE FROB IS ON.  THE FROB OBJECT IS IN A10.  THE              *
*          HAND OBJECT IS IN A8.  WE WANT TO FIND THE "LETTER"           *
*          OBJECT THAT IS CLOSEST TO A PARTICULAR OFFSET OF              *
*          THE HAND.  WE MOVE THE FROB TO BOX THAT ITEM, AND             *
*          HIGHLIGHT THAT LETTER (BY CHANGING ITS CONSTANT).             *
*                                                                        *
*          WE ARE RESPONSIBLE FOR CHANGING THE LAST ONE THAT             *
*          WAS HIGHLIGHTED TO ITS NORMAL COLOR.                          *
*                                                                        *
**************************************************************************
DO_FROB  MMTM    SP,A0,A1,A2,A3,A4,A5,A6,A7
         MOVE    *A8(OXVAL),A1,L      ;GET POSITION OF HAND
         MOVE    *A8(OYVAL),A2,L
         ADDI    HAND_HOT_DX,A1       ;MOVE TO "HOT" POINT
         ADDI    HAND_HOT_DY,A2
         MOVE    *A13(ENT_Y_OFFSET),A3,L  ;GET DELTA Y
         SUB     A3,A2                    ;"UN-DO" ANIMATION TO GET REAL POINT

         MOVE    *A13(ENT_OLIST),A3,L      ;WALK THROUGH OUR OBJECTS
         JRZ     NO_FROB_NOW               ;DON'T CHANGE IT.

DF1      MOVE    *A3(OID),A7,W             ;GET THE ID OF THE CURRENT GUY
*         CMPI    LET_A,A7                  ;IS IT A LETTER OF SPECIAL CHAR?
         CMPI    EX_PT,A7                  ;IS IT A LETTER OF SPECIAL CHAR?
         JRLO    SKIP_OBJ                  ;NOPE...SKIP THIS ONE

         MOVE    A1,A4                     ;MOVE HAND X TO DESTRUCTABLE PLACE
         MOVE    *A3(OXVAL),A5,L           ;GET THE X OF THIS LETTER
*
*        NOW FIND CENTER OF THE IMAGE AT THIS POINT
*
         MOVE    *A3(OIMG),A6,L            ;THIS IS IMAGE POINTER
         MOVE    *A6,A6,W                  ;THIS IS DX IN PIXELS
         SLL     15,A6                     ;ALIGN, BUT DIVIDE BY 2!
         ADD     A6,A5                     ;THIS IS X WE ARE INTERESTED IN!

         SUB     A5,A4                     ;THIS WILL BE POS IF HAND IS ON RIGHT
         JRN     SKIP_OBJ                  ;THIS IS A NO GO!
*
*        THIS IS WHERE SPECIAL CASE FOR RUB, SPACE, END WILL GO
*
         CMPI    FONT_SPACE,A7             ;ARE WE 3 SPECIAL GUYS?
         JRLO    NOT_RUB                   ;YEP...USE LARGER X

         CMPI    CLOSE_FOR_RUB,A4          ;RUB HAS A LARGER RANGE!
         JRLS    RUB_IN_RANGE              ;WE'RE CLOSE ENOUGH FOR RUB

NOT_RUB
         CMPI    CLOSE_X,A4                ;ARE WE CLOSE ENOUGH IN X TO CONSIDER?
         JRHI    SKIP_OBJ                  ;NOPE....TRY NEXT OBJECT

RUB_IN_RANGE
         MOVE    A2,A4

         MOVE    *A3(OYVAL),A5,L           ;GET THE Y OF THIS LETTER
         SUB     A5,A4                     ;THIS WILL BE POS IF HAND IS ON RIGHT
         JRN     SKIP_OBJ                  ;THIS IS A NO GO!

         CMPI    CLOSE_Y,A4                ;ARE WE CLOSE ENOUGH IN X TO CONSIDER?
         JRHI    SKIP_OBJ                  ;NOPE....TRY NEXT OBJECT
*
*        WE HAVE THE LETTER TO FROB AROUND
*
         MOVE    *A13(ENT_FROB_OBJ),A6,L   ;GET LAST FROB
         JREQ    FROB_UNDEF                ;THIS IS THE 1ST FROB
         CMP     A3,A6                     ;SAME FROB?
         JREQ    NO_FROB_NOW               ;YEP....NOTHING TO DO

         MOVE    *A13(ENT_CONST),A0,W      ;GET THE CONSTANT
         MOVE    A0,*A6(OCONST),W          ;RESTORE "BACKGROUND" COLOR FOR LETTER

FROB_UNDEF
         MOVE    A3,*A13(ENT_FROB_OBJ),L    ;STORE THE CURRENT ONE
         MOVE    A7,*A13(ENT_FROB_ASCII),W  ;STORE THE "ASCII" FOR THIS ONE
*
*        A7 HAS THE ASCII OR SPECIAL CODE TO FROB AROUND
*        NOW GET A DX AND DY FOR THIS CODE
*
         MOVI    FROB_COLOR,A0
         MOVE    A0,*A3(OCONST),W           ;MAKE CURRENT LETTER GLOW
         JRUC    NO_FROB_NOW                ;WE'RE READY TO EXIT.

SKIP_OBJ MOVE    *A3(OSLINK),A3,L           ;WALK TO NEXT
         JRNZ    DF1

NO_FROB_NOW
	MMFM    SP,A0,A1,A2,A3,A4,A5,A6,A7
	RETS

**************************************************************************
*                                                                        *
*          GET_FROB_DY_DX                                                *
*                                                                        *
*          THIS IS CALLED BY DO_FROB TO GET AN OFFSET TO CENTER          *
*          THE BOX AROUND THE VARIOUS FIGURES.  A FIXED OFFSET           *
*          SHOULD WORK FOR A-Z.....THE SP RUB AND END WILL               *
*          REQUIRE THEIR OWN SPECIAL OFFSETS.                            *
*                                                                        *
**************************************************************************
*GET_FROB_DY_DX
*         MOVI    -9*TABLE_UNIT,A1
*         MOVI    -2*TABLE_UNIT,A2
*         RETS

**************************************************************************
*                                                                        *
*          LIMIT_RANGE                                                   *
*                                                                        *
*          THIS IS CALLED TO COMPARE THE NUMBER IN A0                    *
*          TO THE RANGE (UNSIGNED) IN A3,A4.  IF IT IS                   *
*          SMALLER THAN A3 WE RETURN A3 IN A0.  IF IT IS                 *
*          LARGER THAN A4 WE RETURN A4 IN A0.  ELSE WE                   *
*          RETURN A0 AS IS.                                              *
*                                                                        *
**************************************************************************
LIMIT_RANGE
         CMP     A3,A0                ;IS A0 TOO LOW
         JRHS    LR1                  ;NOPE

         MOVE    A3,A0
LR1      CMP     A4,A0
         JRLS    LR2

         MOVE    A4,A0
LR2      RETS

**************************************************************************
*                                                                        *
*          GET_DY_DX                                                     *
*                                                                        *
*          THIS IS CALLED IN STEADY STATE FOR ENTER YOUR INITIALS.       *
*          IT CHECKS THE JOYSTICK AND RETURNS THE DISTANCE               *
*          TO MOVE IN X IN A1, AND THE DISTANCE IN Y IN A2.              *
*                                                                        *
*          THIS DOES NOT HANDLE THE LIMITING.  THIS IS                   *
*          DONE BY THE CALLER.                                           *
*                                                                        *
**************************************************************************
GET_DY_DX
         MMTM    SP,A0,A3
         CLR     A1
         CLR     A2

         CALLR   GET_STICK_IN_A3

         MOVE    A3,A0                     ;COPY
         ANDI    1,A0                      ;IS UP PRESSED?
         JRZ     NOT_UP

         ADDI    -3*TABLE_UNIT,A2          ;

NOT_UP
         MOVE    A3,A0
         ANDI    2,A0
         JRZ     NOT_DOWN

         ADDI    3*TABLE_UNIT,A2

NOT_DOWN
         MOVE    A3,A0
         ANDI    4,A0
         JRZ     NOT_LEFT

         ADDI    -4*TABLE_UNIT,A1

NOT_LEFT
         ANDI    8,A3
         JRZ     NOT_RIGHT

         ADDI    4*TABLE_UNIT,A1
NOT_RIGHT
	MMFM    SP,A0,A3
	RETS

**************************************************************************
*                                                                        *
*          FETCH_BUTTONS                                                 *
*                                                                        *
*          THIS IS CALLED TO READ THE CURRENT STATE OF THE               *
*          CURRENT PLAYERS BUTTONS INTO THE PROCESS                      *
*          AREA.  THE OLD BUTTONS ARE RETURNED IN A1.                    *
*          THE NEW BUTTONS ARE RETURNED IN A0 AND                        *
*          STORED IN THE PROCESS AREA.                                   *
*                                                                        *
*          WE ALSO RETURN A COMPARE OF THE LAST AND CURRENT STATE        *
*                                                                        *
**************************************************************************
FETCH_BUTTONS
         MMTM    SP,A3
         CALLR   GET_STICK_IN_A3           ;GET A NEW STICK

         MOVE    A3,A0
         ANDI    BYTE_MASK,A0              ;JUST KEEP THIS PLAYER

         MOVE    *A13(ENT_LAST_BUTTON),A1,W  ;SHOW LAST STATE
         CMP     A0,A1                       ;RETURN THE COMPARISON
         MOVE    A0,*A13(ENT_LAST_BUTTON)
	MMFM    SP,A3
	RETS

**************************************************************************
*                                                                        *
*          GET_STICK_IN_A3                                               *
*                                                                        *
*          THIS GETS THE 8 SWITCHES FOR THE CURRENT PLAYER               *
*          IN THE LOW BYTE OF A3.   THE HARDWARE IS 1 FOR OPEN,          *
*          BUT THIS ROUTINE RETURNS:                                     *
*                                                                        *
*                  BIT = 0 MEANS SWITCH OPEN                             *
*                  BIT = 1 MEANS SWITCH CLOSED                           *
*                                                                        *
*          THEY READ AS FOLLOWS:                                         *
*                                                                        *
*          MSB                                                 LSB       *
*             ROCKET  JUMP  FIRE  CROUCH  RIGHT  LEFT  DOWN  UP          *
*                                                                        *
**************************************************************************
GET_STICK_IN_A3
         MMTM    SP,A0
         MOVE    *A13(ENT_STICK),A0,W      ;GET THE SHIFT COUNT
         MOVE    @SWITCH,A3,W              ;READ THE STICK
         NEG     A0                        ;BRAIN DAMAGE SRL USES 2'S COMPLE.
         SRL     A0,A3                     ;SHIFT BASED ON PLAYER NUMBER
         NOT     A3                        ;INVERT SO 1 IS CLOSED
         ANDI    BYTE_MASK,A3              ;KEEP JUST THIS PLAYER'S BYTE
	MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          NEW_OBJ                                                       *
*                                                                        *
*          A14 = STFOBJ POINTER                                          *
*          A1  = RELATIVE X OFFSET FROM UPPER LEFT OF AREA               *
*          A2  = RELATIVE Y OFFSET FROM UPPER LEFT OF AREA               *
*                                                                        *
*          RETURN A0 POINTS AT NEW OBJECT                                *
*                 .EQ. IF FAIL                                           *
*                 .NE. IF OK                                             *
*                                                                        *
*          CALL INSOBJ AFTER WE RETURN                                   *
*                                                                        *
**************************************************************************
NEW_OBJ
         CALLA   GPALOBJ                   ;GET THE STUFF NECESSARY
         JREQ    RET_FAIL
         CALLA   STFOBJ                    ;STUFF IT

         CALLR   LINK_TO_ME                ;STRING IT ONTO OUR LIST
         CALLR   STUFF_OBJECT_OFFSET       ;SET IT THERE!
         MOVE    A0,A0                     ;RETURN .NE.
RET_FAIL
         RETS

**************************************************************************
*                                                                        *
*          ADD_ALPHABET                                                  *
*                                                                        *
*          THIS IS CALLED TO GET ALL OF THE LETTER OBJECTS.              *
*                                                                        *
**************************************************************************
ADD_ALPHABET
         MMTM    SP,A1,A2,A3,A4,A5,A6,A7

         CALLR   OP_P                           ;IS IT THE OPERATOR
         JRZ     ADD_OPABET                     ;YEP...PUT HIS SET OUT!

         MOVI    ALPHA_Y,A2
         MOVI    LET_A,A3                       ;THIS IS THE "CURRENT" LETTER
         MOVI    ALPHA_ROWS,A4                  ;THIS IS ROW COUNTER
NEXT_ROW
         MOVI    ALPHA_X,A1                     ;RESET X TO LEFT MARGIN
         MOVI    ALPHA_COLS,A5
NEXT_LET
         MOVI    RD15FONT,A6                    ;POINT AT C-SET
         CALLR   SETUP_LETTER                   ;SETUP THIS LETTER
         ADDI    ALPHA_DX,A1                    ;PUSH TO NEXT X POSITION
         CMPI    LET_Z,A3                       ;DID WE JUST DO THE Z?
         JREQ    SPECIAL_LETS                   ;YEP....DO THE ODDBALLS
         INC     A3                             ;NEXT ASCII LETTER
         DSJS    A5,NEXT_LET

         ADDI    ALPHA_DY,A2                    ;NEXT ROW POSITION
         DSJS    A4,NEXT_ROW

SPECIAL_LETS
         MOVI    FONT_END,A7                    ;LAST LETTER WILL BE "END"
FINISH_OP
         ADDI    Z_TO_SPACE,A1                  ;ADD EXTRA
         ADDI    SPACE_DY,A2                    ;PUSH SPACE DOWN A LITTLE
         MOVI    FONT_SPACE,A3                  ;POINT AT SPACE
         CALLR   SETUP_LETTER                   ;SETUP THIS LETTER

         SUBI    SPACE_DY,A2                    ;RESTORE Y TO "PRE" SPACE 
         ADDI    SPACE_TO_RUB,A1                ;PUSH TO RUB X POSITION
         MOVI    FONT_RUB,A3
         CALLR   SETUP_LETTER                   ;SETUP THIS LETTER

         ADDI    RUB_TO_END,A1                  ;DISTANCE TO "END" POSITION
         MOVE    A7,A3                          ;GET "LAST" SYMBOL.
         CALLR   SETUP_LETTER

	MMFM    SP,A1,A2,A3,A4,A5,A6,A7
	RETS

OP_COLS  EQU     23

**************************************************************************
*                                                                        *
*          ADD_OPABET                                                    *
*                                                                        *
*          THIS IS CALLED TO PUT OUT THE CHARACTER SET FOR THE           *
*          OPERATOR.  IT USES ALOT MORE OR THE CHARACTERS!               *
*                                                                        *
**************************************************************************
ADD_OPABET
         MOVI    OP_TABLE,A7
         MOVI    ALPHA_Y,A2
         MOVI    ALPHA_ROWS,A4                  ;THIS IS ROW COUNTER
NEXT_ROW1
         MOVI    ALPHA_X,A1                     ;RESET X TO LEFT MARGIN
         MOVI    OP_COLS,A5
NEXT_LET1
         MOVB    *A7,A3                         ;FETCH NEXT LETTER
         JRZ     OP_LETS_DONE                   ;NO MORE!
         ANDI    BYTE_MASK,A3                   ;KILL SIGN EXTEND
         ADDI    BYTE_SIZE,A7                   ;PUSH THE POINTER

         MOVI    RD15FONT,A6                    ;POINT AT C-SET
         CALLR   SETUP_LETTER                   ;SETUP THIS LETTER
         ADDI    ALPHA_DX,A1                    ;PUSH TO NEXT X POSITION
         DSJS    A5,NEXT_LET1

         ADDI    ALPHA_DY,A2                    ;NEXT ROW POSITION
         DSJS    A4,NEXT_ROW1

OP_LETS_DONE
         MOVI    FONT_CR,A7                     ;"CR" SYMBOL REPLACES END
         JRUC    FINISH_OP                      ;THIS WILL WRAP IT UP!

**************************************************************************
*                                                                        *
*          OP_P                                                          *
*                                                                        *
*          THIS IS CALLED TO SEE IF THE CURRENT GET_LET                  *
*          RUNNING IS FOR THE OPERATOR MESSAGE.                          *
*                                                                        *
*          .EQ.   YES                                                    *
*          .NE.   NO                                                     *
*                                                                        *
**************************************************************************
OP_P     MMTM    SP,A0
         MOVE    *A13(ENT_Y_COR),A0,L      ;GET THE Y BASE
         CMPI    OP_Y,A0
	MMFM    SP,A0
	RETS

OP_TABLE .STRING "ABCDEFGHI123"
         .BYTE   ASCII_DQ
         .BYTE   FONT_RQUOTE
         .STRING "'.,!?()-/"
         .STRING "JKLMNOPQR456" 
         .STRING "#$%&:;<=>[]"
         .STRING "STUVWXYZ"
         .BYTE   FONT_SPACE
         .STRING "7890"
         .STRING "^_{}|"
         .BYTE   FONT_EPOUND
         .BYTE   0
         .EVEN

**************************************************************************
*                                                                        *
*          SETUP_LETTER                                                  *
*                                                                        *
*          THIS IS CALLED TO GET AN OBJECT FOR A LETTER.                 *
*          A1,A2 HAS RELATIVE OFFSET POSITON FOR LETTER.                 *
*          A3 IS THE ASCII REP OF THE LETTER.                            *
*          A6 HAS FONT LIST OF LETTERS (E.G. RD15FONT)                   *
*                                                                        *
**************************************************************************
SETUP_LETTER
         MMTM    SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A14
         MOVE    A3,A7                ;SAVE ASCII IN A7
         SUBI    EX_PT,A3             ;EXPT IS FIRST CHAR.....NOW WE'RE AT BASE
         JRC     BAD_LETTER           ;LETTER TOO LOW FOR SET

         SLL     5,A3                 ;MAKE LONG WORD OFFSET
         ADD     A3,A6                ;NOW A6 POINTS AT IMAGE STRUCTURE.
         MOVE    *A6,A6,L             ;FETCH THE IMAGE STRUCTURE
*
*        A6 POINTS AT X,Y WIDTH IN PIXELS.
*
         MOVI    ALPHA_DX,A8          ;THIS IS INTER CHARACTER WIDTH
         MOVE    *A6,A0,W             ;GET THE X WIDTH OF LETTER
         SLL     16,A0                ;SHIFT UP TO PIXEL UNITS
         SUB     A0,A8                ;THIS IS EXCESS WHITESPACE
         SRA     1,A8                 ;THIS IS AMOUNT TO INDENT (COULD BE NEGATIVE!)
         ADD     A8,A1                ;ADD THIS TO THE PASSED X POSITION

         MOVI    LETTER_TEMPLATE,A14  ;POINT AT STUFF FOR OBJECT

         CALLA   GETOBJ               ;GET AN OBJECT PALETTE AND OBJECT
         JREQ    BAD_LETTER           ;CAN'T GET OBJECT....EXIT

         MOVE    A0,A3                ;OBJECT IN A3

         MOVI    NARCS,A0               ;USE NARCS PALETTE
	CALLA	GETFPAL			  ;GET A PALETTE

	JRZ	NO_PALETTE		;COULD NOT GET THE PALETTE
	MOVE	A0,@CURPAL,W		;STUFF THIS IN CURRENT PAL

         MOVE    A3,A0                ;GET OBJECT IN A0
         MOVI    LETTER_TEMPLATE,A14  ;SET FOR STUFFING
         CALLA   STFOBJ               ;STUFF SOME STUFF
         CALLR   STUFF_OBJECT_OFFSET  ;ADD IN A1, A2 AND STORE OFFSET

         MOVE    A7,*A0(OID),W        ;PUT ASCII LETTER AS THE ID

         MOVE    A6,A1                ;GIVE IMAGE POINTER FOR ANI
         MOVE    A0,A8                ;OBJECT STRUCTURE FOR ANI
         MOVE    *A0(OFLAGS),A4,W     ;FETCH THE OFLAGS
         CALLA   ANI                  ;SET NEW ANIMATION PICTURE

         MOVE    *A13(ENT_CONST),A1,W ;GET THE CONSTANT
         MOVE    A1,*A0(OCONST),W        ;PUT IN OBJECT BLOCK

         CALLA   INSOBJ               ;NOW PUT ON OBJECT LIST
         CALLR   LINK_TO_ME           ;LINK IT IN SO WE HAVE IT!
	MMFM    SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A14
	RETS
*
*        ERROR EXITS
*
NO_PALETTE
         MOVE    A3,A0                ;GET OBJECT POINTER BACK IN A0
	CALLA	FREEOBJ

BAD_LETTER
	MMFM    SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A14
	RETS

**************************************************************************
*                                                                        *
*          STUFF_OBJECT_OFFSET                                           *
*                                                                        *
*          THIS IS CALLED TO TAKE A NEWLY CREATED OBJECT IN A0           *
*          AND TO POSITION IT AT X=A1, Y=A2 AWAY FROM OUR UPPER          *
*          LEFT CORNER.                                                  *
*                                                                        *
**************************************************************************
STUFF_OBJECT_OFFSET
         MMTM    SP,A1,A2
         CALLR   ADD_BASE_TO_A1_A2
         MOVE    A1,*A0(OXVAL),L           ;STORE IN OBJECT
         MOVE    A2,*A0(OYVAL),L           ;STORE IN OBJECT
	MMFM    SP,A1,A2
	RETS

**************************************************************************
*                                                                        *
*          ADD_BASE_TO_A1_A2                                             *
*                                                                        *
*          THIS CHANGES A1,A2 FROM AN X,Y OFFSET (FROM                   *
*          OUR UPPER LEFT CORNER) TO ABSOULE X AND Y                     *
*          COORDINATES BY ADDING IN THE UPPER LEFT CORNER.               *
*                                                                        *
**************************************************************************
ADD_BASE_TO_A1_A2
         MMTM    SP,A3
         MOVE    *A13(ENT_X_COR),A3,L      ;GET X FOR CORNER
         ADD     A3,A1                     ;MOVE IN BY A1

         MOVE    *A13(ENT_Y_COR),A3,L      ;GET Y FOR CORNER
         ADD     A3,A2                     ;MOVE IN BY A2
	MMFM    SP,A3
	RETS

**************************************************************************
*                                                                        *
*          LINK_TO_ME                                                    *
*                                                                        *
*          THIS IS CALLED TO LINK THE OBJECT BLOCK IN A0                 *
*          TO THE LIST FOR THE CONTROLLING PROCESS.                      *
*                                                                        *
*          THE LIST STARTS AT END_OLIST OFFSET IN THE                    *
*          CONTROLLING PROCESS STORE AREA.                               *
*                                                                        *
**************************************************************************
LINK_TO_ME
         MMTM    SP,A1
         MOVE    *A13(ENT_OLIST),A1,L      ;GET THE LIST POINTER
         MOVE    A1,*A0(OSLINK),L          ;STORE OUR LIST AS HIS PTR
         MOVE    A0,*A13(ENT_OLIST),L      ;STORE HIM AS HEAD OF LIST
	MMFM    SP,A1
	RETS

**************************************************************************
*                                                                        *
*          STUFF_ENT_PDATA                                               *
*                                                                        *
*          THIS IS CALLED TO STUFF THE ROM DATA INTO THE                 *
*          ENTRY PROCESS AREA.                                           *
*                                                                        *
*          A8 = DATA FOR AREA                                            *
*                                                                        *
**************************************************************************
STUFF_ENT_PDATA
         MMTM    SP,A8,A1,A2
         MOVE    A13,A1               ;USE A1 FOR PROCESS AREA
         ADDI    PDATA,A1             ;POINT A1 AT PDATA
         MOVI    ENT_STRUCT_IN_WORDS,A2    ;THIS IS COUNT OF WHAT TO MOVE
STUFF1   MOVE    *A8+,*A1+,W
         DSJS    A2,STUFF1
	MMFM    SP,A8,A1,A2
	RETS

**************************************************************************
*                                                                        *
*          E_TITLES                                                      *
*                                                                        *
*          THIS IS CALLED BEFORE ENTER YOUR INITIALS TO PUT UP           *
*          TITLES FOR PLAYER 1 OR PLAYER 2.                              *
*                                                                        *
*          ENT_DATA POINTS AT PLAYER ROM STRUCTURE FOR PLAYER            *
*                                                                        *
*          NEED TO SAVE ONLY A8,A9,A10,A11                               *
*                                                                        *
**************************************************************************
E_TITLES
         MMTM    SP,A8,A9,A10,A11

         CALLR   OP_P                      ;OPERATOR?
         JRZ     ET_X                      ;YEP...NO MESSAGE!

         MOVE    *A13(ENT_DATA),A1,L       ;FETCH THE DATA POINTER
         CLR     A0                        ;NO SLEEP TIME
         MOVE    *A13(ENT_CONST),A6,W      ;USE THIS RAM VERSION OF COLOR
         MOVE    *A1(LET_MESS),A8,L        ;THIS IS THE MESSAGE
         MOVE    *A1(ENT_X_COR-PDATA),A9,L ;GET X OFFSET
         ADDI    12H*TABLE_UNIT,A9         ;PLACE FOR MESSAGE
         SRL     16,A9                     ;SHIFT IT DOWN
         MOVE    *A1(ENT_Y_COR-PDATA),A3,L ;GET X OFFSET
         SUBI    0C0H*TABLE_UNIT,A3
         ANDI    0FFFF0000H,A3                  ;MASK Y
         ADD     A3,A9                          ;THIS POINTS AT PLACE FOR "PLAYER"

         MOVI    00000002H,A10             ;SMALL SPACING
         MOVI    RD20FONT,A11
         JSRP    STRLNRM
*
*        NOW PUT THE "ENTER YOUR INITIALS" PART
*
         MOVE    *A1(ENT_X_COR-PDATA),A9,L         ;GET X OFFSET
         ADDI    4*TABLE_UNIT,A9             ;PLACE FOR MESSAGE
         SRL     16,A9                       ;SHIFT IT DOWN
         MOVE    *A1(ENT_Y_COR-PDATA),A3,L         ;GET X OFFSET
         SUBI    0A0H*TABLE_UNIT,A3
         ANDI    0FFFF0000H,A3                  ;MASK Y
         ADD     A3,A9                          ;THIS POINTS AT PLACE FOR "PLAYER"

         MOVI    MESS_3,A8                      ;POINT AT TEXT STRING
         MOVI    RD15FONT,A11

         MOVI    00000001H,A10             ;SMALL SPACING

         JSRP    STRLNRM
ET_X	MMFM    SP,A8,A9,A10,A11
	RETS

**************************************************************************
*                                                                        *
*          STRING DEFINITIONS                                            *
*                                                                        *
**************************************************************************

MESS_1   .BYTE   "PLAYER  1",0
MESS_2   .BYTE   "PLAYER  2",0
MESS_3   .BYTE   "ENTER YOUR INITIALS:",0

*****************************************************************************
         .EVEN                             ;AFTER BYTE BLOCK WE EVEN IT OUT!
*****************************************************************************
         .END
