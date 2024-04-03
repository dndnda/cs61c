.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    #check if the length is positive
    li t0, 1
    ble t0, a1, no_exception
    li a1, 78
    j exit2

no_exception:
    mv t1, a0     # address of next array element
    mv t2, a1     # length of array
    li t3, 0    # temp i, the number of elements have been checked

loop_start:
    beq t2, t3, loop_end
    lw t4, 0(t1)
    bge t4, zero, loop_continue
    sw zero, 0(t1)


loop_continue:
    addi t3, t3, 1
    addi t1, t1, 4
    j loop_start


loop_end:
	ret
