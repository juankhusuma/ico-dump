.globl main
.text

main:
	add $t0, $zero, $zero
	add $t1, $zero, $zero
	la $t2, arr
	
loop:
	lw $t3, ($t2)
	beq $t0, $zero, inc
	
	bne $	

inc:
	addi $t1, $t1, 1
	j loop
	
exit:
	
	
.data:
	arr: .word 1, 2, 1, 0, 0, 0, 1, 1, 1