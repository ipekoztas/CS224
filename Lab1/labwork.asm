.text
	
	la $a0,prompt1	
	li $v0,4	
	syscall
	
	li $v0, 5	
	syscall
	
	move $s0, $v0  #store the integer a in $s0
	
	la $a0,prompt2	
	li $v0,4	
	syscall
	
	li $v0, 5	
	syscall
	
	move $s1, $v0  #store b in $s0
	
	la $a0,prompt3	
	li $v0,4	
	syscall
	
	li $v0, 5	
	syscall
	
	move $s2, $v0  #store c in $s2
	
	la $a0,prompt4	
	li $v0,4	
	syscall
	
	li $v0, 5	
	syscall
	
	move $s3, $v0  #store d in $s3
	
	addi $t0, $s1, -3	# calculate b-3
	mul $t0, $t0, $s0	#calculate a*(b-3)

	#andi $s0, $s0, 0x0f	#get last four digits
	
	div $t0, $t0, $s2	#calculate a*(b-3)/c

	li $t3, 2
	div $s3, $t3
	mfhi $t1
	add $t2, $t0, $t1
	
	
	la $a0,result	# output prompt message on terminal
	li $v0,4	# syscall 4 prints the string
	syscall
	
	la $a0, ($t2)	#print the result
	li $v0, 1
	syscall
	
	
	
	.data

prompt1: .asciiz "Enter number a: \n"
prompt2: .asciiz "Enter number b: \n"
prompt3: .asciiz "Enter number c: \n"
prompt4: .asciiz "Enter number d: \n"
result: .asciiz"a * (b-3) /c + (d%2): "
