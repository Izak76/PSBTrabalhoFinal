%include "io.inc"

section .data
entrada db "Qual e a importancia da escola na democratizacao da sociedade",0

section .bss
q1: resb 100

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    call questao_1
    ret
    
questao_1:
    mov esi, entrada+7
    mov ecx, 41
    mov edi, q1
    cld
    rep movsb
    PRINT_STRING q1
    ret