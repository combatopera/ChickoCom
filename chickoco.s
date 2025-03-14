* ChickoCom 0.3

	lea	(a7),a5
	lea	newstk,a7
	movea.l	4(a5),a5
	move.l	12(a5),d0
	add.l	20(a5),d0
	add.l	28(a5),d0
	addi.l	#$100,d0
	move.l	d0,-(sp)
	pea	(a5)
	clr.w	-(sp)
	move.w	#$4a,-(sp)
	trap	#1
	lea	12(sp),sp

	clr.w	-(sp)		; fopen
	pea	fname
	move.w	#$3d,-(sp)
	trap	#1
	addq.l	#8,sp
	move.w	d0,fhand

	clr.w	-(sp)		; fseek
	move.w	fhand,-(sp)
	move.l	#34,-(sp)
	move.w	#$42,-(sp)
	trap	#1
	lea	10(sp),sp

	pea	titlescr		; fread
	move.l	#32000,-(sp)
	move.w	fhand,-(sp)
	move.w	#$3f,-(sp)
	trap	#1
	lea	12(sp),sp

	move.w	fhand,-(sp)	; fclose
	move.w	#$3e,-(sp)
	trap	#1
	addq.l	#4,-(sp)

	dc.w	$a000		; hide mouse
	movea.l	4(a0),a1
	movea.l	8(a0),a2
	dc.w	$a00a

	move.w	#4,-(sp)		; getrez
	trap	#14
	addq.l	#2,sp
	move.w	d0,oldres

	moveq	#15,d7
	lea	oldpal,a6
	lea	32(a6),a6
termina0:	move.w	#-1,-(sp)		; setcolor
	move.w	d7,-(sp)
	move.w	#7,-(sp)
	trap	#14
	addq.l	#6,sp
	move.w	d0,-(a6)
	dbra	d7,termina0

	clr.w	-(sp)		; setscreen
	move.l	#-1,-(sp)
	move.l	#-1,-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp

	move.w	#3,-(sp)		; logbase
	trap	#14
	addq.l	#2,sp
	move.l	d0,logbase

	pea	palette		; setpalette
	move.w	#6,-(sp)
	trap	#14
	addq.l	#6,sp

	clr.l	-(sp)		; supervisor mode
	move.w	#$20,-(sp)
	trap	#1
	addq.l	#6,sp
	move.l	d0,super

	bsr	title
	bsr	termrset

	bsr	chat

	move.l	super,-(sp)	; user mode
	move.w	#$20,-(sp)
	trap	#1
	addq.l	#6,sp

	move.w	oldres,-(sp)	; setscreen
	move.l	#-1,-(sp)
	move.l	#-1,-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp

	pea	oldpal		; setpalette
	move.w	#6,-(sp)
	trap	#14
	addq.l	#6,sp

	dc.w	$a000		; show mouse
	movea.l	4(a0),a1
	movea.l	8(a0),a2
	clr.w	(a2)
	clr.w	2(a1)
	clr.w	6(a1)
	dc.w	$a009

	clr.w	-(sp)		; pterm0
	trap	#1

	ds.l	100
newstk:	dc.l	0

super:	dc.l	0

oldres:	dc.w	0
logbase:	dc.l	0

ucolumn:	dc.w	0
urow:	dc.w	16
uattrib:	dc.w	7,0,0

oldpal:	ds.w	16
palette:	dc.w	$000,$500,$050,$640,$005,$505,$055,$555
	dc.w	$333,$F33,$3F3,$FF3,$33F,$F3F,$3FF,$FFF

crlf:	dc.b	13,10,0
	even
crlflf:	dc.b	13,10,10,0
	even
lf:	dc.b	10,0
	even

fhand:	dc.w	0
fname:	dc.b	"STATLINE.PI1",0
	even


* hang

hang:	movem.l	d0-d3/a0-a3,-(sp)

	tst.w	online
	beq	hang9

hang0:	move.w	#1,-(sp)
	move.w	#8,-(sp)
	trap	#13
	addq.l	#4,sp

	tst.w	d0
	beq	hang0

	move.l	$466,d0
	addi.l	#60,d0		; 1.2 seconds
hang1:	cmp.l	$466,d0
	bgt	hang1

	move.w	#43,-(sp)
	move.w	#1,-(sp)
	move.w	#3,-(sp)
	trap	#13
	addq.l	#6,sp

	move.l	$466,d0
	addi.l	#10,d0		; 0.2 seconds
hang2:	cmp.l	$466,d0
	bgt	hang2

	move.w	#43,-(sp)
	move.w	#1,-(sp)
	move.w	#3,-(sp)
	trap	#13
	addq.l	#6,sp

	move.l	$466,d0
	addi.l	#10,d0		; 0.2 seconds
hang3:	cmp.l	$466,d0
	bgt	hang3

	move.w	#43,-(sp)
	move.w	#1,-(sp)
	move.w	#3,-(sp)
	trap	#13
	addq.l	#6,sp

	bsr	waitok

	lea	hanga,a0
	bsr	auxstr

	bsr	waitok

	clr.w	online

hang9:	movem.l	(sp)+,d0-d3/a0-a3
	rts

hanga:	dc.b	"ATH0",13,10,0
	even


* chkrslt

chkrslt:	tst.w	online
	bne	chkrslt0
	bsr	chkconn
	bra	chkrslt9
chkrslt0:	bsr	chknoca
chkrslt9:	rts


* chkconn

chkconn:	movem.l	a0-a1,-(sp)

	lea	chkconna,a0
	move.b	1(a0),(a0)
	move.b	2(a0),1(a0)
	move.b	3(a0),2(a0)
	move.b	4(a0),3(a0)
	move.b	5(a0),4(a0)
	move.b	6(a0),5(a0)
	move.b	d0,6(a0)

	lea	chkconnb,a1
	cmpm.l	(a0)+,(a1)+
	bne	chkconn9
	cmpm.l	(a0)+,(a1)+
	bne	chkconn9
	move.w	#1,online

chkconn9:	movem.l	(sp)+,a0-a1
	rts

chkconna:	dc.b	0,0,0,0,0,0,0,0
chkconnb:	dc.b	"CONNECT",0


* chknoca

chknoca:	movem.l	a0-a1,-(sp)

	lea	chknocaa,a0
	move.b	1(a0),(a0)
	move.b	2(a0),1(a0)
	move.b	3(a0),2(a0)
	move.b	4(a0),3(a0)
	move.b	5(a0),4(a0)
	move.b	6(a0),5(a0)
	move.b	7(a0),6(a0)
	move.b	8(a0),7(a0)
	move.b	9(a0),8(a0)
	move.b	d0,9(a0)

	lea	chknocab,a1
	cmpm.l	(a0)+,(a1)+
	bne	chknoca9
	cmpm.l	(a0)+,(a1)+
	bne	chknoca9
	cmpm.l	(a0)+,(a1)+
	bne	chknoca9
	clr.w	online

