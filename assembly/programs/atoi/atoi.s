section .data

	EXIT_SUCCESS	equ	0
	sys_exit	equ	60	;exit syscall

	STDIN		equ	0
	STDOUT		equ	1
	STDERR		equ	2

	sys_write	equ	1
	sys_read	equ	0
	
	
	msg		db	"Ingresa un número: ", 0
	msgLen		equ	$ - msg
	
	msg2		db	"Escribiste: ", 0
	msgLen2		equ	$ - msg2

section .bss
	inputLen	equ	150
	input		resq	inputLen
	input2		resq	inputLen

section .text

global _start

_start:

	push msgLen
	push msg
	call _print

	push inputLen
	push input
	call _gets ; primer numero
	
	mov rax, input
	call atoi ; convierte array char numerico en int
		
	add rdx, 1 ; suma 1 al input
	
	call _exit

atoi:
	xor rcx, rcx
	call len ; guarda en rcx la cantidad de bytes en [rax] hasta el '\n'

	xor rdx, rdx
	l2:
		xor r9, r9
		movzx r9, byte [rax]
		sub r9,0x30
			
		call pow ; 10**rcx
	
		imul r9, r12
		add rdx, r9
		
		dec rcx
		inc rax
		cmp rcx,0x00
		jne l2

	ret


pow:
	xor r11, r11
	mov r11, rcx
	mov r12, 1
	cmp r11, 0x1
	je _ret
	power:
		imul r12, 10
		dec r11
		cmp r11, 0x1
		jg power
	
	_ret:
		ret
len:
	l1:
		movzx rdx, byte [rax+rcx]
		inc rcx
		cmp rdx, 0xa
		jne l1	
	
	dec rcx
	ret

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
