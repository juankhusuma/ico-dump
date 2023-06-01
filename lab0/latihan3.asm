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
	
	input(ask_matkul) # meminta input jumlah matkul ke user
	add $t1, $v0, $zero # $t1 menampung hasil input jumlah matkul
	
	li $t2, 0 # counter untuk loop
	li $t3, 0 # $t3 untuk menampung total dari SKS
Loop:
	print(ask_sks) # meminta input SKS matkul ke-n dari user
	addi $t4, $t2, 1 # karena counter mulai dari nol, untuk di print, jumlahkan 1
	print_int($t4) # print angka sks
	print(colon)
	input(empty) # meminta input
	add $t3, $t3, $v0 # jumlahkan sks ke total
	addi $t2, $t2, 1 # increment counter
	bne $t1, $t2, Loop # jika counter belum sama dengan jumlah matkul maka ulangi loop
	
	# print output
	print(out_1)
	print_int($t0) # print NPM
	print(out_2)
	print_int($t1) # print jumlah matkul
	print(out_3)
	print_int($t3) # print total SKS
	print(out_4)
	
	# Exit program
	li $v0, 10
	syscall

.data:
	welcome: .asciiz "Selamat datang pada awal perjalananmu, petualang!\n"
	line_1: .asciiz "Sebelum memulai petualanganmu, silahkan memperkenalkan dirimu terlebih dahulu.\n"
	ask_npm: .asciiz "Masukan NPM kamu: "
	ask_matkul: .asciiz "Masukan jumlah mata kuliah yang kamu ambil: "
	ask_sks: .asciiz "Masukan sks mata pelajaran "
	out_1: .asciiz "Halo petualang dengan NPM "
	out_2: .asciiz ". Hebat! Anda mengambil "
	out_3: .asciiz " mata kuliah dengan total "
	out_4: .asciiz " SKS."
	colon: .asciiz ": "
	empty: .asciiz ""