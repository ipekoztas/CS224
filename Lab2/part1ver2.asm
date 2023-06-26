.data

prompt1: 	.asciiz "\nEnter a value: "
hex1:		.asciiz "\nHex value of the first register: "
hex2:		.asciiz "\nHex value of the second register: "
finalPrompt:	.asciiz "\nEnter 1 to continue, 0 to quit: "
result:		.asciiz "\nHamming distance calculated is: "
ans:	.space 8

.text

main:

	jal promptUser
	move $s0, $v0	#reg value1 
		
	jal promptUser
	move $s1, $v0	#reg value 2
	
	la $a0, hex1
	li $v0, 4
	syscall
	
	move $a0, $s0
	jal convertHex
	
	la $a0, hex2
	li $v0, 4
	syscall

	move $a0, $s1
	jal convertHex
	
	move $a0, $s0
	move $a1, $s1
	jal calculateDistance
	move $s2, $v0	#result
	
	
	la $a0, result
	li $v0, 4
	syscall
	
	li $v0, 1
	move $a0, $s2
	syscall
	
	la $a0, finalPrompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0
	beq $t0, $0, exit
	jal main
	
	exit:
		li $v0, 10
		syscall

promptUser:

	la $a0, prompt1
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	jr $ra
	
calculateDistance:

	addi $sp, $sp, -24
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $s0, 20($sp)

	move $t0, $a0	#value1
	move $t1, $a1	#value2
	
	li $t2, 10	#base 10
	li $s0, 0	#result
	
	
	while:
	beq $t1, $0, end    
	
	div $t0, $t2        # divide by ten, $hi = $t0/$t2, $lo = $t0 mod $t2
	mfhi $t3        
	mflo $t0 

	div $t1, $t2        # divide by ten, $hi = $t1/$t2, $lo = $t1 mod $t2
	mfhi $t4        
	mflo $t1
	
	beq $t3, $t4, cont
	addi $s0, $s0, 1	#digit count
	cont:
	j while

	end:
	move $v0, $s0
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $t4, 16($sp)
	lw $s0, 20($sp)
	addi $sp, $sp, 24
	jr $ra
	
convertHex:
addi $sp,$sp -16
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)

	
li $t0, 8 # counter 
move $t1, $a0
la $t2, ans # where answer will be stored 

Loop: beq $t0, $0, exithex # branch to exit if counter is equal to zero 
	rol $t1, $t1, 4 # rotate 4 bits to the left 
	and $t3, $t1, 0xf # mask with 1111 
	ble $t3, 9, Sum # if less than or equal to nine, branch to sum 
	addi $t3, $t3, 55 # if greater than nine, add 55 
	b End 
Sum: addi $t3, $t3, 48 # add 48 to result 
End: sb $t3, 0($t2) # store hex digit into result 
	addi $t2, $t2, 1 # increment address counter 
	addi $t0, $t0, -1 # decrement loop counter 
	j Loop 
exithex: 	
	la $a0, ans 
	li $v0, 4 
	syscall 
	

	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	addi $sp,$sp 16
	
	jr $ra


