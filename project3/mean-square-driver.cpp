/*
Author name: xxxxxxxx xxxxxx
Program name: How to Average Integerss
Names of files in this programming: driver.cpp, control.asm, display.c, mean.asm, square.cpp
Course number: CPSC 240
Scheduled delivery date: March 7, 2019
Program purpose: Software to assist teachers in computing a class average.
Status: Finished. No known bugs
Date of last modification: Feb 28, 2019
Information about this module:
This module purpose: Driver for How to Average Integers
File name of this module: integers.cpp
Compile this module: g++ -c -m64 -std=c++99 -o integers.o integers.cpp
Link this module with other objects:
g++ -m64 -std=c++99 -o average.out integers.o controller.o display.o mean.o display.o
*/

////Begin code area////
#include <stdio.h>
#include <stdint.h>                                        
#include <ctime>
#include <cstring>
#include <iostream>
#include <iomanip>
#include <math.h>
extern "C"{
	double control();
}

using namespace std;

int main(int argc, char* argv[]){
  double return_code = 88.9;                              //88.9 is an arbitrary number; that initial value could have been anything.
  return_code = control();								  //Set the return code to what the assembly controller returns, which should be the mean of the array in the control								
  printf("%s%1.18lf%s\n","The driver received return code ",return_code,".  The driver will now return 0 to the OS."); //Print out the return value
  return 0;                                                 

}////End of main////


