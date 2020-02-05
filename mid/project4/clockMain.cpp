//This file

#include <stdio.h>
#include <stdint.h>
#include <ctime>
#include <cstring>
#include <iostream>

extern "C" double clockStart();

int main(){
    double returnCode = 34.33;
    //Note: You could also use cout statements instead
    printf("%s", "\n\n");
    printf("%s", "Welome to Assignment 4 created by Raul Alvarez-Ledesma. \n");
    printf("%s", "This program is executing on an Intel® Core™ i5-5257U CPU at 2.70GHz. \n");
    printf("%s", "The main program will now call the clock module. \n\n");
    returnCode = clockStart();
    printf("%s%1.18lf%s\n","The clock main program received this number ",returnCode,
         ".  Have a nice day. Bye.");

    return 0;


}