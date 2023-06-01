.data
	xijinping: .word 0xA0B1C2D3
	
.text
	la $a1, xijinping
	lh $t0, 0($a1)