#Author: Raul Alvarez
#Program name: IClock Square root
#Language: Bash

echo "Removing any previous object and output files."
rm *.o
rm *.out

echo "Assemble the clockSquareRoot.asm file"
nasm -f elf64 -o clockSquareRoot.o clockSquareRoot.asm

echo "Assemble the C++ clockMain.cpp file"
g++ -c -m64 -Wall -o clockMain.o -fno-pie -no-pie  clockMain.cpp

echo "Link the 'O' files clockSquareRoot.o and clockMain.o"
g++ -m64 -fno-pie -no-pie -o squareIt.out clockMain.o clockSquareRoot.o

echo "Run the Clock Iteration square root Loop program"
./squareIt.out
