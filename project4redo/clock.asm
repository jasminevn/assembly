
extern printf

extern scanf

global clocktime

segment .data

;======declare messages========
 
initialmessage db "The clock module has started and the time is %ld tics", 10, 0

promptmessage db "Please enter the number of desired iterations: x ", 10

inputformat db "%ld"

thanks db "Thank you. The iterations will be from 1 through the number inputted.", 10, 0

iteration db "Iterarion number: %ld      Sqrt: %ld", 10, 0

totaltime db "Total time for computing square roots: %ld tics = %lf seconds", 10, 0

bye db "The clock function will now return the time to the caller", 10, 0 

segment .bss

;========begin =========

segment .text

clocktime:

;=====back up GPRS ===========
push       rbp                                     ;Save a copy of the stack base pointer
mov        rbp, rsp                                ;We do this in order to be 100% compatible with C and C++.
push       rbx                                     ;Back up rbx
push       rcx                                     ;Back up rcx
push       rdx                                     ;Back up rdx
push       rsi                                     ;Back up rsi
push       rdi                                     ;Back up rdi
push       r8                                      ;Back up r8
push       r9                                      ;Back up r9
push       r10                                     ;Back up r10
push       r11                                     ;Back up r11
push       r12                                     ;Back up r12
push       r13                                     ;Back up r13
push       r14                                     ;Back up r14
push       r15                                     ;Back up r15
pushf                                              ;Back up rflags

;=======Read the time on clock and save that time==========

mov qword rax, 0												;make sure rax is zerod out. This may be in-necessary.
mov qword rdx, 0
cpuid																		
rdtsc																;write the number of tics in edx:eax
shl rdx, 32														;shift the lower half of rdx to the upper half of rdx
or rax, rdx														;join the two half into a single register, namely:rax
mov r15, rdx													;save the clock in a safe register, r15

;=========display the time==================

mov qword rax, 0												;No data from SSE will be printed
mov rdi, initialmessage										;"The time is %ld tics"
mov rsi, r15											
call printf

;=======prompt iterations==========

mov qword rax, 0
mov rdi, promptmessage							;"please enter the iteration"
call printf

;====scanf for input===============

push qword 0
push qword 0
mov rax, 0
mov rdi, inputformat						;"%ld"
mov rsi, rsp
call scanf
pop r14										;hold # of iteration in r14
pop rax		

;=========== display thanks ======

;mov qword rax, 0
;mov rdi, thanks			;"iteration from 1 to inputted number"
;call printf


;==========check for the # of iterations==========

;mov 12, 0				;r12 is the counter = 0
;mov r13, 10

;mov rax, r14			;move inputted # to rax
;cqo
;idiv r13					;inputted # divide by 10

;mov r13, rax			;store quotient to r13
;mov rbx, rdx			;store remainder to rbx

;==== is iteration less than 10???=========
;cmp r14, 10				;compare inputted with 10
;jl lessthanten			;if less go to lessthanten

;=== is iteration exactly 10???========
;cmp rbx, 0				;compare remainder to 0
;je exactly				;if exact go to exactly

;==== is iteration more than 10???======

;jmp morethanten		;go to morethanten

;====== LESS THAN 10 =========

;lessthanten:

;less:

;cmp r14, r12			;compare input with 0
;je exit
;inc r12					;increase counter
;mov r13, r12			;move counter to r13
;cvtsi2sd xmm1, r13	;convert to float
;sqrtsd xmm0, xmm1		;square root number

;===display LESS THAN 10==============
;push qword 0
;mov rax, 1
;mov rdi, iteration
;mov rsi, r12
;call printf

;pop rax

;jmp less

;=====EXACTLY 10 ========

;exactly:

;exactten:

;cmp r12, 10
;je exit
;inc 12
;mov rbx, r13
;imul rbx, r12
;cvtsi2sd xmm1, rbx
;sqrtsd xmm0, xmm1

;====display EXACTLY 10================

;push qword 0
;mov rax, 1
;mov rdi, iteration
;mov rsi, r12
;call printf

;pop rax

;jmp exactten

;==== MORE THAN TEN ==============
;morethanten:

;more:

;cmp r12, 10
;je finditer
;inc r12
;mov r14, r13
;imul r14, r12
;cvtsisd xmm1, r14
;sqrtsd cmm0, xmm1

;==== display MORE THAN 10 ==============
;mov qword 0
;mov rax, 1
;mov rdi, interation
;mov rsi, r14
;call printf

;pop rax

;jmp more

;===== find iterations =====
;finditer:

;add r14, rbx 				;add remainder to previous iteration
;cvtsi2sd xmm2, r14
;sqrtsd xmm0, xmm2

;===== display ======

;push qword 0
;mov rax, 1
;mov rdi, iteration
;mov rsi, r14
;call printf

;pop rax
;jmp exit

;==== find total time=========

;exit:

;mov qword rdx, 0					;set registers back to zero
;mov qword rax, 0
;cpuid
;rdtsc
;shl rdx, 32
;or rax, rdx

;mov r12, rax

;=== calculate total time (end - beginning) =====

;sub r12, r15

;====== get processor number =======


mov rax, 0x4020000000000000
push rax
movsd xmm12, [rsp]
movsd xmm0,xmm12
pop rax

;===============restore=======
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

ret


