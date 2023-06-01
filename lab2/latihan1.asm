# Macro for cleaner code
.macro print(%s) # macro untuk print string
	li $v0, 4  # set to print string
	la $a0, %s # load the address of the string
	syscall
.end_macro

.macro input(%s) # macro untuk menerima input
	print(%s) # print pesan input
	li $v0, 5, # set to int input
	syscall
.end_macro

.macro print_int(%d) # macro untuk print int
	li $v0, 1 # set to print int
	add $a0, %d, $zero # load int value
	syscall
.end_macro 

.macro input_word_arr(%s, %amt, %addr, %temp, %counter, %remainder)
	input(%s) # minta input int ke user
	addi %temp, $v0, 0 # pindahkan input dari $v0 ke $t1
	li %counter, 0 # counter
	
	input_loop: # loop untuk memotong digit sebanyak panjang input
		# membagi 10 untuk mencari digit ke-n dan juga string selanjutnya
		div %temp, %temp, 10
		mflo %temp
		mfhi %remainder
		
		# remainder dari div merupakan digit ke-n
		sw %remainder, (%addr) # simpan digit ke-n ke array pada memmory
		
		# increment array pointer dan juga counter loop
		addi %addr, %addr, 4
		addi %counter, %counter, 1
		bne %counter, %amt, input_loop
.end_macro

.data
	npm: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	input_text: .asciiz "Masukan Input 10 digit: "
	total_mobil: .asciiz "Total penjualan mobil : "
	total_motor: .asciiz "Total penjualan motor : "
	newline: .asciiz "\n"

.globl main
.text
main:
	la $t0, npm # simpan address array digit NPM
	# minta input npm lalu simpan setiap digitnya sebagai array
	input_word_arr(input_text, 10, $t0, $t1, $t2, $t3)
	la $t0, npm # reset pointer
	li $t1, 0 # counter loop

	li $t3, 0 # count total motor
	li $t4, 0 # count total mobil

print_loop:
	# cek digit ganjil atau genap
	div $t2, $t1, 2
	mfhi $t5
	
	# jika ganjil (counter mulai dari 0, jadi digit ganjil adalah jumlah mobil), tambahkan ke counter mobil
	bnez $t5, add_mobil
	# jika genap tambahkan ke counter motor
	j add_motor

inc:	
	# increment array pointer dan loop counter
	addi $t0, $t0, 4
	addi $t1, $t1, 1
	bne $t1, 10, print_loop
	# exit ketika loop selesai
	j exit

add_motor:
	lw $t2, ($t0) #load digit ke-n
	add $t4, $t4, $t2 # jumlahkan ke total motor
	j inc # increment loop dan array pointer

			
add_mobil:
	lw $t2, ($t0) #load digit
	add $t3, $t3, $t2 # jumlahkan ke total mobil
	j inc # increment loop dan array pointer
	
exit:
	# print total motor
	print(total_motor)
	print_int($t3)
	print(newline)
	
	# print total mobil
	print(total_mobil)
	print_int($t4)
	print(newline)
	
	# exit dari program
	li $v0, 10
	syscall
