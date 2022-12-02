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
    mov     edx,    2           ; comprimento 2 (1 num + null terminator)
    push    ecx                 ; por no stack para passar pointer para imprimir
    mov     [esp+1],byte 0Ah    ; inserir linefeed
    mov     [esp+2],byte 0h     ; inserir null terminator
    mov     ecx,    esp         ; passar pointer para imprimir
    mov     eax,    4           ; SYS_PRINT
    mov     ebx,    1           ; STDOUT
    int     80h                 ; syscall
    pop     ecx                 ; retomar ecx
    ret

; void sysquit()
sysquit:
    mov     ebx, 0
    mov     eax, 1
    int     80h
    ret
