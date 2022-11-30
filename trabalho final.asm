;Projeto da disciplina MATA49 - Programação de Software Básico
;Aluno: Izak Alves Gama
;Professor: Babacar Mane

%include "io.inc"

;Qual e a importancia da escola na democratizacao da sociedade

section .data ;Strings para a impressão de textos
str_q2a db "Quantidade de a's: ", 0
str_q2m db "Quantidade de m's: ", 0
str_q6s db " -> ", 0
str_q6e db ", ", 0
str_q7m db "Media: ", 0

section .bss ;Variáveis para guardar os resultados de cada procedure
entrada: resb 61d  ;Aqui vai ficar o texto de entrada
q1: resb 42d
q3: resb 42d
q4: resb 42d
q5: resb 42d
q6: resb 42d
q6c: resb 1
q7: resb 42d

section .text
global CMAIN

%macro uppercase 1     ;Transforma um caractere minúsculo em maiúsculo
    ;Se o parâmetro for um espaço, ignora-o
    cmp %1, ' '
    je .endupper

    ;Se o parâmetro já for maiúsculo, ignora-o
    cmp %1, 97d
    jl .endupper
    
    ;Subtrai o caractere por 32 (Ex: 98 (b) - 32 = 66 (B)) (vide tabela ASCII)
    sub %1, 20h
    .endupper:
%endmacro

%macro lowercase 1    ;Transforma um caractere maiúsculo em minúsculo
    ;Se o parâmetro for um espaço, ignora-o
    cmp %1, ' '
    je .endlow

    ;Se o parâmetro já for minúsculo, ignora-o
    cmp %1, 90d
    jg .endlow
    
    ;Soma o caractere por 32 (Ex: 66 (B) + 32 = 98 (b)) (vide tabela ASCII)
    add %1, 20h
    .endlow:
%endmacro

%macro result 1     ;Imprime a string passada como parâmetro
    PRINT_STRING %1
    NEWLINE
    NEWLINE
%endmacro

CMAIN:
    GET_STRING entrada, 61d    ;Obtém a string de entrada

    ;Chama os procedures de cada questão
    call questao_1
    call questao_2
    call questao_3
    call questao_4
    call questao_5
    call questao_6
    call questao_7
    
    ret
    
questao_1:
    mov esi, entrada+7d ;Aponta o reg. ESI para a posição da entrada onde começa "a importância..."
    mov ecx, 41d        ;Contador para o comando de repetição (a string de interesse tem 41 caracteres)
    mov edi, q1         ;Define o reg. EDI com o endereço da variável q1
    cld                 ;Define direction flag como 0 (percorre a string da esquerda para a direita)
    rep movsb           ;Repete o movimento de caracteres da entrada para q1 até que ECX seja 0.
    result q1           ;Imprime o resultado

    ret
    
questao_2:
    xor bx, bx          ;Zera o reg. BX (bh conta os a's e bl conta os m's)
    xor eax, eax        ;Zera o reg. EAX
    
    mov cx, 41d         ;Define CX como 41 (tamanho de q1)
    mov esi, q1         ;ESI aponta para o endereço de q1
    while_2:
        lodsb           ;Carrega para o AL o próximo caractere da string
        cmp al, 'a'     ;Compara se o valor de AL é 'a'
        jne nea         ;Se não, passa para a próxima comparação
        inc bh          ;Se sim, incremente bh
        
        nea:
        cmp al, 'm'     ;Compara se o valor de AL é 'm'
        jne nem         ;Se não, pula a próxima instrução
        inc bl          ;Se sim, incrementa bl
        
        nem:
        
    loop while_2        ;Repete while_2 até que ECX = 0
    
    ;Imprime os resultados
    PRINT_STRING str_q2a
    PRINT_DEC 1, bh
    NEWLINE
    PRINT_STRING str_q2m
    PRINT_DEC 1, bl
    NEWLINE
    NEWLINE
    
    ret

questao_3:
    mov esi, q1         ;move o endereço de q1 para ESI
    mov edi, q3         ;move o endereço de q3 para EDI
    mov ecx, 21d        ;Define ECX como 21 (metade do tamanho de q1)
    xor eax, eax
    
    while_3_1:
        lodsw           ;Carrega um word para AX
        push ax         ;Manda a word carregada para a pilha
    loop while_3_1      ;Repete while_3_1 até zerar ECX
    
    ;A partir daqui é o processo de desempilhamento da pilha,
    ;onde ocorre a inversão da string.
    ;Mais detalhes no "Apêndice 1", no final do código
    mov ecx, 20d        ;Define ECX como 20 (metade do tamanho de q1-1)
    pop ax              ;Desempilha um word para AX
    stosb               ;Move para q3 o valor de AL
    
    while_3_2:
        pop ax          ;Desempilha um word para AX
        xchg al, ah     ;Troca os valores de AL e AH
        stosw           ;Move para q3 o valor de AX
    loop while_3_2      ;Repete while_3_2 até que ECX = 0

    result q3           ;Imprime q3
    
    ret

