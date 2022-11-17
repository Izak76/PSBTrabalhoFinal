%include "io.inc"

section .data
entrada db "Qual e a importancia da escola na democratizacao da sociedade", 0
str_q2a db "Qtde. de a's: ", 0
str_q2m db "Qtde. de m's: ", 0

section .bss
q1: resb 42d
q3: resb 42d
q4: resb 42d

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    call questao_1
    call questao_2
    call questao_3
    call questao_4
    ret
    
questao_1:
    mov esi, entrada+7d
    mov ecx, 41d
    mov edi, q1
    cld
    rep movsb
    PRINT_STRING q1
    NEWLINE
    NEWLINE
    ret
    
questao_2:
    xor bx, bx ;bh=conta os a's / bl=conta os m's
    xor eax, eax
    
    mov cx, 41d
    mov esi, q1
    while_2:
        lodsb
        cmp eax, 'a'
        jne nea
        inc bh
        
        nea:
        cmp eax, 'm'
        jne nem
        inc bl
        
        nem:
        
    loop while_2
    
    PRINT_STRING str_q2a
    PRINT_DEC 1, bh
    NEWLINE
    PRINT_STRING str_q2m
    PRINT_DEC 1, bl
    NEWLINE
    NEWLINE
    
    ret

questao_3:
    mov esi, q1
    mov edi, q3
    mov ecx, 21d
    xor eax, eax
    
    while_3_1:
        lodsw
        push ax
    loop while_3_1
    
    mov ecx, 20d
    pop ax
    stosb
    
    while_3_2:
        pop ax
        xchg al, ah
        stosw 
    loop while_3_2

    PRINT_STRING q3
    NEWLINE
    NEWLINE
    
    ret

questao_4:
	mov esi, q1
	mov edi, q4
	xor eax, eax
	mov ecx, 41d

	while_4:
		lodsb
		cmp eax, ' '
		je continue_4
		stosb
		continue_4:
	loop while_4

	PRINT_STRING q4
    NEWLINE
    NEWLINE
    
    ret