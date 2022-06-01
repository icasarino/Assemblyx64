section .data

	EXIT_SUCCESS	equ	0
	sys_exit	equ	60	;exit syscall

	STDIN		equ	0
	STDOUT		equ	1
	STDERR		equ	2

	sys_write	equ	1

	msg:	db	"Holaaa estoy en un loop", 10, 0
	msglen:	equ	$ - msg

	msg2:	db	"Ya saliiiiii",10,0
	msglen2:	equ	$ - msg2

section .text

global _start

_start:

	mov r8, 5
	l1:
		push msglen
		push msg
		call _print
	dec r8
	jnz l1
	
	push msglen2
	push msg2
	call _print
	
	call _exit
	
_exit:
	mov rax, sys_exit
	mov rdx, EXIT_SUCCESS
	syscall
	ret

_print:
	mov rax, sys_write
	mov rdi, STDOUT
	pop r12 ; guardo return addr en r12
	pop rsi ; obtengo mensaje del stack
	pop rdx ; obtengo length del stack
	syscall
	push r12 ; push ret addr al stack
	ret
