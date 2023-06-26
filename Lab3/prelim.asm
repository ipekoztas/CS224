.text
	
main:

	la $a0, prompt_dividend
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	#	$s0 stores the dividend
	move $s0, $v0
	
	la $a0, prompt_divisor
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	#	$s1 stores the divisor
	move $s1, $v0
	
	# print an error msg if the divisor is zero
	beq $s1, $zero, error_message

	move $a0, $s0
	move $a1, $s1
	jal recursiveDivision	#returns the result in 
	
	#move result
	move $s2, $v0
	li $v0, 4
	la $a0, result
	syscall
	
	li $v0, 1
	move $a0, $s2
	syscall
	
	#ask the user to continue
	again:
	li $v0,4
	la $a0, promptAgain
	syscall
	
	li $v0 , 5
	syscall
	
	bne $v0, $zero, main
	
	j exit
	
recursiveDivision:
	addi $sp, $sp, -16 #uses 4 registers 
	sw $ra, 0($sp)
	sw $s0, 4($sp) #dividend
	sw $s1, 8($sp) #divisor
	sw $a0, 12 ($sp)
	
	#base case
	li $v0, 0 #result is stored
	blt $s0, $s1, done
	
	move $s0, $a0
	move $s1, $a1
	sub $a0, $a0, $a1
	jal recursiveDivision
	
	addi $v0, $v0 ,1
	
	done:
	
	
	addi $sp, $sp, 16 
	lw $ra, 0($sp)
	lw $s0, 4($sp) #dividend
	lw $s1, 8($sp) #divisor
	lw $a0, 12 ($sp)
	jr $ra


error_message:
	li $v0, 4
	la $a0, errormsg
	syscall
	j again
exit: 
	li $v0, 10
	syscall


	.data
dividend: .word 0 
divisor: .word 0
promptAgain: .asciiz "\n Would you like to try again?\n0 : NO\n1 : YES\n"
	
prompt_dividend: .asciiz "Enter a dividend value: "
prompt_divisor: .asciiz "Enter a divisor value: "
	
result: .asciiz "The result of the division is:  "
errormsg: .asciiz "You cannot enter 0 as a divisor!\n"
