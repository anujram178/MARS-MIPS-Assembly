#                         ICS 51, Lab #3
#
#      IMPORTANT NOTES:
#
#      Write your assembly code only in the marked blocks.
#
#      DO NOT change anything outside the marked blocks.
#
###############################################################
#                           Data Section
j main
.data

new_line: .asciiz "\n"
space: .asciiz " "
i_str: .asciiz "Program input: " 
po_str: .asciiz "Obtained output: " 
eo_str: .asciiz "Expected output: "
t2_str: .asciiz "Testing fibonacci_recur: \n"
t3_str: .asciiz "Testing GCD: \n"
dump_str: .asciiz "Testing dump_file: \n" 

num_numeric_tests:          .word 8

numerical_inputs:           .word       0, 1, 2, 3, 6, 9 , 10, 13
fibonacci_recur_expected_outputs: .word 0, 1, 1, 2, 8, 34, 55, 233

gcd_inputs:                 .word 1, 12, 4, 79322, 1378, 75, 28300, 74000
gcd_expected_outputs:       .word     1, 4,     2,     2, 1,     25,  100 

file_read_lbl1: .asciiz "\nI love ics 51.\nI am so glad that I am taking ics 51..\n"
file_read_lbl2:	.asciiz	"And I love assembly language even more than java or c or pyhton...\n"
file_read_lbl3: .asciiz "Because it is such fun....:D)\n4\n"

file_name:
	.asciiz	"lab3_data.dat"	# File name
	.word	0
read_buffer:
	.space	300			# Place to store character


###############################################################
#                           Text Section
.text
# Utility function to print integer arrays
#a0: array
#a1: length
print_array:

li $t1, 0
move $t2, $a0
print:

lw $a0, ($t2)
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $t2, $t2, 4
addi $t1, $t1, 1
blt $t1, $a1, print
jr $ra

###############################################################
###############################################################
###############################################################
#                           PART 1 (Fibonacci_recur)
#a0: input number
###############################################################
fibonacci_recur:
############################### Part 1: your code begins here ##
addi $sp, $sp, -12
sw $ra, 0($sp)
sw $a0, 4($sp)
bgt $a0, 1, elseFib
bne $a0, $zero, elseif
li $v0, 0			# return 0 or 1
addi $sp, $sp, 12		# restore stack
jr $ra

elseif:
li $v0, 1
addi $sp, $sp, 12		# restore stack
jr $ra

elseFib:
addi $a0, $a0, -1		# x-1
jal fibonacci_recur
lw $a0, 4($sp)
sw $v0, 8($sp)
addi $a0, $a0, -2		# x-2
jal fibonacci_recur
lw $t0, 8($sp)
add $v0, $t0, $v0		# return fib(x-1) + fib(x-2)
lw $ra, 0($sp)
addi $sp, $sp, 12
jr $ra


############################### Part 1: your code ends here  ##
jr $ra

###############################################################
###############################################################
###############################################################
#                           PART 2 (GCD)
#a0: input number
#a1: input number
###############################################################
gcd:
############################### Part 2: your code begins here ##
addi $sp, $sp, -4
sw $ra, 0($sp)			# store return address
bnez $a1, else
addi $v0, $a0, 0 		# storing a into v0 
addi $sp, $sp, 4		# restore stack
jr $ra
else:
div $t0, $a0, $a1
mfhi $t1			# t1 contains a mod b
move $a0, $a1
move $a1, $t1
jal gcd
lw $ra, 0($sp)			# restore return address
addi $sp, $sp, 4		# restore stack
jr $ra

############################### Part 2: your code ends here  ##
jr $ra

###############################################################
###############################################################
###############################################################
#                           PART 3 (SYSCALL: read a file, print)
#
# You will read characters (bytes) from a file (lab3_data.dat) and print them.
# You should print strings of each line from the file and print number of lines read.
# file_name : the array that stores the file name
# read_buffer : the arrary that you use to hold string (MAXIMUM: 300 bytes)
#
dump_file:
############################### Part 3: your code begins here ##
li   $v0, 13          # system call for open file
la   $a0, file_name      # input file name
li   $a1, 0           # flag for reading
li   $a2, 0           # mode is ignored
syscall               # open a file 
move $s0, $v0         # save the file descriptor  


# reading from file just opened

li   $v0, 14        # system call for reading 
move $a0, $s0       # file descriptor 
la   $a1, read_buffer    # address of buffer to read
li   $a2,  300       # hardcoded buffer length
syscall             # read from file


# Printing File Content
li  $v0, 4         
la  $a0, read_buffer     # buffer 
syscall             # print int

li $v0, 1
li $a0, 5
syscall

li $v0, 10      # Finish the Program
syscall


############################### Part 3: your code ends here   ##
jr $ra

###############################################################
###############################################################
###############################################################

#                          Main Function
main:

###############################################################
# Test fibonacci_recur function
li $v0, 4
la $a0, t2_str
syscall

la $a0, i_str
syscall
li $s0, 0 # used to index current test input
la $s1, num_numeric_tests
lw $s1, 0($s1)  # number of tests
la $s2, numerical_inputs
move $a0, $s2
move $a1, $s1
jal print_array
la $a0, new_line
syscall


la $a0, eo_str
syscall
li $s0, 0 # used to index current test input
la $s1, num_numeric_tests
lw $s1, 0($s1)  # number of tests
la $s2, fibonacci_recur_expected_outputs
move $a0, $s2
move $a1, $s1
jal print_array
la $a0, new_line
syscall


la $a0, po_str
syscall

la $s2, numerical_inputs
test_fibonacci_recur:
bge $s0, $s1, end_test_fibonacci_recur
# call the function
lw $a0, 0($s2)
jal fibonacci_recur
# print results
move $a0, $v0
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $s0, $s0, 1
addi $s2, $s2, 4
j test_fibonacci_recur


end_test_fibonacci_recur:
la $a0, new_line
syscall
syscall
###############################################################
# Test GCD function
li $v0, 4
la $a0, t3_str
syscall

la $a0, i_str
syscall
li $s0, 0 # used to index current test input
la $s1, num_numeric_tests
lw $s1, 0($s1)  # number of tests
la $s2, gcd_inputs
move $a0, $s2
move $a1, $s1
jal print_array
la $a0, new_line
syscall


la $a0, eo_str
syscall
li $s0, 0 # used to index current test input
la $s1, num_numeric_tests
lw $s1, 0($s1)  # number of tests
addi $s1, $s1, -1 # tests are in pairs
la $s2, gcd_expected_outputs
move $a0, $s2
move $a1, $s1
jal print_array
la $a0, new_line
syscall


la $a0, po_str
syscall

la $s2, gcd_inputs

test_gcd:
bge $s0, $s1, end_test_gcd
# call the function
lw $a0, 0($s2)
lw $a1, 4($s2)
jal gcd
# print results
move $a0, $v0
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $s0, $s0, 1
addi $s2, $s2, 4
j test_gcd


end_test_gcd:
la $a0, new_line
syscall

###############################################################
# Test dump_file function
li $v0, 4
la $a0, new_line
syscall
la $a0, dump_str
syscall

la $a0, eo_str
syscall
la $a0, file_read_lbl1
syscall
la $a0, file_read_lbl2
syscall
la $a0, file_read_lbl3
syscall

la $a0, po_str
syscall
la $a0, new_line
syscall
jal dump_file

_end:
# end program
li $v0, 10
syscall
