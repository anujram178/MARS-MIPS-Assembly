j main
.data
.text



multiply_recur:
addi $t0, $a0, 0                               # storing the input into t0
addi $sp, $sp, -8                              # making space on the stack
sw $ra, 0($sp)                                   # storing ra into stack
blt $a0, $a1, if                                    # branch if x<y and return multiply_recur(y,x)
bnez $a1, elseif                                # if y !=0, return (x+ multiply_recur(x, y-1))
li $v0, 0                                           # return 0 otherwise
addi $sp, $sp, 8                             # restore stack since 0 is returned
jr $ra

if:
move $t1, $a1                            
move $a1, $a0                            # switching the inputs when x<y
move $a0, $t1
addi $sp, $sp, 8                             # restoring stack
j multiply_recur

elseif:
move $v0, $a0                                      #return x
sw $v0, 4($sp)                                         # storing return value on the stack 
addi $a1, $a1, -1                                      # making the call on y-1
jal multiply_recur
lw $ra, 0($sp)                                        # restore address
add $v0, $v0, $t0                                    
lw $t0, 4($sp)                                           # restore return value 
addi $sp, $sp, 8                                       # restore stack
jr $ra


jr $ra

main:
li $a0, 3
li $a1, 5
jal multiply_recur
move $a0, $v0

li $v0, 1
syscall