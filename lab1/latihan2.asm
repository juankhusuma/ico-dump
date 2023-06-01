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
ppn: .asciiz "Total ppn: "
newline: .asciiz "\n"
service: .asciiz "Total service: "
new_total: .asciiz "Total Harga yang perlu dibayar: "
minta_bayar: .asciiz "Masukan nominal pembayaran: "
kurang: .asciiz "Maaf, uang anda kurang sebesar "
selesai: .asciiz "Terima kasih, berikut kembalian sebesar "

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
	
	# minta jumlah pesanan pada kategori n
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
	# $t0, $t1, $t2
	print(total)
	print_int($t4)
	print(newline)
	# reassign $t0 untuk menampung PPN (menyimpan penyebut dr 1/10)
	li $t0, 10
	# reassign $t0 untuk menampung service (menyimpan penyebut dr 1/20)
	li $t1, 20
	
	# hitung besar ppn
	div $t2, $t4, $t0
	print(ppn)
	print_int($t2)
	print(newline)
	
	# hitung service fee
	div $t3, $t4, $t1
	print(service)
	print_int($t3)
	print(newline)
	
	# Tambahkan service fee dan ppn
	add $t4, $t4, $t2
	add $t4, $t4, $t3
	
	# print jumlah yang harus dibayar
	print(new_total)
	print_int($t4)
	print(newline)
	
	# minta bayaran jika kurang branch ke label Kurang
	input(minta_bayar)
	add $t0, $v0, $zero
	blt $t0, $t4, Kurang
	
	# print kembalian
	sub $t2, $t0, $t4
	print(selesai)
	print_int($t2)
	
	
Exit:
	li $v0, 10
	syscall
	
Warn:
	# print peringatan
	print(warning)
	j Exit
	
Kurang:
	# print jumlah yang kurang
	sub $t2, $t4, $t0
	print(kurang)
	print_int($t2)