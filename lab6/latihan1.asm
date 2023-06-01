.include "m8515def.inc"
.def temp = R18
.def n = R16
.def a = R19
.def b = R20
.def result = R22
.def _two = R23

init:
	; reset stack pointer
	ldi temp, HIGH(RAMEND)
	out SPH, temp
	ldi temp, LOW(RAMEND)
	out SPL, temp
	; initialize register R16
	ldi n, 5

start:
	; loop deret peokra dari n sampai 1
	tst n
	breq forever
	ldi _two, 2
	ldi XH, $00
	ldi XL, $5F
	add XL, n
	; hitung deret peokra ke n lalu simpan ke memmory
	rcall peokra
	st X, result
	; decrement counter lalu loop
	dec n
	rjmp start

forever:
	rjmp forever

peokra:
	; push data ke stack
	push n
	push a
	push b
	push temp
	; base case

	; cek kasus n = 1
	cpi n, 1
	breq one

	; cek kasus n = 1
	cpi n, 2
	breq two

	
	rec:
		; hitung n - 1 dan n - 2
		mov a, n
		dec a
		mov b, n
		subi b, 2

		; hitung deret peokra n - 1
		mov n, a
		rcall peokra
		inc result
		mov temp, result

		; hitung deret peokra n - 2
		mov n, b
		rcall peokra
		mul result, _two
		add temp, R0
		mov result, temp

		rjmp end

one:
	; jika n = 1 return 1
	ldi result, 1
	rjmp end

two:
 	; jika n = 2 return 2
	ldi result, 2

end:
	; pop semua dari stack lalu return
	pop temp
	pop b
	pop a
	pop n
	ret
