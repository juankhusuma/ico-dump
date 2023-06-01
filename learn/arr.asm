.text
	la $s0, arr1
	li $t1, 1
	li $t2, 4
	mul $t1, $t1, $t2
	add $s0, $s0, $t1
	lw $s2, ($s0)
	
	
.data
	arr1: .word 1, 2, 3, 4
