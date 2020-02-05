//****************************************************************************************************************************
//Program name: "Demonstrate Numeric IO".  This program demonstrates how to call functions in the C library for the purposse *
//of inputting or outputting numeric values.  Copyright (C) 2019  Floyd Holliday                                             *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
//version 3 as published by the Free Software Foundation.                                                                    *
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
//****************************************************************************************************************************



//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//Author information
//  Author name: Floyd Holliday
//  Author email: holliday@fullerton.edu
//Program information
//  Program name: Demonstrate Numeric IO
//  Programming languages: C++ (1 modules), X86-assembly (1 module).
//  Date program development began: 2018-June-20
//  Date of last update: 2019-Jan-09
//  Files in this program: fp-i-driver.cpp, fp-io.asm, run.sh
//  Status: Done.  The author can find no errors.
//
//Purpose
//  Demonstrate how to embed calls to functions in the standard C library.  In this program calls to printf and scanf are shown.
//
//This file
//  File name: fp-io-driver.cpp
//  Language: C++
//  Page width: 132 chars
//  Gnu compiler: g++ -c -m64 -Wall -l fp-io-driver.lis -o fp-io-driver.o fp-io-driver.cpp -fno-pie -no-pie
//  Gnu linker:   g++ -m64 -o fpio.out fp-io-driver.o fp-io.o -fno-pie -no-pie
//
//
//===== Begin code area ============================================================================================================

#include <stdio.h>
#include <stdint.h>
#include <ctime>
#include <cstring>

extern "C" long int floating_point_io();

int main(){

  long int return_code = -99.99;

  printf("%s","Welcome to Looping Sum. \n");
  return_code = floating_point_io();
  printf("%s%ld%s\n","The driver received return code ",return_code,
         ".  The driver will now return 0 to the OS.  Bye.");

  return 0;

}//End of main
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

