#/bin/bash

#Program: Date and Time
#Author: F. Holliday

#Delete some un-needed files
rm *.o
rm *.out
rm *.lis

echo "Assemble the X86 file  clock.asm"
nasm -f elf64 -l clock.lis -o clock.o clock.asm

echo "Compile the C++ accum.cpp"
g++ -c -m64 -Wall -l accum.lis -o accum.o  accum.cpp -fno-pie -no-pie

echo "Link the object files clock.0 and accum.o"
g++ -m64 -fno-pie -no-pie -o run.out clock.o accum.o

echo "Run the program clock :"
./run.sh
