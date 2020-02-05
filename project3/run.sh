

rm *.o, *.lis, *.out
echo " " #Blank line


echo "Assemble the X86 file mean-square-control.asm"
nasm -f elf64 -l mean-square-control.lis -o mean-square-control.o mean-square-control.asm

echo "Assemble the X86 file compute_mean.asm"
nasm -f elf64 -l compute_mean.lis -o compute_mean.o compute_mean.asm

echo "Compiles the C++ square.cpp"
g++ -c -m64 -Wall -fno-pie -no-pie -l square.lis -o square.o square.cpp

echo "Compile the C++ file mean-square-driver.cpp"
g++ -c -m64 -Wall -fno-pie -no-pie -l mean-square-driver.lis -o mean-square-driver.o mean-square-driver.cpp

echo "Compile the C file display.c"
gcc -c -m64 -Wall -fno-pie -std=c99 -o display.o display.c

echo "Link the 'O' files arrays-main.o and arrays-x86.o"
g++ -m64 -fno-pie -no-pie -o array.out mean-square-driver.o mean-square-control.o square.o display.o compute_mean.o
echo "Run the program Floating Point Input Output"
./array.out

echo "This Bash script file will now terminate.  Bye."


