.text
lw $t0, start # load variables into registers
lw $t1, end
lw $t2, inc

loop:
	li $v0, 1
	la $a0, ($t0)
	syscall # print int syscall

	add $t0, $t0, $t2 # t1 <- t1 + t2
	bgt $t0, $t1, stop
	j loop
stop:



.data # just some variables
start: .word 0
end: .word 100
inc: .word 1
