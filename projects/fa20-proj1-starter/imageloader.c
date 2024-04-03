/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

// Opens a .ppm P3 image file, and constructs an Image object.
// You may find the function fscanf useful.
// Make sure that you close the file with fclose before returning.
Image *readData(char *filename)
{
	// YOUR CODE HERE
	FILE *fp = fopen(filename, "r");
	if (fp == NULL)
	{
		printf("fail to open %s.\n", filename);
		return NULL;
	}
	char format[5];
	int width, height;
	int scale;
	fgets(format, sizeof(format), fp);
	if (format[0] != 'P' || format[1] != '3')
	{
		printf("wrong ppm format\n");
		return NULL;
	}

	fscanf(fp, "%u %u %u", &width, &height, &scale);

	Image *ip = (Image *)malloc(sizeof(Image));
	ip->cols = width;
	ip->rows = height;
	ip->image = (Color **)malloc(width * height * sizeof(Color *));

	for (int i = 0; i < height; i++)
	{
		for (int j = 0; j < width; j++)
		{
			Color *c = (Color *)malloc(sizeof(Color));
			fscanf(fp, "%hhu %hhu %hhu", &(*c).R, &(*c).G, &(*c).B);
			ip->image[i * width + j] = c;
		}
	}
	fclose(fp);
	return ip;
}

// Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	// YOUR CODE HERE
	printf("P3\n%d %d\n255\n", image->cols, image->rows);
	Color **colors = image->image;
	for (int i = 0; i < image->rows; i++)
	{
		for (int j = 0; j < image->cols - 1; j++)
		{
			printf("%3hhu %3hhu %3hhu   ", (*colors)->R, (*colors)->G, (*colors)->B);
			colors++;
		}
		printf("%3hhu %3hhu %3hhu\n", (*colors)->R, (*colors)->G, (*colors)->B);
		colors++;
	}
}

// Frees an image
void freeImage(Image *image)
{
	// YOUR CODE HERE
	for (int i = 0; i < image->cols * image->rows; i++)
	{
		free(image->image[i]);
	}
	free(image->image);
	free(image);
}
