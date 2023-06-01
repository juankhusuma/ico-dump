.include "m8515def.inc"

.def temp = r16

.org $00
rjmp MAIN

.org $07
rjmp ISR_TOV0


MAIN:
	ldi temp, HIGH(RAMEND)
	out SPH, temp
	ldi temp, LOW(RAMEND)
	out SPL, temp

	ser temp
	out DDRA, temp
	out PORTA, temp

	rcall init_timer

stuck:
	rjmp stuck

init_timer:
	ldi temp, (1<<CS01)
	out TCCR0, temp

	ldi temp, (1<<TOV0)
	out TIFR, temp

	ldi temp, (1<<TOIE0)
	out TIMSK, temp

	sei
	ret

ISR_TOV0:
	push temp
	in temp, SREG
	push temp

	clr temp
	out DDRB, temp
	in temp, DDRB
	
	tst temp
	breq toggle_yellow

	clr temp
	out DDRA, temp
	in temp, DDRA

	tst temp
	breq toggle_red

	
	
	clr temp
	out DDRC, temp
	in temp, DDRC
	
	tst temp
	breq toggle_green	

	clear:
		pop temp
		out SREG, temp
		pop temp

	reti

toggle_red:
	ser temp
	out DDRA, temp
	clr temp
	out PORTA, temp
	ser temp
	out DDRB, temp
	out PORTB, temp
	rjmp clear

toggle_yellow:
	ser temp
	out DDRB, temp
	clr temp
	out PORTB, temp
	ser temp
	out DDRC, temp
	out PORTC, temp
	rjmp clear

toggle_green:
	ser temp
	out DDRC, temp
	clr temp
	out PORTC, temp
	ser temp
	out DDRA, temp
	out PORTA, temp
	rjmp clear


