.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    ble a1, zero, exit_72
    ble a2, zero, exit_72
    ble a4, zero, exit_73
    ble a5, zero, exit_73
    bne a2, a4, exit_74

    # Prologue
    addi sp, sp, -40
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw ra, 36(sp)


    mv s0, a0   # pointer to start of m0
    mv s1, a1   # rows of m0
    mv s2, a2   # cols of m0
    mv s3, a3   # pointer to start of m1
    mv s4, a4   # rows of m1
    mv s5, a5   # cols of m1
    mv s6, a6   # pointer to the next to be stored
    li s7, 0    # row loop parameter i
    li s8, 0    # col loop parameter j
outer_loop_start:
    bge s7, s1, outer_loop_end

    j inner_loop_start


inner_loop_start:

    bge s8, s1, inner_loop_end
    mv a0, s0
    mv a1, s3
    mv a2, s2
    li a3, 1
    mv a4, s5
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal dot
    lw ra, 0(sp)
    addi sp, sp, 4
    sw a0, 0(s6)
    addi s6, s6, 4

    addi s8, s8, 1
    addi s3, s3, 4
    j inner_loop_start




inner_loop_end:

    li s8, 0
    addi s7, s7, 1
    li t0, 4
    mul t1, t0, s2
    add s0, s0, t1
    mul t1, t0, s5
    sub s3, s3, t1
    j outer_loop_start
    



outer_loop_end:


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw ra, 36(sp)   
    addi sp, sp, 40
    
    ret



exit_72:
    li a1, 72
    j exit2
exit_73:
    li a1, 73
    j exit2
exit_74:
    li a1, 74
    j exit2