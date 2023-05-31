.data

prompt1: 	.asciiz "\nEnter a value: "
hex1:		.asciiz "\nHex value of the first register: "
hex2:		.asciiz "\nHex value of the second register: "
hexValue1:	.space 8
hexValue2:	.space 8
finalPrompt:	.asciiz "\nEnter 1 to continue, 0 to quit: "
result:		.asciiz "\nHamming distance calculated is: "

.text

main:

	jal promptUser
	move $s0, $v0	#reg value1 
	move $a0, $s0	#value1
	jal digitArray
	move $s1, $v0	#array1
		
	jal promptUser
	move $s2, $v0	#reg value 2
	move $a0, $s1	#value2
	jal digitArray
	move $s3, $v0	#array2
	
	li $a0, 20
	move $a2, $s1
	move $a3, $s3
	jal calculateArray
	move $s0, $v0 #hamming dist
	
	la $a0, result
	li $v0, 4
	syscall
	
	li $v0, 1
	move $a0, $s0
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
	
digitArray:

	addi $sp, $sp, -24
	sw $s0, 20($sp)
	sw $t4, 16($sp)
	sw $t0, 12($sp)
	sw $t1, 8($sp)
	sw $t2, 4($sp)
	sw $t3, 0($sp)

	
	li $s0, 20	#20 digit number
	mul $s0, $s0, 4
	
	li $v0, 9
	move $a0, $s0
	syscall
	
	move $a1, $v0		# array address
	
	move $t0, $a1	#array address
	move $t1, $a0            #number to be stored
	li $t2, 10            #base 10
	li $t4, 0	#digit count

	while:
	beq $t1, $0, end     

	div $t1, $t2        # divide by ten, $hi = $t1/$t2, $lo = $t1 mod $t2
	mfhi $t3        
	mflo $t1
	sw $t3, 0($t0)      #store word into array
	addi $t0, $t0, 4    #increment array index
	addi $t4, $t4, 1	#digit count
	j while
end:
	move $v0, $a1	#return array address
	sw $s0, 20($sp)
	lw $t4, 16($sp)
	lw $t0, 12($sp)
	lw $t1, 8($sp)
	lw $t2, 4($sp)
	lw $t3, 0($sp)
	addi $sp, $sp, 24
	
	move $v0, $a1
	jr $ra
	
calculateArray:	
	addi $sp, $sp, -24
	sw $s3, 20($sp)
	sw $s2, 16($sp)
	sw $s1, 12($sp)
	sw $s0, 8($sp)
	sw $t1, 4($sp)
	sw $t0, 0($sp)
	

	move $s0, $a0 #array size
	move $s1, $a1	#array1 address
	move $s2, $a2 	#array2 address
	li $s3, 0	#count 
	
	compare:
		beq $s0, $0, finishCal
		lw $t0, 0($s1) #array1 element
		lw $t1, 0($s2) #array2 element
		bne $t0, $t1, continue
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