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
	
	msg2		db	"El siguiente número es: ", 0
	msgLen2		equ	$ - msg2

	LF		db	10
	LFLen		equ	$ - LF
	
section .bss
	inputLen	equ	8
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
		
	add rax, 1 ; suma 1 al input
	call itoa ; El número queda en el stack con un 0x0 al final
	
	mov [input2], rax

	push msgLen2
	push msg2
	call _print
	
	push inputLen
	push input2
	call _print

	push LFLen
	push LF
	call _print
	

	call _exit



itoa:
	mov rbp, rsp
	xor r15, r15
	pop r15
	push 0x0
	l3:
		xor rdx, rdx
		mov rbx, 10
		idiv rbx ; divide RAX por RBX y guarda el resto en RDX
		
		add dl, 0x30 ; Tomo el resto y le sumo 0x30 para convertirlo en char
		push rdx
				
		cmp rax,0x0
		jne l3
	mov r14, rsp
	xor rax, rax
	mov rbx, 0x100

	fromStack:
		add rax, [rsp]
		imul rbx
		add rsp,0x8
		mov rcx, [rsp]
		cmp rcx, 0x0	
		jne fromStack
	
	idiv rbx
	xor rcx, rcx
	reverse:
		idiv rbx
		add rcx,rdx
		push rax
		mov rax, rcx
		imul rbx
		mov rcx, rax
		pop rax
		cmp rax,0x0
		jne reverse
		
	mov rax, rcx
	idiv rbx
	mov rsp,r14
	push r15
	ret



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

	mov rax, rdx
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