chknoca9:	movem.l	(sp)+,a0-a1
	rts

chknocaa:	dc.b	0,0,0,0,0,0,0,0,0,0,0,0
chknocab:	dc.b	"NO CARRIER",0,0


* waitok

waitok:	movem.l	d0-d3/a0-a3,-(sp)

waitok0:	move.w	#1,-(sp)
	move.w	#1,-(sp)
	trap	#13
	addq.l	#4,sp

	tst.w	d0
	beq	waitok0

	move.w	#1,-(sp)
	move.w	#2,-(sp)
	trap	#13
	addq.l	#4,sp

	lea	waitoka,a0
	move.b	1(a0),(a0)
	move.b	d0,1(a0)

	move.w	waitokb,d0
	cmp.w	(a0),d0
	bne	waitok0

	movem.l	(sp)+,d0-d3/a0-a3
	rts

waitoka:	dc.b	0,0
waitokb:	dc.b	"OK"


* chat

chat:	movem.l	d0-d3/a0-a3,-(sp)

chat0:	move.w	#2,-(sp)
	move.w	#1,-(sp)
	trap	#13
	addq.l	#4,sp

	tst.w	d0
	beq	chat1

	move.w	#2,-(sp)
	move.w	#2,-(sp)
	trap	#13
	addq.l	#4,sp

	cmpi.l	#$003f0000,d0	; f5 puts debug5
	bne	chate
	lea	debug5,a0
	bsr	putstr
	bra	chat1

chate:	cmpi.l	#$00400000,d0	; f6 puts debug6
	bne	chatf
	lea	debug6,a0
	bsr	putstr
	bra	chat1

chatf:	cmpi.l	#$00410000,d0	; f7 puts debug7
	bne	chatg
	lea	debug7,a0
	bsr	putstr
	bra	chat1

chatg:	cmpi.l	#$00420000,d0	; f8 hangs up
	bne	chath
	bsr	hang
	bra	chat1

chath:	cmpi.l	#$00430000,d0	; f9 resets the terminal
	bne	chati
	bsr	title
	bsr	termrset
	bra	chat1

chati:	cmpi.l	#$00440000,d0	; f10 quits
	bne	chatj
	bra	chat2

chatj:	bsr	sendkey

chat1:	move.w	#1,-(sp)
	move.w	#1,-(sp)
	trap	#13
	addq.l	#4,sp

	tst.w	d0
	beq	chat3

	move.w	#1,-(sp)
	move.w	#2,-(sp)
	trap	#13
	addq.l	#4,sp

	bsr	chkrslt
	bsr	putchar
	bra	chat0

chat3:	bsr	update
	bra	chat0

chat2:	movem.l	(sp)+,d0-d3/a0-a3
	rts

debug5:	dc.w	0
	even

debug6:	dc.w	0
	even

debug7:	dc.w	0
	even


* sendkey

sendkey:	movem.l	d0-d1/a0,-(sp)

	swap	d0
	lea	extended,a0
	lea	0(a0,d0.w),a0
	tst.b	(a0)
	beq	sendkey8

	tst.w	doorway
	bne	sendkey7		; if doorway send null sequence

	cmpi.w	#59,d0
	blt	sendkey0
	cmpi.w	#62,d0
	bgt	sendkey0
	lea	sdf1234,a0	; for fkeys 1 to 4
	sub.w	#59,d0
	asl.w	#2,d0
	lea	0(a0,d0.w),a0
	movea.l	(a0),a0
	bsr	auxstr
	bra	sendkey9

sendkey0:	cmpi.w	#72,d0
	bne	sendkey1
	lea	sdup,a0		; for cursor up
	bsr	auxstr
	bra	sendkey9

sendkey1:	cmpi.w	#80,d0
	bne	sendkey2
	lea	sddown,a0		; for cursor down
	bsr	auxstr
	bra	sendkey9

sendkey2:	cmpi.w	#77,d0
	bne	sendkey3
	lea	sdright,a0	; for cursor right
	bsr	auxstr
	bra	sendkey9

sendkey3:	cmpi.w	#75,d0
	bne	sendkey4
	lea	sdleft,a0		; for cursor left
	bsr	auxstr
	bra	sendkey9

sendkey4:	cmpi.w	#71,d0
	bne	sendkey5
	lea	sdhome,a0		; for clr home
	bsr	auxstr
	bra	sendkey9

sendkey5:	cmpi.w	#119,d0
	bne	sendkey7
	lea	sdcthome,a0	; for control clr home
	bsr	auxstr
	bra	sendkey9

sendkey7:	move.w	d0,d1		; for most extended keys
	moveq	#0,d0		; for all if in doorway mode
	bsr	auxchar		; assumes d0 was swapped
	move.w	d1,d0
	bsr	auxchar
	bra	sendkey9

sendkey8:	swap	d0		; for normal keys
	bsr	auxchar		; assumes d0 was swapped

sendkey9:	movem.l	(sp)+,d0-d1/a0
	rts

extended:	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1
	dc.b	1,1,1,1,1,0,0,1,1,0,0,1,0,1,0,0
	dc.b	1,0,1,0,1,1,1,1,1,1,1,1,1,1,0,0
	dc.b	0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

sdf1234:	dc.l	sdf1,sdf2,sdf3,sdf4
sdf1:	dc.b	27,"OP",0
	even
sdf2:	dc.b	27,"OQ",0
	even
sdf3:	dc.b	27,"Ow",0
	even
sdf4:	dc.b	27,"Ox",0
	even

sdup:	dc.b	27,"[A",0
	even
sddown:	dc.b	27,"[B",0
	even
sdright:	dc.b	27,"[C",0
	even
sdleft:	dc.b	27,"[D",0
	even
sdhome:	dc.b	27,"[H",0
	even
sdcthome:	dc.b	27,"[L",0
	even


* termrset

termrset:	move.w	#7,uattrib
	clr.l	uattrib+2
	move.w	#-1,oldwrap
	move.w	#-1,olddoor
	move.w	#-1,oldscrl
	move.w	#-1,oldrel
	move.w	#-1,oldban
	move.w	#-1,oldled1
	move.w	#-1,oldled2
	move.w	#-1,oldcaps
	move.w	#-1,oldon
	clr.w	nulled
	clr.w	doorway
	move.w	#1,wordwrap
	clr.w	scrltop
	move.w	#24,scrllen
	clr.w	relative
	clr.w	led1
	clr.w	led2
	clr.w	banana
	bsr	update
	bsr	putclock
	rts


* update

update:	movem.l	d0-d4,-(sp)

	tst.w	online
	beq	updateaa
	bsr	tmud

