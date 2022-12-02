;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.1.6 #12539 (MINGW32)
;--------------------------------------------------------
	.module main
	.optsdcc -mgbz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _set_sprite_data
	.globl _wait_vbl_done
	.globl _joypad
	.globl _player
	.globl _fireball
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;main.c:17: void main(){
;	---------------------------------
; Function main
; ---------------------------------
_main::
	dec	sp
;main.c:19: NR52_REG = 0x80; //turn on the sound
	ld	a, #0x80
	ldh	(_NR52_REG + 0), a
;main.c:20: NR50_REG = 0x77; // Sets volume level to the max (0x77) for both Left and Right
	ld	a, #0x77
	ldh	(_NR50_REG + 0), a
;main.c:21: NR51_REG = 0xFF; // select all sound channels, one bit for left, one bit for right
	ld	a, #0xff
	ldh	(_NR51_REG + 0), a
;main.c:26: uint8_t y = 76; // Our beginning y coord
;main.c:27: uint8_t z = 55;
	ld	bc, #0x374c
;main.c:29: uint8_t w = 75;
	ldhl	sp,	#0
	ld	(hl), #0x4b
;main.c:32: SPRITES_8x8;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfb
	ldh	(_LCDC_REG + 0), a
;main.c:33: set_sprite_data(1, 1, fireball);
	ld	de, #_fireball
	push	de
	ld	hl, #0x101
	push	hl
	call	_set_sprite_data
	add	sp, #4
;C:/gbdk/include/gb/gb.h:1447: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 6)
	ld	(hl), #0x01
;main.c:41: set_sprite_data(0, 1, player);
	ld	de, #_player
	push	de
	xor	a, a
	inc	a
	push	af
	call	_set_sprite_data
	add	sp, #4
;C:/gbdk/include/gb/gb.h:1447: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 2)
	ld	(hl), #0x00
;C:/gbdk/include/gb/gb.h:1520: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
;C:/gbdk/include/gb/gb.h:1521: itm->y=y, itm->x=x;
	ld	a, #0x4c
	ld	(hl+), a
	ld	(hl), #0x37
;main.c:48: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;main.c:50: while(1){
00126$:
;main.c:51: joydata = joypad(); // Read once per frame and cache the result
	call	_joypad
;main.c:65: if (joydata & J_UP)  // If UP is pressed
	bit	2, e
	jr	Z, 00107$
;main.c:67: if (y == 18){
	ld	a, c
	sub	a, #0x12
	jr	Z, 00107$
;main.c:70: if (y > 18)
	ld	a, #0x12
	sub	a, c
	jr	NC, 00107$
;main.c:72: y = y - 2;
	dec	c
	dec	c
;C:/gbdk/include/gb/gb.h:1520: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
;C:/gbdk/include/gb/gb.h:1521: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), #0x37
;main.c:73: move_sprite(0,x,y); // move sprite 0 to x and y coords
00107$:
;main.c:77: if (joydata & J_DOWN)  // If DOWN is pressed
	bit	3, e
	jr	Z, 00114$
;main.c:79: if (y == 150){
;main.c:82: if ( y < 150)
	ld	a,c
	cp	a,#0x96
	jr	Z, 00114$
	sub	a, #0x96
	jr	NC, 00114$
;main.c:84: y = y + 2;
	inc	c
	inc	c
;C:/gbdk/include/gb/gb.h:1520: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
;C:/gbdk/include/gb/gb.h:1521: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), #0x37
;main.c:85: move_sprite(0,x,y); // move sprite 0 to x and y coords
00114$:
;main.c:89: if (joydata & J_B && z == x)  // If gun has not been fired and B is pressed, then draw bullet
	bit	5, e
	jr	Z, 00118$
	ld	a, b
	sub	a, #0x37
	jr	NZ, 00118$
;main.c:100: NR10_REG = 0x1F; 
	ld	a, #0x1f
	ldh	(_NR10_REG + 0), a
;main.c:107: NR11_REG = 0x10;
	ld	a, #0x10
	ldh	(_NR11_REG + 0), a
;main.c:116: NR12_REG = 0xF7;  
	ld	a, #0xf7
	ldh	(_NR12_REG + 0), a
;main.c:121: NR13_REG = 0x00;   
	xor	a, a
	ldh	(_NR13_REG + 0), a
;main.c:130: NR14_REG = 0xF7;
	ld	a, #0xf7
	ldh	(_NR14_REG + 0), a
;main.c:132: z = z + 5;
	ld	a, b
	add	a, #0x05
	ld	b, a
;main.c:133: w = y;
	ldhl	sp,	#0
	ld	(hl), c
;main.c:134: if (z < 170){
	ld	a, b
	sub	a, #0xaa
	jr	NC, 00118$
;C:/gbdk/include/gb/gb.h:1520: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 4)
;C:/gbdk/include/gb/gb.h:1521: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;main.c:135: move_sprite(1,z,w);
00118$:
;main.c:139: if (z > x && z < 170)  // If gun has been fired and is within the screen limit
	ld	a, #0x37
	sub	a, b
	jr	NC, 00123$
;main.c:141: z = z + 5;
	ld	a,b
	cp	a,#0xaa
	jr	NC, 00123$
	add	a, #0x05
	ld	b, a
;C:/gbdk/include/gb/gb.h:1520: OAM_item_t * itm = &shadow_OAM[nb];
	ld	de, #_shadow_OAM+4
;C:/gbdk/include/gb/gb.h:1521: itm->y=y, itm->x=x;
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(de), a
	inc	de
	ld	a, b
	ld	(de), a
;main.c:143: if (z == 170){
	ld	a, b
	sub	a, #0xaa
	jr	NZ, 00123$
;main.c:144: z=x;
	ld	b, #0x37
00123$:
;main.c:147: wait_vbl_done();
	call	_wait_vbl_done
	jp	00126$
;main.c:149: } 
	inc	sp
	ret
_fireball:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x1e	; 30
	.db #0x1e	; 30
	.db #0x07	; 7
	.db #0x2b	; 43
	.db #0x0d	; 13
	.db #0x2d	; 45
	.db #0x0b	; 11
	.db #0x1e	; 30
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x1e	; 30
	.db #0x00	; 0
	.db #0x00	; 0
_player:
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x0f	; 15
	.db #0x17	; 23
	.db #0x0c	; 12
	.db #0x14	; 20
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x18	; 24
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
