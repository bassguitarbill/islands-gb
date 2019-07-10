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

    ld d, $13
    ld hl, $9800
    ld bc, $9BFF - $9800
    call FillWithDataLengthBC

    ld hl, MAP
    ld de, $9800
    ld b, $07 ; ROWS

.newRow
    ld c, $07 ; COLUMNS
    
.inARow
    ld a, [hl]
    and %11110000
    swap a
    ld [de], a
    inc de
    dec c
    jr z, .putRightBorder

    ld a, [hl]
    and %00001111
    ld [de], a
    inc de
    dec c
    jr z, .putRightBorder
    inc hl
    jr .inARow
.putRightBorder
    ld a, $11
    ld [de], a
    ld a, $13
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    dec b
    inc hl
    jr nz, .newRow

.finalRow
    ld c, $08
    ld a, $10
    ld [de], a
    inc de
    ld [de], a
    inc de
    ld [de], a
    inc de
    ld [de], a
    inc de
    ld [de], a
    inc de
    ld [de], a
    inc de
    ld [de], a
    inc de
    add 2
    ld [de], a
    

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
	ld a, %10010011
	ld [rLCDC], a

    ld a, %00000001
    ld [$FFFF], a

.lockup
    ei
    halt
	jr .lockup

CopyDataLengthBC:
	ld a,[hli]
	ld [de],a
	inc de
	dec bc
	ld a,c
	or b
	jr nz,CopyDataLengthBC
	ret

FillWithDataLengthBC:
    ld [hl], d
    inc hl
    dec bc
    ld a, c
    or b
    jr nz, FillWithDataLengthBC
    ret

VBlankHandler:
    call Draw
    call Update
    reti

Draw:
    ret

Update:
    ld a, $69
    ldh [$FF80], a
    ld a, $3F
    ld [$FE00], a
    ld a, $2F
    ld [$FE01], a
    ld a, $14
    ld [$FE02], a
    xor a
    ld [$FE03], a

    ld a, $42
    ld [$FE04], a
    ld a, $2F
    ld [$FE05], a
    ld a, $14
    ld [$FE06], a
    ld a, %01000000 
    ld [$FE07], a

    ld a, $3F
    ld [$FE08], a
    ld a, $32
    ld [$FE09], a
    ld a, $14
    ld [$FE0A], a
    ld a, %00100000 
    ld [$FE0B], a

    ld a, $42
    ld [$FE0C], a
    ld a, $32
    ld [$FE0D], a
    ld a, $14
    ld [$FE0E], a
    ld a, %01100000 
    ld [$FE0F], a
    ret

Section "Tiles", ROM0[$700]
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

TILE_BOTTOM_EDGE:
    DB %11111111 
    DB %00000000

    DB %00000000
    DB %00000000

    DB %00000000
    DB %00000000

    DB %00000000
    DB %00000000

    DB %00000000
    DB %00000000

    DB %00000000
    DB %00000000

    DB %00000000
    DB %00000000

    DB %00000000
    DB %00000000

TILE_RIGHT_EDGE:
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

    DB %10000000
    DB %00000000

TILE_LAST_CORNER:
    DB %10000000
    DB %00000000

    DB %00000000
    DB %00000000

    DB %00000000
    DB %00000000

    DB %00000000
    DB %00000000

    DB %00000000
    DB %00000000

    DB %00000000
    DB %00000000

    DB %00000000
    DB %00000000

    DB %00000000
    DB %00000000

EMPTY_TILE:
    DB $00, $00, $00, $00, $00, $00, $00, $00
    DB $00, $00, $00, $00, $00, $00, $00, $00

CORNER:
    DB %11111000
    DB %11111000

    DB %11111000
    DB %10001000

    DB %11111000
    DB %10111000

    DB %11100000
    DB %10100000

    DB %11100000
    DB %11100000

    DB %00000000
    DB %00000000

    DB %00000000
    DB %00000000

    DB %00000000
    DB %00000000

TILE_END:

MAP:
    DB $00, $00, $00, $F0
    DB $00, $60, $0F, $E0
    DB $00, $00, $EF, $E0
    DB $00, $0F, $4F, $30
    DB $00, $F2, $F2, $F0
    DB $00, $FE, $FE, $F0
    DB $0F, $FF, $FF, $F0

MAP_END:
