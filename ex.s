.text
li $t0, 100631167
li $t1, 0                                                              # initialize counter with 0
li $t3, 2147483648                                                          # mask for querying the left most bit

startforloop:
and $t4, $t3, $t0
beq $t4, $zero, incrementcounter                                     # check if t4 is 0 and increase counter if it is                                   
j end                                                                # jump to end since left most bit is 1

incrementcounter:
addi $t1, $t1, 1                                                            #increase counter by 1 
sll $t0, $t0, 1
j startforloop

end:  
move $a0, $t1                                                  # move to a0 the value of the counter