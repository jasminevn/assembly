extern printf

extern scanf

global clockStart

;==============================================
;=== Define data needed for the application ===
;==============================================

segment .data


startClockMessage db "The clock module has started and the time is %ld tics.", 10, 0

promptMessage db "Please enter the number of desired iterations: ", 0

thankMessage db "Thank you. The iterations will be from 1 through the number inputted.",10,0

iterationOut db "Iteration number: %ld      Sqrt: %lf",10,0

totalMessage db "Total time for computing square roots: %ld tics = %lf seconds.", 10, 0

termMessage db "The clock function will now return the time to the caller.", 10, 0

rdxVar db "This is the value being stored in rdx: %ld", 10,0

raxVar db "This is the value being stored in rax(r13): %ld", 10,0

floatCheck db "Int val converted to float xmm(_) register holds: %lf", 10, 0

jmpLess db "Jumped to lessThanTen successfully!", 10, 0

jmpExact db "Jumped to exactlyTen successfully!", 10, 0

jmpMore db "Jumped to moreThanTen successfully!", 10, 0

newline db "", 10, 0

stringFormat db "%s", 0

integerFormat db "%ld", 0

floatFormat db "%lf", 0

checkIter db "The inputted number to be iterated is: %ld", 10, 0

segment .bss ;This section will again be empty

;=====================================================
;=== Segment where the application is set to start ===
;=====================================================

segment .text 

stackSetUp:

push rbp ;Declare the start of a new stack for this application

mov rbp, rsp ; have rsp now point to the start of our new stack
push       rbx  ;Back up rbx
push       rcx  ;Back up rcx
push       rdx  ;Back up rdx
push       rsi  ;Back up rsi
push       rdi  ;Back up rdi
push       r8   ;Back up r8
push       r9   ;Back up r9
push       r10  ;Back up r10
push       r11  ;Back up r11
push       r12  ;Back up r12
push       r13  ;Back up r13
push       r14  ;Back up r14
push       r15  ;Back up r15
pushf           ;Back up rflags

clockStart:

;=============================================
;=== Start the clock, then output the time ===
;=============================================

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

;================================================================================
;=== Safetly copy value of tics into another register (rdx) for printf to use ===
;================================================================================

mov r15, rax

;========================================
;=== Now to print the initial message ===
;========================================

mov qword rax, 0
mov rdi, startClockMessage
mov rsi, r15    ;# of tics 
                ;   view lines 150-158 JHW1 asm file 
                ;   to see how the registers are used w printf

call printf

;===============================================================
;=== Prompt the user to enter a certain amount of iterations ===
;===============================================================

mov qword rax, 0
mov rdi, promptMessage

call printf

;======================================
;=== Now to actually get the number ===
;======================================

push qword 0    ;Bc of segmentation fault 
                ;   Reserving memory for scanf
                ;       sometimes reqcuires two pops to get back onto the boundary


mov qword rax, 0
mov rdi, integerFormat  ;Predetermine the type of data to be inputted (in this case integer type)
mov rsi, rsp    ;The source is again rsp bc information will be
                ;Provided by using the stack
call scanf

;==================================================
;=== Check to see if the user inputted a number ===
;==================================================

pop r14  ;Store the value at the top of the stack into register r15

;============================================================
;=== Check to see that we are getting the correct numbers ===
;============================================================
mov qword rax, 0
mov rdi, checkIter
mov rsi, r14

call printf

;========================================
;=== Display the confirmation message ===
;========================================

mov qword rax, 0
mov rdi, thankMessage
call printf

;=======================================================
;=== Check to see how many iterations will be needed ===
;=======================================================
;   To do this will will need to do some division.
;       If the quotient holds any number:
;           -ten or more iterations will be needed
;               -iterate by that number
;       If the quotient holds the number 0:
;           -less than ten iterations will be needed
;               -in this case we can iterate by one
;=======================================================




mov r12, 0  ;r12 will be our counter
mov r13, 10 ;Note: You can use numbers directly in asm but not floats
            ;   -r13 = 10 That way we can use it to check which output case it would apply too.

