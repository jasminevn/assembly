#!/bin/bash

rm *.o, *.lis, *.out

echo "Assemble the X86 file final.asm"
nasm -f elf64 -l final.lis -o final.o final.asm

echo "Assemble the C++ driver.cpp"
g++ -c -m64 -Wall -l driver.lis -o driver.o driver.cpp -fno-pie -no-pie

echo "Link the 0 files final.o driver.o"
g++ -m64 -fno-pie -no-pie -o run.out final.o driver.o

echo "Run the program"
./run.out
