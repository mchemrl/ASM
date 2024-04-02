.model small
    .stack 100h

    .data
        oneChar db 00h
        buffer dw 1000 dup(2)
        counter dw 0
        arrayIndex dw 0
        power dw 0
        inputBuffer dw 0
        isSpace db 0
        isNeg db 0
        countArrayNum dw 0
        arraySum dw 0
        newline db 0Dh, 0Ah, '$' ; define a newline string
        ;to store median and average somewhere
        median dw 0
        average dw 0
        counterMedian dw 0 ; to count amount of digits in median
        counterAverage dw 0 ; to count amount of digits in average
    
    .code
    main proc
        mov ax, @data
        mov ds, ax

        input:
            push bx
            push cx

            mov ah, 3Fh
            mov bx, 0h  ; stdin handle
            mov cx, 1   ; 1 byte to read
            mov dx, offset oneChar   ; read to ds:dx 
            int 21h 

            pop bx
            pop cx
        
            mov inputBuffer, ax

            or ax, ax
            jnz next
            or ax, ax
            jz end_input

        next: 
            mov ah, 02h
            mov dl, oneChar

                cmp oneChar, '-'
                je set_neg
                ;check for spaces and newlines
                cmp oneChar, 0Dh ;check if the input is a new line
                je input
                cmp oneChar, 20h ;check if the input is a space
                je update_array
                cmp oneChar, 0Ah ;check if the input is a new line
                je input
                
            mov isSpace, 0
            push dx ; Saving the value to the stack
            inc counter ;  
            jmp end_input

            set_neg:
            mov isNeg, 1   
        
            end_input:
            mov ax, inputBuffer
            or ax, ax
            jnz input

            jmp update_array
        
        update_array:

            cmp counter, 0
            je bubble_sort

            mov cx, counter ;amount of digits in one number
            ;set to zero
            xor ax, ax
            xor dx, dx 
            
        convert_decimal:

            pop ax
            sub ax, '0' ;convert to ascii
            push cx
            push dx
            call convertionToDecimal
            pop dx
            pop cx

            add dx, ax
            inc power

            cmp dx, 32767
            jg set_max
            cmp dx, -32768
            jl set_min

            loop convert_decimal
            jmp end_check

            set_max:
            mov dx, 32767
            jmp end_check

            set_min:
            mov dx, -32768

           
        end_check:
        ;reset for next number
            mov counter, 0
            mov power, 0 
                
            cmp isNeg, 1
            je negate_number

        add_toarray:
        ;adding a decimal number to array
            lea bx, [buffer]
            add bx, arrayIndex 
            mov [bx], dx
            add arrayIndex, 2
            inc countArrayNum
            jmp end_input

        negate_number:
            neg dx
            mov isNeg, 0
            jmp add_toarray

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
                mov bx, [si]   ; load the middle number to ax
                mov ax, bx

                mov bx, 10 ; We will divide by 10 to get each digit
                mov cx, 0 ; CX will hold the count of digits
                           
                cmp ax, 0
                jl checkminus_median

                mov median, ax
                        
            count_digits:

                xor dx, dx ; Clear DX for division
                cmp ax, '-'
                je checkminus_median
                div bx ; Divide AX by BX, quotient in AX, remainder in DX
                inc cx ; Increment the count of digits
                test ax, ax ; Check if there are more digits to process
                jnz count_digits 
                mov counterMedian, cx; amount of digits in meadian

                    ; output the middle number to the console
                    ; TODO get the remainder of number, print it in a loop. add some counter to cx
                mov ax, median

            convert_median_loop:
                            
                mov bx, 10; 
                xor dx, dx     ; Clear DX before division to hold the remainder
                div bx           ; AX = AX / BX, DX = AX % BX
                push dx         ; push the remainder to the stack
                loop convert_median_loop
                
                mov cx, counterMedian

            print_median_loop:
                cmp isNeg, 1
                je print_minus_median
                print_median_loop_next:
                    pop dx 
                    add dx, '0'
                    mov ah, 02h
                    int 21h
                    loop print_median_loop

                    mov dx, offset newline
                    mov ah, 09h
                    int 21h

                    jmp calculate_sum

            checkminus_median:
                mov isNeg, 1
                neg ax
                mov median, ax
                jmp count_digits

            print_minus_median:
                mov dx, '-'
                mov ah, 02h
                int 21h
                mov isNeg, 0
                jmp print_median_loop_next

            calculate_sum:

                mov isNeg, 0
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

                cmp arraySum,0
                jl negate_sum

            calculate_average:
                mov ax, bx
                xor dx, dx
                cmp cx, 0
                je fix_end
            
            division_loop:
                sub ax, cx
                js end_division
                inc dx
                jmp division_loop

            end_division:
                add ax, cx
                mov bx, dx
                mov ax, bx
                mov bx, 10 
                mov cx, 0 
                cmp ax, 0
                jl checkminus_avg

                mov average, ax 

                jmp count_digitsAVG

            negate_sum:
                neg bx
                mov arraySum, bx
                mov isNeg, 1
                jmp calculate_average
                            
            fix_end:
                jmp end_program

            count_digitsAVG:
                xor dx, dx 
                cmp ax, '-'
                je checkminus_avg
                div bx 
                inc cx 
                test ax, ax 
                jnz count_digitsAVG

                mov ax, average
                mov counterAverage, cx 

            convert_average_loop:
                mov bx, 10; 
                xor dx, dx    ; Clear DX before division to hold the remainder
                div bx           ; AX = AX / BX, DX = AX % BX
                push dx         ; push the remainder to the stack
                loop convert_average_loop
                mov cx, counterAverage
                        
            print_average_loop:
                cmp isNeg, 1 
                je print_minus_avg
                print_average_loop_next:
                pop dx 
                add dx, '0'
                mov ah, 02h
                int 21h
                loop print_average_loop
                        
                jmp end_program
                        
            checkminus_avg:
                mov isNeg, 1
                neg ax
                mov average, ax
                jmp count_digitsAVG

            print_minus_avg:
                mov dx, '-'
                mov ah, 02h
                int 21h
                mov isNeg, 0
                jmp print_average_loop_next

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        ;function to convert a symbol to a decimal number
        convertionToDecimal:
            mov cx, [power] 
            mov bx, 10 

            cmp cx, 0 ; if the power is 0, we don't need to do anything
            je endPowerOfTenToDecimal ; jump to endPowerOfTen if cx is zero

            powerLoopToDecimal:
                mul bx ; multiply ax by 10 ?
                loop powerLoopToDecimal  

            endPowerOfTenToDecimal:

            ret
        
        end_program:
            mov ax, 4C00h   
            int 21h

    main endp
    end main
