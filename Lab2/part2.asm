.data
prompt1:	.asciiz "Enter the number of elements: \n"
prompt2:	.asciiz "Enter the element: \n"
prompt3:	.asciiz "Enter index: \n"
result:		.asciiz "The number of occurrences of the array element that occurs at the given position is: "
finalPrompt:	.asciiz "\nEnter 0 to quit: "
.text

main:
	promptUser:
	la $a0, prompt1
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	ble $v0, $zero, promptUser	#arraysize > 0
	
	# $a1 holds the array size 
	move $a1, $v0 
	
	jal createArray
	#a2 array1 address
	move $a2, $v0 
	
	getIndex:
	la $a0, prompt3
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	blt $v0, $zero, getIndex	# arraysize > index >= 0
	bge $v0, $a1, getIndex
	
	move $a3, $v0	#index
	
	jal findOccurrences
	move $s0, $v0
	
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
	jal getIndex
	
	exit:
		li $v0, 10
		syscall
createArray:
	addi $sp, $sp, -8
	sw $s0, 4($sp)

	
	# $a1 = arraysize
	
	move $s0, $a1
	mul $s0, $s0, 4
	
	li $v0, 9
	move $a0, $s0
	syscall
	
	move $a0, $v0		# array address
	
	#save $ra
	sw $ra, 0($sp)
	jal initializeArray
	lw $ra, 0($sp)
	
	move $v0, $a0
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	
	jr $ra
	
initializeArray:
	#input arraysize($a1) and array address($a0)
	addi $sp, $sp, -12
	sw $a0, 8($sp)
	sw $s0, 4($sp)
	sw $s1, 0($sp)

	move $s1, $a0
	move $s0, $a1
	
	getInput:
		li $v0, 4
		la $a0, prompt2
		syscall
	
		li $v0, 5
		syscall
		
		sw $v0, 0($s1)		# store the element into memory
		addi $s1, $s1, 4
		addi $s0, $s0, -1
		bne $s0, $zero, getInput

	lw $a0, 8($sp)
	lw $s0, 4($sp)
	lw $s1, 0($sp)
	addi $sp, $sp, 12
	jr $ra
	
findOccurrences:

	addi $sp, $sp, -24
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $t0, 12($sp)
	sw $t1, 8($sp)
	sw $t2, 4($sp)
	sw $t3, 0($sp)
	

	move $s0, $a2	#array address
	move $s1, $a1	#array size
	
	li $t0, 0	#count
	move $t1, $a3	#index
	mul $t1, $t1, 4	#byte
	add $s0, $s0, $t1
	lw $t2, ($s0)	#wanted element
	sub $s0, $s0, $t1
	
	
	compare:
		beq $s1, $0, finishCal
		lw $t3, 0($s0) #array element
		bne $t3, $t2, continue
		addi $t0, $t0, 1
	continue:
		addi $s0, $s0, 4
		addi $s1, $s1, -1
		j compare
	finishCal:
		move $v0, $t0
		

	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $t0, 12($sp)
	lw $t1, 8($sp)
	lw $t2, 4($sp)
	lw $t3, 0($sp)
	addi $sp, $sp, 24
	jr $ra