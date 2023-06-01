.globl main
.text

main:
	li $t0, 0 
	li $t1, 0
		
loop:
	addi $t1, $t1, 5
	addi $t0, $t0, 1
	blt $t0, 10, loop
	
exit: