main:
_mainloop:
			xor		r0, r0, r0
			add		r0, r0, &HELLO_WORLD
			c		&txstr
			b		&_mainloop


txstr:
			llr		r27
			add		r28,	r0,		0
_txloop:
			l		r0,		r28
			cmp		r0,		r0,		0
			beq		&_txdone
			c		&txbyte
			add		r28,	r28,	1
			b		&_txloop
_txdone:
			slr		r27
			r

txbyte:
			llr		r31
			c		&txwait
			l		r30, 	&STX_DATA
			s		r0, 	r30
			slr		r31
			r

txwait:
			l		r30,	&STX_STATUS
_txspin:
			l		r29,	r30
			cmp		r29,	r29,	0x00000001
			beq 	&_txspin
			r

STX_STATUS:			.dw 0x80000000
STX_DATA:			.dw 0x80000001
HELLO_WORLD:		.dw 0x00000048
					.dw 0x00000065
					.dw 0x0000006c
					.dw 0x0000006c
					.dw 0x0000006f
					.dw 0x0000002c
					.dw 0x00000020
					.dw 0x00000057
					.dw 0x0000006f
					.dw 0x00000072
					.dw 0x0000006c
					.dw 0x00000064
					.dw 0x00000021
					.dw 0x00000000