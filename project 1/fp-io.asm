
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;Author name: Jasmine Nguyen	
;Program title:
;Files in this program:
;Course number: CPSC 240
;Assignment number: 1
;Required delivery date: Feb 4, 2019 before 11:59pm
;Purpose: Learn how to embed C library function calls in an X86 module
;Language of this module: X86 with Intel syntax
;Compile this module:


;Author information
;  Author name: Floyd Holliday
;  Author email: holliday@fullerton.edu or activeprofessor@yahoo.com
;  Author location: CSUF
;Course information
;  Course number: CPSC240
;  Assignment number: 6
;  Due date: 2014-Aug-25
;Project information
;  Project title: Demonstrate Numeric IO
;  Purpose: Demonstrate to the Cpsc240 class the operations of input and output of 64-bit floating point numbers.
;  Status: No known errors
;  Project files: fp-io-driver.cpp, fp-io.asm
;Module information
;  This module's call name: floating_point_io
;  Language: X86-64
;  Syntax: Intel
;  Date last modified: 2014-Jan-14
;  Purpose: This module will show how to call scanf for input and how to call printf for output.
;  File name: fp-io.asm
;  Status: This module functions as expected as a demonstrator.
;  Future enhancements: None planned
;Translator information
;  Linux: nasm -f elf64 -l fp-io.lis -o fp-io.o fp-io.asm
;References and creditsv  
;  Seyfarth, Chapter 11
;Format information
;  Page width: 172 columns
;  Begin comments: 61
;  Optimal print specification: Landscape, 7 points or smaller, monospace, 8½x11 paper
;
;===== Begin code area ====================================================================================================================================================

extern printf                                               ;External C++ function for writing to standard output device

extern scanf                                                ;External C++ function for reading from the standard input device

global floating_point_io                                    ;This makes floating_point_io callable by functions outside of this file.

segment .data                                               ;Place initialized data here

;===== Declare some messages ==============================================================================================================================================

initialmessage db "Welcome", 10, 0

prompt1 db "Input an integer " , 0

inputformat db "%ld", 0

multiplyout db "The product of %ld and %ld is %ld" , 10, 0

outputformat db "The quotient is %ld and the remainder is %ld", 10, 0

goodbye db "This assembly function will now return the remainder to the driver", 10, 0


segment .bss                                                ;Place un-initialized data here.



;===== Begin executable instructions here =================================================================================================================================

segment .text                                               ;Place executable instructions in this segment.

floating_point_io:                                          ;Entry point.  Execution begins here.

;=========== Back up all the GPRs whether used in this program or not =====================================================================================================

push       rbp                                              ;Save a copy of the stack base pointer
mov        rbp, rsp                                         ;We do this in order to be 100% compatible with C and C++.
push       rbx                                              ;Back up rbx
push       rcx                                              ;Back up rcx
push       rdx                                              ;Back up rdx
push       rsi                                              ;Back up rsi
push       rdi                                              ;Back up rdi
push       r8                                               ;Back up r8
push       r9                                               ;Back up r9
push       r10                                              ;Back up r10
push       r11                                              ;Back up r11
push       r12                                              ;Back up r12
push       r13                                              ;Back up r13
push       r14                                              ;Back up r14
push       r15                                              ;Back up r15
pushf                                                       ;Back up rflags



;==========================================================================================================================================================================
startapplication: ;===== Begin the application here: demonstrate floating point i/o =======================================================================================
;==========================================================================================================================================================================

;=========== Show the WELCOME message =====================================================================================================================================

mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, initialmessage                              ;"This X86 program will demonstrate the input and output of 8-byte ... "
call       printf                                           ;Call a library function to make the output


;=========== PROMPT FOR 1ST INTEGER =======================================================================================================================================

mov qword  rax, 0
mov        rdi, prompt1
call       printf


;=========== SCANF FOR INPUT ==============================================================================================================================================
push       qword 0
push       qword 0
mov 	   rax, 0                                           ;No data from SSE will be printed
mov        rdi, inputformat                                 ;"%ld"
mov	   rsi, rsp
call       scanf                                         
pop        r14    
pop        rax                                     

;=========== PROMPT FOR 2ND INTEGER =======================================================================================================================================
mov qword  rax, 0
mov        rdi, prompt1
call       printf

;========== SCANF FOR 2ND INPUT ===========================================================================================================================================

push       qword 0
push       qword 0
mov 	   rax, 0                                           ;No data from SSE will be printed
mov        rdi, inputformat                                 ;"%ld"
mov	   rsi, rsp
call       scanf                                         
pop        r15    
pop        rax                                     


;=========== MULTIPLY 2 INTEGERS ==========================================================================================================

mov  	   rbx, r14
mov        rcx, r15
imul       rbx, rcx

;========== OUTPUT PRODUCT ===========================================================================================================

mov qword  rax, 0
mov        rdi, multiplyout
mov	   rsi, r14
mov        rdx, r15
mov        rcx, rbx
call       printf

;========== DIVIDE 1ST BY 2ND =============================================================================================================================================

mov       rax, r14
cqo
idiv      r15
mov	  r13, rdx

;idiv makes QUOTIENT to rax and REMAINDER to rdx even though it doesn't state it!!!

;========= SET UP OUTPUT AND CALL PRINTF ==================================================================================================================================


mov       rdi, outputformat
mov 	  rsi, rax
mov qword rax, 0	
call	  printf


;========== SAY GOODBYE ===================================================================================================================================================

mov qword rax, 0
mov       rdi, goodbye
call      printf

;========== MOVE REMAINDER INTO RAX =============================================================================================================================================

mov       rax, r13


                                       
;=========== RETURN ====================================================================================================

popf                                                        ;Restore rflags
pop        r15                                              ;Restore r15
pop        r14                                              ;Restore r14
pop        r13                                              ;Restore r13
pop        r12                                              ;Restore r12
pop        r11                                              ;Restore r11
pop        r10                                              ;Restore r10
pop        r9                                               ;Restore r9
pop        r8                                               ;Restore r8
pop        rdi                                              ;Restore rdi
pop        rsi                                              ;Restore rsi
pop        rdx                                              ;Restore rdx
pop        rcx                                              ;Restore rcx
pop        rbx                                              ;Restore rbx
pop        rbp                                              ;Restore rbp

ret                                                         ;No parameter with this instruction.  This instruction will pop 8 bytes from
                                                            ;the integer stack, and jump to the address found on the stack.
;========== End of program fp-io.asm ======================================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
