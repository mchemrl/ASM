.model small
.stack 100h

.data
    buffer db 80h dup(?)

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 3Fh
    mov bx, 0
    lea dx, buffer
    mov cx, 80h
    int 21h

    cmp ax, cx
    jae check_eof
    mov cx, ax

display:
    mov ah, 02h
    mov si, 0

print_loop:
    mov dl, buffer[si]
    int 21h
    inc si
    loop print_loop
check_eof:
    mov ah, 3Eh
    mov bx, 0
    int 21h

    cmp ax, 80h
    jne end_program

    jmp main

end_program:
    mov ax, 4C00h
    int 21h

main endp
end main