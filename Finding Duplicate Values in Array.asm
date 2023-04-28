;Doğa Kayra Yılmazarslan
;.\makefile.bat Lab_8_Q2
%include "asm_io.inc"

segment .bss
array resd 10

segment .text
global _asm_main
_asm_main:
enter 0,0 
pusha 


push dword 10
push array
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


segment .data
prompt db "Enter an integer: ", 0
segment .bss

segment .text

inputArray:


push ebp
mov ebp, esp
sub esp, 0x8
mov DWORD [ebp-4], 0 ; count = 0
mov DWORD [ebp-8], 0 ; userInput = 0

lea ebx, [array] ; mov the addr of array into ebx

do:
mov eax, prompt ; print enter an int
call print_string
call read_int
mov [ebp-8], eax ; userInput = eax


push eax ; psh user input
push DWORD [ebp-4] ; psh count
push DWORD [ebp+8] ; psh array
call findValue
add esp, 12 ; reset stack


cmp eax, 0 ; if user entered a duplicate integer
jnz do ; jmp if eax!=0

mov eax, DWORD [ebp-8] ; eax = userInput

mov [ebx], eax ; mov user input to array
inc DWORD [ebp-4] ; count++

while:
add ebx, 4 ; add 4 to get to next index
xor ecx, ecx
mov ecx, [ebp + 12]
imul ecx, 4
lea ecx, [array + ecx] ; get addr of last 4 byte index
cmp ebx, ecx

jnz do ; loop if number of entered integers < 10 


mov esp, ebp
pop ebp
ret


segment .data
msg1 db "Value already entered, try again!", 0x0A, 0
segment .bss

segment .text

findValue:


push ebp
mov ebp, esp
push ebx


mov eax, [ebp+12] ; eax = count
cmp eax, 0 ; compare if init count is equal to 0
jz return ; jmp if ZF = 0 

mov ebx, array
mov edx, [ebp+16] ; edx = user input

compare_value:
cmp [ebx], edx ; compare if array have already the value of user input
jz duplicate ; jump if array has duplicated value
jmp loop1

duplicate:
mov eax, msg1
call print_string
mov eax, ebx
jmp exit_findValue

loop1:
dec DWORD [ebp+12] ; count--
add ebx, 4 ; array[i++]

mov eax, [ebp+12] 
cmp eax, 0        
jnz compare_value  ;jump if eax!=0


return:
xor eax, eax ; mov eax,0   return 0


exit_findValue:


pop ebx
mov esp, ebp
pop ebp
ret



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
xor ecx, ecx ; mov ecx,0
mov ecx, [ebp + 12]
imul ecx, 4
lea ecx, [array + ecx]
cmp ebx, ecx

jz end_print ; exit all array has printed 

xor eax, eax ; mov eax,0
mov eax, 0x2C
call print_char
mov eax, 0x20
call print_char
jmp print

end_print:
call print_nl


mov esp, ebp
pop ebp
ret