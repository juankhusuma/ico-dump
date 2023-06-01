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

.data
greet: .asciiz "Selamat Datang di Restoran Peokra!\n"
ask_kategori: .asciiz "Masukan banyak kategori pesanan: "
ask_menu_amt: .asciiz "total menu yang dipesan pada kategori "
colon: .asciiz ": " 
empty: .asciiz ""
warning: .asciiz "Minimal pesan satu makanan!\n"
total: .asciiz "Total Harga Pesanan: "

.globl main
.text
main:
	print(greet)
	input(ask_kategori)
	# simpan input jumlah kategori + 1 ke $t0
	addi $t0, $v0, 1
	# $t1: Loop counter
	li $t1, 1
	li $t2, 5000
	# $t4: total pesanan
	li $t4, 0
Loop:
	# $t3: harga = 5000 * n
	mul $t3, $t1, $t2
	
	print(ask_menu_amt)
	print_int($t1)
	print(colon)
	input(empty)
	
	# $t5: pesanan
	add $t5, $v0, $zero
	# if pesanan <= 0 goto Exit
	ble $t5, $zero Warn
	
Inc:
	# harga *= pesanan
	mul $t3, $t3, $t5
	# total += harga
	add $t4, $t4, $t3

	addi $t1, $t1, 1
	# Jika $t0 != 0, lanjut loop
	bne $t0, $t1, Loop

Total:
	print(total)
	print_int($t4)
	
Exit:
	li $v0, 10
	syscall
	
Warn:
	print(warning)
	j Exit