updateaa:	moveq	#24,d1
	moveq	#0,d3

	move.w	wordwrap,d0
	cmp.w	oldwrap,d0
	beq	update0
	move.w	d0,oldwrap
	tst.w	d0
	beq	updatec
	moveq	#13,d2
	bra	updated
updatec:	moveq	#8,d2
updated:	moveq	#30,d0
	moveq	#87,d4		; W
	bsr	putcsub

update0:	move.w	doorway,d0
	cmp.w	olddoor,d0
	beq	update1
	move.w	d0,olddoor
	tst.w	d0
	beq	updatee
	moveq	#13,d2
	bra	updatef
updatee:	moveq	#8,d2
updatef:	moveq	#31,d0
	moveq	#68,d4		; D
	bsr	putcsub

update1:	cmpi.w	#0,scrltop
	bne	updatea
	cmpi.w	#24,scrllen
	bne	updatea
	moveq	#0,d0
	bra	updateb
updatea:	moveq	#1,d0
updateb:	cmp.w	oldscrl,d0
	beq	update2
	move.w	d0,oldscrl
	tst.w	d0
	beq	updateg
	moveq	#13,d2
	bra	updateh
updateg:	moveq	#8,d2
updateh:	moveq	#32,d0
	moveq	#83,d4		; S
	bsr	putcsub

update2:	move.w	relative,d0
	cmp.w	oldrel,d0
	beq	update3
	move.w	d0,oldrel
	tst.w	d0
	beq	updatei
	moveq	#13,d2
	bra	updatej
updatei:	moveq	#8,d2
updatej:	moveq	#33,d0
	moveq	#82,d4		; R
	bsr	putcsub

update3:	move.w	banana,d0
	cmp.w	oldban,d0
	beq	update4
	move.w	d0,oldban
	tst.w	d0
	beq	updatek
	moveq	#13,d2
	bra	updatel
updatek:	moveq	#8,d2
updatel:	moveq	#34,d0
	moveq	#66,d4		; B
	bsr	putcsub

update4:	move.w	led1,d0
	cmp.w	oldled1,d0
	beq	update5
	move.w	d0,oldled1
	tst.w	d0
	beq	updatem
	moveq	#10,d2
	bra	updaten
updatem:	moveq	#8,d2
updaten:	moveq	#76,d0
	move.w	#254,d4
	bsr	putcsub

update5:	move.w	led2,d0
	cmp.w	oldled2,d0
	beq	update6
	move.w	d0,oldled2
	tst.w	d0
	beq	updateo
	moveq	#10,d2
	bra	updatep
updateo:	moveq	#8,d2
updatep:	moveq	#77,d0
	move.w	#254,d4
	bsr	putcsub

update6:	tst.w	oldon
	bmi	updateab
	tst.w	online
	beq	updateq
	tst.w	oldon
	bne	updateq
	move.w	#1,oldon		; from offline to online
	bsr	tminit
	moveq	#9,d2
	bra	updater
updateq:	tst.w	online
	bne	update7
	tst.w	oldon
	beq	update7
	bsr	termrset		; from online to offline
	clr.w	oldon
	moveq	#8,d2
	bra	updater
updateab:	tst.w	online		; if oldon negative
	bne	updateac
	clr.w	oldon
	moveq	#8,d2
	bra	updater
updateac:	move.w	#1,oldon
	moveq	#9,d2
updater:	moveq	#25,d0
	moveq	#79,d4		; O
	bsr	putcsub
	moveq	#26,d0
	moveq	#78,d4		; N
	bsr	putcsub

update7:	bsr	chkcaps
	move.w	capslock,d0
	cmp.w	oldcaps,d0
	beq	update8
	move.w	d0,oldcaps
	tst.w	d0
	beq	updates
	moveq	#11,d2
	bra	updatet
updates:	moveq	#8,d2
updatet:	moveq	#78,d0
	move.w	#254,d4
	bsr	putcsub

update8:	move.l	$466,d0
	btst	#4,d0
	bne	updateu
	bsr	cursoff
	bra	update9
updateu:	bsr	curson

update9:	movem.l	(sp)+,d0-d4
	rts

oldwrap:	dc.w	-1
olddoor:	dc.w	-1
oldscrl:	dc.w	-1
oldrel:	dc.w	-1
oldban:	dc.w	-1
oldled1:	dc.w	-1
oldled2:	dc.w	-1
oldon:	dc.w	-1
oldcaps:	dc.w	-1


* chkcaps

chkcaps:	movem.l	d0-d3/a0-a3,-(sp)

	move.w	#-1,-(sp)
	move.w	#11,-(sp)
	trap	#13
	addq.l	#4,sp

	btst	#4,d0
	beq	chkcaps0
	move.w	#1,capslock
	bra	chkcaps9
chkcaps0:	move.w	#0,capslock

chkcaps9:	movem.l	(sp)+,d0-d3/a0-a3
	rts


* title

title:	movem.l	d0-d7/a0-a6,-(sp)

	bsr	cursoff

	lea	titlescr,a0
	movea.l	logbase,a1

	move.w	#665,d0
title0:	movem.l	(a0)+,d1-d7/a2-a6
	movem.l	d1-d7/a2-a6,(a1)
	lea	48(a1),a1
	dbra	d0,title0

	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	move.w	#16,urow
	move.w	#0,ucolumn

	movem.l	(sp)+,d0-d7/a0-a6
	rts


* auxstr

auxstr:	movem.l	d0/a0,-(sp)

	moveq	#0,d0

auxstr0:	move.b	(a0)+,d0
	tst.b	d0
	beq	auxstr9
	bsr	auxchar
	bra	auxstr0

auxstr9:	movem.l	(sp)+,d0/a0
	rts


* auxchar

auxchar:	movem.l	d0-d3/a0-a3,-(sp)

	move.w	d0,auxchar1

auxchar0:	move.w	#1,-(sp)
	move.w	#8,-(sp)
	trap	#13
	addq.l	#4,sp

	tst.w	d0
	beq	auxchar0

	move.w	auxchar1,-(sp)
	move.w	#1,-(sp)
	move.w	#3,-(sp)
	trap	#13
	addq.l	#6,sp

	movem.l	(sp)+,d0-d3/a0-a3
	rts

auxchar1:	dc.w	0


* putstr

putstr:	movem.l	d0/a0,-(sp)

	moveq	#0,d0

putstr0:	move.b	(a0)+,d0
	tst.b	d0
	beq	putstr9
	bsr	putchar
	bra	putstr0

putstr9:	movem.l	(sp)+,d0/a0
	rts


* putchar

putchar:	movem.l	d0-d4/a0-a3,-(sp)

	tst.l	cursub
	beq	putchari
	bsr	donum
	movea.l	cursub,a0
	jmp	(a0)

putchari:	tst.w	nulled
	beq	putcharj
	clr.w	nulled
	bra	putchar6

