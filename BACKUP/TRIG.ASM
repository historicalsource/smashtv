	.FILE	'TRIG.ASM'
	.TITLE	'ROBO-RAMA GAME PROGRAM'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST


	.DEF	GETSIN,GETCOS

HALFPI	.set	102944
PI		.set	205887
X3HALFPI	.set	308831
X2PI	.set	411775


	.text
******************************************************************
GETSIN:
; PARMS   - A0 = theta in s15.16
; RETURNS - A0 = sin(theta) in s15.16
;return	A14 = theta normalized to range of 0 to 2Pi

	mmtm	SP,A2

;long int getsin (theta)
;long int theta;
;{
;int indx;
;long int retval;

;while (theta < 0) theta += X2PI;
TRIGLP1:
	move	A0,A0
	jrnn	TRIGSK1
	addi	X2PI,A0,L
	jruc	TRIGLP1
TRIGSK1:
;while (theta > X2PI) theta -= X2PI;
TRIGLP2:
	cmpi	X2PI,A0,L
	jrn	TRIGSK2
	subi	X2PI,A0,L
	jruc TRIGLP2
TRIGSK2:
	move	A0,A14			;A14 theta normalized

;if (theta < HALFPI) {
;	indx = ((theta+5) >> 9);
;	retval = sintbl[indx];
;	}
	cmpi	HALFPI,A0,L
	jrnn	TRIGSK3
	move	A0,A2
	addk	5,A2
	sra	9,A2
	sla	5,A2
	addi	SINTBL,A2,L
	move	*A2,A0,1
	mmfm	SP,A2
	rets
TRIGSK3:

;else if (theta <= PI) {
;	indx = (((PI - theta)+5) >> 9);
;	retval = sintbl[indx];
;	}
	cmpi	PI,A0,L
	jrp	TRIGSK4
	movi	PI,A2,L
	sub	A0,A2
	addk	5,A2
	sra	9,A2
	sla	5,A2
	addi	SINTBL,A2,L
	move	*A2,A0,1
	mmfm	SP,A2
	rets
TRIGSK4:

;else if (theta < X3HALFPI) {
;	indx = (((theta - PI) + 5) >> 9);
;	retval = sintbl[indx];
;	retval = -retval;
;	}
 	cmpi	X3HALFPI,A0,L
	jrnn	TRIGSK5
	move	A0,A2
	subi	PI,A2,L
	addk	5,A2
	sra	9,A2
	sla	5,A2
	addi	SINTBL,A2,L
	move	*A2,A0,1
	neg	A0
	mmfm	SP,A2
	rets
TRIGSK5:

;else {
;	indx = (((X2PI - theta) + 5) >> 9);
;	retval = sintbl[indx];
;	retval = -retval;
; 	}
	movi	X2PI,A2,L
	sub	A0,A2
	addk	5,A2
	sra 9,A2
	sla	5,A2
	addi	SINTBL,A2,L
	move	*A2,A0,1
	neg	A0
	mmfm	SP,A2
	rets

******************************************************************


	.text
******************************************************************
GETCOS:
; PARMS   - A0 = theta in s15.16
; RETURNS - A0 = cos(theta) in s15.16

	mmtm	SP,A2

;long int getcos (theta)
;long int theta;
;{
;int indx;
;long int retval;

;while (theta < 0) theta += X2PI;
TRIGLP3:
	move	A0,A0
	jrnn	TRIGSK6
	addi	X2PI,A0,L
	jruc	TRIGLP3
TRIGSK6:
;while (theta > X2PI) theta -= X2PI;
TRIGLP4:
	cmpi	X2PI,A0,L
	jrn	TRIGSK7
	subi	X2PI,A0,L
	jruc TRIGLP4
TRIGSK7:
	move	A0,A14			;A14 theta normalized

;if (theta < HALFPI) {
;	indx = (((HALFPI - theta) + 5) >> 9);
;	retval = sintbl[indx];
;	}
	cmpi	HALFPI,A0,L
	jrnn	TRIGSK8
	movi	HALFPI,A2,L
	sub	A0,A2
	addk	5,A2
	sra	9,A2
	sla	5,A2
	addi	SINTBL,A2,L
	move	*A2,A0,1
	mmfm	SP,A2
	rets
TRIGSK8:


;else if (theta <= PI) {
;	indx = (((theta - HALFPI) + 5) >> 9);
;	retval = sintbl[indx];
;	retval = -retval;
;	}
	cmpi	PI,A0,L
	jrp	TRIGSK9
	move	A0,A2
	subi	HALFPI,A2,L
	addk	5,A2
	sra	9,A2
	sla	5,A2
	addi	SINTBL,A2,l
	move	*A2,A0,1
	neg	A0
	mmfm	SP,A2
	rets
TRIGSK9:



;else if (theta < X3HALFPI) {
;	indx = (((X3HALFPI - theta) + 5) >> 9);
;	retval = sintbl[indx];
;	retval = -retval;
;	}
;else if (theta < X3HALFPI) {
;	indx = (((theta - PI) + 5) >> 9);
;	retval = sintbl[indx];
;	retval = -retval;
;	}
 	cmpi	X3HALFPI,A0,L
	jrnn	TRIGSK10
	movi	X3HALFPI,A2,L
	sub	A0,A2
	addk	5,A2
	sra	9,A2
	sla	5,A2
	addi	SINTBL,A2,L
	move	*A2,A0,1
	neg	A0
	mmfm	SP,A2
	rets
TRIGSK10:



;else {
;	indx = (((theta - X3HALFPI) + 5) >> 9);
;	retval = sintbl[indx];
; 	}
	move	A0,A2
	subi	X3HALFPI,A2,L
	addk	5,A2
	sra 9,A2
	sla	5,A2
	addi	SINTBL,A2,L
	move	*A2,A0,1
	mmfm	SP,A2
	rets

*****************************************************************


;/* Table of sin from 0 through PI/2 Radians in 2**-7 increments */
	.data
	.even
SINTBL:
	.int	0,511,1023,1535,2047,2559,3070,3582
	.int	4093,4604,5114,5625,6135,6644,7153,7662
	.int	8170,8678,9185,9692,10198,10703,11208,11712
	.int	12216,12718,13220,13721,14221,14721,15219,15717
	.int	16213,16709,17204,17697,18189,18681,19171,19660
	.int	20148,20634,21120,21604,22086,22568,23048,23526
	.int	24004,24479,24953,25426,25897,26367,26835,27301
	.int	27766,28228,28690,29149,29607,30063,30517,30969
	.int	31419,31867,32314,32758,33201,33641,34080,34516
	.int	34950,35382,35812,36240,36665,37088,37509,37928
	.int	38344,38758,39170,39579,39986,40391,40793,41192
	.int	41589,41984,42375,42765,43151,43535,43917,44295
	.int	44671,45045,45415,45783,46148,46510,46869,47226
	.int	47579,47930,48278,48622,48964,49303,49639,49972
	.int	50301,50628,50951,51272,51589,51903,52214,52522
	.int	52827,53128,53426,53721,54013,54301,54586,54868
	.int	55146,55421,55693,55961,56226,56487,56745,56999
	.int	57250,57498,57741,57982,58219,58452,58682,58908
	.int	59131,59349,59565,59776,59985,60189,60390,60587
	.int	60780,60970,61156,61338,61516,61691,61862,62029
	.int	62192,62352,62507,62659,62807,62952,63092,63229
	.int	63361,63490,63615,63736,63854,63967,64076,64182
	.int	64283,64381,64475,64564,64650,64732,64810,64884
	.int	64954,65020,65082,65140,65195,65245,65291,65333
	.int	65371,65406,65436,65462,65484,65503,65517,65527
	.int	65533,65535,65534
	
