.include "m8515def.inc"
.def a = R9
.def b = R2
.def tmpa = R6
.def tmpb = R7
.def temp = R3
.def lcm = R1
.def gcd = R5
.def count = R23

main:
	ldi ZH, HIGH(2*DATA) ; load stack pointer
	ldi ZL, LOW(2*DATA)
	lpm ; load a dari mem
	mov	a, r0 ; mov a dari r0 
	mov tmpa, a
	adiw ZL, 1 ; increment stack pointer
	lpm ; load b from mem ke r0
	mov b, r0 ; mov b dari r0
	mov tmpb, b


_gcd:
	tst b ; cek jika b <= 0
	breq _lcm ; jika b = 0 jump ke _lcm
	mov temp, b ; temp = b
	
	mod: ; a = a mod b
	cp a, b ; cek jika a < b
	brlt done ; jika a < b jump ke done
	sub a, b ; jika tidak a = a - b
	rjmp mod ; loop kembali mod

	done:
	mov b, a ; b = a mod b
	mov a, temp ; a = b
	rjmp _gcd ; loop ulang gcd

		
_lcm:
	mov gcd, a ; pindahkan nilai a ke gcd
	mul tmpa, tmpb ; r0 = a * b

	ldi count, 0 ; counter berapa kali a * b dikurang gcd, sebagai hasil pembagian
	div:
	tst R0 ; cek jika a * b <= 0
	breq fin ; jika a * b = 0 jump ke fin
	sub R0, gcd ; jika masih > 0 kurangi a * b dengan gcd
	inc count ; increment div counter
	rjmp div ; ulang div loop

	fin:
	mov lcm, count ; lcm(a, b) = a * b /gcd(a, b)

forever:
	rjmp forever



DATA:
	.db 12, 10
	.db 0, 0

