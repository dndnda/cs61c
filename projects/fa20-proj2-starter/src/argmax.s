.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    li t0, 1
    bge a1, t0, no_exception
    li a1, 77
    j exit2
    # Prologue
no_exception:
    lw t0, 0(a0)   # the largest number
    li t1, 0    # index of the largest number
    li t2, 1    # num of the elements have been traversed
    addi a0, a0, 4

loop_start:
    bge t2, a1, loop_end
    lw t3, 0(a0)
    bge t0, t3, loop_continue
    mv t0, t3
    mv t1, t2

loop_continue:
    addi t2, t2, 1
    addi a0, a0, 4

loop_end:
    mv a0, t1
    ret