mov rax, r14    ;Safetly move the number for iterations into rax
                ;   now we can us cqo to create an extension of rax to
                ;   store the quotient and remainder in eax and edx respectively
                ;   when the division has occurred

cqo ;Extension of rax has now been created

idiv r13    ;Divides rax (desired number to be iterated too) by r13(10)

mov r13, rax ;Move quotient (what we might increment by) into a safe register (r13)
mov rbx, rdx    ;Move remainder into a safe register (rbx)

;=============================================
;=== Check to see what we got in rax (r13) ===
;=============================================

mov qword rax, 0
mov rdi, raxVar
mov rsi, r13

call printf

;=============================================
;=== Check to see what we get in rdx (rbx) ===
;=============================================
;mov qword rax, 0
;mov rdi, rdxVar
;mov rsi, rbx

;call printf

;===========================================================
;===========================================================
;=== Now to check to see what type of number we inputted ===
;   Then send it to it's respective section for iteration
;===========================================================
;===========================================================

;=---------------------------------------=
;=========================================
;=== Check for less than 10 iterations ===
;=========================================
;=---------------------------------------=

; Note: r14 still hold the number that was inputted


;=== Check if less than ten iterations are needed ===
cmp r14, 10
jl lessThanTen  ;Send to lessThanTen if true

;If not...

;=================================================
;=== Check if exactly 10 iterations are needed ===
;=================================================
;Note:  We can check this by comparing the remainder (the inputted number divided by 10) to 0
;           This was done earlier and is now in rdx

cmp rbx, 0
je exactlyTen

;============================================================
;=== If fail previous tests ---> outputting 11 iterations ===
;============================================================

jmp moreThanTen


;----------------------------------------------------------------
;================================================================
;=== Case 1: Number inputted requires less than 10 iterations ===
;================================================================
;----------------------------------------------------------------

lessThanTen:

;=========================================
;=== Let user know they were sent here ===
;=========================================
;mov qword rax, 0
;mov rdi, jmpLess

;call printf

lessTop:

;====================================================
;=== Check if counter less than # incrementations ===
;====================================================

cmp r14, r12
je retTotalTime ;Jump to the end if counter reaches max # increments (n-1)

;=================
;=== If not... ===
;=================
;   -increment the counter(r12) 
;   -calculate square root for incrementation
;   -display


;=================================
;=== Incrementation of counter ===
;=================================

inc r12

mov r13, r12 ;Move value of counter to r13 to calculate sqrt w/o corrupting counter

;=================================
;=== Calculate the square root ===
;=================================
 
;Convert the number we want to squareroot (stored in r13) to a floating point number
;   -This way we can use the sqrtsd standard to easily calculate the squareroot

cvtsi2sd xmm1, r13

;=====================================================
;=== Here is where the actual squaring will happen ===
;=====================================================

sqrtsd xmm0, xmm1   ;Stores into xmm0 the squareroot of xmm1
;Note: printf used registers xmm0-xmm7 in that order, for passing parameters
;   -why we moved sqrt value into xmm0

;===============
;=== Display ===
;===============

push qword 0    ;Reserve some memory to stay on the boundary and avoid a segmentation fault

mov rax, 1    ;Lets printf know we will be using a floating point number
mov rdi, iterationOut
mov rsi, r12
call printf

pop rax ;Again: Every push needs a pop. Here's the one for this printf.

;==================================================
;=== Jump to top of loop to continue iterations ===
;==================================================

jmp lessTop


;--------------------------------------------------
;==================================================
;=== Case two: Exactly 10 iterations are needed ===
;==================================================
;--------------------------------------------------

exactlyTen:

;=========================================
;=== Let user know they were sent here ===
;=========================================

;mov qword rax, 0
;mov rdi, jmpExact

;call printf

exactTop:

;====================================================
;=== Check if counter less than # incrementations ===
;====================================================

cmp r12, 10
je retTotalTime ;Jump to the end if counter reaches max # increments (n-1)

;=================
;=== If not... ===
;=================
;   -increment the counter(r12) 
;   -calculate square root for incrementation
;   -display


;=================================
;=== Incrementation of counter ===
;=================================

