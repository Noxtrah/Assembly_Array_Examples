;Doğa Kayra Yılmazarslan

%include "asm_io.inc"
segment .data
	
segment .bss
	array resd 10
segment .text
global _asm_main
	_asm_main:
	enter 0,0 ; setup routine
	pusha
	
	push array
	push dword 10
	call inputArray
	add esp, 8
	
	push dword 10
	push array
	call printArray
	add esp, 8
	
	popa
	mov eax, 0 
	leave
	ret
	
	;-----------------------------------------
	segment .data
	msg1 db "Enter an integer: ",0
	segment .bss

	segment .text
	
	inputArray:
	push ebp
	mov ebp,esp
	
	mov ecx,[ebp+12] ; ecx = address at which store the integers
	mov ebx, [ebp+8] ; ebx = number of integers to read
	shl ebx,2
	add ebx,ecx
	
	loop1:
	mov eax, msg1
	call print_string
	call read_int
	mov [ecx], eax ;store the int in memory at correct address
	add ecx,4 ; ECX = ECX+4
	cmp ecx, ebx
	jb loop1 ; if ECX < EBX jump loop1
	
	pop ebp
	ret
;------------------------------------------------------------
	segment .data
	msg2 db "List: ", 0
	segment .bss

	segment .text

	printArray:

	push ebp
	mov ebp, esp
	
	print_start:
	lea ebx, [array]

	mov eax, msg2
	call print_string

	print:
	mov eax, [ebx]
	call print_int

	print_while:
	add ebx, 4
	xor ecx, ecx
	mov ecx, [ebp + 12]
	imul ecx, 4
	lea ecx, [array + ecx]
	cmp ebx, ecx

	jz exit ; exit if printed all array

	xor eax, eax
	mov eax, 0x2C
	call print_char
	mov eax, 0x20
	call print_char
	jmp print

	exit:
	call print_nl


	mov esp, ebp
	pop ebp
	ret
	
	
