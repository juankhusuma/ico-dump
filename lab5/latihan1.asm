.include "m8515def.inc"
.def result = r2

main:
	ldi ZH, HIGH(2*DATA) ; Inisialisasi stack pointer
	ldi ZL, LOW(2*DATA)
loop:
	lpm	; load data dari memmory ke register r0
	tst r0 ; cek nilai apakah nilai dari r0 nol atau negatif
	breq stop ; stop eksekusi jika flag zero true
	mov r16, r0 ; salin data dari r0 ke r16
funct1: ; menghitung r16 % 3
	cpi r16, 3 ; melakukan comparison r16 < 3
	brlt funct2 ; jika r16 < 3, jump ke funct2
	subi r16, 3 ; jika r16 >= 3, r16 = r16 - 3
	rjmp funct1 ; loop kembali funct1

funct2:
	add r1, r16 ; jumlahkan r1 dengan r16
	adiw ZL, 1 ; increment stack pointer by 1
	rjmp loop ; ulang kembali loop, dg jump ke label loop
stop:
	mov result, R1 ; jika program berhenti, pindahkan nilai dari R1 ke result
forever: ; infinite loop untuk mengakhiri program
	rjmp forever
DATA:
	.db 2, 11, 7, 8
	.db 0, 0

; alur eksekusi 
; r0 = 2 -> load from mem
; r16 = r0 = 2
; r16 = 2 % 3 = 2
; r1 = r1 + r16 = r1 + 2
; SP + 1
; r0 = 11
; r16 = r0 = 11
; r16 = 11 % 3 = 2
; r1 = r1 + r16 = r1 + 2 + 2 = r1 + 4
; SP + 1
; r0 = 7 -> load from mem
; r16 = r0 = 7
; r16 = r16 % 3 = 7 % 3 = 1
; r1 = r1 + r16 = r1 + 4 + 1 = r1 + 5
; SP + 1
; r0 = 8 <- load from mem
; r16 = r0 = 8
; r16 = r16 % 3 = 8 % 3 = 2
; r1 = r1 + r16 = r1 + 5 + 2 = r1 + 7
; SP + 1
; r0 = 0 <- load from mem
; Program berakhir karena r0 = 0
; result = r1
; result = r1 + 7
