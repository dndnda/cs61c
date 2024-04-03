.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    li t0, 1
    bge a2, t0, no_len_exception
    li a1, 75
    j exit2


no_len_exception:
    bge a3, t0, no_exception1
    li a1, 76
    j exit2

no_exception1:
    bge a4, t0, no_exception
    li a1, 76
    j exit2
no_exception:
    li t0, 0   # num of elements have been checked
    li t1, 0   # sum

    li t5, 4
    li t6, 4
    mul t5, t5, a3
    mul t6, t6, a4

loop_start:
    bge t0, a2, loop_end
    lw t2, 0(a0)
    lw t3, 0(a1)
    mul t4, t2, t3
    add t1, t1, t4
    addi t0, t0, 1
    add a0, a0, t5
    add a1, a1, t6
    j loop_start

loop_end:
    mv a0, t1
    ret
