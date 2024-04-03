/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

// Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	// YOUR CODE HERE
	Color **p = image->image;
	int position = row * (image->cols) + col;
	Color *c = *(p + position);
	int flag = c->B & 1;

	Color *rt = (Color *)malloc(sizeof(Color));
	if (rt == NULL)
	{
		printf("Failed to alloc space\n");
		return NULL;
	}
	if (c->B % 2 == 0)
	{
		rt->B = 0;
		rt->G = 0;
		rt->R = 0;
	}
	else if (c->B % 2 == 1)
	{
		rt->B = 255;
		rt->G = 255;
		rt->R = 255;
	}
	return rt;
}

// Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	// YOUR CODE HERE
	int rows = image->rows;
	int cols = image->cols;
	int pos = 0;

	Image *newImage = (Image *)malloc(sizeof(Image));
	newImage->cols = cols;
	newImage->rows = rows;
	newImage->image = (Color **)malloc(cols * rows * sizeof(Color *));

	for (int row = 0; row < rows; row++)
	{
		for (int col = 0; col < cols; col++)
		{
			*(newImage->image + pos) = evaluateOnePixel(image, row, col);
			pos++;
		}
	}
	return newImage;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image,
where each pixel is black if the LSB of the B channel is 0,
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	// YOUR CODE HERE
	if (argc < 2)
	{
		return -1;
	}

	Image *source = readData(argv[1]);
	Image *new = steganography(source);
	if (source == NULL || new == NULL)
	{
		return -1;
	}
	freeImage(source);
	writeData(new);
	freeImage(new);
	return 0;
}
