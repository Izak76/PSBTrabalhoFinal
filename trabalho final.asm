%include "io.inc"

section .data
entrada db "Qual e a importancia da escola na democratizacao da sociedade",0
str_q2a db "Qtde. de a's: ",0
str_q2m db "Qtde. de m's: ",0

section .bss
q1: resb 100d

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    call questao_1
    call questao_2
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
    while:
        lodsb
        cmp eax, 'a'
        jne nea
        inc bh
        
        nea:
        cmp eax, 'm'
        jne nem
        inc bl
        
        nem:
        dec cx
        jnz while
    
    PRINT_STRING str_q2a
    PRINT_DEC 1, bh
    NEWLINE
    PRINT_STRING str_q2m
    PRINT_DEC 1, bl
    NEWLINE
    NEWLINE
    
    ret