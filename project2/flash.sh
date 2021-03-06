#/bin/bash

#Author: Jasmine Nguyen
#Name of Program: Accumulator Program

#Author: Floyd Holliday
#Program name: Demonstrate Numeric IO

rm *.o
rm *.out

echo "This is program <Demonstrate Numeric IO>"

echo "Assemble the module fp-io.asm"
nasm -f elf64 -l fp-io.lis -o fp-io.o sum.asm

echo "Compile the C++ module fp-io-driver.cpp"
g++ -c -m64 -Wall -l loopsum.lis -o loopsum.o loopsum.cpp -fno-pie -no-pie

echo "Link the two object files already created"
g++ -m64 -o fpio.out loopsum.o fp-io.o -fno-pie -no-pie

echo "The bash script file is now closing."
