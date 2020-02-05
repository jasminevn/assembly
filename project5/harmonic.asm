
;=====Begin code here==================
extern printf						;External C++ function for writing to standard output device

extern scanf						;External C++ function for reading from the standard input device

global harmonic					;This makes harmonic callable by functions outside of this file

segment .data						;Place initialized data here

;====declare some messages==========

introduction db "This program will compute the resistance of a circuit configured with parallel sub-circuits", 10, 0

promptmess db "Enter the resistance of a circuit: ", 0

input db "%lf", 10, 0

answer db "Thank you. The number of sub-circuits is %ld", 10, 0

total db "The total resistance in this system is R = %lf", 10, 0

bye db "Thank you for using ECP. The total resistance will now be returned to the driver program", 10, 0

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


;==== display mess=====
mov qword rax, 0
mov rdi, introduction					;This program will compute circuits
call printf

;===Ask user for values=====

mov qword rax, 0
mov rdi, promptmess					;Enter the resistance
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

;mov qword rax, 1
;mov rdi, total					;The total number of resistance is "%lf"
;movsd xmm0, xmm8
;call printf

mov rax, 1
cvtsi2sd xmm9, rax
divsd xmm9, xmm8
addsd xmm10, xmm9


;mov qword rax, 1
;mov rdi, total					;The total number of resistance is "%lf"
;movsd xmm0, xmm9
;call printf

pop r13							;make free the storage that was used by scanf
pop rax
inc r15							;add 1 to the loop counter
jmp begin_loop					;REPEAT THE LOOP

loop_finished:
pop rax                                        ;These two pops are needed because the loop did not complete the last
pop rax                                        ;iteration.  The loop jumped out before doing 2 pops.

movsd xmm15, xmm10                             ;Save an extra backup copy of xmm10

;====Return total======
mov qword rax, 0
mov rdi, answer			;The total number of sub-circuits is "%ld"
mov rsi, r15
call printf

;====1/R=======


mov qword rax, 1
mov rdi, total					;The total number of resistance is "%lf"
movsd xmm0, xmm10
call printf

;==== bye=========

mov qword rax, 0
mov rdi, bye					;"resistance will be returned to  driver"
call printf


movsd xmm0, xmm15                               ;Send a copy of the resistance to the driver.

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
