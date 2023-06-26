.text 
main:
	
	la $a0, prompt 
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $s0, $v0	#register num
	move $a0, $s0
	jal RegisterCount
	move $s1, $v0	#result
	
	la $a0, result
	li $v0, 4
	syscall
	
	move $a0, $s1
	li $v0, 1
	syscall
	

	
	fin:
		li 	$v0, 10
		syscall

RegisterCount: 
	addi 	$sp, $sp, -24
	sw 	$s5, 20($sp)
	sw 	$s4, 16($sp)
	sw 	$s3, 12($sp)
	sw 	$s2, 8($sp)
	sw 	$s1, 4($sp)
	sw	$s0, 0($sp)
	
	la 	$s0, 0($a0)
	
	add	$s1, $s1, $s1
	add	$s1, $s1, $s1
	add	$s1, $s1, $s1

	ori	$s1, $s1, 0
	ori	$s1, $s1, 0
	ori	$s1, $s1, 0
	ori	$s1, $s1, 0
	
	lw	$s1, 0($a0)
	lw	$s1, 0($a0)
	lw	$s1, 0($a0)
	
	li	$s1, 0
	li	$s2, 0
	li	$s3, 0
	li	$s4, 0
	li	$s5, 0
	
	count:
		bge 	$s0, $a1, counted
		
		lw 	$s1, 0($s0)
		srl 	$s2, $s1, 26
		
		beq 	$s2, 0, rType
		beq 	$s2, 13, incrementOriCounter
		
		
		sll 	$s2, $s1, 26
		srl 	$s2, $s2, 26
		
		beq 	$s2, 32, incrementAddCounter
		
		incrementProgramPointer: 
			addi $s0, $s0, 4
			
		j 	count
	rType:
		
	
	increment:
		addi $s3, $s3,1
		
	counted: 
		move 	$v0, $s3		
		
		#deallocate memory
		lw 	$s0, 0($sp)
		lw 	$s1, 4($sp)
		lw 	$s2, 8($sp)
		lw 	$s3, 12($sp)
		lw 	$s4, 16($sp)
		lw 	$s5, 20($sp)
		
		addi 	$sp, $sp, 24
	
	return:
		jr $ra


.data


	prompt1: .asciiz "\nEnter a register number (1 to 32): "
	result: .asciiz "\nresult is: "	
	endline: .asciiz "\n"


