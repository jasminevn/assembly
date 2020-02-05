////BEGIN CODE AREA////
#include <stdio.h>
#include <stdlib.h>

extern "C" void square(long [], long unsigned int); //use this code to have c++ code compatible with assembly

void square(long vals[], long unsigned int j){  	//takes values of an array of longs and multiplies itself to get the square of the value
	long unsigned int i; 							//pre-declare the iteratore 
	for(i = 0; i < j; i++) { vals[i] = vals[i] * vals[i]; } //Loop through the array and multiply by itself
}

////END CODE AREA////
