.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -20
    sw s3, 0(sp)
    sw s4, 4(sp)
    sw s1, 8(sp)
    sw ra, 12(sp)
    sw s0, 16(sp)


    mv s0, a1   # pointer
    mv s3, a2   # rows
    mv s4, a3   # cols

    # open file
    mv a1, a0
    li t0, 1
    mv a2, t0
    jal fopen
    li t0, -1
    beq a0, t0, exit_93
    mv s1, a0    # file discriptor

    #allocate for row
    li a0, 4
    jal malloc
    sw s3, 0(a0)

    mv t2, a0

    mv a1, s1
    mv a2, a0
    li a3, 1
    li a4, 4
    addi sp, sp, -4
    sw t2, 0(sp)
    jal fwrite
    lw t2, 0(sp)
    addi sp, sp, 4
    li t0, 1
    bne a0, t0, exit_94

    # free 
    mv a0, t2
    jal free

    # allocate for col
    li a0, 4
    jal malloc
    sw s4, 0(a0)

    mv t2, a0

    mv a1, s1
    mv a2, a0
    li a3, 1
    li a4, 4
    addi sp, sp, -4
    sw t2, 0(sp)
    jal fwrite
    lw t2, 0(sp)
    addi sp, sp, 4

    li t0, 1
    bne a0, t0, exit_94

    # free 
    mv a0, t2
    jal free

    # write all
    mv a1, s1
    mv a2, s0
    mul t0, s3, s4
    mv a3, t0
    li a4, 4
    
    addi sp, sp, -4
    sw t0, 0(sp)
    jal fwrite
    lw t0, 0(sp)
    addi sp, sp, 4

    bne a0, t0, exit_94

    # close
    mv a1, s1
    jal fclose
    bne a0, zero, exit_95
    


    # Epilogue
    lw s3, 0(sp)
    lw s4, 4(sp)
    lw s1, 8(sp)
    lw ra, 12(sp)
    lw s0, 16(sp)
    addi sp, sp, 20

    ret


exit_93:
    li a1, 93
    j exit2

exit_94:
    li a1, 94
    j exit2

exit_95:
    li a1, 95
    j exit2