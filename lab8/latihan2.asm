;====================================================================
; Processor		: ATmega8515
; Compiler		: AVRASM
;====================================================================

;====================================================================
; DEFINITIONS
;====================================================================

.include "m8515def.inc"
.def counter = r17
.def is_slow = r18
.def alternating = r19

;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================

.org $00 	; JUMP to MAIN to initialze
rjmp MAIN
.org $01	; When Button0 pressed, jump to ext_int0
rjmp ext_int0
.org $02
rjmp ext_int1
.org $06	; When Timer1 overflows, jump to ISR_TOV1
rjmp ISR_TOV1

;====================================================================
; CODE SEGMENT
;====================================================================

; Initialize stack pointer
MAIN:
	ldi r16, low(RAMEND)
	out SPL, r16
	ldi r16, high(RAMEND)
	out SPH, r16

	ldi alternating, $00


; Setup LED PORT
SET_LED:
	ser r16			; Load $FF to temp		
	out DDRB, r16	; Set PORTB to output	
	out PORTB, r16

; Set button interupt
SET_BUTTON:
	; init button interrupt
	ldi r16, 0b00001010 ; set trigger mode int0 & int1
	out MCUCR, r16 
	ldi r16, 0b11000000 ; set int0 & int1
	out GICR, r16
	sei


; Setup Overflow Timer0
SET_TIMER:
	; Timer speed = clock with no slow down
	ldi r16, (1<<CS00)
	out TCCR1B, r16
	clr r16
	out TCCR1A, r16

	; Execute an internal interrupt when Timer1 overflows
	ldi r16, (1<<TOV1)
	out TIFR, r16

	; Set Timer1 overflow as the timer
	ldi r16, (1<<TOIE1)
	out TIMSK, r16

	; Set global interrupt flag
	sei

; While waiting for interrupt, loop infinitely
FOREVER:
	rjmp FOREVER

; Program executed on button press
ext_int0:
	com is_slow

; Program executed on timer overflow
ISR_TOV1:
	; menambah delay jika pada mode lambat
	cpi is_slow, $FF
	breq next
	rcall DELAY_02
	rcall DELAY_02
	next:

	; simpan sreg
	push r16
	in r16, SREG
	push r16
	in r16, PORTB 	; Read Port B

	; mematikan dan menghidupkan lampu sesuai urutan di soal
	cpi alternating, $00
	brne other_pattern
	
	cpi counter, $01
	breq blue_off

	cpi counter, $02
	breq yellow_off

	cpi counter, $03
	breq green_off
	
	cpi counter, $04
	breq green_on

	cpi counter, $05
	breq yellow_on

	cpi counter, $06
	rjmp blue_on

	other_pattern:
	cpi counter, $01
	breq p1
	rjmp p2

	clear:
	inc counter
	pop r16
	out SREG, r16
	pop r16

	reti

p1: ; set pattern 1
	push r16
	ser r16
	ldi r16, $AA
	out PORTB, r16
	pop r16
	rjmp clear

p2: ; set pattern 2
	push r16
	ser r16
	ldi r16, $55
	out PORTB, r16
	pop r16
	ldi counter, $00
	rjmp clear

blue_off: ; mematikan lampu biru
	push r16
	ser r16
	ldi r16, 0b11100111
	out PORTB, r16
	pop r16
	rjmp clear

yellow_off: ; mematikan lampu kuning
	push r16
	ser r16
	ldi r16, 0b11000011
	out PORTB, r16
	pop r16
	rjmp clear
 
green_off: ; mematikan lampu hijau
	push r16
	ser r16
	ldi r16, 0b10000001
	out PORTB, r16
	pop r16
	rjmp clear

green_on: ; menghidupkan lampu hijau
	push r16
	ser r16
	ldi r16, 0b11000011
	out PORTB, r16
	pop r16
	rjmp clear

yellow_on: ; menghidupkan lampu kuning
	push r16
	ser r16
	ldi r16, 0b11100111
	out PORTB, r16
	pop r16
	rjmp clear

blue_on: ; menghidupkan lampu biru
	push r16
	ser r16
	ldi r16, 0b11111111
	out PORTB, r16
	pop r16
	ldi counter, $00
	rjmp clear

ext_int1: ; tonggle other pattern
	com alternating
	reti


DELAY_02:				; Delay 160 000 cycles
						; 20ms at 8.0 MHz
	    ldi  r18, 208
	    ldi  r19, 202
	L2: dec  r19
	    brne L2
	    dec  r18
	    brne L2
	    nop
	ret
