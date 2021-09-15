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
ted_vox1_lo EQU $0e
ted_vox1_hi EQU $12
ted_vox2_lo EQU $0f
ted_vox2_hi EQU $10
ted_vol     EQU $11
ted_sq1_en  EQU $1a
ted_sq2_en  EQU $1b
ted_nse_en  EQU $1c
ted_vox_upd EQU $1d

hat_c       EQU $e0
frame_c     EQU $f0

; ted addresses
vol_vox     EQU $ff11
vox1_lo     EQU $ff0e 
vox1_hi     EQU $ff12
vox2_lo     EQU $ff0f
vox2_hi     EQU $ff10
raster_x    EQU $ff1d


; program start
	jsr petscii_ref
	lda #$00
	sta hat_c
	sta frame_c
	jsr audio_reset
	lda #$0f
	sta vol_vox
	sta vox1_lo
main_loop:
	inc frame_c
	lda frame_c
	sta $0f00
; display ted data
	lda vol_vox
	sta $0e80
	lda vox1_hi
	sta $0e82
	lda vox1_lo
	sta $0e84
	jsr hat_check
	jsr audio_update
	jsr wait_for_raster
	jmp main_loop


hat_check:
	lda hat_c
	sta $0f02
	cmp #$00
	beq hat_silent
; turn on voice 2 noise
	jsr noise_enable
; set hat pitch
	lda #$fe
	sta ted_vox2_lo
	lda #$03
	sta ted_vox2_hi
	lda #$07
	jsr vol_set
	dec hat_c
	jmp hat_done
hat_silent:
	jsr noise_disable
	lda frame_c
	and #$08
	cmp #$08
	bne hat_done
	lda #$03
	sta hat_c
hat_done:
	rts


audio_update:
; volume and voice select
	lda ted_vox_upd
	sta $0e00
	cmp #$00
	beq .skip_vox_update
	lda ted_vol
;	ora ted_sq1_en
;	ora ted_sq2_en
	ora ted_nse_en
;	ora #%10000000
	sta $0e10
	sta vol_vox
	lda #$00
	sta ted_vox_upd
.skip_vox_update
; voice 1 low
	lda ted_vox1_lo
	sta $0e12
	sta vox1_lo
; voice 1 high
	lda ted_vox1_hi
	sta $0e14
	ora #$04
	sta vox1_hi
; voice 2 low
	lda ted_vox2_lo
	sta $0e16
	sta vox2_lo
; voice 2 high
	lda ted_vox2_hi
	sta $0e18
	sta vox2_hi
	rts

audio_reset:
	lda #$00
	sta vol_vox
	sta ted_vol
	sta vox1_lo
	sta vox2_lo
	sta vox2_hi
	sta ted_vox1_lo
	sta ted_vox2_lo
	sta ted_vox2_hi
	sta ted_vox_upd
	lda #$04
	sta vox1_hi
	sta ted_vox1_hi
	rts

noise_disable:
	lda ted_nse_en
	cmp #$00
	beq .skip_disable
	lda #$00
	sta ted_nse_en
	lda #$ff
	sta ted_vox_upd
.skip_disable
	rts

noise_enable:
	lda ted_nse_en
	cmp #$40
	beq .skip_enable
	lda #$00
	sta ted_sq2_en
	lda #$40
	sta ted_nse_en
	lda #$ff
	sta ted_vox_upd
.skip_enable
	rts

vol_set:
; put it in the accumulator! :D
	and #%00000111
	sta ted_vol
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

petscii_ref:
	ldx #$00
.loop
	txa
	sta $0c00,x
	inx
	cpx #$00
	bne .loop
	rts
