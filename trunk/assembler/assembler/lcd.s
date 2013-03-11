_start:			l r3, &LCD_CTRL
			l r0, r3
			l r1, r4
			s r1, r3
			s r0, r3
			

_lcd_reset_cmd_l:	.dw 0b0001
_lcd_reset_cmd_h:	.dw 0b0000

_lcd_on_cmd_l:		.dw 0b1100
_lcd_on_cmd_h:		.dw 0b0000

_lcd_init_cmd_l:	.dw 0b1000
_lcd_init_cmd_h:	.dw 0b0011

LCD_CTRL:		.dw 0x80000000
LCD_DATA:		.dw 0x80000001