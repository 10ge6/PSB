%include "io.inc"
section .data

    frase db "Qual e a importancia da escola na democratizacao da sociedade", 0h
    
    setadir db "->"
    
    fst0 dw 0.0
    fst1 dw 0.0
    
section .bss

    msg resb 41
    inv resb 41
    concat resb 36
    caps resb 41
    numeros resb 36
    sorted resb 36
    indice resw 1
    
section .text
global CMAIN
CMAIN:

    mov ebp, esp; for correct debugging
    
    call Q1
    call Q2
    call Q3
    call Q4
    call Q5
    call Q6
    call Q7
    
    ret
    
    
Q1:
    mov esi, frase + 7         ; offset para comecar em "a importancia..."
    mov ecx, 41                ; comprimento ate "democratizacao"
    mov edi, msg               ; comecar a copiar string no endereco msg
    cld                        ; garantir DF em estado correto
    rep movsb                  ; passar parte desejada da string
    PRINT_STRING msg
    NEWLINE
    ret
    
    
Q2:
    xor     eax,    eax         ; zerar registradores ainda
    xor     ebx,    ebx         ; nao utilizados no programa
    mov     ecx,    41          ; mesmo setup: comprimento de msg
    mov     edi,    msg         ; e seu pointer
    mov     al,     'a'         ; compararemos primeiro contra 'a'
    
Q2DENOVOA:
    repne   scasb               ; percorre a string (repne termina quando ECX = 0; scasb le de EDI e compara contra EAX,
                                ; muda EDI considerando DF.ZF = 0 quando a comparacao e diferente! por isso que caso exista
                                ; a possibilidade da string terinar com o caractere sendo procurado, deve haver um jcxz antes
                                ; do ultimo jmp; evitar um loop infinito)
    jne     Q2CONT              ; jump caso ZF = 0 (neste caso seria ate possivel fazer o contrario e so ter jcxz aqui)
    inc     bl                  ; bl e utilizado como counter de 'a's
    jmp     Q2DENOVOA
    
Q2CONT:
    mov     al,     'm'
    mov     edi,    msg
    mov     ecx,    41
    
Q2DENOVOM:
    repne   scasb
    jne     Q2FIM
    inc     bh                  ; bh e utilizado como counter de 'm's
    jmp     Q2DENOVOM
    
Q2FIM:
    PRINT_DEC 1,    bl
    NEWLINE
    PRINT_DEC 1,    bh
    NEWLINE
    ret
    
    
Q3:
    xor     ebx,    ebx         ; zerar ebx para poder usar como incremento ao criar a string inversa
    mov     ecx,    47          ; fim da string (ultimo 'o')
    
Q3INICIO:
    cmp     ecx,    6           ; checar se estamos no comeco da string - 1 (o espaco antes do primeiro 'a')
    je      Q3FIM               ; caso sim, terminar
    mov     al,    [frase+ecx]  ; mov [Q3MSG+ebx], [frase+ecx] nao pode ser feito diretamente, portanto
    mov     [inv+ebx],  al      ; utilizamos al como buffer para realizar essa troca, um byte por vez
    inc ebx                     ; proximo caractere a ser colocado na string a imprimir
    dec ecx                     ; caractere anterior a ser lido da string normal
    jmp Q3INICIO
    
Q3FIM:
    PRINT_STRING inv
    NEWLINE
    ret
    
    
Q4:
    xor     ebx,    ebx         ; zerar para utilizar como counter de indice
    xor     ecx,    ecx         ; das strings origem e concatenada
    
Q4INICIO:
    cmp     ecx,    41          ; checar se no fim da string origem
    je      Q4FIM
    cmp     [msg+ecx], byte 20h ; char ' '?
    je      Q4IGUAL
    mov     al,    [msg+ecx]    ; mesma ideia, utilizar
    mov     [concat+ebx], al    ; registrador como buffer
    inc     ebx                 ; incrementar
    inc     ecx                 ; indices
    jmp     Q4INICIO
    
