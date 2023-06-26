.data

prompt1: 	.asciiz "\nEnter a value: "
hex1:		.asciiz "\nHex value of the first register: "
hex2:		.asciiz "\nHex value of the second register: "
finalPrompt:	.asciiz "\nEnter 1 to continue, 0 to quit: "
result:		.asciiz "\nHamming distance calculated is: "
ans1:	.space 32
ans2:	.space 32

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
	la $a1, ans1
	jal convertHex
	
	la $a0, ans1
	li $v0, 4 
	syscall 
	
	la $a0, hex2
	li $v0, 4
	syscall

	move $a0, $s1
	la $a1, ans2
	jal convertHex
	
	la $a0, ans2
	li $v0, 4 
	syscall 
	
	la $a0, ans1
	la $a1, ans2
	jal calculateDistance
	move $s2, $v0	#result
	#hamming distance is calcullated in hexadecimal form
	
	
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
	sw $s3, 20($sp)
	sw $s2, 16($sp)
	sw $s1, 12($sp)
	sw $s0, 8($sp)
	sw $t1, 4($sp)
	sw $t0, 0($sp)
	

	li $s0, 8 #array size
	move $s1, $a0	#array1 address
	move $s2, $a1 	#array2 address
	li $s3, 0	#count 
	
	compare:
		beq $s0, $0, finishCal
		lw $t0, 0($s1) #array1 element
		lw $t1, 0($s2) #array2 element
		beq $t0, $t1, continue
		addi $s3, $s3, 1
	continue:
		addi $s1, $s1, 4
		addi $s2, $s2, 4
		addi $s0, $s0, -1
		j compare
	finishCal:
		move $v0, $s3
		
	lw $s3, 20($sp)
	lw $s2, 16($sp)
	lw $s1, 12($sp)
	lw $s0, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
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
move $t2, $a1 # where answer will be stored 

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

	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	addi $sp,$sp 16
	
	jr $ra


