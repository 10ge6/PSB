%include "lib.s"

section .data
frase: db "Qual e a importancia da escola na democratizacao da sociedade", 0h

section .bss
msg: resb 41                    ; reservar area na memoria com comprimento da string desejada ("a importancia...democratizacao")

section .text
global _start

_start:
    
    call Q1
    call Q2
    call Q3
    
    call sysquit


Q1:
    mov     esi,    frase+7     ; offset para comecar em "a importancia..."
    mov     ecx,    41          ; comprimento ate "democratizacao"
    mov     edi,    msg         ; comecar a copiar string no endereco msg
    cld                         ; garantir DF em estado correto
    rep     movsb               ; passar parte desejada da string
    mov     eax,    msg         ; setup e
    call    strecho             ; print
    ret


Q2:
    mov     ecx,    41          ; mesmo setup: comprimento de msg
    mov     edi,    msg         ; e seu pointer
    mov     eax,    'a'         ; compararemos primeiro contra 'a'

DENOVOA:
    repne   scasb               ; percorre a string (repne termina quando ECX = 0; scasb le de EDI e compara contra EAX, muda EDI considerando DF. ZF = 0 quando a comparacao e diferente! por
                                ; isso que caso exista a possibilidade da string terminar com o caractere sendo procurado, deve haver um jcxz antes do ultimo jmp; evitar um loop infinito)
    jne     CONT                ; jump caso ZF = 0 (neste caso seria ate possivel fazer o contrario e so ter jcxz aqui)
    inc     ebx                 ; ebx e utilizado como counter de 'a's
    jmp     DENOVOA

CONT:
    mov     eax,    'm'
    mov     edi,    msg
    mov     ecx,    41

DENOVOM:
    repne   scasb
    jne     Q2FIM
    inc     edx                 ; edx e utilizado como counter de 'm's
    jmp     DENOVOM

Q2FIM:
    mov     ecx,    ebx
    call    regprint
    mov     ecx,    edx
    call    regprint
    ret


Q3:
    xor     ebx,    ebx         ; zerar ebx para poder usar como incremento ao criar a string inversa
    mov     ecx,    47          ; fim da string (ultimo 'o')

Q3INVRT:
    cmp     ecx,    6           ; checar se estamos no comeco da string - 1 (o espaco antes do primeiro 'a')
    je      Q3FIM               ; caso sim, terminar
    mov     al,    [frase+ecx]  ; mov [Q3MSG+ebx], [frase+ecx] nao pode ser feito diretamente, portanto
    mov     [msg+ebx], al       ; utilizamos al como buffer para realizar essa troca, um byte por vez
    inc ebx                     ; proximo caractere a ser colocado na string a imprimir
    dec ecx                     ; caractere anterior a ser lido da string normal
    jmp Q3INVRT

Q3FIM:
    mov     eax,    msg
    call    strecho
    ret
