*
*INTERRUPT CONSTANTS
HSINT	.SET	127+1BH		;HALF SCREEN
EOSINT	.SET	255+1BH		;END OF SCREEN

*-----------------------------------------------------------------------
* Define names of I/O registers
*-----------------------------------------------------------------------
HESYNC	.set	0C0000000h
HEBLNK	.set	0C0000010h
HSBLNK	.set	0C0000020h
HTOTAL	.set	0C0000030h
VESYNC	.set	0C0000040h
VEBLNK	.set	0C0000050h
VSBLNK	.set	0C0000060h
VTOTAL	.set	0C0000070h
DPYCTL	.set	0C0000080h
DPYSTRT	.set	0C0000090h
DPYINT	.set	0C00000A0h
CONTROL	.set	0C00000B0h
HSTDATA	.set	0C00000C0h
HSTADRL	.set	0C00000D0h
HSTADRH	.set	0C00000E0h
HSTCTLL	.set	0C00000F0h
HSTCTLH	.set	0C0000100h
INTENB	.set	0C0000110h
INTPEND	.set	0C0000120h
CONVSP	.set	0C0000130h
CONVDP	.set	0C0000140h
PSIZE	.set	0C0000150h
PMASK	.set	0C0000160h
* I/O register locations 23-27 are reserved for future expansion
HCOUNT	.set	0C00001C0h
VCOUNT	.set	0C00001D0h
DPYADR	.set	0C00001E0h
REFCNT	.set	0C00001F0h
*
hesync	.set	0C0000000h
heblnk	.set	0C0000010h
hsblnk	.set	0C0000020h
htotal	.set	0C0000030h
vesync	.set	0C0000040h
veblnk	.set	0C0000050h
vsblnk	.set	0C0000060h
vtotal	.set	0C0000070h
*	Display and memory control registers
dpyctl	.set	0C0000080h
dpystrt	.set	0C0000090h
dpyint	.set	0C00000A0h
control	.set	0C00000B0h
*	Host interface registers
hstdata	.set	0C00000C0h
hstadrl	.set	0C00000D0h
hstadrh	.set	0C00000E0h
hstctll	.set	0C00000F0h
hstctlh	.set	0C0000100h
*	Interrupt control registers
intenb	.set	0C0000110h
intpend	.set	0C0000120h
*	Graphics I/O registers
convsp	.set	0C0000130h
convdp	.set	0C0000140h
psize	.set	0C0000150h
pmask	.set	0C0000160h
*
hcount	.set	0C00001C0h
vcount	.set	0C00001D0h
dpyadr	.set	0C00001E0h
refcnt	.set	0C00001F0h


X	.set	1
Y	.set	010000h
;W	.SET	0
;L	.set	1

*-----------------------------------------------------------------------
* Masks for I/O register fields:
*-----------------------------------------------------------------------

*	DISPLAY CONTROL REGISTER BIT DEFINITIONS
HSD	.set	01h		; Horizontal Sync Direction
DUDATE	.set	0000001111111100B	; display update (2-9)
ORG	.set	0400h		; ORiGin (1 = lower left; 0 = upper left)
SRT	.set	0800h		; Shift Reg Transfer enable
SRE	.set	01000h		; Screen Refresh Enable
DXV	.set	02000h		; Disable eXternal Video
NIL	.set	04000h		; Non-InterLaced video enable
ENV	.set	08000h		; ENable Video

*	BIT FIELDS WITHIN CONTROL REGISTER
CD	.set	08000h		;Mask for Cache Dis bit in CONTROL
PPOP	.set	07C00h		;Mask for Pix Proc OPer in CONTROL
PBH	.set	0200h		;Mask for PBH bit in CONTROL
PBV	.set	0100h		;Mask for PBV bit in CONTROL
WIN	.set	0C0h		;Mask for Window field in CONTROL
T	.set	020h		;Mask for Transparency field in CONTROL
RR	.set	018h		;Mask for dram Refresh Rate bit in CONTROL
RM	.set	04h		;Mask for dram Refresh Mode bit in CONTROL

*	BITS WITHIN INTPEND AND INTENB
WVP	.set	0800h		;Mask for Window Violation in INTPEND
DIE	.set	0400h		;Mask for Disp Int in INTPEND
HIE	.set	0200h		;Mask for Host Int in INTPEND
X2E	.set	04h		;Mask for Ext Int 2 in INTPEND 
X1E	.set	02h		;Mask for Ext Int 1 in INTPEND
*	BIT POSITIONS IN INTPEND
DIP	.EQU	10		;BIT TEST FOR DISPLAY INTERRUPT PENDING

*	FIELDS WITHIN HSTCTLL
MSGIN	.set	07h	; Message from Host to GSP
INTIN_MSK	.set	08h	; GSP can write 0 to this bit (ANDNI)
INTIN_BIT	.set	03h		; GSP can write 0 to this bit (ANDNI)
INTOUT_MSK .set	080h	; GSP can write 1 to this bit (ORI)
INTOUT_BIT .set	07h		; GSP can write 1 to this bit (ORI)

* OPTIONS FOR WINDOW FIELD IN CONTROL REG
*W0	(ANDNI) No writes inhibited, no interrupt
W3	.set 0C0h	;inhibit writes outside window, no interrupt
W2	.set	080h	;Inhibit all writes, Int on attempt to write within window
W1	.set	040h	;Int on attempt to write outside window.

*OPTIONS FOR PIXEL PROC OPERATIONS IN CONTROL REG 
* PPOP  (ANDNI)	replace
P_AND	.set	0400h
P_ANDNOT	.set	0800h
P_ZERO	.set	0C00h
P_ORNOT	.set	01000h
P_XNOR	.set	01400h
P_NEG	.set	01800h
P_NOR	.set	01C00h
P_OR	.set	02000h
P_NOP	.set	02400h
P_XOR	.set	02800h
P_NOTAND	.set	02C00h
P_ONES	.set	03000h
P_NOTOR	.set	03400h
P_NAND	.set	03800h
P_NOT	.set	03C00h
P_ADD	.set	04000h
P_ADDS	.set	04400h
P_SUB	.set	04800h
P_SUBS	.set	04C00h
P_MAX	.set	05000h
P_MIN	.set	05400h


*------- Register names for TMS34010 assembly language functions -------

*-----------------------------------------------------------------------
* Define special A- and B-file registers
*-----------------------------------------------------------------------
* Special A-file registers:
fp	.set	A13		;Frame, param. stack
pstk	.set	A14		;Parameter stack pointer
frame_pntr	.set	A14	;Used by C Compiler
* Special B-file registers:
*
*	B FILE REGISTER GRAPHICS DEFINITIONS
*
saddr	.set	B0
sptch	.set	B1
daddr	.set	B2
dptch	.set	B3
offset	.set	B4
wstart	.set	B5
wend	.set	B6
dydx	.set	B7
color0	.set	B8
color1	.set	B9
count	.set	B10
inc1	.set	B11
inc2	.set	B12
pattrn	.set	B13
*
SADDR	.set	B0		;Source address register
SPTCH	.set	B1		;Source pitch register
DADDR	.set	B2		;Dest. address register
DPTCH	.set	B3		;Dest. pitch register
OFFSET	.set	B4		;XY offset register
WSTART	.set	B5		;Window start register
WEND	.set	B6		;Window end register
DYDX	.set	B7		;Delta X/delta Y register
COLOR0	.set	B8		;Color 0 register
COLOR1	.set	B9		;Color 1 register
COUNT	.set	B10
INC1	.set	B11
INC2	.set 	B12
PATTRN	.set	B13