putcharj:	cmpi.w	#27,d0
	bne	putcharz
	move.l	#doansi,cursub
	bra	putchar9

putcharz:	cmpi.w	#7,d0
	bne	putchar0
	bsr	ding
	bra	putchar9

putchar0:	cmpi.w	#8,d0
	bne	putchar1
	bsr	cursoff
	lea	ucolumn,a0
	tst.w	(a0)
	beq	putchar9
	subq.w	#1,(a0)
	bra	putchar9

putchar1:	cmpi.w	#9,d0
	bne	putchar2
	bsr	cursoff
	move.w	ucolumn,d0
	addq.w	#8,d0
	andi.w	#$fff8,d0
	cmpi.w	#72,d0
	ble	putcharb
	moveq	#72,d0
putcharb:	move.w	d0,ucolumn
	bra	putchar9

putchar2:	cmpi.w	#10,d0
	bne	putchar3
	move.w	#1,numbers
	move.w	#1,curnum
	bra	elinefd

putchar3:	cmpi.w	#12,d0
	beq	eclear

putchar4:	cmpi.w	#13,d0
	bne	putchar5
	bsr	cursoff
	clr.w	ucolumn
	bra	putchar9

putchar5:	tst.w	d0
	bne	putchar6
	tst.w	doorway
	beq	putchar6
	move.w	#1,nulled
	bra	putchar9

putchar6:	bsr	cursoff
	move.w	d0,d4
	move.w	ucolumn,d0
	move.w	urow,d1
	move.w	uattrib+4,d2
	asl.w	#3,d2
	add.w	uattrib,d2
	move.w	uattrib+2,d3
	bsr	putcsub

	move.w	ucolumn,d0
	cmpi.w	#79,d0
	beq	putcharc
	addq.w	#1,d0
	move.w	d0,ucolumn
	bra	putchar9

putcharc:	tst.w	wordwrap
	beq	putchar9
	clr.w	ucolumn
	move.w	#1,numbers
	move.w	#1,curnum
	bra	elinefd

putchar9:	movem.l	(sp)+,d0-d4/a0-a3
	rts

cursub:	dc.l	0

numbers:	ds.w	10
curnum:	dc.w	0
numflag:	dc.w	0

nulled:	dc.w	0
doorway:	dc.w	0
wordwrap:	dc.w	1

scrltop:	dc.w	0
scrllen:	dc.w	24
relative:	dc.w	0

led1:	dc.w	0
led2:	dc.w	0
capslock:	dc.w	0

online:	dc.w	0
banana:	dc.w	0


* donum

donum:	movem.l	d0-d1/a0,-(sp)

	cmpi.w	#48,d0
	blt	donum1
	cmpi.w	#57,d0
	bgt	donum1

	move.w	#1,numflag	; if digit identified
	lea	numbers,a0
	move.w	curnum,d1
	asl.w	#1,d1
	lea	0(a0,d1.w),a0
	move.w	(a0),d1
	mulu	#10,d1
	sub.w	#48,d0
	add.w	d0,d1
	move.w	d1,(a0)
	bra	donum9

donum1:	tst.w	numflag		; if terminator identified
	beq	donum9
	clr.w	numflag
	lea	curnum,a0
	addq.w	#1,(a0)

donum9:	movem.l	(sp)+,d0-d1/a0
	rts


* doansi

doansi:	cmpi.w	#91,d0		; [
	bne	doansi0
	move.l	#domulti,cursub
	bra	putchar9
doansi0:	cmpi.w	#68,d0		; D
	beq	escrlup
	cmpi.w	#77,d0		; M
	beq	escrldn
	bra	ansifin


* domulti

domulti:	cmpi.w	#64,d0
	blt	putchar9
	cmpi.w	#127,d0
	bgt	putchar9
	lea	domulti0,a0
	sub.w	#64,d0
	asl.w	#2,d0
	lea	0(a0,d0.w),a0
	movea.l	(a0),a0
	jmp	(a0)

domulti0:	dc.l	einschar,ecursup,ecursdn,ecursrt	;  ABC
	dc.l	ecurslt,elinefd,ansifin,ansifin	; DEFG
	dc.l	emoveto,ansifin,eclrdspl,eclrline	; HIJK
	dc.l	einsline,emusicm,emusicn,ansifin	; LMNO
	dc.l	edelchar,ansifin,ansifin,escrlup	; PQRS
	dc.l	escrldn,eclear,ansifin,ansifin	; TUVW
	dc.l	ansifin,edelline,ebacktab,ansifin	; XYZ 
	dc.l	ansifin,ansifin,ansifin,ansifin	;     
	dc.l	ansifin,ansifin,ebanana,equery	;  abc
	dc.l	ansifin,ansifin,emoveto,ansifin	; defg
	dc.l	esetopt,ansifin,ansifin,ansifin	; hijk
	dc.l	eclropt,esetvid,ereport,ansifin	; lmno
	dc.l	ansifin,elights,eregion,esavcurs	; pqrs
	dc.l	ansifin,erescurs,ansifin,ansifin	; tuvw
	dc.l	ansifin,ansifin,ereset,ansifin	; xyz 
	dc.l	ansifin,ansifin,ansifin,ansifin	;     


einschar:	bra	ansifin

ecursup:	bsr	cursoff		; perfect
	move.w	numbers,d0
	tst.w	d0
	bne	ecursup0
	moveq	#1,d0
ecursup0:	move.w	urow,d1
	sub.w	d0,d1
	tst.w	relative
	bne	ecursup1
	cmpi.w	#0,d1
	bge	ecursup9
	moveq	#0,d1
	bra	ecursup9
ecursup1:	move.w	scrltop,d0
	cmp.w	d0,d1
	bge	ecursup9
	move.w	d0,d1
ecursup9:	move.w	d1,urow
	bra	ansifin

ecursdn:	bsr	cursoff		; perfect
	move.w	numbers,d0
	tst.w	d0
	bne	ecursdn0
	moveq	#1,d0
ecursdn0:	move.w	urow,d1
	add.w	d0,d1
	tst.w	relative
	bne	ecursdn1
	cmpi.w	#23,d1
	ble	ecursdn9
	moveq	#23,d1
	bra	ecursdn9
ecursdn1:	move.w	scrltop,d0
	add.w	scrllen,d0
	subq.w	#1,d0
	cmp.w	d0,d1
	ble	ecursdn9
	move.w	d0,d1
ecursdn9:	move.w	d1,urow
	bra	ansifin

ecursrt:	bsr       cursoff             ; perfect
	move.w	numbers,d0
	tst.w	d0
	bne	ecursrt0
	moveq	#1,d0
ecursrt0:	move.w	ucolumn,d1
	add.w	d0,d1
	cmpi.w	#79,d1
	ble	ecursrt1
	moveq	#79,d1
ecursrt1:	move.w	d1,ucolumn
	bra	ansifin

