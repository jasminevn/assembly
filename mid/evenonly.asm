
;Jasmine Nguyen
;March 28, 2019


;===== Begin code area ====================================================================================================================================================

extern printf                                               ;External C++ function for writing to standard output device

extern scanf                                                ;External C++ function for reading from the standard input device

extern display

extern square

extern replace

global evenonly                                             ;This makes evenonly callable by functions outside of this file.

segment .data                                               ;Place initialized data here



;===== Declare some messages ==============================================================================================================================================
;The identifiers in this segment are quadword pointers to ascii strings stored in heap space.  They are not variables.  They are not constants.  There are no constants in
;assembly programming.  There are no variables in assembly programming: the registers assume the role of variables.

promptmessage db "Please enter an integer: " , 0

inputformat db "%ld" , 0

segment .bss                                                ;Declare pointers to un-initialized space in this segment.

myarray resq 60
;==========================================================================================================================================================================
;===== Begin the application here: show how to input and output floating point numbers ====================================================================================
;==========================================================================================================================================================================

segment .text                                               ;Place executable instructions in this segment.

evenonly:                                                ;Entry point.  Execution begins here.

;=========== Prompt for integer ==============

mov qword  rax, 0                                           
mov        rdi, promptmessage                    ;Enter an integer:           
call       printf                                           



;===== for loop until ctrl d =========================

mov        r15, 0
mov	     r14, 0
begin_loop:

mov r8, myarray
push qword 0				;reserve 8 bytes of storage 
mov qword  rax, 0			;SSE is not involved in this scanf operation
mov        rdi, inputformat
mov        rsi, rsp			;give scanf a pointer to the reserved storage
call       scanf			;call a library function to do the input work
cdq					;place into rdx sign-extension of that 32-bits to the left
shl 	     rdx, 32			;shift the sign extension 32 bits to the left
or         rax, rdx			;Perform the operation rax = rax or rdx
cmp 	     rax, -1			;Compare rax with -1
je	   loop_finished		;if rax == -1 then exit from the loop
mov	     r13, [rsp]			;copy the inputted number to r13
mov        [r8 + 8 * r15], r13
pop	     rax				;make free the storage that was used by scanf
inc	     r15				;add 1 to the loop counter
jmp	     begin_loop			;REPEAT THE LOOP

loop_finished:
pop	   rax


mov rdi, myarray
mov rsi, r15
call display

call replace

call square



ret                                                         ;Pop a qword from the stack into rip, and continue executing..
