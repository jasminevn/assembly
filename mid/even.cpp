                                                                       
//===== Begin code area ===================================================================================================================================================
//Jasmine Nguyen
//March 28, 2019


#include <stdio.h>
#include <stdint.h>                                         //To students: the second, third, and fourth header files are probably not needed.
#include <ctime>
#include <cstring>
#include <iostream>
#include <iomanip>
#include <math.h>

extern "C" long int evenonly();                      //The "C" is a directive to the C++ compiler to use standard "CCC" rules for parameter passing.

using namespace std;

int main(){
    
	printf("%s", "Welcome to an array of long integers. \n");
	printf("%s", "This program is brought to you by Jasmine Nguyen \n");
	long int returnvalue = 0;
	returnvalue = evenonly();
  printf("%s%ld%s\n","The driver received return code ",returnvalue,".  The driver will now return 0 to the OS.");

  return 0;                                                 //'0' is the traditional code for 'no errors'.

}//End of main
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**

