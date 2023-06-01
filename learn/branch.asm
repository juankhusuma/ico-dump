.text
	li $s0, 1 # f
	li $s1, 3 # g
	li $s2, 3 # h
	li $s3, 4 # i
	li $s4, 5 # j
	
	beq $s3, $s4, Add
	j Sub
	
	Add:
		add $s0, $s1, $s2
		j Exit
	Sub:
		sub $s0, $s1, $s2		
	
	Exit:
		
		