

;===== Begin code area ====================================================================================================================================================

;%include "savedata.inc"                                     ;Not used in this program.  External macros that assist in data backup.

;%include "debug.inc"                                        ;Not now in use.  The debug tool was used during the development stages of this program.

extern printf                                               ;External C++ function for writing to standard output device

extern scanf                                                ;External C++ function for reading from the standard input device

extern get_data                                             ;The external function will file a passed array with qword data.

extern put_data

extern pow

global geometric_mean                                        ;This makes array_tools callable by functions outside of this file.

segment .data                                               ;Place initialized data here

;===== Declare some messages ==============================================================================================================================================
;The identifiers in this segment are quadword pointers to ascii strings stored in heap space.  They are not variables.  They are not constants.  There are no constants in
;assembly programming.  There are no variables in assembly programming: the registers assume the role of variables.

initialMessage db "The clock module has started and the time is %ld tics", 10,0

iterationMessage db "Please enter the number of iterations", 10, 0

iterationConfirmationMessage db "Thank you. The iterations will be from 1 through the number inputted.", 10 ,0

sqrtMessage db "Iteration number:%ld		Sqrt:%lf.", 10 ,0

ticMessage db "Total time for computer square roots: %ld.", 10 ,0

intFormat db "%ld", 0

stringformat db "%s", 0                                     ;general string format


segment .bss                                                ;Declare pointers to un-initialized static space in this segment.

academic resq 28                                            ;Declare a static array for demonstration purposes.

;==========================================================================================================================================================================
;===== Begin the application here: show how to input and output floating point numbers ====================================================================================
;==========================================================================================================================================================================

segment .text                                               ;Place executable instructions in this segment.

geometric_mean:                                             ;Entry point.  Execution begins here.

;The pushes that follow are here to backup the data in GPRs placed there by the calling module.  It is probable that the caller
;already backed up his own data before making the call -- however, we never know for sure.
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

;=========== Show the initial message, but first calculate the amount of tics =================================================================================================

mov qword rdx, 0
mov qword rax, 0
cpuid
rdtsc				;all of this just puts the current amt of tics in rdx
shl rdx,32
or rax, rdx

mov r15, rdx	;puts the current amount of tics in r15 to save it for later

mov qword rax, 0
mov rdi, initialMessage 		;prints initial Message "Clock has started and the time is ... tics"
mov rsi, r15
call printf

mov qword rax, 0
mov rdi, iterationMessage		;prints "Please enter the number of iterations."
call printf

push	qword 0
push	qword 0
mov	rax, 0
mov	rdi, intFormat		;int format because we need an int
mov	rsi, rsp		;stack pointer
call	scanf			;call input function
pop	r14	;hold number of iterations in r14
pop	rbx	;use any other register, it doesn't have to be rax, i just used rbx

mov qword rax, 0
mov rdi, iterationConfirmationMessage
call printf

mov r13, 1			;sets for loop counter to 1

topOfLoop:			;Where the loop repeats
cmp r13, r14			;compared for loop counter to the # of iterations
jg endOfLoop

mov r12, r13				;puts a copy of the for loop counter into r12
cvtsi2sd xmm2,r12			;converts the for loop counter number to a double
sqrtsd xmm1, xmm2			;puts the sqrt of the for loop counter into xmm1

mov rax, 1
mov rdi, sqrtMessage			;prints Iteration number: 		Sqrt:
mov rsi, r12
movsd xmm0, xmm1
call printf

inc r13				;increments the for loop counter
jmp topOfLoop

endOfLoop:

mov qword rdx, 0
mov qword rax, 0
cpuid
rdtsc				;all of this just puts the current amt of tics in rdx
shl rdx,32
or rax, rdx

mov r11, rdx			;puts all of this into r11

sub r11,r15			;second tic count minus the first

mov rax, 0
mov rdi, ticMessage
mov rsi, r11			;prints Total tic for computer square roots.
call printf






;========== Send a float number back to the caller ====================================================================================

movsd      xmm0, xmm15

;===== Restore GPRs with the values held when this module "geometric_mean" was called =================================================

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
pop        rbp                                              ;Return rbp to point to the base of the activation record of the caller.
;Now the system stack is in the same state it was when this function began execution.

ret                                                         ;Pop a qword from the stack into rip, and continue executing.
;========== End of program "geometric_mean" located in the file geometric_controller ==================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**















