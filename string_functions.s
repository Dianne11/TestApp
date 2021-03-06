##############################################################################
#
#  COURSE: CMSC 132 -  Computer Architecture
#	
#  DATE: 	April 18, 2017
#
#  NAME:				
#
#  NAME:	
#
##############################################################################

	.data
	
ARRAY_SIZE:
	.word	10	# Change here to try other values (less than 10)
FIBONACCI_ARRAY:
	.word	1, 1, 2, 3, 5, 8, 13, 21, 34, 55
STR_str:
	#.asciiz "A string of characters..."
	.asciiz "Hunden, Katten, Glassen"
	#.asciiz "Some characters and a string"
	#.asciiz "Dianne, Denia, Divine Rose, Dale Denver"

	.globl DBG
	.text

##############################################################################
#
# DESCRIPTION:  For an array of integers, returns the total sum of all
#		elements in the array.
#
# INPUT:        $a0 - address to first integer in array.
#		$a1 - size of array, i.e., numbers of integers in the array.
#
# OUTPUT:       $v0 - the total sum of all integers in the array.
#
##############################################################################
integer_array_sum:  

DBG:	##### DEBUGG BREAKPOINT ######

        addi    $v0, $zero, 0           # Initialize Sum to zero.
		add		$t0, $zero, $zero		# Initialize array index i to zero.
	
for_all_in_array:

	#### Append a MIPS-instruktion before each of these comments
	
		beq		$t0, $a1, end_for_all	# Done if i == N
		sll 	$t4, $t0, 2				# 4*i
		add 	$t3, $a0, $t4			# address = ARRAY + 4*i
		lw 		$t5, 0($t3)				# n = A[i]
       	add 	$v0, $v0, $t5			# Sum = Sum + n
        addi 	$t0, $t0, 1				# i++ 
  		j 		for_all_in_array		# next element
	
end_for_all:
	
	jr	$ra			# Return to caller.
	
##############################################################################
#
# DESCRIPTION: Gives the length of a string.
#
#       INPUT: $a0 - address to a NUL terminated string.
#
#      OUTPUT: $v0 - length of the string (NUL excluded).
#
#    EXAMPLE:  string_length("abcdef") == 6.
#
##############################################################################	
string_length:

    addi    $v0, $zero, 0      # Initialize Length to zero.
	add	    $t0, $zero, $zero	# Initialize counter to zero.
	lb $t1,STR_str			# loads the first character in STR_str with offset $t0 into $t1

next_char:

	#### Append a MIPS-instruktion before each of these comments
	beq $t1,0x00,null_found		# Done if t1 encounters a null character
       addi $t0,$t0,1			# increment the counter
	   lb $t1,STR_str($t0)		# loads the next character in STR_str with offset $t0
  	j next_char					# next element
	
null_found:
	move $v0,$t0
	jr	$ra
	
##############################################################################
#
#  DESCRIPTION: For each of the characters in a string (from left to right),
#		call a callback subroutine.
#
#		The callback suboutine will be called with the address of
#	        the character as the input parameter ($a0).
#	
#        INPUT: $a0 - address to a NUL terminated string.
#
#		$a1 - address to a callback subroutine.
#
##############################################################################	
string_for_each:

	addi	$sp, $sp, -4		# PUSH return address to caller
	sw	$ra, 0($sp)
	

	#### Write your solution here ####
	addi $t6,$zero,0x00				#initialize a counter(for offset)
	
loop:
    add $a0, $a0,$t6                # Load address of next character
	lb $t0, 0($a0)               	# Get current character
    beq $t0, $zero, end_loop   		# Done when reaching NULL character
    jalr $a1                        # Call callback subroutine
	la $a0,STR_str					# Reload address of the string
									#(could have been changed by subroutine)
	addi $t6,$t6,1					# Increment the offset by 1			
    
	j loop						# next character
	
	end_loop:
	###########end_of_solution###########
	
	lw	$ra, 0($sp)		# Pop return address to caller
	addi	$sp, $sp, 4		

	jr	$ra
##############################################################################
#
#  DESCRIPTION: Transforms a lower case character [a-z] to upper case [A-Z].
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################		
to_upper:

	#### Write your solution here ####
	
	lb $t0,0($a0)				#loads the character from the string in $a0

	blt $t0,'a', ignore_case	#if character is less than 97, it is ignored in the next steps
	bgt $t0, 'z',ignore_case	#if character is greater than 122, it is ignored in the next steps
	
	sub $t0,$t0,32				#character is subtracted by 32 to get its uppercase equivalent
	sb $t0,0($a0)					#stores the content of $t0 back to $a0
	
	ignore_case:
	###########end_of_solution###########
	jr	$ra

