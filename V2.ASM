.model small
.stack 100h

.data
    oneChar db 00h
    buffer dw 1000 dup(2)
    counter dw 0
    arrayIndex dw 0
    power dw 0
    inputBuffer dw 0
    binaryResult dw 0
    isSpace db 0
    printBuffer db 1000 dup(0)
    countArrayNum dw 0
    arraySum dw 0
    newline db 0Dh, 0Ah, '$' ; Define a newline string

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
        cmp oneChar, 0Dh ;check if the input is a new line
        je update_array
        cmp oneChar, 20h ;check if the input is a space
        je update_array
        cmp oneChar, 0Ah ;check if the input is a new line
        je update_array
        cmp oneChar, 'a'
        je bubble_sort

        mov isSpace, 0
    
        push dx ;saving the value to the stack
        inc counter ;counter for digits in one number
    
    end_input:
        mov ax, inputBuffer
        or ax, ax
        jnz input

        jmp update_array
    
    update_array:

        mov cx, counter ;amount of digits in one number
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
            inc countArrayNum
            jmp end_input

            bubble_sort:
                        mov cx, word ptr countArrayNum
                        dec cx  ; count-1
                    outerLoop:
                        push cx
                        lea si, buffer
                    innerLoop:
                        mov ax, [si]
                        cmp ax, [si+2]
                        jl nextStep
                        xchg [si+2], ax
                        mov [si], ax
                    nextStep:
                        add si, 2
                        loop innerLoop
                        pop cx
                        loop outerLoop

                find_median:
                        mov cx, word ptr countArrayNum
                        shr cx, 1 ; Divide countArrayNum by 2 to get the index of the middle number
                        lea si, buffer
                        add si, cx ;
                        add si, cx ; Add the index to the start of the buffer to get the address of the middle number
                        mov bx, [si] ; Load the middle number into AX

                       
                        ; Output the middle number to the console
                        mov ah, 02h
                        add bx, '0'  ; Convert number to ASCII character
                        mov dl, bl   ; bl is the lower byte of bx
                        int 21h

                        jmp calculate_sum

                       calculate_sum:
                        xor bx, bx
                        lea si, buffer
                        mov cx, word ptr countArrayNum

                        calculate_sum_loop:
                            mov ax, [si]
                            add arraySum, ax
                            add si, 2
                            loop calculate_sum_loop
                            mov bx, arraySum ;bx contains the sum of all elements
                            mov cx, countArrayNum ;cx contains the number of elements
                    calculate_average:
    ; Move the sum to axcalculate_average:
    ; Move the sum to ax
    mov ax, bx

    ; Initialize the quotient to 0
    xor dx, dx

    ; Check if cx is zero to avoid division by zero
    cmp cx, 0
    je end_program

    ; Division loop
    division_loop:
        ; Subtract the divisor from the dividend
        sub ax, cx

        ; Check if the result is negative
        js end_division

        ; If not, increment the quotient and repeat
        inc dx
        jmp division_loop

    end_division:
        ; Add the divisor back to the dividend
        add ax, cx
        mov bx, dx
                        mov ah, 02h
                        add bx, '0'  ; Convert number to ASCII character
                        mov dl, bl   ; bl is the lower byte of bx
                        int 21h
 
    jmp end_program







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

        ret

        ;check if the program should stop
        
    end_program:
        mov ax, 4C00h   
        int 21h

main endp
end main
