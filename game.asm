INCLUDE "hardware.inc"

SECTION "vblank",ROM0[$40]
    jp VBlankHandler

SECTION "Header", ROM0[$100]

EntryPoint:
;	di ; disable interrupts
	jp Start ; This area is too smol

REPT $150 - $104
	db 0
ENDR

Section "Game code", ROM0[$0400]

Start:
.waitVBlank
	ld a, [rLY]
	cp 144 ; is the LCD past VBlank?
	jr c, .waitVBlank

	xor a ; reset bit 7 (and all other bits) or LCDC
	ld [rLCDC], a
	; okay we're in VBlank, let's get to work

	ld hl, TILE_BLANK
    ld bc, TILE_END - TILE_BLANK
    ld de, $8000
    call CopyDataLengthBC

	; init display registers
	ld a, %11100100
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a

	xor a
	ld [rSCY], a
	ld [rSCX], a

	; shut sound down
	ld [rNR52], a

	; turn screen on, show BG
	ld a, %10000011
	ld [rLCDC], a

    ld a, %00000001
    ld [$FFFF], a

    ld a, $50 ; Middle of the screen or so
    ld [$FF83], a

.lockup
    ei
    halt
	jr .lockup

VBlankHandler:
    call Draw
    call Update
    reti

CopyDataLengthBC:
	ld a,[hli]
	ld [de],a
	inc de
	dec bc
	ld a,c
	or b
	jr nz,CopyDataLengthBC
	ret

Draw:
    ret

Update:
    ret

Section "Tiles", ROM0
TILE_BLANK:
    DB %11111111 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10000000 
    DB %00000000
     
TILE_ONE:
    DB %11111111 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10001000 
    DB %00001000

    DB %10001000 
    DB %00001000

    DB %10001000 
    DB %00001000

    DB %10001000 
    DB %00001000

    DB %10001000 
    DB %00001000

    DB %10000000 
    DB %00000000

TILE_TWO:
    DB %11111111 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10011100 
    DB %00011100

    DB %10110010 
    DB %00110010

    DB %10000110 
    DB %00000110

    DB %10011000 
    DB %00011000

    DB %10111110 
    DB %00111110

    DB %10000000 
    DB %00000000

TILE_THREE:
    DB %11111111 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10011100 
    DB %00011100

    DB %10110110 
    DB %00110110

    DB %10001100 
    DB %00001100

    DB %10110110 
    DB %00110110

    DB %10011100 
    DB %00011100

    DB %10000000 
    DB %00000000

TILE_FOUR:
    DB %11111111 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10001100 
    DB %00001100

    DB %10010100 
    DB %00010100

    DB %10100100 
    DB %00100100

    DB %10111110 
    DB %00111110

    DB %10000100 
    DB %00000100

    DB %10000000 
    DB %00000000

TILE_FIVE:
    DB %11111111 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10111110 
    DB %00111110

    DB %10100000 
    DB %00100000

    DB %10111110 
    DB %00111110

    DB %10000010 
    DB %00000010

    DB %10111100 
    DB %00111100

    DB %10000000 
    DB %00000000

TILE_SIX:
    DB %11111111 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10011100 
    DB %00011100

    DB %10100000 
    DB %00100000

    DB %10111100 
    DB %00111100

    DB %10100010 
    DB %00100010

    DB %10011100 
    DB %00011100

    DB %10000000 
    DB %00000000

TILE_SEVEN:
    DB %11111111 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10111110 
    DB %00111110

    DB %10000100 
    DB %00000100

    DB %10001000 
    DB %00001000

    DB %10001000 
    DB %00001000

    DB %10001000 
    DB %00001000

    DB %10000000 
    DB %00000000

TILE_EIGHT:
    DB %11111111 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10011100 
    DB %00011100

    DB %10100010 
    DB %00100010

    DB %10011100 
    DB %00011100

    DB %10100010 
    DB %00100010

    DB %10011100 
    DB %00011100

    DB %10000000 
    DB %00000000

TILE_NINE:
    DB %11111111 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10011100 
    DB %00011100

    DB %10100010 
    DB %00100010

    DB %10011110 
    DB %00011110

    DB %10000010 
    DB %00000010

    DB %10011100 
    DB %00011100

    DB %10000000 
    DB %00000000

TILE_TEN:
    DB %11111111 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10100100 
    DB %00100100

    DB %10101010 
    DB %00101010

    DB %10101010 
    DB %00101010

    DB %10101010 
    DB %00101010

    DB %10100100 
    DB %00100100

    DB %10000000 
    DB %00000000

TILE_ELEVEN:
    DB %11111111 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10100010 
    DB %00100010

    DB %10100010 
    DB %00100010

    DB %10100010 
    DB %00100010

    DB %10100010 
    DB %00100010

    DB %10100010 
    DB %00100010

    DB %10000000 
    DB %00000000

TILE_TWELVE:
    DB %11111111 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10100100 
    DB %00100100

    DB %10101010 
    DB %00101010

    DB %10100010 
    DB %00100010

    DB %10100100 
    DB %00100100

    DB %10101110 
    DB %00101110

    DB %10000000 
    DB %00000000

TILE_THIRTEEN:
    DB %11111111 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10101110 
    DB %00101110

    DB %10100010 
    DB %00100010

    DB %10101110 
    DB %00101110

    DB %10100010 
    DB %00100010

    DB %10101110 
    DB %00101110

    DB %10000000 
    DB %00000000

TILE_DOT:
    DB %11111111 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10000000 
    DB %00000000

    DB %10001000 
    DB %00001000

    DB %10011100 
    DB %00011100

    DB %10001000 
    DB %00001000

    DB %10000000 
    DB %00000000

    DB %10000000 
    DB %00000000

TILE_FILLED:
    DB %11111111 
    DB %00000000

    DB %11111111 
    DB %01111111

    DB %11111111 
    DB %01111111

    DB %11111111 
    DB %01111111

    DB %11111111 
    DB %01111111

    DB %11111111 
    DB %01111111

    DB %11111111 
    DB %01111111

    DB %11111111 
    DB %01111111

TILE_END:
