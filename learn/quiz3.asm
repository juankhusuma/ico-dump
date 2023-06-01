.text
	la $t2, k
	li $t0, 0xAAAAAAAA
	lh $t0, 0($t2)
.data
	k: .word 0xFF