ecurslt:	bsr	cursoff		; perfect
	move.w	numbers,d0
	tst.w	d0
	bne	ecurslt0
	moveq	#1,d0
ecurslt0:	move.w	ucolumn,d1
	sub.w	d0,d1
	cmpi.w	#0,d1
	bge	ecurslt1
	moveq	#0,d1
ecurslt1:	move.w	d1,ucolumn
	bra	ansifin

elinefd:	bsr       cursoff             ; perfect
	move.w	numbers,d0
	tst.w	d0
	bne	elinefd0
	moveq	#1,d0
elinefd0:	move.w	urow,d1
	add.w	d0,d1
	move.w	scrltop,d2
	add.w	scrllen,d2
	subq.w	#1,d2
	cmp.w	d2,d1
	bgt	elinefd1
	move.w	d1,urow
	bra	elinefd9
elinefd1:	move.w	#23,urow
	sub.w	d2,d1
	move.w	d1,d2
	move.w	scrltop,d0
	add.w	d2,d0
	move.w	scrllen,d1
	sub.w	d2,d1
	bsr	scrollu
	move.w	scrltop,d0
	add.w	scrllen,d0
	subq.w	#1,d2
elinefd2:	subq.w	#1,d0
	bsr	clrline
	dbra	d2,elinefd2
elinefd9:	bra	ansifin

emoveto:	bsr	cursoff		; perfect
	move.w	numbers,d0
	tst.w	d0
	bne	emoveto0
	moveq	#1,d0
emoveto0:	subq.w	#1,d0
	tst.w	relative
	beq	emovetoc
	add.w	scrltop,d0
	move.w	scrltop,d1
	add.w	scrllen,d1
	subq.w	#1,d1
	bra	emovetod
emovetoc:	moveq	#23,d1
emovetod:	cmp.w	d1,d0
	ble	emovetoa
	move.w	d1,d0
emovetoa:	move.w	d0,urow
	move.w	numbers+2,d0
	tst.w	d0
	bne	emoveto1
	moveq	#1,d0
emoveto1:	subq.w	#1,d0
	cmpi.w	#79,d0
	ble	emovetob
	moveq	#79,d0
emovetob:	move.w	d0,ucolumn
	bra	ansifin

eclrdspl:	bsr	cursoff		; perfect
	move.w	numbers,d0
	cmpi.w	#0,d0
	bne	eclrdsp0
	move.w	urow,d0
	move.w	ucolumn,d1
	moveq	#80,d2
	sub.w	d1,d2
	bsr	clrpart
	move.w	scrltop,d1
	add.w	scrllen,d1
	sub.w	d0,d1
	subq.w	#2,d1
	tst.w	d1
	bmi	eclrdsp9
eclrdspa:	addq.w	#1,d0
	bsr	clrline
	dbra	d1,eclrdspa
	bra	eclrdsp9
eclrdsp0:	cmpi.w	#1,d0
	bne	eclrdsp1
	move.w	urow,d0
	moveq	#0,d1
	move.w	ucolumn,d2
	addq.w	#1,d2
	bsr	clrpart
	move.w	d0,d1
	sub.w	scrltop,d1
	subq.w	#1,d1
	tst.w	d1
	bmi	eclrdsp9
eclrdspb:	subq.w	#1,d0
	bsr	clrline
	dbra	d1,eclrdspb
	bra	eclrdsp9
eclrdsp1:	cmpi.w	#2,d0
	bne	eclrdsp9
	move.w	scrltop,d0
	move.w	scrllen,d1
	subq.w	#1,d1
eclrdspc:	bsr	clrline
	addq.w	#1,d0
	dbra	d1,eclrdspc
	clr.w	ucolumn
	move.w	scrltop,urow
eclrdsp9:	bra	ansifin

eclrline:	bsr	cursoff		; perfect
	move.w	numbers,d0
	cmpi.w	#0,d0
	bne	eclrlin0
	move.w	urow,d0
	move.w	ucolumn,d1
	moveq	#80,d2
	sub.w	d1,d2
	bsr	clrpart
	bra	eclrlin9
eclrlin0:	cmpi.w	#1,d0
	bne	eclrlin1
	move.w	urow,d0
	moveq	#0,d1
	move.w	ucolumn,d2
	addq.w	#1,d2
	bsr	clrpart
	bra	eclrlin9
eclrlin1:	cmpi.w	#2,d0
	bne	eclrlin9
	bsr	clrline
eclrlin9:	bra	ansifin

einsline:	bsr	cursoff		; perfect
	move.w	numbers,d0
	tst.w	d0
	bne	einslin0
	moveq	#1,d0
einslin0:	move.w	d0,d2
	move.w	urow,d0
	move.w	scrltop,d1
	add.w	scrllen,d1
	sub.w	d0,d1
	sub.w	d2,d1
	bsr	scrolld
	move.w	uattrib+2,d1
	subq.w	#1,d2
einslin1:	bsr	colline
	addq.w	#1,d0
	dbra	d2,einslin1
	bra	ansifin

emusicm:	tst.w	banana		; crippled
	beq	edelline
	bra	ansifin

emusicn:	bra	ansifin		; crippled

edelchar:	bra	ansifin		; blank

escrlup:	bsr	cursoff		; perfect
	move.w	scrltop,d0
	addq.w	#1,d0
	move.w	scrllen,d1
	subq.w	#1,d1
	moveq	#1,d2
	bsr	scrollu
	move.w	scrltop,d0
	add.w	scrllen,d0
	subq.w	#1,d0
	move.w	uattrib+2,d1
	bsr	colline
	bra	ansifin

escrldn:	bsr	cursoff		; perfect
	move.w	scrltop,d0
	move.w	scrllen,d1
	subq.w	#1,d1
	moveq	#1,d2
	bsr	scrolld
	move.w	scrltop,d0
	move.w	uattrib+2,d1
	bsr	colline
	bra	ansifin

eclear:	bsr	cursoff		; perfect
	bsr	clrscr
	clr.w	ucolumn
	clr.w	urow
	bra	ansifin

edelline:	bsr	cursoff		; perfect
	move.w	numbers,d0
	tst.w	d0
	bne	edellin0
	moveq	#1,d0
edellin0:	move.w	d0,d2
	move.w	urow,d0
	move.w	scrltop,d1
	add.w	scrllen,d1
	sub.w	d0,d1
	sub.w	d2,d1
	add.w	d2,d0
	bsr	scrollu
	move.w	scrltop,d0
	add.w	scrllen,d0
	move.w	uattrib+2,d1
	subq.w	#1,d2
edellin1:	subq.w	#1,d0
	bsr	colline
	dbra	d2,edellin1
	bra	ansifin

ebacktab:	bsr	cursoff		; perfect
	move.w	ucolumn,d0
	subq.w	#1,d0
	andi.w	#$fff8,d0
	cmpi.w	#0,d0
	bge	ebackta0
	moveq	#0,d0
