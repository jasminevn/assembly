; Author Name: Jasmine Nguyen
; Program name: Accumulator Program
; Names of files in this programming: sum.asm, loopsum.cpp, flash.sh
; Course number: CPSC 240
; Scheduled delivery date: February 18, 2019
; Program purpose: Compute sum
; Date of last modification: February 14, 2019

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
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
;References and credits
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

initialmessage db "The fast accumulator program written in X86 Intel langauge has begun", 10, 0

instruction    db "Instructions: Enter a sequence of integers. Include white space between each number. To terminate, press 'Enter' followed by Control+D.", 10, 0

promptmessage  db "Enter an integer: ", 0

inputformat    db "%ld", 0

outputformat   db "Thank you. You entered %ld numbers with a sum equal to %ld.", 10, 0

goodbye        db "The X86 function will now return the sum to the caller program. Bye.", 10, 0

segment .bss 

                                       
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

push qword 0

;==========================================================================================================================================================================
startapplication: ;===== Begin the application here: demonstrate floating point i/o =======================================================================================
;==========================================================================================================================================================================

;=========== Show the initial message ==================

mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, initialmessage                              ;"This X86 program will demonstrate the input and output of 8-byte ... "
call       printf                                           ;Call a library function to make the output


;========== Print instructions ============================

mov qword   rax, 0
mov         rdi, instruction
call        printf

;=========== Prompt for integer ==============

mov qword  rax, 0                                           
mov        rdi, promptmessage                    ;Enter an integer:           
call       printf                                           



;===== for loop until ctrl d =========================

mov        r15, 0
mov	   r14, 0
begin_loop:

push qword 0				;reserve 8 bytes of storage 
mov qword  rax, 0			;SSE is not involved in this scanf operation
mov        rdi, inputformat
mov        rsi, rsp			;give scanf a pointer to the reserved storage
call       scanf			;call a library function to do the input work
cdq					;place into rdx sign-extension of that 32-bits to the left
shl 	   rdx, 32			;shift the sign extension 32 bits to the left
or         rax, rdx			;Perform the operation rax = rax or rdx
cmp 	   rax, -1			;Compare rax with -1
je	   loop_finished		;if rax == -1 then exit from the loop
mov	   r13, [rsp]			;copy the inputted number to r13
pop	   rax				;make free the storage that was used by scanf
inc	   r15				;add 1 to the loop counter
add	   r14, r13			;add the two numbers together
jmp	   begin_loop			;REPEAT THE LOOP

loop_finished:
pop	   rax


;====== output sum ==============

mov qword rax, 0
mov  	  rdi, outputformat		;you entered %ld numbers with the sum equal to %ld
mov 	  rsi, r15			;numbers inputted
mov       rdx, r14			;sum
call      printf


;===== output goodbye=======

mov qword rax, 0
mov 	  rdi, goodbye
call 	  printf

;==== return sum ===============
pop rax
mov rax, r14

;=========== Restore GPR values and return to the caller ==================================================================================================================


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
