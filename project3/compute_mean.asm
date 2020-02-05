;///BEGIN CODE AREA///

global compute_mean 	 ;allows this code to be called outside of this file

segment .bss  

segment .text      

compute_mean:

;///Begin real computations here.///
push       rbp           ;This marks the start of a new stack frame belonging to this execution of this function.
mov        rbp, rsp  

;///store the array and its actual size in stable registers///
mov r13, rdi             ;r13=the passed in array
mov r11, rsi             ;r11=the count of actual numbers in the array

;///Initialize accumulator and counter///
mov r10, 0               ;r10=accumulator of numbers from the array
mov r15, 0               ;r15=loop control variable

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
