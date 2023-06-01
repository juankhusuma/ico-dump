.include "m8515def.inc"
.def temp = r16
.def is_npm = r17
.def count = r23
.def txt = r19

init:
	; init stack pointer
	ldi temp, HIGH(RAMEND)
	out SPH, temp
	ldi temp, LOW(RAMEND)
	out SPL, temp

	; cek write npm atau nama
	ldi is_npm, 1

start:
	; init lcd
	rcall init_lcd
	ldi temp, $FF
	out DDRA,temp ; port A as output
	out DDRB,temp ; port B as output
	rcall load_txt
	; mulai menulis
	rcall write

	rjmp forever
	
write:
	ldi count, 0
	; tulis npm atau tidak
	tst is_npm
	breq write_npm
	write_npm:
		; tulis npm label dan nilai npm
		rcall write_npm_label
		rcall write_npm_value
	; tulis nama label dan nama	
	rcall init_lcd
	rcall write_nama_label
	rcall write_nama_value
	; reset lcd dan pointer
	rcall init_lcd
	rcall load_txt
	rjmp write

	ret_write:
		ret

write_npm_label:
	; loop dan print
	ldi count, 0
	loop_npm_label:
		lpm
		mov txt, r0
		rcall write_char
		inc count
		adiw ZL, 1
		cpi count, 3
		brne loop_npm_label
	ret	

write_nama_label:
	ldi count, 0
	loop_nama_label:
		lpm
		mov txt, r0
		rcall write_char
		inc count
		adiw ZL, 1
		cpi count, 4
		brne loop_nama_label
	ret	


write_npm_value:
	ldi count, 0
	cbi PORTA,1 
	ldi temp,$C0 
	out PORTB,temp
	rcall trigger
	loop_npm:
		lpm
		mov txt, r0
		rcall write_char
		inc count
		adiw ZL, 1
		cpi count, 10
		brne loop_npm
	ldi is_npm, 0
	ret
	

write_nama_value:
	cbi PORTA,1 
	ldi temp,$C0 
	out PORTB,temp
	rcall trigger
	loop_nama:
		lpm
		mov txt, r0
		tst txt
		breq  return_nama_value
		rcall write_char
		adiw ZL, 1
		rjmp loop_nama
				
	ldi is_npm, 1
	return_nama_value:
		ret
	

write_char:	
	sbi PORTA,1
	out PORTB, txt
	rcall trigger
	ret

init_lcd:
	; setup display
	cbi PORTA,1 
	ldi temp,0x38 
	out PORTB,temp
	rcall trigger

	cbi PORTA,1 
	ldi temp,$0E 
	out PORTB,temp
	rcall trigger

	rcall clear

	cbi PORTA,1 
	ldi temp,$06 
	out PORTB,temp
	rcall trigger
	ret

; trigger falling edge
trigger:
	sbi PORTA,0 
	cbi PORTA,0 
	rcall DELAY_01
	ret

; reset pointer	
load_txt:
	ldi ZH, HIGH(2*message)
	ldi ZL, LOW(2*message)
	ret


; clear lcd
clear:
	cbi PORTA,1 ; CLR RS
	ldi temp,$01 ; MOV DATA,0x01
	out PORTB, temp
	rcall trigger
	ret

DELAY_00:				; Delay 4 000 cycles
						; 500us at 8.0 MHz	
	    ldi  r18, 6
	    ldi  r19, 49
	L0: dec  r19
	    brne L0
	    dec  r18
	    brne L0
	ret

DELAY_01:				; DELAY_CONTROL 40 000 cycles
						; 5ms at 8.0 MHz
	    ldi  r18, 52
	    ldi  r19, 242
	L1: dec  r19
	    brne L1
	    dec  r18
	    brne L1
	    nop
	ret

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

forever:
	rjmp forever

message:
.db "NPM2206081521NAMAJUANDK", 0  
