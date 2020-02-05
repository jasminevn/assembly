
//Jasmine Nguyen
//March 28, 2019



#include <stdio.h>
#include <stdint.h>
#include <iostream>

using namespace std;

extern "C" void display(long [], long unsigned int);

void display(long nice[], long unsigned int size){

long unsigned int i = 0;

for(i = 0; i < size; i = i+1){
	printf("%ld", nice[i]);
};

return ;

}