;=========== Here are some templates =============


checkIter:
mov r12, 1  ;r12 will be the register we will be incrementing by starting at zero
mov r11, r12  ;r11 now holds r12 (the number we will be square rooting)
mov r13, 10 ;Note: You can use numbers directly in asm but not floats
            ;   -r13 = 10 That way we can use it to check which output case it would apply too.

mov rax, r15    ;Safetly move the number for iterations into rax
                ;   now we can us cqo to create an extension of rax to
                ;   store the quotient and remainder in eax and edx respectively
                ;   when the division has occurred

cqo ;Extension of rax has now been created

idiv r13    ;Divides rax (desired number to be iterated too) by r13(10)


;=== PrintFormat ===
mov qword rax, 0
mov rdi, rdxVar
mov rsi, rdx

call printf


;///Loop to add all of the elements in the sum together///
Loop_to_compute_sum:     ;top of loop
cmp r15,r11 			 ;compare the iterator to the count of values in the array
jge loopfinished		 ;Jump to the loop finished to get the mean
add r10,[r13+8*r15]		 ;add the value from the array to the accumulator
inc r15					 ;Increment the iterator
jmp Loop_to_compute_sum	 ;loop back to the beginning

;///This section takes the accumulator and divides it by the count///
loopfinished:

cvtsi2sd xmm4, r10 		 ;Convert the accumulator to a double and store it in xmm4
cvtsi2sd xmm3, r11		 ;Convert the count to a double and store it in xmm3

divsd xmm4, xmm3		 ;Divide the two and store it in xmm4
movsd xmm0, xmm4         ;Move xmm4 to xmm0

pop rbp
ret

;///END CODE AREA///


cvtsi2sd xmm2,r12	;converts the for loop counter number to a double
sqrtsd xmm1, xmm2	;puts the sqrt of the for loop counter into xmm1


;======================================================================================

;=== Convert the number we are going to be incrementing by to float ===

cvtsi2sd xmm0, r13

;=== Check to see if it was successfully converted ===
push qword 0 ;Need push onto the stack to avoid a segmentation fault

mov qword rax, 1    ;Changed to one because we will be outputting one float point value
mov rdi, floatCheck
call printf

pop rax ;Reminder: Every push needs to be followed by a pop

;=======================================================================================

;=====================================================================
;=== Verify that the values inputted/calculate are still in memory ===
;=====================================================================
mov qword rax, 0
mov rdi, rdxVar
mov rsi, r15

call printf

mov qword rax, 0
mov rdi, rdxVar
mov rsi, r14

call printf

mov qword rax, 0
mov rdi, rdxVar
mov rsi, r12

call printf

mov qword rax, 0
mov rdi, rdxVar
mov rsi, rbx

call printf



;==============================
;=== how to calculate time ====
;==============================


mov qword rdx, 0
mov qword rax, 0

cpuid
rdtsc   ;copies the # of elapsed tics (since computer was powered on)
        ;   info is moved into edx:eax respectively
        ;       MSB half (32 bits) is in rdx
        ;       LSM half (32 bits) is in rax
        ;combine both of the registers to get the actual time (measured in tics)
        ;   this will require a shift

shl rdx, 32 ;Shift the MSB of rdx over to the left (Where they belong)
or rax, rdx ; rax now holds the cout of tics at the moment of rdtsc

;=== Safetly copy value of tics into another register (rdx) for printf to use ===

mov r15, rax


;===== Division of 1st integer by 2nd =====
mov        rax, r14			;moves integer to be divided by into rax
cqo					;creates an extension of rax, is now one big byte of memory as rdx:rax
idiv       r15				;divides 1st integer(now in rax) by 2nd integer(r15), quotient is stored in rax, remainder is stored in rdx
mov        r13, rax			;move quotient(in rax) to safer memory (r13)
mov        r12, rdx			;move remainder(in rdx) to safer memory (r12)



;=== Convert the numbers into float for division a float number ===

cvtsi2sd xmm1,r13
cvtsi2sd xmm2,r14

;=== Now divided r13 by r14

divsd xmm1, xmm2

;=== Check to make sure it was done correctly ===

movsd xmm0, xmm1 

push qword 0 ;Need push onto the stack to avoid a segmentation fault

mov qword rax, 1    ;Changed to one because we will be outputting one float point value
mov rdi, floatCheck
call printf

pop rax ;Reminder: Every push needs to be followed by a pop