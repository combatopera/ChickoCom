

      ####   ##  ##  ##   ####   ##  ##   ####    ####    ####   #########
     ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
     ##      ######  ##  ##      #####   ##  ##  ##      ##  ##  ##  ##  ##
     ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
      ####   ##  ##  ##   ####   ##  ##   ####    ####    ####   ##  ##  ##

     Banana ANSI terminal by Andrzej Cichocki, version 0.3


	READ FIRST
	""""""""""

		The ChickoCom archive contains the following files:

		AUTO\DRVIN.PRG	HSMODEM (this must run first).
		AUTO\MFP.PRG	HSMODEM (ST/STE only).
		CHICKOCO.PRG	ChickoCom!
		STATLINE.PI1	status line picture.
		README.TXT	this is what you're reading now.

		HSMODEM is a particularly slick serial patch written  by
	Harun Scheutzow, which you need if you want to  go  faster  than
	9600 bps. Mega ST/STE, Falcon and TT users should  download  the
	HSMODEM  archive  for  themselves  and   customise   their   own
	configuration.

		Banana ANSI is a standard created by Paul Wheaton  which
	combines ANSI,  VT100,  pseudo-ANSI  and  pseudo-VT100  into  an
	emulation which most modem services expect and use. To find  out
	more, download BANSI002.ZIP from Ooh! BBS.

		ChickoCom is freeware meaning you may distribute it  far
	and wide as long as the archive remains intact and no files  are
	altered or go  missing  in  any  way.  The  files  CHICKOCO.PRG,
	STATLINE.PI1 and README.TXT are copyright Andrzej Cichocki 1997.
	DRVIN.PRG and MFP.PRG belong  to  Harun  Scheutzow.  The  latest
	version of ChickoCom will always be on 42BBS.


	CHICKOCOM
	"""""""""

		This  simple  little  terminal  is   both   faster   and
	emulates ANSI more accurately than AnsiTerm v1.90 by TWS. At the
	moment, I am still working on it meaning a few escape  sequences
	are unsupported (only two!) and there  are  no  file  transfers.
	However, it has enough features for you  to  play  online  games
	without problems, which is the task I programmed it for.

		ChickoCom should work on any ST, but I am only  able  to
	test it with my 1040 STE, TOS 1.62. I have no  idea  whether  it
	will work on the Falcon or not, but if anyone wants to have a go
	then let me know what happens.

		Make sure STATLINE.PI1  is  in  the  same  directory  as
	CHICKOCO.PRG, and that  HSMODEM  has  installed.  Remember  that
	DRVIN.PRG must run before any others. Then just double click  on
	CHICKOCO.PRG.

		The terminal itself  is  entirely  keyboard  based,  and
	you're expected to type in modem commands  yourself  -  this  is
	much easier than it sounds. Use the commands below  followed  by
	Return to do stuff.

		ATZ		resets your modem - do this first.

		ATDT <number>	tone dials  the  specified  BBS  number.
				A result code  of  CONNECT  <baud  rate>
				indicates a  successful  connection,  NO
				CARRIER means it was unsuccessful.

		ATDT #43#	turns BT Call Waiting off - if left  on,
				connections may be  disrupted.  Press  a
				key  to  hang  up  after  you  hear  the
				message.

		ATDT *43#	turns BT Call Waiting on.

		ATDL		redials the previous number.

		ATL <volume>	controls speaker volume. 0 is  quietest,
				3 is loudest. The default is 2.

		ATM <flag>	0 turns the modem's speaker off, 1 turns
				it on.

		These commands and more  can  be  found  in  your  modem
	manual. To simply dial a BBS, use ATZ to  reset  the  modem  and
	then use ATDT followed by the number of the BBS to dial it up.

		These keys do stuff within ChickoCom itself.

		F8		hangs up. Please use respectfully.

		F9		resets the terminal to the state it  was
				in when first loaded. Use this when  you
				finish a call.

		F10		quits ChickoCom. Make  sure  you're  off
				line first.

		Note that F9 will not hang up if a call is in progress.


	HISTORY
	"""""""

	Version and date	Comments

	0.1	08/07/97	First freeware release  of  ChickoCom  -
				also my first ever software  release  of
				all  time!  This  version  was  slightly
				crippled and I didn't  acknowledge  some
				people I should have done.

	0.2	12/07/97	More escape sequences supported,  cursor
				keys et cetera work. A minor bug causing
				the  status  line  to  be   occasionally
				overwritten is  fixed.  The  online  and
				caps lock lights now work, as  does  the
				timer. No need to reset after each call.
				Proper acknowledgement in documentation.

	0.3	15/07/97	Cursor added, timer improved, minor  bug
				with the online  light  fixed.  Lots  of
				escape  sequences  added,  only   insert
				character and delete  character  to  go.
				Dodgy code made less dodgy. Hang  option
				added. Logo improved :-).


	CONTACTS
	""""""""

		If anyone has any bug  reports  or  suggestions,  please
	email me or leave a message for Andrzej  Cichocki  on  42BBS  or
	Ooh! BBS. Or alternatively, just let me  know  you're  using  my
	program!

		Play online games on Ooh! BBS  with  ChickoCom.  Planets
	and Lord II are particularly good and I can be reached in either
	of these games as Gruntbuggly.

	Email		chick@ooh.dircon.co.uk

	42BBS		01256 895 106
	Ooh! BBS	0181 395 3108


	-- Andrzej
