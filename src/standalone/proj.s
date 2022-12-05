%include "lib.s"

section .data
frase:      db      "Qual e a importancia da escola na democratizacao da sociedade", 0h
newline:    db      0Ah, 0h
acount:     db      " 'a's", 0h
mcount:     db      " 'm's", 0h
seta:       db      " -> ", 0h
quociente:  db      "quociente: ", 0h
resto:      db      "resto: ", 0h

section .bss
msg:        resb    41          ; reservar area na memoria com comprimento da string desejada ("a importancia...democratizacao")
inv:        resb    41
concat:     resb    36
caps:       resb    41
numeros:    resb    36
charbuf:    resb    1
sorted:     resb    36
indice:     resb    1

section .text
global _start

_start:
    
    call    Q1
    call    Q2
    call    Q3
    call    Q4
    call    Q5
    call    Q6
    call    Q7
    
    call    sysquit


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
    xor     eax,    eax
    xor     ebx,    ebx
    mov     ecx,    41          ; mesmo setup: comprimento de msg
    mov     edi,    msg         ; e seu pointer
    mov     al,     byte 61h    ; compararemos primeiro contra 'a'

DENOVOA:
    repne   scasb               ; percorre a string (repne termina quando ECX = 0; scasb le de EDI e compara contra EAX, muda EDI considerando DF. ZF = 0 quando a comparacao e diferente! por
                                ; isso que caso exista a possibilidade da string terminar com o caractere sendo procurado, deve haver um jcxz antes do ultimo jmp; evitar um loop infinito)
    jne     CONT                ; jump caso ZF = 0 (neste caso seria ate possivel fazer o contrario e so ter jcxz aqui)
    inc     ebx                 ; ebx e utilizado como counter de 'a's
    jmp     DENOVOA

CONT:
    mov     al,     byte 6dh    ; agora, contra 'm'
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
    mov     eax,    acount
    call    strecho
    mov     ecx,    edx
    call    regprint
    mov     eax,    mcount
    call    strecho
    ret


Q3:
    xor     ebx,    ebx         ; zerar ebx para poder usar como incremento ao criar a string inversa
    mov     ecx,    47          ; fim da string (ultimo 'o')

Q3INVRT:
    cmp     ecx,    6           ; checar se estamos no comeco da string - 1 (o espaco antes do primeiro 'a')
    je      Q3FIM               ; caso sim, terminar
    mov     al,    [frase+ecx]  ; mov [Q3MSG+ebx], [frase+ecx] nao pode ser feito diretamente, portanto
    mov     [inv+ebx], al       ; utilizamos al como buffer para realizar essa troca, um byte por vez
    inc     ebx                 ; proximo caractere a ser colocado na string a imprimir
    dec     ecx                 ; caractere anterior a ser lido da string normal
    jmp     Q3INVRT

Q3FIM:
    mov     eax,    inv
    call    strecho
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
    mov     eax,    concat
    call    strecho
    ret


Q5:
    xor     ecx,    ecx
    xor     ebx,    ebx
    
Q5UPPER:
    cmp     ecx,    41          ; checar por fim da string
    je      Q5FIM
    cmp     [msg+ecx], byte 20h ; char ' '?
    je      Q5PULARESPACOU      ; queremos ignorar espacos
    mov     al,     [msg+ecx]   ; buffer
    sub     al,     32          ; converter para uppercase
    mov     [caps+ecx],   al    ; buffer
    inc     ecx                 ; counter posicao string
    inc     ebx                 ; counter loop
    cmp     ebx,    2           ; dois caracteres em uppercase por vez
    jne     Q5UPPER
    xor     ebx,    ebx         ; a ser reutilizado para loop lowercase
Q5LOWER:
    cmp     ecx,    41
    je      Q5FIM
    cmp     [msg+ecx], byte 20h
    je      Q5PULARESPACOL
    mov     al,     [msg+ecx]
    mov     [caps+ecx],   al
    inc     ecx
    inc     ebx
    cmp     ebx,    3           ; desta vez sao tres caracteres por vez
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
    mov     eax,    caps
    call    strecho
    ret
	
	
Q6:
    xor     eax,    eax
    xor     ebx,    ebx
    xor     ecx,    ecx
   
Q6INICIO:
    cmp     ecx,    41
    je      Q6FIM
    cmp     [msg+ecx], byte 20h ; char ' '?
    jne     Q6MEIO
    inc     ecx                 ; counter para iterar pela string (ebx itera pelo vetor que setamos com os numeros)
    jmp     Q6INICIO
Q6MEIO:
    mov     al,     [msg+ecx]
    sub     al,     96          ; converter para numero
    mov     [numeros+ebx], al
    inc     ebx
    push    eax                 ; preservar eax
    mov     al,     [msg+ecx]   ; .
    mov     [charbuf], al       ; .
    mov     eax,    charbuf     ; .
    call    sprint              ; pois o mesmo e argumento de sprint
    mov     eax,    seta
    call    sprint
    pop     eax                 ; recuperar eax
    push    ecx                 ; preservar ecx
    mov     ecx,    eax         ; ...
    call    regecho             ; pois o mesmo e argumento de regecho
    pop     ecx                 ; recuperar ecx
    inc     ecx
    jmp     Q6INICIO
   
Q6FIM:
    ret


Q7:
    xor     ebx,    ebx
    mov     ecx,    36          ; comprimento do array de numeros
    
Q7SORT:
    dec     ecx                 ; percorremos o array 36x, cada vez colocando o numero mais alto encontrado em ultimo no array sorted
    xor     eax,    eax
    xor     edx,    edx
Q7STRITER:
    cmp     edx,    36          ; checar se percorremos o array inteiro nesta iteracao
    je      Q7SETMAX
    mov     bl,     [numeros+edx]
    cmp     bl,     al          ; checar se numero na posicao atual no array e maior que o em al
    jg      Q7SETBUF
Q7AFTERSET:
    inc     edx                 ; checar proximo numero no array
    jmp     Q7STRITER
Q7SETBUF:
    mov     al,     bl
    mov     [indice], edx       ; salvar indice de numero mais alto na iteracao atual
    jmp     Q7AFTERSET

Q7SETMAX:
    mov     [sorted+ecx], al
    mov     edx,    [indice]
    mov     [numeros+edx], byte 0 ; temos o numero mais alto ja em sorted, o zeramos em numeros para encontrarmos o proximo mais alto
    push    ecx
    mov     cl,     [sorted+ecx]
    call    regecho
    pop     ecx
    cmp     ecx,    0
    je      Q7MEDIA             ; caso tenhamos percorrido o array inteiro, calcular media
    jmp     Q7SORT              ; retornar ao comeco do sort para mais uma iteracao
    
Q7MEDIA:
    xor     eax,    eax
    xor     ebx,    ebx
    xor     ecx,    ecx
    xor     edx,    edx
Q7ADD:
    cmp     ecx,    36
    je      Q7CALC
    mov     bl,     [sorted+ecx]
    add     eax,    ebx         ; somamos todos os numeros de sorted e guardamos o resultado em eax
    inc     ecx
    jmp     Q7ADD
Q7CALC:
    div     ecx
    push    eax
    mov     eax,    quociente
    call    sprint
    pop     eax
    mov     ecx,    eax
    call    regecho
    mov     eax,    resto
    call    sprint
    mov     ecx,    edx
    call    regprint
    ret


; qol "macros"
linefeed:
    push    eax
    mov     eax,    newline
    call    sprint
    pop     eax
    ret
	
regecho:
    call    regprint
    call    linefeed
    ret