ebackta0:	move.w	d0,ucolumn
	bra	ansifin

ebanana:	move.w	#1,banana		; perfect
	lea	ebanana0,a0
	bsr	auxstr
	bra	ansifin
ebanana0:	dc.b	"002",0

equery:	lea	equery0,a0	; perfect
	bsr	auxstr
	bra	ansifin
equery0:	dc.b	27,"[?1;2c",0

esetopt:	move.w	numbers,d0	; perfect
	cmpi.w	#6,d0
	bne	esetopt0
	move.w	#1,relative
	bra	esetopt9
esetopt0:	cmpi.w	#7,d0
	bne	esetopt1
	move.w	#1,wordwrap
	bra	esetopt9
esetopt1:	cmpi.w	#255,d0
	bne	esetopt9
	move.w	#1,doorway
esetopt9:	bra	ansifin

eclropt:	move.w	numbers,d0	; perfect
	cmpi.w	#6,d0
	bne	eclropt0
	clr.w	relative
	bra	eclropt9
eclropt0:	cmpi.w	#7,d0
	bne	eclropt1
	clr.w	wordwrap
	bra	eclropt9
eclropt1:	cmpi.w	#255,d0
	bne	eclropt9
	clr.w	doorway
eclropt9:	bra	ansifin

esetvid:	lea	numbers,a0	; blink and underline missing
	move.w	curnum,d1
	subq.w	#1,d1
esetvid0:	move.w	(a0)+,d0
	tst.w	d0
	bne	esetvid1
	move.w	#7,uattrib
	clr.l	uattrib+2
	bra	esetvid9
esetvid1:	cmpi.w	#1,d0
	bne	esetvid2
	move.w	#1,uattrib+4
	bra	esetvid9
esetvid2:	cmpi.w	#2,d0
	bne	esetvid3
	clr.w	uattrib+4
	bra	esetvid9
esetvid3:	cmpi.w	#7,d0
	bne	esetvid4
	move.w	uattrib+2,d0
	move.w	uattrib,uattrib+2
	move.w	d0,uattrib
	bra	esetvid9
esetvid4:	cmpi.w	#8,d0
	bne	esetvid5
	move.w	uattrib+2,uattrib
	clr.w	uattrib+4
	bra	esetvid9
esetvid5:	cmpi.w	#30,d0
	blt	esetvid9
	cmpi.w	#37,d0
	bgt	esetvid6
	sub.w	#30,d0
	move.w	d0,uattrib
	bra	esetvid9
esetvid6:	cmpi.w	#40,d0
	blt	esetvid9
	cmpi.w	#47,d0
	bgt	esetvid9
	sub.w	#40,d0
	move.w	d0,uattrib+2
esetvid9:	dbra	d1,esetvid0
	bra	ansifin

ereport:	move.w	numbers,d0	; perfect
	cmpi.w	#6,d0
	bne	ereport8
	lea	ereporta,a0
	move.w	urow,d0
	move.w	d0,d1
	divu	#10,d1
	move.b	d1,2(a0)		; tens
	mulu	#10,d1
	sub.w	d1,d0
	move.b	d0,3(a0)		; units
	move.w	ucolumn,d0
	move.w	d0,d1
	divu	#10,d1
	move.b	d1,5(a0)		; tens
	mulu	#10,d1
	sub.w	d1,d0
	move.b	d0,6(a0)		; units
	add.b	#48,2(a0)
	add.b	#48,3(a0)
	add.b	#48,5(a0)
	add.b	#48,6(a0)
	bsr	auxstr
	bra	ereport9
ereport8:	cmpi.w	#255,d0
	bne	ereport9
	lea	ereportb,a0
	bsr	auxstr
ereport9:	bra	ansifin
ereporta:	dc.b	27,"[00;00R",0
ereportb:	dc.b	27,"[24;80R",0

elights:	move.w	numbers,d0	; perfect
	cmpi.w	#0,d0
	bne	elights0
	clr.w	led1
	clr.w	led2
	bra	elights9
elights0:	cmpi.w	#1,d0
	bne	elights1
	move.w	#1,led1
	bra	elights9
elights1:	cmpi.w	#2,d0
	bne	elights9
	move.w	#1,led2
elights9:	bra	ansifin

eregion:	clr.w	relative		; perfect
	move.w	#1,wordwrap
	move.w	numbers,d0
	move.w	numbers+2,d1
	tst.w	d0
	bne	eregion0
	tst.w	d1
	bne	eregiona
	clr.w	scrltop
	move.w	#24,scrllen
	bra	eregion9
eregiona:	moveq	#1,d0
eregion0:	subq.w	#1,d0
	move.w	d0,scrltop
	tst.w	d1
	bne	eregion1
	moveq	#24,d1
eregion1:	sub.w	d0,d1
	move.w	d1,scrllen
eregion9:	bra	ansifin

esavcurs:	move.w	ucolumn,esavcur0	; perfect
	move.w	urow,esavcur0+2
	bra	ansifin
esavcur0:	dc.w	0,0

erescurs:	move.w	esavcur0,ucolumn	; perfect
	move.w	esavcur0+2,urow
	bra	ansifin

ereset:	bra	ansifin		; blank


* ansifin

ansifin:	clr.l	cursub
	clr.w	numflag
	clr.w	curnum
	clr.l	numbers
	clr.l	numbers+4
	clr.l	numbers+8
	clr.l	numbers+12
	clr.l	numbers+16
	bra	putchar9


* scrollv
* d0.w start, d1.w len, d2.w count

scrollv:	movem.l	d0-d7/a0-a6,-(sp)

	move.l	logbase,a0
	mulu	#1280,d0
	adda.l	d0,a0

	move.l	a0,a1
	muls	#1280,d2
	adda.l	d2,a1

	subq.w	#1,d1
scrollv1:	moveq	#28,d0
scrollv0:	movem.l	(a0)+,d2-d7/a2-a6
	movem.l	d2-d7/a2-a6,(a1)
	lea	44(a1),a1
	dbra	d0,scrollv0
	move.l	(a0)+,(a1)+
	dbra	d1,scrollv1

	movem.l	(sp)+,d0-d7/a0-a6
	rts


* clrline

clrline:	movem.l	d0-d7/a0-a6,-(sp)

	move.l	logbase,a0
	addq.w	#1,d0
	mulu	#1280,d0
	adda.l	d0,a0

	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	movea.l	d1,a1
	movea.l	d1,a2
	movea.l	d1,a3
	movea.l	d1,a4
	movea.l	d1,a5
	movea.l	d1,a6

	moveq	#23,d0
clrline0:	movem.l	d1-d7/a1-a6,-(a0)
	dbra	d0,clrline0

	movem.l	d1-d7/a1,-(a0)

	movem.l	(sp)+,d0-d7/a0-a6
	rts