Q4IGUAL:
    inc     ecx                 ; pular whitespace
    jmp     Q4INICIO
    
Q4FIM:
    PRINT_STRING concat
    NEWLINE
    ret
    
    
Q5:
    xor     ecx,    ecx
    xor     ebx,    ebx
    
Q5UPPER:
    cmp     ecx,    41
    je      Q5FIM
    cmp     [msg+ecx], byte 20h ; char ' '?
    je      Q5PULARESPACOU
    mov     al,     [msg+ecx]
    sub     al,     32
    mov     [caps+ecx],   al
    inc     ecx
    inc     ebx
    cmp     ebx,    2
    jne     Q5UPPER
    xor     ebx,    ebx
    
Q5LOWER:
    cmp     ecx,    41
    je      Q5FIM
    cmp     [msg+ecx], byte 20h
    je      Q5PULARESPACOL
    mov     al,     [msg+ecx]
    mov     [caps+ecx],   al
    inc     ecx
    inc     ebx
    cmp     ebx,    3
    jne     Q5LOWER
    xor     ebx,    ebx
    jmp     Q5UPPER
    
Q5PULARESPACOU:
    mov     al,     [msg+ecx]
    mov     [caps+ecx],   al
    inc     ecx
    jmp     Q5UPPER
    
Q5PULARESPACOL:
    mov     al,     [msg+ecx]
    mov     [caps+ecx],   al
    inc     ecx
    jmp     Q5LOWER
    
Q5FIM:
    PRINT_STRING caps
    NEWLINE
    ret
    
    
Q6:
   xor      ebx,    ebx
   xor      ecx,    ecx
   
Q6INICIO:
   cmp      ecx,    41
   je       Q6FIM
   cmp      [msg + ecx], byte 20h
   jne      Q6MEIO
   inc      ecx
   jmp      Q6INICIO

Q6MEIO:
   mov      al,     [msg + ecx]
   sub      al,     96
   mov      [numeros+ebx], al
   inc      ebx
   PRINT_CHAR [msg + ecx]
   PRINT_CHAR " "
   PRINT_CHAR "-"
   PRINT_CHAR ">"
   PRINT_CHAR " "
   PRINT_DEC 1,     al
   NEWLINE
   inc      ecx
   jmp      Q6INICIO
   
Q6FIM:
   ret    
    
    
Q7:
    xor     ebx,    ebx
    mov     ecx,    36
    jmp     Q7SORT
    
Q7SORT:
    dec     ecx
    xor     eax,    eax
    xor     edx,    edx
Q7STRITER:
    cmp     edx,    36
    je      Q7SETMAX
    mov     bl,     [numeros+edx]
    cmp     bl,     al
    jg      Q7SETBUF
Q7AFTERSET:
    inc     edx
    jmp     Q7STRITER
    
Q7SETBUF:
    mov     al,     bl
    mov     [indice], edx
    jmp     Q7AFTERSET
    
Q7SETMAX:
    mov     [sorted+ecx], al
    mov     edx,    [indice]
    mov     [numeros+edx], byte 0
    PRINT_DEC 1, [sorted+ecx]
    PRINT_CHAR ' '
    cmp     ecx,    0
    je      Q7MEDIA
    jmp     Q7SORT
    
Q7MEDIA:
    NEWLINE
    xor     eax,    eax
    xor     ebx,    ebx
    xor     ecx,    ecx
    xor     edx,    edx
Q7ADD:
    cmp     ecx,    36
    je      Q7CALC
    mov     bl,     [sorted+ecx]
    add     eax,    ebx
    inc     ecx
    jmp     Q7ADD
Q7CALC:
    div     ecx
    PRINT_STRING "quociente: "
    PRINT_DEC 4, eax
    NEWLINE
    PRINT_STRING "resto: "
    PRINT_DEC 4, edx
    NEWLINE
    ret