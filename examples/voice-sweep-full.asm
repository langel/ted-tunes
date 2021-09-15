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
bank        EQU $81
vol_vox     EQU $ff11
vox1_lo     EQU $ff0e 
vox1_hi     EQU $ff12
vox2_lo     EQU $ff0f
vox2_hi     EQU $ff10
raster_x    EQU $ff1d


; program start
	jsr reset_audio
	jsr wait_for_raster
main_loop:
; turn on voice 1 sqaure
	lda #$17
	sta vol_vox
	lda #$00
square_loop:
	jsr wait_for_raster
	inc pitch
	lda pitch
	sta vox1_lo
	cmp #$00
	bne square_loop
	inc bank
	lda bank
	cmp #$04
	beq square_done
	ora #$04
	sta vox1_hi
	jmp square_loop
square_done:
	jsr reset_audio
; turn on voice 2 noise
	lda #$4f
	sta vol_vox
	lda #$00
noise_loop:
	sta vox2_lo
	jsr wait_for_raster
	inc pitch
	lda pitch
	sta vox2_lo
	cmp #$00
	bne noise_loop
	inc bank
	lda bank
	cmp #$04
	beq noise_done
	sta vox2_hi
	jmp noise_loop
noise_done:
	jsr reset_audio
; start it over
	jmp main_loop


reset_audio:
	lda #$00
	sta pitch
	sta bank
	sta vox1_lo
	sta vox2_lo
	sta vox2_hi
	lda #$04
	sta vox1_hi
	rts


wait_for_raster:
	lda #$22
	sta $ff15
	lda raster_x
	cmp #$80
	bne wait_for_raster
	lda #$00
	sta $ff15
	rts