inc r12

;============================================
;=== Calculate number to be square rooted ===
;============================================
;Note: This time we use rbx because data stored in there is irrleat

mov rbx, r13
imul rbx, r12


;=================================
;=== Calculate the square root ===
;=================================
 
;Convert the number we want to squareroot (stored in rbx) to a floating point number
;   -This way we can use the sqrtsd standard to easily calculate the squareroot

cvtsi2sd xmm1, rbx


;Here is where the actual squaring will happen

sqrtsd xmm0, xmm1   ;Stores into xmm0 the squareroot of xmm1
;Note: printf used registers xmm0-xmm7 in that order, for passing parameters
;   -why we moved sqrt value into xmm0

;===============
;=== Display ===
;===============

push qword 0    ;Reserve some memory to stay on the boundary and avoid a segmentation fault

mov rax, 1    ;Lets printf know we will be using a floating point number
mov rdi, iterationOut
mov rsi, rbx
call printf

pop rax ;Again: Every push needs a pop. Here's the one for this printf.

;==================================================
;=== Jump to top of loop to continue iterations ===
;==================================================

jmp exactTop



;-------------------------------------------------------
;=======================================================
;=== Case 3: More than Ten(11) iterations are needed ===
;=======================================================
;-------------------------------------------------------


;Note: In this case the information held in r14 (number inputted is irrelevant)
;   All we need to know is what to increment by and when we are on the 11th number 
;       to display the proper number on the last iteration

moreThanTen:

;=========================================
;=== Let user know they were sent here ===
;=========================================
;mov qword rax, 0
;mov rdi, jmpMore

;call printf



moreTop:

;====================================================
;=== Check if counter less than # incrementations ===
;====================================================

cmp r12, 10
je lastIteration ;Jump to the end if counter reaches max # increments (n-1)

;=================
;=== If not... ===
;=================
;   -increment the counter(r12) 
;   -calculate square root for incrementation
;   -display
;Couple things to not here

;=================================
;=== Incrementation of counter ===
;=================================

inc r12

;====================================================================
;=== Calculate the number we need to use for displaying iteration ===
;====================================================================
;Reminder: Informaion in r14 is irrelevant
mov r14, r13    ;Transfer this info here to ensure information is preserved
imul r14, r12

;================================================
;=== Calculate the square root of said number ===
;================================================
 
;Convert the number we want to squareroot (stored in r13) to a floating point number
;   -This way we can use the sqrtsd standard to easily calculate the squareroot

cvtsi2sd xmm1, r14


;Here is where the actual squaring will happen

sqrtsd xmm0, xmm1   ;Stores into xmm0 the squareroot of xmm1
;Note: printf used registers xmm0-xmm7 in that order, for passing parameters
;   -why we moved sqrt value into xmm0



;===============
;=== Display ===
;===============

push qword 0    ;Reserve some memory to stay on the boundary and avoid a segmentation fault

mov rax, 1    ;Lets printf know we will be using a floating point number
mov rdi, iterationOut
mov rsi, r14
call printf

pop rax ;Again: Every push needs a pop. Here's the one for this printf.

;==================================================
;=== Jump to top of loop to continue iterations ===
;==================================================

jmp moreTop

lastIteration:

;=================================
;=== Incrementation of counter ===
;=================================
;We dont need to do anything here. r12 (counter) is already at the proper counting
;spot bc of previous incrementations - so is (r14). Think about it like this we
;we increment up to the highest possible number that is a multiple of 10. After that,
;all we do is add the remaining amount of the number that could not be di 

;====================================================================
;=== Calculate the number we need to use for displaying iteration ===
;====================================================================
;Note: We get the last number by adding the remainder to r14 (register being used to display results)

add r14, rbx    ;add remainder to previous number for iteration (gives final number to iterate too)

;================================================
;=== Calculate the square root of said number ===
;================================================
 
;Convert the number we want to squareroot (stored in r13) to a floating point number
;   -This way we can use the sqrtsd standard to easily calculate the squareroot

cvtsi2sd xmm2, r14

;Here is where the actual squaring will happen
sqrtsd xmm0, xmm2