* colline

colline:	movem.l	d0-d7/a0-a3,-(sp)

	move.l	logbase,a3
	addq.w	#1,d0
	mulu	#1280,d0
	adda.l	d0,a3

	lea	masks,a1
	asl.w	#3,d1
	lea	0(a1,d1.w),a1

	move.l	(a1),d0
	move.l	4(a1),d1		; 16 pixels
	move.l	d0,d2
	move.l	d1,d3		; 32 pixels
	move.l	d0,d4
	move.l	d1,d5		; 48 pixels
	move.l	d0,d6
	move.l	d1,a0		; 64 pixels
	movea.l	d0,a1
	movea.l	d1,a2		; 80 pixels

	moveq	#7,d7
colline0:	movem.l	d0-d6/a0-a2,-(a3)
	movem.l	d0-d6/a0-a2,-(a3)
	movem.l	d0-d6/a0-a2,-(a3)
	movem.l	d0-d6/a0-a2,-(a3)
	dbra	d7,colline0

	movem.l	(sp)+,d0-d7/a0-a3
	rts


* clrscr

clrscr:	movem.l	d0-d7/a0-a6,-(sp)

	move.l	logbase,a0
	lea	30720(a0),a0

	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	movea.l	d1,a1
	movea.l	d1,a2
	movea.l	d1,a3
	movea.l	d1,a4
	movea.l	d1,a5
	movea.l	d1,a6

	move.w	#589,d0
clrscr0:	movem.l	d1-d7/a1-a6,-(a0)
	dbra	d0,clrscr0

	movem.l	d1-d7/a1-a3,-(a0)

	movem.l	(sp)+,d0-d7/a0-a6
	rts


* ding

ding:	movem.l	d0-d3/a0-a3,-(sp)

ding0:	move.w	#1,-(sp)
	move.w	#8,-(sp)
	trap	#13
	addq.l	#4,sp
	tst.w	d0
	beq	ding0

	move.w	#7,-(sp)
	move.w	#1,-(sp)
	move.w	#3,-(sp)
	trap	#13
	addq.l	#6,sp

	movem.l	(sp)+,d0-d3/a0-a3
	rts


* putcsub

putcsub:	movem.l	d0-d7/a0-a3,-(sp)

	move.w	d0,d5
	move.l	logbase,a0
	mulu	#1280,d1
	adda.l	d1,a0
	andi.l	#$0000fffc,d0
	asl.w	#1,d0
	adda.l	d0,a0

	lea	font,a1
	ext.l	d4
	asl.w	#2,d4
	adda.l	d4,a1

	lea	masks,a2
	asl.w	#3,d2
	lea	0(a2,d2.w),a2
	lea	masks,a3
	asl.w	#3,d3
	lea	0(a3,d3.w),a3

	andi.w	#$0003,d5
	addq.w	#1,d5
	asl.w	#2,d5		; Character shift

	move.w	#7,d0
putcsub5:	move.l	(a1),d1
	move.w	d0,d3
	asl.w	#2,d3
	lsr.l	d3,d1
	andi.w	#$000f,d1
	move.w	d1,d2
	eori.w	#$000f,d1
	ori.w	#$fff0,d1
	ori.w	#$fff0,d2
	ror.w	d5,d1
	ror.w	d5,d2
	move.l	(a2),d6
	eor.l	d6,(a0)
	move.l	4(a2),d7
	eor.l	d7,4(a0)
	and.w	d1,(a0)
	and.w	d1,2(a0)
	and.w	d1,4(a0)
	and.w	d1,6(a0)
	eor.l	d6,(a0)
	eor.l	d7,4(a0)
	move.l	(a3),d6
	eor.l	d6,(a0)
	move.l	4(a3),d7
	eor.l	d7,4(a0)
	and.w	d2,(a0)
	and.w	d2,2(a0)
	and.w	d2,4(a0)
	and.w	d2,6(a0)
	eor.l	d6,(a0)
	eor.l	d7,4(a0)
	lea	160(a0),a0
	dbra	d0,putcsub5

	movem.l	(sp)+,d0-d7/a0-a3
	rts

masks:	dc.w	$0000,$0000,$0000,$0000,$ffff,$0000,$0000,$0000
	dc.w	$0000,$ffff,$0000,$0000,$ffff,$ffff,$0000,$0000
	dc.w	$0000,$0000,$ffff,$0000,$ffff,$0000,$ffff,$0000
	dc.w	$0000,$ffff,$ffff,$0000,$ffff,$ffff,$ffff,$0000
	dc.w	$0000,$0000,$0000,$ffff,$ffff,$0000,$0000,$ffff
	dc.w	$0000,$ffff,$0000,$ffff,$ffff,$ffff,$0000,$ffff
	dc.w	$0000,$0000,$ffff,$ffff,$ffff,$0000,$ffff,$ffff
	dc.w	$0000,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff

