.include "m8515def.inc"
.def temp = R16
.def n = R17
.def total= R23
.def a = R18
.def b = R19

reset:
  ldi temp, HIGH(RAMEND)
  out SPH, temp
  ldi temp, $5F
  out SPL, temp
  
main:
	ldi n, 5
	rcall fib	

forever:
	rjmp forever

fib:
	push n
	push a
	push b
	push total

	cpi n, 2
	brlt lt2
	rec:
		mov a, n
		dec a
		mov b, n
		subi b,2
		
		mov n, a
		rcall fib

		mov n, b
		rcall fib
	lt2:
		inc total

	stop:
		ret