;sqrtsd xmm0, xmm1   ;Stores into xmm0 the squareroot of xmm1
;Note: printf used registers xmm0-xmm7 in that order, for passing parameters
;   -why we moved sqrt value into xmm0

;===============
;=== Display ===
;===============

push qword 0    ;Reserve some memory to stay on the boundary and avoid a segmentation fault

mov rax, 1    ;Lets printf know we will be using a floating point number
mov rdi, iterationOut
mov rsi, r14
call printf

pop rax ;Again: Every push needs a pop. Here's the one for this printf.

jmp retTotalTime


retTotalTime:

;=--------------------------------------------------------------=
;================================================================
;=== This is where the calculations for total time will occur ===
;================================================================
;=--------------------------------------------------------------=


;====================================
;=== Get current time on computer ===
;====================================
;We can mess with any of the registers now that we dont need any of the
;them (except for r15 which holds start time of clock)

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

;=== Safetly copy value of tics into another register (r12) for printf to use ===

mov r12, rax


;================================================================================
;=== Quickly calculate the total time by subtracting start time from end time ===
;================================================================================

sub r12, r15    ;Total time (end time - start time) now in r12
                ;   This time is stored in tics

;=========================================
;=== Now we need the processors number ===
;=========================================

;Note:This part you must edit to match your computer
;   This can be summed too ---> ((your processor)*(10))/10
;   i.e.) 2.7GHz processor = [(2.7)(10)]/10
mov r13, 27 ;Because I have a 2.7GHz processor
mov r14, 10 ;view equation up top

;=================================================
;=== Now to calculate the time time in seconds ===
;=================================================
;Note: Calculated by dividing the total number of tics by the number of your processor
;   -in my case processor is 2.7 ---> so I have to divide by 2.7
;   |
;   |   This is where we calculate the number of your processor
;   V

;==================================================================
;=== Convert the numbers into float for division a float number ===
;==================================================================

cvtsi2sd xmm1,r13   ;27 ---> 27.0
cvtsi2sd xmm2,r14   ;10 -----> 10.0

;=== Divide r13 by r14 ===

divsd xmm1, xmm2    ;xmm1 = xmm1/xmm2 = 27.0/10.0 = 2.7

;=======================================================================================
;=== Now time to convert total number of tics (r12) to decimal to convert to seconds ===
;=======================================================================================
mov r15, r12    ;Make a copy of the total number of tics(r12) in r15 for dividing

cvtsi2sd xmm3, r12 ;Conver total time (in tics) to decimal for conversion to seconds

;===========================================
;=== Calculate the total time in seconds ===
;===========================================

divsd xmm3, xmm1    ;Total time(in seconds) now in xmm3

;===============================================
;== Now Time to END THIS MUTHAFUCKIN PROJECT ===
;===============================================
movsd xmm0, xmm3

push qword 0 ;Need push onto the stack to avoid a segmentation fault

mov qword rax, 1    ;Changed to one because we will be outputting one float point value
mov rdi, totalMessage
mov rsi, r12
call printf

pop rax ;Reminder: Every push needs to be followed by a pop

;==================================================================================
;=============== This part doesnt work yet but ill talk to him monday =============
;==================================================================================

;=== Return the registers to their previous state ===

;===== Restore GPRs with the values held when this module "geometric_mean" was called =================================================

;popf                                                        ;Restore rflags
;pop        r15                                              ;Restore r15
;pop        r14                                              ;Restore r14
;pop        r13                                              ;Restore r13
;pop        r12                                              ;Restore r12
;pop        r11                                              ;Restore r11
;pop        r10                                              ;Restore r10
;pop        r9                                               ;Restore r9
;pop        r8                                               ;Restore r8
;pop        rdi                                              ;Restore rdi
;pop        rsi                                              ;Restore rsi
;pop        rdx                                              ;Restore rdx
;pop        rcx                                              ;Restore rcx
;pop        rbx                                              ;Restore rbx
;pop        rbp                                              ;Return rbp to point to the base of the activation record of the caller.
;Now the system stack is in the same state it was when this function began execution.

ret                  




