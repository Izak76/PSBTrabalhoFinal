%include "io.inc"

section .data
entrada db "Qual e a importancia da escola na democratizacao da sociedade", 0
str_q2a db "Quantidade de a's: ", 0
str_q2m db "Quantidade de m's: ", 0
str_q6s db " -> ", 0
str_q6e db ", ", 0

section .bss
q1: resb 42d
q3: resb 42d
q4: resb 42d
q5: resb 42d
q6: resb 42d
q6c: resb 1

section .text
global CMAIN

%macro uppercase 1    
    cmp %1, ' '
    je endupper
    cmp %1, 97d
    jl endupper
    
    sub %1, 20h
    endupper:
%endmacro

%macro lowercase 1    
    cmp %1, ' '
    je endlow
    cmp %1, 90d
    jg endlow
    
    add %1, 20h
    endlow:
%endmacro

%macro result 1
    PRINT_STRING %1
    NEWLINE
    NEWLINE
%endmacro

CMAIN:
    mov ebp, esp; for correct debugging
    call questao_1
    call questao_2
    call questao_3
    call questao_4
    call questao_5
    call questao_6
    
    ret
    
questao_1:
    mov esi, entrada+7d
    mov ecx, 41d
    mov edi, q1
    cld
    rep movsb
    result q1

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

    result q3
    
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

    result q4
    
    ret

questao_5:
    mov esi, q1
    mov edi, q5
    mov ecx, 41d
    xor eax, eax
    mov bl, 2
    mov bh, 3
    
    while_5:
        cmp bh, bl
        jne nozero_5
        cmp bh, 0
        jne nozero_5
        mov bx, 302h
        
        nozero_5:
        lodsb
        cmp al, ' '
        je continue_5
        
        cmp bl, 0
        je minusc_5
        uppercase al
        dec bl
        jmp continue_5
        
        minusc_5:
        lowercase al
        dec bh
        
        continue_5:
        stosb
        
    loop while_5
    
    result q5
    
    ret

questao_6:
    mov esi, q1
    mov edi, q6
    mov ecx, 41d
    xor eax, eax
    
    while_6:
        lodsb
        cmp al, ' '
        je continue_6
        
        mov [q6c], al
        PRINT_STRING q6c
        PRINT_STRING str_q6s
        sub al, 96
        
        stosb
        PRINT_DEC 1, al
        cmp ecx, 1
        je continue_6
        PRINT_STRING str_q6e
        continue_6:
        
    dec ecx
    jnz while_6
    NEWLINE
    NEWLINE
    
    ret