#CS224
#Lab 6.
#Section 1.
#İpek Öztaş
#22003250
#21.5.2023
		.text 
	.globl	__start
	
__start:

	jal main  
	li $v0, 10
	syscall
		
				
main: 
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	menu:
		jal displayMenu
		# Ask user to enter option
		li $v0, 4 
		la $a0, prompt
		syscall

		li $v0, 5 
		syscall
		
		#create an array with consecutive numbers
		beq $v0, 1, select1	
		# display desired element
		beq $v0, 2, select2		
		# sum array row wise
		beq $v0, 3, select3	
	 	# sum array column wise
	 	beq $v0, 4, select4
	    	#exit 
	    	beq $v0, 5, selectExit	

	    	
	   
 		select1:
 			li $v0, 4 
 			la $a0, promptDim
			syscall
			
			li $v0, 5 
			syscall
			
			move $s0, $v0 #N
			mul $s2, $s0, $s0 # N*N
			mul $a0, $s2, 4 # size
			#array allocation
			li $v0, 9 
			syscall 
			
			move $a1, $v0 #array address
			move $s1, $a1
			move $a0, $s2	#N*N
			jal consecutiveValues
 			j loopBack
 		select2:

 			li $v0, 4 
 			la $a0, enterRow
 			syscall 
 			
 			li $v0, 5
 			syscall
 			
 			move $t0, $v0 # row - $t0
 			
 			li $v0, 4 
 			la $a0, enterCol
 			syscall
 			 
 			li $v0, 5 
 			syscall
 			
 			move $a1, $v0 # column
 			
 			move $a0, $t0
 			
 			jal getItem
 			j loopBack
 		select3:
 			move $a0, $s0  #N
 			move $a1, $s1
 			# sum matrix row wise
 			jal sumMatrixRow
 			j loopBack
 		select4:
 			move $a0, $s2  #N*N
 			move $a1, $s1
 			# sum matrix column wise
 			jal sumMatrixCol
 			j loopBack

	    	loopBack:
	    		j menu	
	    selectExit: 
	   	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra 

getItem:

	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $s0, 4($sp) #no of elements (N)
	sw $s1, 8($sp)	#address
	sw $s2, 12($sp)	#size (N^2)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	

	move $s4, $a0 # row 
 	move $s3, $a1 # column

 	subi $s3, $s3, 1 # j-1
 	mul $s3, $s3, $s0 # (j-1) * N 
 	mul $s3, $s3, 4 # (j-1) * N * 4 byte wise
 	subi $s4, $s4, 1 # i-1
 	mul $s4, $s4, 4 # (i-1) * 4 
 	add $s3, $s3, $s4 # (j-1) * N * 4 + (i-1) * 4
 	
 	add $s5, $s3, $s1 # address

	li $v0, 4 
 	la $a0, showItem
	syscall
	
 	lw $a0, 0($s5)
 	li $v0, 1
 	syscall
 
 			
	
	lw $s5, 24($sp)
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 28
	jr $ra 
	




# summation of elements col-major
sumMatrixCol:

	addi $sp, $sp, -20 
	sw $ra, 0($sp)
	sw $s0, 4($sp)  #address
	sw $s1, 8($sp)	#size
	sw $s2, 12($sp)	#sum
	sw $s3, 16($sp) #temp
	
	move $s0, $a1
	move $s1, $a0
	move $s2, $0
	li $s3, 0
	
	sumItems:
		lw $s3, 0($s0)	#current item of the matrix
		add $s2, $s2, $s3
		addi $s0, $s0, 4 # next element of the matrix
		addi $s1, $s1, -1 # decrement index
		bne $s1, $zero, sumItems	#stop when there are no elements left to add

	
	li $v0, 4 
	la $a0, displaySum
	syscall
	
	move $a0, $s2
	li $v0, 1
	syscall 
	
	move $v0, $s2		
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20
	jr $ra 


sumMatrixRow:

	#save the address and size of the matrix
	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $s0, 4($sp) #no of elements (N)
	sw $s1, 8($sp)	#sum
	sw $s2, 12($sp)	#4N
	sw $s3, 16($sp) #address
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	
	move $s0, $a0
	move $s3, $a1 #address of the matrix
	li $s1, 0 
	mul $s2, $s0, 4 #4N
	
	li $s6, 0 #outer loop counter

	outerLoop2:
		bge $s6, $s0, outerLoopEnd2
		li $s7, 0 #inner loop counter
		move $s5, $s3
	
	innerLoop2:
		
		bge $s7, $s0, innerLoopEnd2
				
		lw $t1, 0($s3) # element
		
		add $s1, $s1, $t1
    		add $s3, $s3, $s2  #next row-columnwise
		addi $s7, $s7, 1
		b innerLoop2	
		
	innerLoopEnd2:
		addi $s6, $s6, 1
		move $s3, $s5
		addi $s3, $s3, 4
		b outerLoop2
		

	outerLoopEnd2:
	
	li $v0, 4 
	la $a0, displaySum
	syscall
	
	move $a0, $s1
	li $v0, 1
	syscall 
	move $v0, $s1
			
	
	lw $s7, 32($sp)
	lw $s6, 28($sp)
	lw $s5, 24($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 32
	jr $ra 

consecutiveValues:	
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)

	li $s2, 1 #array element
	move $s1, $a1	#address
	move $s0, $a0	#N
	fillArray:
		sw $s2, 0($s1) 
		addi $s2, $s2, 1
		addi $s1, $s1, 4 
		addi $s0, $s0, -1
		bne $s0, 0, fillArray
		
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	jr $ra 


displayMenu:

	addi $sp, $sp, -4 
	sw $ra, 0($sp)
	li $v0, 4 
	
	la $a0, menudisp
	syscall
	
	la $a0, menu2
	syscall
	la $a0, menu3
	syscall
	la $a0, menu5
	syscall
	la $a0, menu6
	syscall
	la $a0, menuExit
	syscall 
	lw $ra, 0($sp) 
	addi $sp, $sp, 4
	jr $ra 




	




		.data 

prompt:	.asciiz "Please choose an option:  "
menudisp: .asciiz " \n MENU \n"

menu2: .asciiz " 1) Create matrix (NxN) initialized with consecutive values \n"
menu3: .asciiz " 2) Display desired element of the matrix by row*column \n"
menu5: .asciiz " 3) Obtain summation of matrix elements row-major (row by row) summationse\n"
menu6: .asciiz " 4) Obtain summation of matrix elements column-major (column by column)summation \n"
menuExit: .asciiz " 5) Exit \n"

enterRow: .asciiz "Please enter Row number i: \n " 
enterCol: .asciiz "Please enter Column number j: \n " 
showItem: .asciiz "Item in the given row and column is :  " 
promptDim: .asciiz "Enter the matrix dimension N of (NxN) matrix: " 
displaySum:  .asciiz "\n Sum is : "


line: .asciiz "\n"
space: .asciiz " "
