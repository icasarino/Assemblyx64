section .data

	EXIT_SUCCESS	equ	0
	sys_exit	equ	60	;exit syscall

	STDIN		equ	0
	STDOUT		equ	1
	STDERR		equ	2

	sys_write	equ	1
	sys_read	equ	0
	
	
	inMsg		db	"Escribí algo: ", 0
	inMsgLen	equ	$ - inMsg
	
	msg		db	"Escribiste: ", 0
	msgLen		equ	$ - msg

section .bss
	inputLen	equ	150
	input		resb	inputLen


section .text

global _start

_start:

	push inMsgLen
	push inMsg
	call _print

	push inputLen
	push input
	call _gets
		
	push msgLen
	push msg
	call _print
	
	push inputLen	
	push input
	call _print
	
	call _exit

_exit:

	mov rax, sys_exit
	mov rdx, EXIT_SUCCESS
	syscall
	ret

_print:

	pop r12 ; guardo return addr en r12

	mov rax, sys_write
	mov rdi, STDOUT
	pop rsi ; obtengo mensaje del stack
	pop rdx ; obtengo length del stack

	syscall
	push r12 ; push ret addr al stack
	ret

_gets:
	pop r12 ; guardo return addr en r12

	mov rax, sys_read
	mov rdi, STDIN
	pop rsi ; obtengo addr donde guardar el mensaje
	pop rdx ; obtengo length total del stack
	syscall
	
	push r12 ; push ret addr al stack
	ret
