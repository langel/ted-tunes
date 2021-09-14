	processor 6502

	org $1000

; 10 SYS 4109
	byte	$00,$0b,$10,$04,$00,$9e,$34,$31
	byte  $31,$30,$00,$00,$00,$00

; disable interupts
	sei
; no decimal mode
	cld

; variables
raster_pos	EQU $82
frame_count EQU $84
base_color	EQU $86
COLOR_BG		EQU $ff15
COLOR_FRAME	EQU $ff19
RASTER_X		EQU $ff1d

	lda #$00
	sta raster_pos
	sta frame_count
	sta base_color
	tax

main_loop:
	inc raster_pos
	inc raster_pos
	lda raster_pos
	cmp #$f0
	bne raster_loop
	lda #$00
	sta raster_pos
	inc frame_count
	lda frame_count
	cmp #$04
	bne skip_counts
	lda #$00
	sta frame_count
	inc base_color
	lda base_color
	cmp #$60
	bne skip_counts
	lda #$00
	sta base_color
skip_counts:
	lda raster_pos
	ldx base_color
raster_loop:
	cmp RASTER_X
	bne raster_loop
	lda color_table,x
	sta COLOR_FRAME
	sta COLOR_BG
	inx
	cpx #$60
	bcc skip_x_check
	ldx #$00
skip_x_check:
	jmp main_loop


	.org $1200

color_table:
	byte	$06, $16, $26, $36, $46, $56, $66, $76
	byte	$0d, $1d, $2d, $3d, $4d, $5d, $6d, $7d
	byte	$03, $13, $23, $33, $43, $53, $63, $73
	byte	$0c, $1c, $2c, $3c, $4c, $5c, $6c, $7c
	byte	$05, $15, $25, $35, $45, $55, $65, $75
	byte	$0f, $1f, $2f, $3f, $4f, $5f, $6f, $7f
	byte	$0a, $1a, $2a, $3a, $4a, $5a, $6a, $7a
	byte	$07, $17, $27, $37, $47, $57, $67, $77
	byte	$09, $19, $29, $39, $49, $59, $69, $79
	byte	$08, $18, $28, $38, $48, $58, $68, $78
	byte	$02, $12, $22, $32, $42, $52, $62, $72
	byte	$0b, $1b, $2b, $3b, $4b, $5b, $6b, $7b
	byte	$04, $14, $24, $34, $44, $54, $64, $74
	byte	$0e, $1e, $2e, $3e, $4e, $5e, $6e, $7e
	byte	$01, $11, $21, $31, $41, $51, $61, $71
	byte	$00, $10, $20, $30, $40, $50, $60, $70

	byte	$06, $0d, $03, $0c, $06, $0f, $0a, $07
	byte	$09, $08, $02, $0b, $04, $0e, $01, $00
