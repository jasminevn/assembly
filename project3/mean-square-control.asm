
;/////BEGIN CODE AREA/////

extern printf                                               ;External C++ function for writing to standard output device

extern scanf                                                ;External C++ function for reading from the standard input device

extern display												;External C function for display all the values of an array of longs

extern square												;External C++ function for squaring all of the values in an array of longs

extern compute_mean											;External x86 function that gets the mean of all the values in an array

global control                                         		;This makes array_tools callable by functions outside of this file.

segment .data                                               ;Place initialized data here

;///Declare some messages///

;(Holy statement by Professor Holliday) 
;The identifiers in this segment are quadword pointers to ascii strings stored in heap space.  They are not variables.  They are not constants.  There are no constants in
;assembly programming.  There are no variables in assembly programming: the registers assume the role of variables.

control.initialmessage db "The X86 subprogram is now executing, Brought to you by Francisco Ocegueda.", 10, 0

instruct_msg db "INSTRUCTIONS: enter integer values seperated by spaces, then press enter & ctrl-d when finished.", 10, 0

promptforcell db "Please enter an integer: ", 0

arr_message db "Here are the numbers as recieved: ", 10, 0

mean_msg db "Here is the mean of the values: %6.3lf", 10, 0

square_message db "Here are the squares of the numbers as recieved: ", 10, 0

goodbye db "The X86 subprogram control will now return to the caller program.", 10, 10, 0

stringformat db "%s", 0                                     ;general string format

integerformat db "%ld", 0                                   ;general decimal integer

eight_byte_format db "%lf", 0                               ;general 8-byte float format

newline db "", 10, 0										;string used for printing out a newline								

segment .bss                                                ;Declare pointers to un-initialized space in this segment.

myarr resq 16												;an array of qwords with a size of 16

segment .text                                               ;Place executable instructions in this segment.

control:                                                	;Entry point.  Execution begins here.

;///The next two instructions should be performed at the start of every assembly program.///
push       rbp                                              ;This marks the start of a new stack frame belonging to this execution of this function.
mov        rbp, rsp                                         ;rbp holds the address of the start of this new stack frame.  When this function returns to its caller rbp must
push qword 0                                                ;hold the same value it holds now.	

;///Save the data passed to this X86 subprogram///
mov		   r12, myarr 										;r12 holds the pointer to the array created in the caller program
mov        r14, 0                 							;r14 holds the size of the array that was passed to this x86 subprogram

;///Show the initial message///
mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, stringformat                                ;"%s"
mov        rsi, .initialmessage                             ;"The X86 subprogram is now executing."
call       printf                                           ;Call a library function to make the output

;///Show the instruction message informing the user on how to use this program///
mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, stringformat                             	;"%s"
mov        rsi, instruct_msg                                ;"INSTRUCTIONS: enter integer values seperated by spaces, then press enter & ctrl-d when finished."
call       printf											;Call external function printf to print out the message

;///Prompt user to enter some values///
mov qword  rax, 0											
mov        rdi, stringformat  								;"%s"
mov        rsi, promptforcell                               ;"Please enter an integer: "
call       printf											;Call external function printf to print out the message

;///Loop for passing inputed values in out array (r12)///
begin_loop:

push qword 0                                          		;Reserve 8 bytes of storage for the incoming number
mov qword  rax, 0                                           ;SSE is not involved in this scanf operation
mov        rdi, integerformat                          		;"%ld"
mov        rsi, rsp                                         ;Give scanf a pointer to the reserved storage
call       scanf  											;Call a library function to do the input work														
cdq                                                         ;Place into rdx sign-extension of that 32-bit number
shl rdx, 32                                                 ;Shift the sign extension 32 bits to the left
or rax, rdx 						    					;Perform the operation rax = rax or rdx 
cmp 	   rax, -1				           					;Compare the user input to Ctrl-d (-1)
je		   loop_finished									;Jump out of the loop if ctrl-d is inputed
pop rax													
mov qword [r12 + r14 * 8], rax								;Put the value in rax into the array													
inc        r14     											;Increment our counter of the amount of values in an array                                                                                  
jmp        begin_loop  										;Loop back to the beginning		

;///Loop is done, now perform use the display, mean, and square function///
loop_finished:

;///Print out the message before displaying the values using display///
mov qword  rax, 0
mov        rdi, stringformat 								;"%s"
mov        rsi, arr_message									;"Here are the numbers as recieved: "
call       printf											;Call external printf to print the string

;///Begin section display the values in the array r12///
mov rdi, r12												;Move the array into rdi for it to be used in the display function
mov rsi, r14												;Move the counter into rsi for use in the display function
call display												;Call our external display fuction
pop rsi														;pop out the values for later use
pop rdi


;///Begin section to compute the average of the numbers in the array r12///
mov rdi, r12           										;starting address of array is in rdi
mov rsi, r14           										;actual size of the array is in rsi
call compute_mean											;Call our external mean function
movsd xmm15, xmm0											;move our a copy of mean into a temporary spot for later use

;///Print out the mean///
mov qword  rax, 1
mov        rdi, mean_msg									;"Here is the mean of the values: %6.3lf"                                              
call       printf 											;External print function                                              

;///Print out a newline///
mov qword rax, 0											
mov	rdi, stringformat										;"%s" 
mov rsi, newline											;""
call printf													;External print function

;//Print out pre-message for square before computing and displaying them
mov qword  rax, 0
mov        rdi, stringformat 								;"%s"
mov        rsi, square_message								;"Here are the squares of the numbers as recieved: "
call       printf											;External print function

;///Begin section to calculate the squares///
mov rdi, r12												;Starting address of array stored in rdi
mov rsi, r14												;Size counter of the array moved to rsi
call square 												;Call our external square function

;///Begin section display the squared values in the array r12///
mov rdi, r12												;Starting address of array stored in rdi
mov rsi, r14												;Size counter stored in the 
call display												;Call our external display function



;///Show our goodbye message///
;It is not necessary to be on a boundary to output a string.
mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, stringformat                                ;"%s"
mov        rsi, goodbye                                     ;"The X86 subprogram control will now return to the caller program."
call       printf                                           ;Call a library function to do the hard work.

;///Send a float number back to the caller///
movsd xmm0, xmm15 											;move our temp value in xmm4 back to xmm0

;///Restore the pointer to the start of the stack frame before exiting from this function///
pop       rbp                                              ;Now the system stack is in the same state it was when this function began execution.
ret 
                                                        ;Pop a qword from the stack into rip, and continue executing..
;/////End of program mean-square-control.asm/////
