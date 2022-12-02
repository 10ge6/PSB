%include "io.inc"
section .data

    frase db "Qual e a importancia da escola na democratizacao da sociedade", 0h

section .bss

    R1 resb 36
    A resb 5
    M resb 5
    R4 resb 36
    MSG resb 36

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    call Q1
    call Q2
    call Q3
    call Q4
    
    ret

Q1:
    mov esi, frase + 7
    mov ecx, 41
    mov edi, R1
    cld
    rep movsb
    PRINT_STRING R1
    NEWLINE
ret
    
Q2:
    xor     eax,    eax
    xor     ebx,    ebx
    xor     ecx,    ecx
    xor     edx,    edx
    mov     ecx,    41
    mov     edi,    R1
    mov     al,     'a'
    cld

DENOVOA:
    repne   scasb
    JNE     CONT
    INC     bl
    JMP     DENOVOA

CONT:
    mov     al,     'm'
    mov     edi,    R1
    mov     ecx,    41

DENOVOM:
    repne   scasb
    JNE     Q2FIM
    INC     bh
    JMP     DENOVOM

Q2FIM:
    PRINT_DEC 1,    bl
    NEWLINE
    PRINT_DEC 1,    bh
    NEWLINE
    ret


Q3:
    xor     eax,    eax
    xor     ebx,    ebx
    xor     ecx,    ecx
    mov     ecx,    47      ; fim da string

Q3INICIO:
    cmp     ecx,    6       ; (comeco da string - 1, o espaco antes do primeiro 'a')
    je      Q3FIM
                                ; mov [Q3MSG+ebx], [frase+ecx] nao pode ser feito diretamente
    mov     eax,    [frase+ecx] ; portanto utilizamos eax como buffer
    mov     [MSG+ebx],  eax     ; para realizar a troca em duas partes
    inc ebx
    dec ecx
    jmp Q3INICIO

Q3FIM:
    mov     eax,    0       ; nao zerando o final de Q3MSG, por algum motivo(?) o comeco
    mov     [MSG+ebx],  eax ; da string aparece no final de Q3MSG (na direcao normal)
    PRINT_STRING MSG
    NEWLINE
    ret

Q4:
    xor     eax,    eax
    xor     ebx,    ebx
    xor     ecx,    ecx
    xor     edx,    edx
    mov     edx,    20h
Q4INICIO:
    cmp     ecx,    41
    je      Q4FIM
    
    cmp     [R1 + ecx],  edx  
    je      Igual
    
    mov     eax,    [R1 + ecx]
    mov     [R4 + ebx], eax
    inc     ebx
    inc     ecx
    jmp     Q4INICIO     
Igual:
    inc     ecx
    jmp     Q4INICIO

Q4FIM:
    mov     eax,    0       ; nao zerando o final de Q3MSG, por algum motivo(?) o comeco
    mov     [R4+ebx],  eax ; da string aparece no final de Q3MSG (na direcao normal)
    PRINT_STRING R4
    NEWLINE
    ret

   