font:	dc.l	$00000000,$e1b1f1e0,$ef5f1fe0,$0bffee40,$04effe40,$04e4bf40,$04eeff40,$004e4000
	dc.l	$0fb1bf00,$004a4000,$0fb5bf00,$735a4000,$004a4e40,$46444cc0,$65e55df3,$05ebe500
	dc.l	$08cec800,$026e6200,$4e444e40,$aaaaa0a0,$7bb73330,$686ac2c0,$00000ff0,$4e44e4e0
	dc.l	$4e444440,$44444e40,$002f2000,$004f4000,$00888f00,$2f204f40,$004ef000,$00fe4000
	dc.l	$00000000,$44444040,$aa000000,$0afafa00,$46842c40,$a24448a0,$4a87aa40,$44000000
	dc.l	$24444442,$84444448,$0a4e4a00,$044e4400,$00000048,$000e0000,$00000040,$22444880
	dc.l	$4aeeaa40,$4c4444e0,$4a2448e0,$4a242a40,$2266af20,$e8c22a40,$488caa40,$e2244440
	dc.l	$4aa4aa40,$4aa62240,$00400040,$00400048,$02484200,$00e0e000,$08424800,$4a224040
	dc.l	$4aeee860,$4aaaeaa0,$caacaac0,$4a888a40,$caaaaac0,$e88c88e0,$e88c8880,$4a8aaa60
	dc.l	$aaaeaaa0,$e44444e0,$e4444480,$aaacaaa0,$888888e0,$aeeaaaa0,$caaaaaa0,$4aaaaa40
	dc.l	$caac8880,$4aaaaa42,$caacaaa0,$4a842a40,$e4444440,$aaaaaa60,$aaaaaa40,$aaaaeea0
	dc.l	$aaa4aaa0,$aaa44440,$e22488e0,$64444446,$88444220,$c444444c,$4a000000,$0000000f
	dc.l	$42000000,$00426a60,$88caaac0,$004a8a40,$226aaa60,$004ae860,$24e44440,$006aa62c
	dc.l	$88caaaa0,$40c444e0,$40c44448,$88aacaa0,$c44444e0,$00aeaaa0,$00caaaa0,$004aaa40
	dc.l	$00caaac8,$006aaa62,$00ca8880,$006842c0,$04e44420,$00aaaa60,$00aaaa40,$00aaaea0
	dc.l	$00aa4aa0,$00aaa62c,$00e248e0,$24484442,$44444444,$84424448,$004f2000,$a4a4a4a4
	dc.l	$4a888a4c,$0a0aaa60,$2404e860,$4a042e60,$0a042e60,$84042e60,$04042e60,$004a8a4c
	dc.l	$4a04e860,$0a04e860,$8404e860,$0a0c44e0,$4a0c44e0,$840c44e0,$a04aaea0,$404aaea0
	dc.l	$24e8c8e0,$00e5fcf0,$7aabeab0,$4a04aa40,$0a04aa40,$8404aa40,$4a0aaa60,$840aaa60
	dc.l	$0a0aa62c,$a04aaa40,$a0aaaa60,$044a8a44,$4a8c88e0,$aaa44e40,$cabeaa90,$24e44448
	dc.l	$24042ec0,$240c44e0,$2404aa40,$240aaa60,$6c0caaa0,$6ccaaaa0,$426a6000,$4aaa4000
	dc.l	$40488a40,$00f88800,$00f11100,$8a4b1230,$8a495710,$40444440,$005a5000,$00a5a000
	dc.l	$a0a0a0a0,$a5a5a5a5,$f5f5f5f5,$44444444,$444c4444,$44c4c444,$aaaaaaaa,$000eaaaa
	dc.l	$00c4c444,$aaa2aaaa,$aaaaaaaa,$00e2aaaa,$aaa2e000,$aaae0000,$44c4c000,$000c4444
	dc.l	$44470000,$444f0000,$000f4444,$44474444,$000f0000,$444f4444,$44747444,$aaabaaaa
	dc.l	$aab8f000,$00f8baaa,$aab0f000,$00f0baaa,$aab8baaa,$00f0f000,$aab0baaa,$44f0f000
	dc.l	$aaaf0000,$00f0f444,$000faaaa,$aaaf0000,$44747000,$00747444,$000faaaa,$aaafaaaa
	dc.l	$44f4f444,$444c0000,$00074444,$ffffffff,$0000ffff,$cccccccc,$33333333,$ffff0000
	dc.l	$005aaa50,$4aacaac8,$e8888880,$00eaaaa0,$e84248e0,$007aaa40,$00aaaae8,$00e44440
	dc.l	$44aaa440,$4aaeaa40,$4aaaa4a0,$684aaa40,$00ad57a0,$024aaa48,$0068e860,$4aaaaaa0
	dc.l	$0e0e0e00,$44e440e0,$842480e0,$248420e0,$24444444,$44444480,$040e0400,$4f204f20
	dc.l	$4a400000,$4e400000,$00040000,$3222a620,$caaaa000,$c248e000,$00eee000,$f0000000


* tminit

tminit:	movem.l	d0-d4,-(sp)

	move.l	$466,tmbase
	clr.l	tmold

	clr.l	tmud0
	clr.l	tmud0+4
	clr.l	tmud0+8

	bsr	putclock

	movem.l	(sp)+,d0-d4
	rts

tmbase:	dc.l	0
tmold:	dc.l	0


* tmud

tmud:	movem.l	d0-d4/a0,-(sp)

	move.l	$466,d0
	sub.l	tmbase,d0
	divu	#50,d0
	andi.l	#$0000ffff,d0
	cmp.l	tmold,d0
	beq	tmud9
	move.l	d0,tmold
	lea	tmud0,a0

	move.l	d0,d1
	divu	#36000,d1
	move.w	d1,(a0)
	mulu	#36000,d1
	sub.l	d1,d0
	move.l	d0,d1
	divu	#3600,d1
	move.w	d1,2(a0)
	mulu	#3600,d1
	sub.l	d1,d0
	move.l	d0,d1
	divu	#600,d1
	move.w	d1,4(a0)
	mulu	#600,d1
	sub.l	d1,d0
	move.l	d0,d1
	divu	#60,d1
	move.w	d1,6(a0)
	mulu	#60,d1
	sub.l	d1,d0
	move.l	d0,d1
	divu	#10,d1
	move.w	d1,8(a0)
	mulu	#10,d1
	sub.l	d1,d0
	move.w	d0,10(a0)

	bsr	putclock

tmud9:	movem.l	(sp)+,d0-d4/a0
	rts

tmud0:	ds.w	6


* putclock

putclock:	movem.l	d0-d4/a0,-(sp)

	lea	tmud0,a0
	moveq	#24,d1
	moveq	#11,d2
	moveq	#0,d3

	moveq	#3,d0
	move.w	(a0),d4
	add.w	#48,d4
	bsr	putcsub
	moveq	#4,d0
	move.w	2(a0),d4
	add.w	#48,d4
	bsr	putcsub
	moveq	#6,d0
	move.w	4(a0),d4
	add.w	#48,d4
	bsr	putcsub
	moveq	#7,d0
	move.w	6(a0),d4
	add.w	#48,d4
	bsr	putcsub
	moveq	#9,d0
	move.w	8(a0),d4
	add.w	#48,d4
	bsr	putcsub
	moveq	#10,d0
	move.w	10(a0),d4
	add.w	#48,d4
	bsr	putcsub

	movem.l	(sp)+,d0-d4/a0
	rts


* curson

curson:	tst.w	cursflag
	bne	curson9
	bsr	putcurs
	move.w	#1,cursflag
curson9:	rts

cursflag:	dc.w	0


* cursoff

cursoff:	tst.w	cursflag
	beq	cursoff9
	bsr	putcurs
	clr.w	cursflag
cursoff9:	rts


* putcurs

putcurs:	movem.l	d0-d2/a0,-(sp)

	move.w	ucolumn,d0
	move.w	urow,d1

	move.w	d0,d2
	move.l	logbase,a0
	mulu	#1280,d1
	adda.l	d1,a0
	andi.l	#$0000fffc,d0
	asl.w	#1,d0
	adda.l	d0,a0

	andi.w	#$0003,d2
	addq.w	#1,d2
	asl.w	#2,d2		; Character shift
	move.w	#$000f,d1
	ror.w	d2,d1

	move.w	#7,d0
putcurs5:	eor.w	d1,(a0)
	eor.w	d1,2(a0)
	eor.w	d1,4(a0)
	eor.w	d1,6(a0)
	lea	160(a0),a0
	dbra	d0,putcurs5

	movem.l	(sp)+,d0-d2/a0
	rts


	.bss

titlescr:	ds.b	32000
