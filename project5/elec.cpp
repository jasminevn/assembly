#include <stdio.h>
#include <stdint.h>
#include <ctime>
#include <cstring>

extern "C" double harmonic();

int main(){

	double return_code = 88.9;

	printf("%s", "Welcome to Electric Circuit Processing. \n");
	return_code = harmonic();
	printf("%s%lf%s\n", "The driver received this number: ",
		 return_code,". The driver will return 0 to the operating system. Have a nice day");

	return 0;
}
