
	.text
main:
	# Open file for reading

	la   $a0, src_file    # Souce file name
	li   $a1, 0           # For Read Mode
	li   $a2, 0           
	li   $v0, 13          # Open file
	syscall               # open a file 
	
	move $s0, $v0         # File Descriptor in $s0

	beq  $s0, -1, msg

	# reading from file just opened
	move $a0, $s0       	# Loading file descriptor 
	la   $a1, buffer    	# Base address of target 
	li   $a2,  10000     # Maximum size
	li   $v0, 14        	# Reading from file
	
	syscall             	


	# Printing File Content
	la  $a0, buffer     	# Loading buffer for printing
	li  $v0, 4          	# system Call for PRINT STRING
	syscall             	# print int
	
	# Calculating number of words, characters
	la   $t0, buffer
	li   $t1, 0				# Total characters
	li   $t2, 0				# Alphabet count
	li   $t3, 0				# Digit count
	li   $t4, 0				# Other count
	li   $t5, 0				# Words Count

	# Finding number of alphabets, digits, words and other characters
	
pro_loop:
	lb   $t6, ($t0)			# $t6 is the temporary register to hold the character
	
	blt  $t6, 'A', check_digit
	bgt  $t6, 'Z', try_lower
	add  $t2, $t2, 1
	b next_part
	
try_lower:
	blt  $t6, 'a', check_other
	bgt  $t6, 'z', check_other
	add  $t2, $t2, 1
	b next_part
	
check_digit:
	blt  $t6, '0', check_other
	bgt  $t6, '9', check_other
	add  $t3, $t3, 1
	b next_part
	
check_other:
	beq $t6, ' ', check_word
	add $t4, $t4, 1
	b next_part
	
check_word:
	add $t5, $t5, 1
	
next_part:
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	bne  $t6, 0, pro_loop
	
	la   $a0, char_count
	li   $v0, 4
	syscall
	
	move $a0, $t1
	li   $v0, 1
	syscall
	
	la   $a0, alpha_count
	li   $v0, 4
	syscall
	
	move $a0, $t2
	li   $v0, 1
	syscall
	
	la   $a0, digit_count
	li   $v0, 4
	syscall
	
	move $a0, $t3
	li   $v0, 1
	syscall
	
	la   $a0, other_count
	li   $v0, 4
	syscall
	
	move $a0, $t4
	li   $v0, 1
	syscall
	
	la   $a0, word_count
	li   $v0, 4
	syscall
	
	move $a0, $t5
	li   $v0, 1
	syscall
	
	b end_part

msg:
	la  $a0, file_not_found_message
	li	$v0, 4
	syscall
	
end_part:

	jr  $ra

.data  
src_file: 
	.asciiz "e:\\abc.txt"      # Input file name and path
char_count:
	.asciiz "\nCharacter = "
alpha_count:
	.asciiz "\nAlphabet = "
digit_count:
	.asciiz "\nDigits = "
other_count:
	.asciiz "\nOthers = "
word_count:
	.asciiz "\nWords = "
buffer: 
	.space 10000
	
file_not_found_message:
	.asciiz "Unable to open the file. Please check you spelled correct file-name and path.." 