##############################################################################
#
#  DESCRIPTION: reverses an input string such as "MIPS" to "SPIM".
#	
#        INPUT: $a0 - address of a NUL terminated string
#				$a1 - length of the string
#
##############################################################################		
reverse_string:

	#### Write your solution here ####
	add $t0,$a0,$zero  		#starting address loaded to t0
    add $t1,$zero,$zero     # left counter = 0
    addi $t2,$a1,-1     	# right counter = length-1

next_swap:
    add $t3,$t0,$t1			# index for left = $t0 + $t1
    lb $t4,0($t3)   		# load the current left character
    add $t5,$t0,$t2			# index for right = $t0 + $t2
    lb $t6,0($t5)   		# load the current right character
    sb $t4,0($t5)   		# string[j] = string[i]
    sb $t6,0($t3)   		# string[i] = string[j]
    addi $t1,$t1,1 			# increment left counter; $t1++
    addi $t2,$t2,-1     	# decrement right counter; $t2--

    slt $t6,$t2,$t1			# 0 if t1 < t2, 1 if t2 < t1
    beq $t6,$zero,next_swap	#goes to next swap as long as left counter < right counter

	###########end_of_solution###########
	jr	$ra
	
	
##############################################################################
##############################################################################
##
##	  You don't have to change anything below this line.
##	
##############################################################################
##############################################################################

	
##############################################################################
#
# Strings used by main:
# 
##############################################################################

	.data

NLNL:	.asciiz "\n\n"
	
STR_sum_of_fibonacci_a:	
	.asciiz "The sum of the " 
STR_sum_of_fibonacci_b:
	.asciiz " first Fibonacci numbers is " 

STR_string_length:
	.asciiz	"\n\nstring_length(str) = "

STR_for_each_ascii:	
	.asciiz "\n\nstring_for_each(str, ascii)\n"

STR_for_each_to_upper:
	.asciiz "\n\nstring_for_each(str, to_upper)\n\n"

STR_for_reverse:
	.asciiz "\n\nstring_for_reverse(str, reverse)\n\n"
	

	.text
	.globl main

##############################################################################
#
# MAIN: Main calls various subroutines and print out results.
#
##############################################################################	
main:
	addi	$sp, $sp, -4	# PUSH return address
	sw	$ra, 0($sp)

	##
	### integer_array_sum
	##
	
	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_a
	syscall

	lw 	$a0, ARRAY_SIZE
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_b
	syscall
	
	la	$a0, FIBONACCI_ARRAY
	lw	$a1, ARRAY_SIZE
	jal 	integer_array_sum

	# Print sum
	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, NLNL
	syscall
	
	la	$a0, STR_str
	jal	print_test_string

	##
	### string_length 
	##
	
	li	$v0, 4
	la	$a0, STR_string_length
	syscall

	la	$a0, STR_str
	jal 	string_length

	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	##
	### string_for_each(string, ascii)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_ascii
	syscall
	
	la	$a0, STR_str
	la	$a1, ascii
	jal	string_for_each

	##
	### string_for_each(string, to_upper)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_to_upper
	syscall

	la	$a0, STR_str
	la	$a1, to_upper
	jal	string_for_each
	
	la	$a0, STR_str
	jal	print_test_string

	##
	### reverse_string(string, reverse)
	##
	
	li	$v0, 4
	la	$a0, STR_for_reverse
	syscall

	la	$a0, STR_str
	jal 	string_length
	
	la	$a0, STR_str
	add	$a1, $v0, $zero
	jal	reverse_string
	
	la	$a0, STR_str
	jal	print_test_string
	
	lw	$ra, 0($sp)	# POP return address
	addi	$sp, $sp, 4	
	
	jr	$ra

##############################################################################
#
#  DESCRIPTION : Prints out 'str = ' followed by the input string surronded
#		 by double quotes to the console. 
#
#        INPUT: $a0 - address to a NUL terminated string.
#
##############################################################################
print_test_string:	

	.data
STR_str_is:
	.asciiz "str = \""
STR_quote:
	.asciiz "\""	

	.text

	add	$t0, $a0, $zero
	
	li	$v0, 4
	la	$a0, STR_str_is
	syscall

	add	$a0, $t0, $zero
	syscall

	li	$v0, 4	
	la	$a0, STR_quote
	syscall
	
	jr	$ra
	

##############################################################################
#
#  DESCRIPTION: Prints out the Ascii value of a character.
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################
ascii:	
	.data
STR_the_ascii_value_is:
	.asciiz "\nAscii('X') = "

	.text

	la	$t0, STR_the_ascii_value_is

	# Replace X with the input character
	
	add	$t1, $t0, 8	# Position of X
	lb	$t2, 0($a0)	# Get the Ascii value
	sb	$t2, 0($t1)

	# Print "The Ascii value of..."
	
	add	$a0, $t0, $zero 
	li	$v0, 4
	syscall

	# Append the Ascii value
	
	add	$a0, $t2, $zero
	li	$v0, 1
	syscall


	jr	$ra
	