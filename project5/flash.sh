#!/bin/bash

rm *.o, *.lis, *.out

echo "Assemble the X86 file harmonic.asm"
nasm -f elf64 -l harmonic.lis -o harmonic.o harmonic.asm

echo "Assemble the C++ elec.cpp"
g++ -c -m64 -Wall -l elec.lis -o elec.o elec.cpp -fno-pie -no-pie 

echo "Link the '0' files harmonic.o and elec.o"
g++ -m64 -fno-pie -no-pie -o flash.out harmonic.o elec.o

echo "Run the Electric Circuit program"
./flash.out

