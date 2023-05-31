	.text
main:
	la $a0, prompt1
	li $v0, 4
	syscall
	la $a0, dividend
	syscall

	li $v0, 5
	syscall
	
	move $s0, $v0	#dividend

div:	la $a0, divisor
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $s1, $v0	#divisor
	
	beq $s1, $0, error
	
	move $a1, $s1
	move $a0, $s0
	# Recursive function call
	jal recursiveDivision
	move $s0, $a0
	
	la $a0, quotient
	li $v0, 4
	syscall
	
	move $a0, $s0
	li $v0, 1
	syscall 
	la $a0, remainder
	li $v0, 4
	syscall
	
	move $a0, $a1 
	li $v0, 1
	syscall 

	j exit
	
error:
	la $a0, error_msg
	li $v0, 4
	syscall
	j div

# $a0 quotient $a1 remainder
recursiveDivision:
	addi $sp, $sp, -20
	sw $s1, 16($sp) 
	sw $s0, 12($sp) 
	sw   $a1, 8($sp) 
    	sw   $a0, 4($sp)   
    	sw   $ra, 0($sp) 
 
    	# base condition return remainder as dividend if dividend < divisor
    	# if dividend>=divisor else
    	bge $a0, $a1, elseDiv
   	move $s1, $a0 # obtain the remainder, remainder = num1 
    	addi $a0, $0, 0	# return 0, quotient = 0
    	move $a1, $s1
    	addi $sp, $sp, 16
    	jr  $ra   # next
elseDiv:
	# dividend -= divisor
	sub $a0, $a0, $a1
	# recursive function call
	jal recursiveDivision # return 1 + recursiveDivision(dividend-divisor, divisor)
    
    	lw $s1, 16($sp) 
    	lw $s0, 12($sp)
    	lw   $ra, 0($sp)  
    	addi $sp, $sp, 20
    	addi $a0, $a0, 1 # quotient += 1
	jr $ra # goto next
exit: 
	li $v0, 10
	syscall 

	.data
prompt1: .asciiz "RECURSIVE DIVISION"
dividend: .asciiz "\nPlease enter the Dividend: "
divisor: .asciiz "\nPlease enter the Divisor: "
quotient: .asciiz "\nQuotient: "
remainder: .asciiz "\nRemainder: "
error_msg: .asciiz "\Cannot enter 0 as divisor! "
