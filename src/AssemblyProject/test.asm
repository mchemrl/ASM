.model small
.stack 100h

.data
    array db 255 

.code
main PROC
    mov ax, @data
    mov ds, ax

read_input_loop:
    mov ah, 01h       
    int 21h          
    cmp al, 1Ah       
    je end_input    
    cmp al, 4Dh      
    je end_input     

    
     lea si, array  
    mov [array + si], al       
    inc si                    
    cmp si, 255                 
    jnb end_input   

end_input:
    mov cx, si            
    mov si, offset array  
write_output_loop:


    mov dl, [si]        
    mov ah, 02h          
    int 21h               
    inc si                
    loop write_output_loop

    ; End program
    mov ax, 4c00h        
    int 21h               

main ENDP

END main