questao_4:
    mov esi, q1         ;ESI recebe o endereço de q1
    mov edi, q4         ;EDI recebe o endereço de q4
    xor eax, eax        ;Zera eax
    mov ecx, 41d        ;Define ecx como 41 (tamanho de q1)

    while_4:
        lodsb           ;Carrega um caractere de q1 para AL
        cmp al, ' '     ;Compara se AL é um espaço
        je continue_4   ;Se sim, ignora-o
        stosb           ;Senão, amazena-o em q4
        continue_4:
    loop while_4        ;Repete while_4 até que ECX = 0

    result q4           ;Imprime q4
    
    ret

questao_5:
    mov esi, q1             ;Move o endereço de q1 para ESI
    mov edi, q5             ;Move o endereço de q5 para EDI
    mov ecx, 41d            ;Define ECX como 41 (tamanho de q1)
    xor eax, eax            ;Zera EAX
    mov bl, 2               ;Define BL como 2 (contador das maiúsculas)
    mov bh, 3               ;Define BH como 3 (contador das minúsculas)
    
    while_5:
        cmp bh, bl          ;Compara se BH e BL são iguais
        jne nozero_5        ;Se não, pula para nozero_5 (porque BL e/ou BH ainda não é 0)
        cmp bh, 0           ;Se sim, compara se BH é 0
        jne nozero_5        ;Se não, pula para nozero_5 (porque BL e/ou BH ainda não é 0)
        mov bx, 0302h       ;Se sim, define BL como 2 e BH como 3 outra vez
                            ;(pois o 5º e 4º caractere anterior já são maiúsculas, enquanto o 3º, 2º e 1º caractere já são minúsculas)
        
        nozero_5:
        lodsb               ;Carrega para AL um caractere de q1
        cmp al, ' '         ;Compara-o com o espaço
        je continue_5       ;Se sim, pula para continue_5 (pois não vamos fazer a transformação em espaço)
        
        cmp bl, 0           ;Compara se BL é 0
        je minusc_5         ;Se sim, isso significa que os 2 caracteres anteriores já são maiúsculas, então vamos pular essa parte
        uppercase al        ;Transforma o valor de AL em maiúscula
        dec bl              ;Decrementa BL
        jmp continue_5      ;Pula para continue_5 (para que AL não se transforme em minúscula com as instruções seguintes)
        
        minusc_5:
        lowercase al        ;Transforma AL em minúscula
        dec bh              ;Decrementa
        
        continue_5:
        stosb               ;Armazena AL em q5
        
    loop while_5            ;Repete while_5 até que ECX = 0
    
    result q5               ;Imprime q5
    
    ret

questao_6:
    mov esi, q1                 ;Move o endereço de q1 para ESI
    mov edi, q6                 ;Move o endereço de q6 para EDI (usaremos essa variável na questão 7)
    mov ecx, 41d                ;Define ECX como 41 (tamanho de q1)
    xor eax, eax                ;Zera EAX
    
    while_6:
        lodsb                   ;Carrega um caractere de q1 para AL
        cmp al, ' '             ;Verififica se AL é um espaço
        je continue_6           ;Se sim, pula para o final
        
        mov [q6c], al           ;Move o conteúdo de AL para a variável q6c
        PRINT_STRING q6c        ;Imprime q6c
        PRINT_STRING str_q6s    ;Imprime " -> "
        lowercase al            ;Transforma AL em minúscula (apenas para padronizar)
        sub al, 96              ;Subtrai AL por 96 (96 é a diferença de um caractere minúsculo para a sua posição no alfabeto)
        
        stosb                   ;Armazena AL em q6
        PRINT_DEC 1, al         ;Imprime o valor de AL
        cmp ecx, 1              ;Compara se ECX é 1
        je continue_6           ;Se sim, pula para o final (não imprime ", ", pois já é o último caractere)
        PRINT_STRING str_q6e    ;Senão, imprime ", "
        continue_6:
        
    dec ecx                     ;Decrementa ECX
    jnz while_6                 ;Volta para while_6 até que ECX = 0
    NEWLINE
    NEWLINE
    
    ret

