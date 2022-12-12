slen:
    push    ebx
    mov     ebx,    eax

nextchar:
    cmp     byte [eax], 0       ; null terminator
    jz      finished
    inc     eax
    jmp     nextchar

finished:
    sub     eax,    ebx
    pop     ebx
    ret


sprint:
    push    edx
    push    ecx
    push    ebx
    push    eax
    call slen

    mov     edx,    eax
    pop     eax

    mov     ecx,    eax
    mov     eax,    4           ; SYS_PRINT
    mov     ebx,    1           ; STDOUT
    int     80h

    pop     ebx
    pop     ecx
    pop     edx
    ret


strecho:
    call    sprint

    push    eax
    mov     eax,    0Ah         ; '\n'
    push    eax
    mov     eax,    esp
    call    sprint
    pop     eax
    pop     eax
    ret


regprint:                       ; printa conteudo de um registrador com valor entre 0-99
    add     ecx,    48          ; conversao para ASCII
    cmp     ecx,    57          ; comparar com '9'
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
twochar:                        ; adaptar argumentos da syscall para +1 ao comprimento do print
    mov     edx,    3
    mov     eax,    48
tens:                           ; ecx-=10 ate chegar entre '0'-'9', eax+=1 (casa decimal)
    add     eax,    1
    sub     ecx,    10
    cmp     ecx,    57
    jg      tens
    push    eax
    mov     [esp+1],ecx         ; eax concat ecx para exibir resultado
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


sysquit:
    mov     ebx, 0              ; EXIT_SUCCESS
    mov     eax, 1              ; SYS_EXIT
    int     80h                 ; http://www.int80h.org/
    ret
