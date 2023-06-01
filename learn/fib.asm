.macro print(%int)
	li $v0, 1
	la $a0, (%int)
	syscall
.end_macro

.text
li $t0, 0
li $t1, 1
lw $t2, n
lw $t3, stop 
lw $t5, step
loop:
	add $t4, $t0, $t1
	print($t4)
	
	la $t0, ($t1)
	la $t1, ($t4)
	
	add $t2, $t5, $t2

	bgt $t2, $t3, end
	j loop
	
end:

.data
n: .word 0
stop: .word 100
step: .word 1
