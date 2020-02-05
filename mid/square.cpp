#include <stdio.h>
#include <stdint.h> 
#include <iostream>
#include <iomanip>

using namespace std;

extern "C" long int square(long[], long unsigned int);


long int square(long nice[], long unsigned int size){

long unsigned int i = 0;
long unsigned int square;

for(i = 0; i < size; i = i+1){
	square = i * i;
	printf("%ld", square);

};

return 0;

}