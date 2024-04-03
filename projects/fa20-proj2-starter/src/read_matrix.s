.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
	

    mv s0, a0   # pointer to the filename
    mv s1, a1   # pointer to the row num
    mv s2, a2   # pointer to the col num
    mv s3, ra

    # open the file
    mv a1, s0
    li a2, 0
    jal fopen
    li t0, -1
    beq a0, t0, exit_90
    mv s4, a0   # discriptor to the opening file

    # read the row num
    mv a1, s4
    mv a2, s1
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, exit_91

    # read the col num
    mv a1, s4
    mv a2, s2
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, exit_91

    # total word to read
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul t3, t0, t1  
    li t1, 4
    mul t3, t3, t1   # total bytes to read

    addi sp, sp, -4
    sw t3, 0(sp)

    # allocate memory
    mv a0, t3
    jal malloc

    lw t3, 0(sp)
    addi sp, sp, 4
    beq a0, zero, exit_88

    mv s5, a0      # pointer to return  

    # read total bytes 
    mv a2, a0
    mv a1, s4
    mv a3, t3
    addi sp, sp, -4
    sw t3, 0(sp)
    jal fread
    lw t3, 0(sp)
    addi sp, sp, 4
    bne a0, t3, exit_91   

    #close the file
    mv a1, s4
    jal fclose
    bne a0, zero, exit_92

    mv a0, s5


    # Epilogue
    mv ra s3 
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    addi sp, sp, 24


    ret

exit_88:
    li a1, 88
    j exit2

exit_90:
    li a1, 90
    j exit2

exit_91:
    li a1, 91
    j exit2

exit_92:
    li a1, 92
    j exit2

