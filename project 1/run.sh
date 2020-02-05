#/bin/bash
#Author name: Jasmine Nguyen
#Program name:
#Assignment number: 1

#Author: Floyd Holliday
#Program name: Demonstrate Numeric IO

rm *.o
rm *.out

echo "This is program <Assembly Language>"

echo "Assemble the module fp-io.asm"
nasm -f elf64 -l fp-io.lis -o fp-io.o doingmath.asm

echo "Compile the C++ module fp-io-driver.cpp"
g++ -c -m64 -Wall -l robot.lis -o robot.o robot.cpp -fno-pie -no-pie

echo "Link the two object files already created"
g++ -m64 -o fpio.out fp-io.o robot.o -fno-pie -no-pie

./fpio.out

echo "The bash script file is now stopping."
