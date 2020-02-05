;Jasmine Nguyen
;CPSC 240
;Final Exam Part 2
;This program submitted to satisfy a special deal

;=====Begin code here==================
extern printf						;External C++ function for writing to standard output device

extern scanf						;External C++ function for reading from the standard input device

global harmonic					;This makes harmonic callable by functions outside of this file

segment .data						;Place initialized data here

;====declare some messages==========
clockintro db "The clock time is now %ld", 10, 0

introduction db "This program will compute the resistance, current, and the work of the circuit ", 10, 0

promptmess db "Enter the resistance of a circuit: ", 0

input db "%lf", 0

input2 db "%ld", 0

answer db "Thank you. The number of sub-circuits is %ld", 10, 0

total db "The total resistance in this system is R = %lf ohms", 10, 0

voltage db "Please enter the voltage of battery in volts: ", 0

currentflow db "The rate of the current flow is I = %lf amps", 10, 0

work db "The work performed by this circuit during the last 60 seconds is W = %lf joules", 10, 0

clocknow db "The clock time is now %ld", 10, 0

bye db "Thank you for using my program. The total resistance will now be returned to the driver", 10, 0

segment .bss

;=====begin executable instructions here===========

segment .text						;Place executable instructions in this segment

harmonic:							;Entry point. Execution begins here.


;=========== Back up all the GPRs whether used in this program or not ====================

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



;=======Read the time on clock and save that time==========

mov qword rax, 0							;make sure rax is zerod out. This may be in-necessary.
mov qword rdx, 0
cpuid																		
rdtsc											;write the number of tics in edx:eax
shl rdx, 32									;shift the lower half of rdx to the upper half of rdx
or rax, rdx									;join the two half into a single register, namely:rax
mov r11, rdx								;save the clock in a safe register, r11

;=========display the time==================

mov qword rax, 0							;No data from SSE will be printed
mov rdi, clockintro						;"The time is %ld tics"
mov rsi, r11											
call printf

;==== display mess=====
mov qword rax, 0
mov rdi, introduction					;This program will compute circuits
call printf

;===Ask user for values=====

mov qword rax, 0
mov rdi, promptmess					   ;Enter the resistance
call printf


;===== for loop until ctrl d =========================

mov r15, 0
push qword 0
movsd xmm10, [rsp]
pop rax

begin_loop:
push qword 0
push qword 0					;reserve 8 bytes of storage 
mov qword  rax, 0				;SSE is not involved in this scanf operation
mov rdi, input
mov rsi, rsp					;give scanf a pointer to the reserved storage
call scanf						;call a library function to do the input work

cdq								;place into rdx sign-extension of that 32-bits to the left
shl rdx, 32						;shift the sign extension 32 bits to the left
or  rax, rdx					;Perform the operation rax = rax or rdx
cmp rax, -1						;Compare rax with -1
je	 loop_finished				;if rax == -1 then exit from the loop

movsd xmm8, [rsp]

mov rax, 1
cvtsi2sd xmm9, rax			
divsd xmm9, xmm8				;1/R
addsd xmm10, xmm9			

pop r13							;make free the storage that was used by scanf
pop rax
inc r15							;add 1 to the loop counter
jmp begin_loop					;REPEAT THE LOOP

loop_finished:
pop rax                                        ;These two pops are needed because the loop did not complete the last
pop rax                                        ;iteration.  The loop jumped out before doing 2 pops.

movsd xmm15, xmm10                             ;Save an extra backup copy of xmm10

;====Return total input======
mov qword rax, 0
mov rdi, answer			;The total number of sub-circuits is "%ld"
mov rsi, r15
call printf

;====return total resistance=======
mov qword rax, 1
mov rdi, total					;The total number of resistance is "%lf"
movsd xmm0, xmm10
call printf

;===Ask user for voltage value=====

mov qword rax, 0
mov rdi, voltage					;Enter the voltage
call printf

;=========== SCANF FOR INPUT ========
push     qword 0
push     qword 0
mov 	   rax, 0                      ;No data from SSE will be printed
mov      rdi, input2                 ;"%ld"
mov	   rsi, rsp
call     scanf                                         
pop      r14    
pop      rax              


;====calculate for current flow=====
mov qword rax, 1
cvtsi2sd xmm1, r14						;convert voltage to a float number
divsd xmm1, xmm10							;divide resistance over voltage

movsd xmm3, xmm1							;store to xmm3


;===display current flow=====
mov qword rax, 1
mov rdi, currentflow
movsd xmm0, xmm1							;display the current flow
call printf


;=== calculate work (I^2 x R x 60)====
mov r9, 60									;store 60 seconds in r9
cvtsi2sd xmm2, r9							; 60 = 60.0 (float number)
movsd xmm3, xmm1							;get one more current flow 
mulsd xmm3, xmm1						   ;square the current flow (I^2)
movsd xmm4, xmm3							;store I^2 to xmm4
mulsd xmm10, xmm4						   ;multiply I^2 with R(resistance)
movsd xmm6, xmm10							;store in xmm6
mulsd xmm2, xmm6							;multiply I^2 x R with 60.0

;====display work=====
mov qword rax, 1
mov rdi, work
movsd xmm0, xmm2
call printf


;== find current time==
mov qword rdx, 0					;set registers back to zero
mov qword rax, 0
cpuid
rdtsc
shl rdx, 32
or rax, rdx

mov r12, rax						;store time to r12

;=== calculate total time (end - beginning) =====

sub r12, r11

;==== display clock=====
mov qword rax, 0
mov rdi, clocknow
mov rsi, r12					;"The clock time now"
call printf

;==== bye=========

;mov qword rax, 0
;mov rdi, bye					;"resistance will be returned to  driver"
;call printf


movsd xmm0, xmm15       ;Send a copy of the work to the driver.
;I couldn't figure out the work so I sent back the resistance

;=========== Restore GPR values and return to the caller =========

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

ret
