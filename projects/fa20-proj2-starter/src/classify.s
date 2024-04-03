.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>


    li t0, 5
    bne a0, t0, exit_89

    addi sp, sp, -44
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw ra, 40(sp)


    lw s0, 4(a1)   # M0_PATH
    lw s1, 8(a1)   # M1_PATH
    lw s2, 12(a1)  # INPUT_PATH
    lw s3, 16(a1)  # OUTPUT_PATH
    mv s4, a2     # flag to print


	# =====================================
    # LOAD MATRICES
    # =====================================

    #malloc for row and col pointer
    li a0, 24
    jal malloc
    beq a0, zero, exit_88
    mv s5, a0    # p[0] -> m0_row; p[1] ->m0_col; p[2] -> m1_row; p[3] -> m1_col; p[4] ->input_row; p[5] -> input_col

    # load m0
    mv a0, s0
    mv a1, s5
    addi a2, s5, 4

    jal read_matrix
    mv s6, a0    # pointer to the m0 array


    # load m1
    mv a0, s1
    addi a1, s5, 8
    addi a2, s5, 12

    jal read_matrix
    mv s7, a0    # pointer to the m1 array

    # load input
    mv a0, s2
    addi a1, s5, 16
    addi a2, s5, 20

    jal read_matrix
    mv s8, a0    # pointer to the input array



    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # m0 * input

    # allocate for hidden_layer
    lw t0, 0(s5)
    lw t1, 20(s5)
    mul t2, t0, t1    # number of items
    li t0, 4
    mul a0, t2, t0    # number of bytes
    jal malloc
    beq a0, zero, exit_88

    mv s9, a0      # pointer to hidden_layer


    mv a0, s6
    lw a1, 0(s5)
    lw a2, 4(s5)
    mv a3, s8
    lw a4, 16(s5)
    lw a5, 20(s5)
    mv a6, s9

    jal matmul

    # relu(hidden_layer) # Recall that relu is performed in-place
    lw t0, 0(s5)
    lw t1, 20(s5)
    mul a1, t0, t1    # number of items   
    mv a0, s9
    jal relu

    # allocate for scores
#    lw t0, 8(s5)
#    lw t1, 20(s5)
 #   mul t2, t0, t1    # number of items
  #  li t0, 4
   # mul t2, t2, t0    # number of bytes
  #  addi sp, sp, -4
  #  sw t2, 0(sp)
  #  mv a0, t2
  #  jal malloc
  #  lw t2, 0(sp)
  #  addi sp, sp, 4
  #  beq a0, zero, exit_88
    li a0, 80
    jal malloc
    beq a0, x0, exit_88
    mv s0, a0        # pointer to output

    # scores = matmul(m1, hidden_layer)
    mv a0, s7
    lw a1, 8(s5)
    lw a2, 12(s5)
    mv a3, s9
    lw a4, 0(s5)
    lw a5, 20(s5)
    mv a6, s0

    jal matmul  

    # write output to output file
    mv a0, s3
    mv a1, s0
    lw a2, 8(s5)
    lw a3, 20(s5)  
    jal write_matrix

    # call argmax
    #lw t0, 8(s5)
    #lw t1, 20(s5)
    #mul t2, t0, t1    # number of items   
    #mv a0, s0
    #mv a1, t2
    mv a0, s0
    li a1, 10
    jal argmax
    mv s1, a0
    
    bne s4, zero, no_print
    mv a1, s1
    jal print_int

    li a1 '\n'
    jal print_char


no_print:

    # free memory
    mv a0, s5
    jal free
    mv a0, s9
    jal free
    mv a0, s0
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free
    mv a0, s8
    jal free

    mv a0, s1
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw ra, 40(sp)
    addi sp, sp, 44

    ret




exit_89:
    li a1, 89
    j exit2

exit_88:
    li a1, 88
    j exit2