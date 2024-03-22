.model small
.stack 100h

.data
    oneChar db 00h
    buffer dw 1000 dup(2)
    counter db 0
    arrayIndex dw 0
    power dw 0
    inputBuffer dw 0
    binaryResult dw 0

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

       mov ah, 02h
       mov dl, oneChar
       int 21h

        ;check EOF
        cmp oneChar, 0Dh
        je update_array
        cmp oneChar, 20h
        je update_array
        cmp oneChar, 0Ah
        je update_array
    ;   cmp oneChar, 'a'
    ;   je check

        mov isSpace, 0
    
        push dx ;saving the value to the stack
        inc counter ;counter for digits in one number
    
    end_input:
        mov ax, inputBuffer
        or ax, ax
        jnz input

        cmp counter, 0
        je check

        jmp update_array
    
    update_array:
        inc isSpace
        cmp isSpace, 2
        je check

        mov cl, counter ;amount of digits in one number
        ;set to zero
        xor ax, ax
        xor dx, dx 
        
    convert_decimal:
            pop ax
            sub ax, '0' ;convert to ascii

            push cx
            push dx
            call convertion
            pop dx
            pop cx

            add dx, ax
            inc power

    loop convert_decimal

    ;reset for next number
            mov counter, 0
            mov power, 0

    ;adding a decimal number to array
            lea bx, [buffer]
            add bx, arrayIndex 
            mov [bx], dx
            add arrayIndex, 2
            
            jmp end_input

    ;function to convert a symbol to a decimal number
    convertion:
        mov cx, [power] 
        mov bx, 10 

        cmp cx, 0 ; if the power is 0, we don't need to do anything
        je endPowerOfTen ; jump to endPowerOfTen if cx is zero

        powerLoop:
            mul bx ; multiply ax by 10 ?
            loop powerLoop  

        endPowerOfTen:
    ; TODO convert AX from decimal to binary by repeatedly dividing by 2
        mov bx, 2
        mov cx, 16 ; maximum number of bits in AX
        mov binaryResult, 0

        convertLoop:
        xor dx, dx ; clear DX
        div bx ; divide DX:AX by BX, quotient in AX, remainder in DX

        shl binaryResult, 1
        or binaryResult, dx ; add the remainder to the binary result   

        loop convertLoop

        ret

        ;check if the program should stop
    check:
        
    end_program:
        mov ax, 4C00h   
        int 21h

main endp
end main
