.model small
.stack 100h

.data
    oneChar dw 00h
    buffer dw 10 dup(2)
    counter db 0
    arrayIndex dw 0
    power dw 0
    inputBuffer dw 0

    isSpace db 0


.code
main proc
    mov ax, @data
    mov ds, ax

    input:
       mov ah, 3Fh
       mov bx, 0h  ; stdin handle
       mov cx, 1   ; 1 byte to read
       mov dx, offset oneChar   ; read to ds:dx 
       int 21h 

       mov inputBuffer, ax

        ;TODO check EOF
        cmp oneChar, 0Dh
        je update_array
        cmp oneChar, 20h
        je update_array
        cmp oneChar, 0Ah
        je update_array
        ;check if the program should stop
        cmp oneChar, 'a'
        je check

        mov isSpace, 0
    
        push oneChar ;saving the value to the stack
        inc counter ;counter for digits in one number
    
    end_input:
        mov ax, inputBuffer
        or ax, ax
        jnz input

        jmp update_array
    
    update_array:
        mov cl, counter ;amount of digits in one number
        ;set to zero
        xor ax, ax
        xor dx, dx 
        
    convert_decimal:
            pop ax
            sub ax, '0' ;convert to ascii
            push cx
            push dx
            call powerOfTen
            pop dx
            pop cx
            inc power
            add dx, ax
            loop convert_decimal

            ;reset for next number
            mov counter, 0
            mov power, 0

    add_to_array:
        ;adding a decimal number to array
            add bx, arrayIndex 
            mov [buffer + bx], dx
            add arrayIndex, 2
            
            jmp end_input



    ;function to convert a symbol to a decimal number
    powerOfTen:
        mov cx, [power] 
        mov bx, 10 

        cmp cx, 0 ; if the power is 0, we don't need to do anything
        je endPowerOfTen ; jump to endPowerOfTen if cx is zero

        powerLoop:
            mul bx ; multiply ax by 10 ?
            loop powerLoop  

        endPowerOfTen:
        ret 

        ;check if the program should stop
    check:
        mov ah, 02h
        mov dl, 'f'
        int 21h
        
    end_program:
        mov ax, 4C00h   
        int 21h

main endp
end main
