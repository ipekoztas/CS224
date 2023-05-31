		.text
main:
	la $a0, welcome
	li $v0, 4
	syscall
	
num_elements:	
	la $a0, prompt1	
	li $v0,4
	syscall		

	li $v0,5	
	syscall	
	move $s0, $v0
	bne $s0, $zero, cont 

error:
	la $a0, error_msg	
	li $v0,4	
	syscall	
	j num_elements		 

cont:
	move $a0, $s0
	jal createLinkedList
	move $s0, $v0	#address of the list
	
	move $a0, $s0	
	jal printLinkedList
	
	la	$a0, prompt_x
	li 	$v0, 4
	syscall
	
	li $v0, 5           # syscall to read integer
    	syscall
    	move $a1, $v0
    	move $a0, $s0
    	
    	jal CopyAllExcept_x	#$a0 address $a1 x value
    	move $s0 ,$v0 	#address of the new list
    	move $s1, $v1	#number of nodes
    	
 	bne $s1, $0, notEmptyList
 	la $a0, emptyList
    	li $v0, 4
    	syscall
    	j exit
  
notEmptyList:
  	
    	move $a0, $s0
    	jal printLinkedList
    	
    	la $a0, result
    	li $v0, 4
    	syscall
    	
    	move $a0, $s1
    	li $v0, 1
    	syscall
	
exit:	li $v0, 10
	syscall

	
	

#Subprogram to copy a linked list to a new list, except for a given value


CopyAllExcept_x:
	addi	$sp, $sp, -32
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move $s0, $a0
	move $s6, $a1
	
	li	$s4, 0		# $s1: Node counter
firstNode:
	beq $s0, $0, Done
	lw $s1, 0($s0)	#next node
	lw $s5, 4($s0)	#data
	bne $s5, $s6, addFirstNode
	move $s0, $s1 
	j firstNode
	
addFirstNode:

# Create the first node: header.
# Each node is 8 bytes: link field then data field.
	li	$a0, 8
	li	$v0, 9
	syscall
	addi $s4, $s4, 1
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
	sw $s5, 4($s2) 
	lw $s1, 0($s0)
	move $s0, $s1 
	
copyNode:
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
	beq	$s0, $0, Done
	lw $s1, 0($s0)	#next node
	lw $s5, 4($s0)	#data
	bne $s5, $s6, copy
	move $s0, $s1 
	j copyNode
	
copy:	addi	$s4, $s4, 1	# Increment node counter.
	li	$a0, 8 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.
	sw $s5, 4($s2) 
	move $s0, $s1 
	j copyNode	

	
Done:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.
	
	beq $s2, $0, empty
	sw $zero, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
empty:	move  $v1, $s4
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	addi	$sp, $sp, 32
	
	jr	$ra
	

createLinkedList:
# $a0: No. of nodes to be created ($a0 >= 1)
# $v0: returns list head
# Node 1 contains 4 in the data field, node i contains the value 4*i in the data field.
# By 4*i inserting a data value like this
# when we print linked list we can differentiate the node content from the node sequence no (1, 2, ...).
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move	$s0, $a0	# $s0: no. of nodes to be created.
	li	$s1, 1		# $s1: Node counter
# Create the first node: header.
# Each node is 8 bytes: link field then data field.
	li	$a0, 8
	li	$v0, 9
	syscall
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
	
	
	la $a0,prompt2	
	li $v0,4	
	syscall		
	
	li $v0, 5	
	syscall		

	sw $v0, 4($s2) 
	
addNode:
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
	beq	$s1, $s0, allDone
	addi	$s1, $s1, 1	# Increment node counter.
	li	$a0, 8 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.
	la $a0,prompt2	
	li $v0,4	
	syscall		
	
	li $v0, 5	  
	syscall		

	sw $v0, 4($s2) 	
	j	addNode
allDone:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.
	sw	$zero, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra


printLinkedList:
# Print linked list nodes in the following format
# --------------------------------------
# Node No: xxxx (dec)
# Address of Current Node: xxxx (hex)
# Address of Next Node: xxxx (hex)
# Data Value of Current Node: xxx (dec)
# --------------------------------------

# Save $s registers used
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

# $a0: points to the linked list.
# $s0: Address of current
# s1: Address of next
# $2: Data of current
# $s3: Node counter: 1, 2, ...
	move $s0, $a0	# $s0: points to the current node.
	li   $s3, 0
printNextNode:
	beq	$s0, $zero, printedAll
				# $s0: Address of current node
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	addi	$s3, $s3, 1
# $s0: address of current node: print in hex.
# $s1: address of next node: print in hex.
# $s2: data field value of current node: print in decimal.
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	

# Now consider next node.
	move	$s0, $s1	# Consider next node.
	j	printNextNode
printedAll:
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
	
	 		
	.data
welcome:	.asciiz "Welcome to the program recursive print in reverse order"
prompt1:	.asciiz "\nEnter the number of elements you wnat in your linked list: "
prompt_x:	.asciiz "\n Enter x value: "

error_msg:   .asciiz "Number of elements should be greater than 0! \n"

prompt2:   .asciiz "Enter list element: \n"

line:	
	.asciiz "\n --------------------------------------"

nodeNumberLabel:
	.asciiz	"\n Node No.: "
	
addressOfCurrentNodeLabel:
	.asciiz	"\n Address of Current Node: "
	
addressOfNextNodeLabel:
	.asciiz	"\n Address of Next Node: "
	
dataValueOfCurrentNode:
	.asciiz	"\n Data Value of Current Node: "
result:	.asciiz "\n Number of nodes in the new linked list is: "

emptyList: .asciiz "\n Linked list is empty"