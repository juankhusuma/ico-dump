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

.text
.globl main
main:
	print(welcome) # print kalimat pembuka
	print(line_1)
	
	input(ask_npm) # meminta input NPM ke user
	add $t0, $v0, $zero # $t0 menampung hasil input NPM
	
	input(ask_sks) # meminta input SKS ke user
	add $t1, $v0, $zero # $t1 menampung hasil input SKS
	
	# printing output
	print(out_1)
	print_int($t0) # print input NPM
	print(out_2)
	print_int($t1) # print input SKS
	print(out_3)
	
	# Exit program
	li $v0, 10
	syscall

.data:
	welcome: .asciiz "Selamat datang pada awal perjalananmu, petualang!\n"
	line_1: .asciiz "Sebelum memulai petualanganmu, silahkan memperkenalkan dirimu terlebih dahulu.\n"
	ask_npm: .asciiz "Masukan NPM kamu: "
	ask_sks: .asciiz "Masukan jumlah SKS yang kamu ambil: "
	out_1: .asciiz "Halo petualang dengan NPM "
	out_2: .asciiz ". Semoga dengan mengambil "
	out_3: .asciiz " SKS anda bisa menyelesaikan petualangan ini dengan baik!"
