//Jasmine Nguyen
//This program submitted to satisfy a special deal

#include <stdio.h>
#include <stdint.h>
#include <ctime>
#include <iostream>
using namespace std;

extern "C" double clocktime();

int main(){
double return_code = 88.9;
printf("Welcome to Assignment 4x created by Jasmine Nguyen \n");
printf("This program is executing on an AMD ????? \n");
printf("The main program will now call the clock module \n");
return_code = clocktime();
printf("%s%lf%s","The driver received return code " , return_code, ". The driver will now return 0 to the OS. ");
printf("Have a nice day. Bye");
return 0;

}