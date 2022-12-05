; int slen(char message[])
slen:
    push    ebx
    mov     ebx, eax

nextchar:
    cmp     byte [eax], 0
    jz      finished
    inc     eax
    jmp     nextchar

finished:
    sub     eax, ebx
    pop     ebx
    ret


; void sprint(char message[])
sprint:
    push    edx
    push    ecx
    push    ebx
    push    eax
    call slen

    mov     edx, eax
    pop     eax

    mov     ecx, eax
    mov     ebx, 1
    mov     eax, 4
    int     80h

    pop     ebx
    pop     ecx
    pop     edx
    ret


; void strecho(char message[])
strecho:
    call    sprint

    push    eax
    mov     eax, 0Ah
    push    eax
    mov     eax, esp
    call    sprint
    pop     eax
    pop     eax
    ret

regprint:   ; printa conteudo de um registrador com valor entre 0-9
    add     ecx,    48          ; conversao para ASCII
    cmp     ecx,    57
    push    eax
    push    ebx
    push    edx	
    jg      twochar
    mov     edx,    2           ; comprimento 2 (1 num + null terminator)
    push    ecx                 ; por no stack para passar pointer para imprimir
    mov     [esp+1],byte 0h     ; inserir null terminator
    mov     ecx,    esp         ; passar pointer para imprimir
    mov     eax,    4           ; SYS_PRINT
    mov     ebx,    1           ; STDOUT
    int     80h                 ; syscall
    pop     ecx                 ; retomar ecx
    pop     edx
    pop     ebx
    pop     eax
    ret
twochar:
    mov     edx,    3
    mov     eax,    48
tens:
    add     eax,    1
    sub     ecx,    10
    cmp     ecx,    57
    jg      tens
    push    eax
    mov     [esp+1],ecx
    mov     [esp+2],byte 0h
    mov     ecx,    esp         ; passar pointer para imprimir
    mov     eax,    4           ; SYS_PRINT
    mov     ebx,    1           ; STDOUT
    int     80h                 ; syscall
    pop     eax
    
    pop     edx
    pop     ebx
    pop     eax
    ret

; void sysquit()
sysquit:
    mov     ebx, 0
    mov     eax, 1
    int     80h
    ret
