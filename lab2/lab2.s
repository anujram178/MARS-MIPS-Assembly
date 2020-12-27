#                                           ICS 51, Lab #2
# 
#                                          IMPORTATNT NOTES:
# 
#                       Write your assembly code only in the marked blocks.
# 
#                       DO NOT change anything outside the marked blocks.
#
#
j main
###############################################################
#                           Data Section
.data

new_line: .asciiz "\n"
space: .asciiz " "

fibonacci_label: .asciiz "\nTesting Fibonacci: fib(5), fib(7), fib(10)\n"
changecase_label: .asciiz "\nTesting Change Case: \n"
bcd_2_bin_lbl: .asciiz "\nBCD to Binary (Hexadecimal Values)\nExpected output:\n004CEF64 00BC614E 00008AE0\nObtained output:\n"
change_case_expected_output: .asciiz "Expected output:\nCashRulesEveryTHINGAroundMe\nObtained output:\n"
fibonacci_lbl: 	.asciiz "Expected output:\n5 13 55\nObtained output:\n"

change_case_input: .asciiz "cA+SH$$$___rU*LE S^^eVE@RY~~th~ing_aRO=/[]UND_mE:|"
change_case_output: .asciiz "cA+SH$$$___rU*LE S^^eVE@RY~~th~ing_aRO=/[]UND_mE:|"

bcd_2_bin_test_data: .word 0x05042020, 0x12345678, 0x35552

hex_digits: .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

fib_array: 
	.space	48

###############################################################
#                           Text Section
.text
# Utility function to print hexadecimal numbers
print_hex:
move $t0, $a0
li $t1, 8 # digits
lui $t2, 0xf000 # mask
mask_and_print:
# print last hex digit
and $t4, $t0, $t2 
srl $t4, $t4, 28
la    $t3, hex_digits  
add   $t3, $t3, $t4 
lb    $a0, 0($t3)            
li    $v0, 11                
syscall 
# shift 4 times
sll $t0, $t0, 4
addi $t1, $t1, -1
bgtz $t1, mask_and_print
exit:
jr $ra

###############################################################
###############################################################
###############################################################
#                            PART 1 (BCD to Binary)
# 
# You are given a 32-bits integer stored in $t0. This 32-bits
# present a BCD number. You need to convert it to a binary number.
# For example: 0x7654_3210 should return 0x48FF4EA.
# The result must be stored inside $t0 as well.
bcd2bin:
move $t0, $a0
############################ Part 1: your code begins here ###
li $t1, 15			# mask for querying first 4 bits
li $t3, 1			# initialize multiple of 10
li $t4, 0			# initialize output 
li $t6, 10			# to multiply counter by 10 each time

bcdWhileLoop:
beq $t0, $zero, endBcdWhileLoop
and $t2, $t0, $t1		# query first 4 bits
srl $t0, $t0, 4			# shift bits by 4 places and fill most sign bits with 0
j updateNumber

updateNumber:
mul $t2, $t2, $t3		# increase number 
mul $t3, $t3, $t6		# change 10
add $t4, $t4, $t2		# add number to output
j bcdWhileLoop

endBcdWhileLoop:
move $t0, $t4


############################ Part 1: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
#                            PART 2 (Fibonacci)
#
# 	The Fibonacci Sequence is the series of integer numbers:
#
#		0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ...

#	The next number is found by adding up the two numbers before it.
	
#	The 2 is found by adding the two numbers before it (1+1)
#	The 3 is found by adding the two numbers before it (1+2),
#	And the 5 is (2+3),
#	and so on!
#
# You should compute the 12 integer elements of fibonacci and put
# in array. The base address of this array is in $a0.
# 
fibonacci:
la $a0, fib_array
############################## Part 2: your code begins here ###
li $t0, 0		# 0th element
li $t1, 1		# first element
li $t2, 11		# number of items to be filled into fib_array
addi $t3, $a0, 8 	# address used for adding next number
li $t4, 0		# number to be added to fib_array

sw $t0, 0($a0)
sw $t1, 4($a0)

fibLoop:
beq $t2, $zero, endFibLoop
add $t4, $t0, $t1
move $t0, $t1
move $t1, $t4
sw $t4, 0($t3)
addi $t3, $t3, 4
addi $t2, $t2, -1
j fibLoop

endFibLoop:

############################## Part 2: your code ends here   ###
jr $ra

###############################################################
###############################################################
###############################################################
#                       PART 3 (Change Case)
#a0: input array
#a1: output array
###############################################################
change_case:
############################## Part 3: your code begins here ###
li $t1, 0x41			# hex for 'A'
li $t2, 0x5b			# hex for non alphabetical char after 'Z'
li $t3, 0x61			# hex for 'a'
li $t4, 0x7b			# hex for non alphabet after 'z'

changeCaseWhileLoop:
lb $t0, 0($a0)						# loading char into t0
beq $t0, $zero, endChangeCaseLoop			# end loop if t0 is zero
blt $t0, $t1, skipChar					
blt $t0, $t2, makeLowerCase				
blt $t0, $t3, skipChar
blt $t0, $t4, makeUpperCase
j skipChar

makeLowerCase:
addi $t0, $t0, 32				# make upper case char lower case by adding 32
addi $a0, $a0, 1				# add 1 to input pointer	
sb $t0, 0($a1)					# store character into output array
addi $a1, $a1, 1				# add 1 to output pointer
j changeCaseWhileLoop

makeUpperCase:
addi $t0, $t0, -32				# subtract 32 to make character upper case
addi $a0, $a0, 1				# add 1 to input pointer
sb $t0, 0($a1)					# store character into output array
addi $a1, $a1, 1				# add 1 to output pointer
j changeCaseWhileLoop

skipChar:
addi $a0, $a0, 1				# add 1 to input pointer, NOT output pointer because nothing is getting stored there
j changeCaseWhileLoop

endChangeCaseLoop:
sb $zero, 0($a1)				# add zero to string because null terminated string



############################## Part 3: your code ends here ###
jr $ra

###############################################################
###############################################################
###############################################################


#                          Main Function 
.globl main
main:
##############################################
##############################################
li $v0, 4
la $a0, new_line
syscall
la $a0, bcd_2_bin_lbl
syscall

# Testing part 1
li $s0, 3 # num of test cases
li $s1, 0
la $s2, bcd_2_bin_test_data

test_p1:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal bcd2bin

move $a0, $v0        # hex to print
jal print_hex

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p1

##############################################
##############################################
test_fibonacci:
li $v0, 4
la $a0, new_line
syscall
la $a0, fibonacci_label
syscall
jal fibonacci

li $v0, 4
la $a0, fibonacci_lbl
syscall

la $s0, fib_array

li $v0, 1
lw $a0, 20($s0)
syscall

li $v0, 4
la $a0, space
syscall

li $v0, 1
lw $a0, 28($s0)
syscall

li $v0, 4
la $a0, space
syscall

li $v0, 1
lw $a0, 40($s0)
syscall

###############################################################
###############################################################
# Test Change case function

li $v0, 4
la $a0, new_line
syscall
la $a0, changecase_label
syscall
# call the function
la $a0, change_case_input
la $a1, change_case_output
jal change_case
# print results
la $a0, change_case_expected_output
syscall
la $a0, change_case_output
syscall
la $a0, new_line
syscall

_end:
# end program
li $v0, 10
syscall

