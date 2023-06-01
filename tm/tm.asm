.data
	n: .word 1
	store: .word 0
	
.globl main
.text:

main:
	la $t0, n
	# menyimpan n di $a0
	lw $a0, ($t0)
	# $a1 menyimpan base pointer array
	la $a1, store
	
	# loop counter
	li $t0, 0
	# suku pertama
	li $t1, 3

loop:
	# simpan ke memmory
	sw $t1, ($a1)

	# increment loop conter & base pointer
	addi $t0, $t0, 1
	addi $a1, $a1, 4
	# an = 3 * an-1
	mul $t1, $t1, 3
	
	bne $t0, $a0, loop