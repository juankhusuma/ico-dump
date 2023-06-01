;====================================================================
; Processor		: ATmega8515
; Compiler		: AVRASM
;====================================================================

;====================================================================
; DEFINITIONS
;====================================================================

.include "m8515def.inc"
.def counter = r17

;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================

.org $00 	; JUMP to MAIN to initialze
rjmp MAIN
.org $01	; When Button0 pressed, jump to ext_int0
rjmp ext_int0
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


; Setup LED PORT
SET_LED:
	ser r16			; Load $FF to temp		
	out DDRB, r16	; Set PORTB to output	
	out PORTB, r16

; Setup Overflow Timer0
SET_TIMER:
	; Timer speed = clock/8 (set CS01 in TCCR0)
	ldi r16, (1<<CS01)
	out TCCR1B, r16
	clr r16
	out TCCR1A, r16

	; Execute an internal interrupt when Timer0 overflows
	ldi r16, (1<<TOV1)
	out TIFR, r16

	; Set Timer0 overflow as the timer
	ldi r16, (1<<TOIE1)
	out TIMSK, r16

	; Set global interrupt flag
	sei

; While waiting for interrupt, loop infinitely
FOREVER:
	rjmp FOREVER

; Program executed on button press
ext_int0:
	reti

; Program executed on timer overflow
ISR_TOV1:
	push r16
	in r16, SREG
	push r16
	in r16, PORTB 	; Read Port B

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

	clear:
	inc counter
	;out PORTB, r16	; Write to Port B
	pop r16
	out SREG, r16
	pop r16

	reti

blue_off:
	push r16
	ser r16
	ldi r16, 0b11100111
	out PORTB, r16
	pop r16
	rjmp clear

yellow_off:
	push r16
	ser r16
	ldi r16, 0b11000011
	out PORTB, r16
	pop r16
	rjmp clear

green_off:
	push r16
	ser r16
	ldi r16, 0b10000001
	out PORTB, r16
	pop r16
	rjmp clear

green_on:
	push r16
	ser r16
	ldi r16, 0b11000011
	out PORTB, r16
	pop r16
	rjmp clear

yellow_on:
	push r16
	ser r16
	ldi r16, 0b11100111
	out PORTB, r16
	pop r16
	rjmp clear

blue_on:
	push r16
	ser r16
	ldi r16, 0b11111111
	out PORTB, r16
	pop r16
	ldi counter, $00
	rjmp clear
