# Macro for cleaner code
.macro str_print %s # macro untuk print string
	li $v0, 4  # set to print string
	la $a0, %s # load the address of the string
	syscall
.end_macro

.macro char_print %s # macro untuk print char
	li $v0, 11  # set to print char
	addi $a0, %s, 0 # load the address of the char
	syscall
.end_macro

.macro read_str %s, %buffer, %length
	str_print %s # print pesan dari inpput
	li $v0, 8 # set to read string
	addi $a0, %buffer, 0  # load buffer address
	li $a1, %length # load string length
	syscall
.end_macro


.data
text_input: .asciiz "Input: "
out_kapital: .asciiz "\nHuruf kapital pada 5 karakter pertama: "
out_kecil: .asciiz "\nHuruf non-kapital pada 5 karakter terakhir: "
str_buffer:
	.align  2
	.space 10

.globl main
.text
main:
	# $t0 adalah string buffer yang akan meyimpan input string
	la $t0, str_buffer
	# minta input dari user
	read_str text_input, $t0, 11
	
	# print 5 huruf kapital pertama
	str_print out_kapital
	
	# $t1 adalah loop counter
	li $t1, 0

cek_kapital_loop:
	# load char pada loop index
	lb $t2, ($t0)
	
	# $t3 untuk mengecek apakah char >= 65
	slti $t3, $t2, 65
	slti $t3, $t3, 1
	
	# $t4 untuk mengecek apakah char <= 90
	slti $t4, $t2, 91
	
	# cek apakah 65 <= char <= 90
	and $t3, $t3, $t4	
	li $t4, 1
	beq $t3, $t4, print_kapital
	
	# increment loop dan pointer
	addi $t1, $t1, 1
	addi $t0, $t0, 1
	bne $t1, 5, cek_kapital_loop
	
	# jika sudah selesai, print 5 huruf non kapital
	str_print out_kecil
	
cek_kecil_loop:
	# load char pada loop index
	lb $t2, ($t0)
	
	# $t3 untuk mengecek apakah char >= 97
	slti $t3, $t2, 97
	slti $t3, $t3, 1
	
	# $t4 untuk mengecek apakah char <= 122
	slti $t4, $t2, 123
	
	# cek apakah 97 <= char <= 122
	and $t3, $t3, $t4	
	li $t4, 1
	beq $t3, $t4, print_non_kapital
	
	# increment loop dan pointer
	addi $t1, $t1, 1
	addi $t0, $t0, 1
	bne $t1, 10, cek_kecil_loop
	
	# exit program
	j exit
	
	
# print char lalu increment loop dan pointer, dan jump kembali ke loop
print_kapital:
	char_print $t2
	addi $t1, $t1, 1
	addi $t0, $t0, 1
	bne $t1, 5 cek_kapital_loop

# print char lalu increment loop dan pointer, dan jump kembali ke loop	
print_non_kapital:
	char_print $t2
	addi $t1, $t1, 1
	addi $t0, $t0, 1
	bne $t1, 10 cek_kecil_loop	

# exit program	
exit:
	li $v0, 10
	syscall
	
