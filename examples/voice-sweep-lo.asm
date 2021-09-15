	processor 6502

	org $1000

; 10 SYS 4109
	byte $00,$0b,$10,$04,$00,$9e,$34,$31
	byte $31,$30,$00,$00,$00,$00

; disable interupts
	sei
; no decimal mode
	cld

; variables
pitch       EQU $80
vol_vox     EQU $ff11
vox1_lo     EQU $ff0e 
vox1_hi     EQU $ff12
vox2_lo     EQU $ff0f
vox2_hi     EQU $ff10
raster_x    EQU $ff1d


	lda #$02
;	sta vox1_hi
main_loop:
; setup voice 1 square
	lda #$17
	sta vol_vox
	ldx #$00
square_loop:
	stx vox1_lo
	jsr wait_for_raster
	inx
	cpx #$00
	bne square_loop
; setup voice 2 noise
	lda #$4f
	sta vol_vox
	ldx #$00
noise_loop:
	stx vox2_lo
	jsr wait_for_raster
	inx
	cpx #$00
	bne noise_loop
	jmp main_loop


wait_for_raster:
	lda #$22
	sta $ff15
	lda raster_x
	cmp #$80
	bne wait_for_raster
	lda #$00
	sta $ff15
	rts