questao_7:
    xor bh, bh                  ;Zera BH. Esse registrador será usado como contador de while_7e
    while_7e:
        xor ax, ax              ;Zera AX
        xor ecx, ecx            ;Zera ECX. Esse registrador será usado como contador de while_7i
        mov al, [q6]            ;Move para AL o 1º valor de q6. Aqui AL armazenará o menor valor de q6, exceto 0
        while_7i:
            mov bl, [q6+ecx]    ;Move para BL o caractere de q6+ECX. Entenda ECX como um contador de um for
            cmp bl, 0           ;Compara se BL é 0
            je endwhile_7i      ;Se sim, pula para o final de while_7i, pois o valor que tinha em q6+ECX já foi enviado para a pilha
            
            cmp al, 0           ;Compara se o valor de AL é 0
            jne nozero_7i       ;Se não, pula a próxima instrução
            mov al, bl          ;Se sim, isso significa que o valor de AL já foi enviado para a pilha, então define-se AL = BL
            nozero_7i:
            
            cmp al, bl          ;Compara se AL tem o mesmo valor de BL
            jl endwhile_7i      ;Se AL é menor que BL, então BL não nos interessa, pois estamos buscando os menores valores
            
            mov al, bl          ;Senão, o novo menor valor (AL) será o valor de BL
            mov edx, q6         ;Armazena o endereço de q6 em EDX
            add edx, ecx        ;Soma-se esse endereço com o index (ECX) do menor valor encontrado até agora.
        endwhile_7i:
        inc ecx                 ;Incrementa ECX
        cmp ecx, 36d            ;Compara se ECX com 36 (número de itens armazenados em q6)
        jl while_7i             ;Se for menor, repete while_7i até que ECX = 36
        
        mov byte [edx], 0       ;Define a posição de memória armazenada em EDX como 0
        push ax                 ;Manda o valor de AX para a pilha. Diferentemene de questao_3, vamos enviar um valor por vez
        
    inc bh                      ;Incrementa BH
    cmp bh, 36d                 ;Compara BH com 36
    jl while_7e                 ;Se for menor, repete while_7e. O processo se repete até BH = 36

    ;Limpeza dos registradores
    xor ax, ax
    xor cx, cx
    mov edi, q7                 ;Define EDI como o endereço de q7. Para facilitar o processo, vamos tratar q7 como uma string
    ploop_7:                    ;Loop para mover os valores ordenados da pilha para o vetor q7
        pop ax                  ;Retira da pilha um elemento e move para AX
        stosb                   ;Move o valor de AL para q7
    endploop_7:
    inc cx                      ;Incrementa CX
    cmp cx, 36d                 ;Compara CX com 36
    jl ploop_7                  ;Se for menor, repete ploop_7 até que CX = 36
    
    ;Limpeza dos registradores
    xor ecx, ecx
    xor ax, ax
    xor bx, bx
    sloop_7:                    ;Loop para imprimir o vetor e somar os valores para calcular a media
        mov bl, [q7+ecx]        ;Move para BL o valor do vetor q7 com index ECX
        PRINT_DEC 1, bl         ;Imprime-o
        add ax, bx              ;Soma AX com BX. AX é o somatório da média (BX foi inicialmente zerado, então BX = BL)
        cmp ecx, 35d            ;Compara se CX é igual a 35
        je endsloop_7           ;Se sim, pula a próxima instrução (não imprime ", ", pois já é o último número)
        PRINT_STRING str_q6e    ;Imprime ", "
    endsloop_7:
    inc ecx                     ;Incrementa ECX
    cmp ecx, 36d                ;Compara ECX com 36
    jl sloop_7                  ;Se for menor, repete sloop_7 até que CX = 36
    
    NEWLINE
    mov dl, 36d                 ;Define DL = 36 (quantidade de itens em q7)
    div dl                      ;Divide AX por DL
    PRINT_STRING str_q7m        ;Imprime "Media: "
    PRINT_DEC 1, al             ;Imprime o quociente da divisão (a parte inteira da média)
    NEWLINE
    ret  


;<APÊNDICE 1>
;Vamos supor que q1 = "banana". Definindo ESI como o endereço de q1 e carregando words (2 bytes) para AX 
;movendo AX para a pilha, a pilha ficaria assim (agrupando os elementos em words):
;--- ESP
;na
;na
;ba
;--- EBP
;"banana" invertido é "ananab", porém, se apenas desempilharmos as words para q3 (passando por AX, é claro),
;o processo seria o seguinte:
;--- ESP              --- ESP             --- ESP             --- ESP
;na                   na                  ba                  --- EBP
;na              =>   ba              =>  -- EBP          => 
;ba                   --- EBP                                 q3 = "nanaba"
;--- EBP              q3 = "na"           q3 = "nana"        
;POP AX e STOSW       POP AX e STOSW      POP AX e STOSW

;Ou seja, se apenas desempilharmos, q3 não terá o valor desejado. No entanto, se invertermos os valores de AL e AH:
;--- ESP              --- ESP             --- ESP             --- ESP
;na                   na                  ba                  --- EBP
;na                   ba                  -- EBP           
;ba              =>   --- EBP         =>                   => q3 = "ananab"
;--- EBP              q3 = "an"           q3 = "anan"        
;POP AX               POP AX              POP AX     
;XCHG AL, AH          XCHG AL, AH         XCHG AL, AH
;STOSW                STOSW               STOSW

;Agora sim temos a string desejada, ou seja, "ananab".