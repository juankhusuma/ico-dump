add $t0, $zero, $zero
add $t1, $t0, $t0
addi $t2, $t1, 4
Loop1: add $t1, $t1, $t0
addi $t0, $t0, 1
bne $t2, $t0, Loop1