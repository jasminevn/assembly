
;Jasmine Nguyen
;March 28, 2019


;===========Begin code area=====================

extern printf								;External C++ function for writing to standard output device  

extern scanf								;External C++ function for reading from the standard input device

extern evenonly

global replace				         ;This makes replace callable by function outside of this file

segment .data								;Place initialized data here

;=============Declare some messages =======================

output db "Find the odd numbers and square it" , 10 , 0


;==========Begin application ===============================
segment .text									;Place executable instructions

replace:								;Entry point. Execution begins here.

;============ find the odd number ==========================

mov rax, 0
mov rdi, output
call printf

;begin_loop:
;mov rdi, myarray
;mov r13, [rsp]
;mov [r8 + 8 * r15], r13
;mul r13, 2

ret




