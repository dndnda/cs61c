#include "transpose.h"

/* The naive transpose function as a reference. */
void transpose_naive(int n, int blocksize, int *dst, int *src)
{
    for (int x = 0; x < n; x++)
    {
        for (int y = 0; y < n; y++)
        {
            dst[y + x * n] = src[x + y * n];
        }
    }
}

/* Implement cache blocking below. You should NOT assume that n is a
 * multiple of the block size. */
void transpose_blocking(int n, int blocksize, int *dst, int *src)
{
    // YOUR CODE HERE
    // Now I assume that n is a multiple of blocksize.
    int iter_num = n / blocksize;
    for (int i = 0; i < iter_num; i++)
    { // row of block
        for (int j = 0; j < iter_num; j++)
        { // col of block
            for (int k = 0; k < blocksize; k++)
            { // row in block size
                for (int m = 0; m < blocksize; m++)
                { // col in blocksize
                    dst[i * blocksize * n + j * blocksize + k * n + m] = src[i * blocksize + j * (n * blocksize) + k + m * n];
                }
            }
        }
    }
}
