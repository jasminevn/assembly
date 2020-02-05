////BEGIN CODE AREA////

#include <stdio.h>
#include <stdlib.h>

//Do not need to extern c due to it already being written in c

void display(long vals[], long unsigned int j){ 		//This function takes the values of an array of longs and prints them out using printf
	long unsigned int i = 0;							//Pre-declare the iterator as required by c
	for(i = 0; i < j; i++) { printf("%ld\n", vals[i]); }//Loop through array and print out the values using printf
}


////END CODE AREA///
