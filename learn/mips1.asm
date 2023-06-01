.data 
	hello: .asciiz "Hello, world\n"
	num: .word 6

.text
	_main:
		lw $s0, num
		lw $s1, num
		lw $t1, 4($s0)