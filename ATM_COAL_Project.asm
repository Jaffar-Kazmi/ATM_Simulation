.model small
.stack 100h
.data
    atm_msg db 10, 10, 10, 13, "*******************************  ATM Simulation  *******************************$"  
    
    ;Account number
    acc_prompt db 10, 10, " Enter your account number: $"
    acc_wrong db 10, 10, 10, " Account number does not exist.$"
    acc_num db "12345$" 
    acc_num_len db 5
    entered_acc_len db 0                                        
    
    ;Password 
    pass_prompt db 10, 10, " Enter your password: $"
    pass_wrong db 10, 10, 13, " Invalid password$"
    pass db "1234$"   
    pass_len db 4
    entered_pass_len db 0
       
    ;Menu options
    wel_msg db 10, 10, 10, 13, "**************************  Welcome to your account  ***************************$"
    bal_msg db 10, 10, 13, " 1. Check your balance$"
    withdraw_msg db 10, 10, 13, " 2. Withdraw money$"
    deposit_msg db 10, 10, 13, " 3. Deposit money$"
    exit_msg db 10, 10, 13, " 4. Exit$"
    
    ;Messages
    thank db 10, 10, 13, "                        Thank you for banking with us!$"
    invalid db 10, 10, 13, " Invalid input.$"
    choose_prompt db 10, 10, 13, " Enter option: $"
    operation_successful db 10, 10, 13, " Transaction successful$"
    above_limit db 10, 10, 13, " Limit exceeded (Maximum amount = Rs. 5000)$" 
    under_limit dw 10, 10, 13, "Below limit(Minimum withdrawl = 500)$"
       
    ;Balance
    current_balance dw 0             
    current_balance_msg db 10, 10, 13, " Current balance = Rs. $"
    
    ;Withdraw
    withdraw_prompt dw 10, 10, 13, "Enter amount to withdraw : $"
   
    low_balance db 10, 10, 13, "Insufficient balance$"  
           
    ;Deposit
    deposit_prompt dw 10, 10, 13, "Enter amount to deposit: Rs. $"
    
    entered_amount dw ? 
    entered_amount_len dw 0 
    min_limit dw 100
    max_limit dw 5000       
    
.code
    main proc
        ; Load data segment
        mov ax, @data
        mov ds, ax  
        
        ; Display ATM message
        lea dx, atm_msg
        mov ah, 9
        int 21h
    
        ; Check account number
        lea si, acc_num      ; Load effective address of existing account number in SI
        mov cl, acc_num_len  ; Loop 5 times as account number has characters
    
        lea dx, acc_prompt
        mov ah, 9
        int 21h  
       
        validate_account: 
            mov ah, 1
            int 21h
                    
            cmp al, 13
            je break_account
                    
            inc entered_acc_len
            cmp al, [si]  
            jne set_bl
            jmp continue
                             
            set_bl:
            mov bl, 1 
                             
            continue: inc si 
                                                
        jmp validate_account 
                    
        break_account: 
            cmp cl, entered_acc_len
            jne acc_fail                   
               
            cmp bl, 1
            je acc_fail
            jmp pass_continue
        
        acc_fail:
            lea dx, acc_wrong
            jmp wrong 
                
        ; Continue to Password if account number is correct                          
        pass_continue:
            ; Check password 
            lea dx, pass_prompt
            mov ah, 9
            int 21h
    
            call validate_pass  
                
            jmp menu      
    
        ;Incorrect validation
        wrong:
            mov ah, 9
            int 21h
            mov ah, 4ch   ; Exit program
            int 21h
           
        ;Display the menu
        menu: 
            lea dx, wel_msg
            mov ah, 9
            int 21h
         
            lea dx, bal_msg
            mov ah, 9
            int 21h
              
            lea dx, withdraw_msg
            mov ah, 9
            int 21h
              
            lea dx, deposit_msg
            mov ah, 9
            int 21h
              
            lea dx, exit_msg
            mov ah, 9
            int 21h  
               
            lea dx, choose_prompt
            mov ah, 9
            int 21h
          
            ; Take input
            mov ah, 1
            int 21h
              
            ; Convert from ascii to decimal
            sub al, 48                     
              
            ; Compare
            cmp al, 1
            je check_balance
              
            cmp al, 2
            je withdraw            ; line number = 262   
            
            cmp al, 3
            je deposit             ; line number = 324
            
            cmp al, 4
            je exit 
            jne invalid_choice
            
            invalid_choice: 
              mov ah, 0        ; Wait until a key is pressed
              int 16h    
              
              lea dx,invalid
              mov ah, 9
              int 21h  
            
              mov ah, 0        ; Wait until a key is pressed
              int 16h 
            
              mov ah, 0          ; Set the screen to standard format
              mov al, 3
              int 10h
            
            jmp menu  ; Invalid option, go back to menu
              
        ; Display the current balance
        check_balance: 
            mov ah, 0        ; Wait until a key is pressed
            int 16h
                           
            lea dx, current_balance_msg
            mov ah, 9
            int 21h
                   
            xor ax, ax
            mov ax, current_balance
            call display_data              ; line number = 455 
                   
            jmp back         

        back:
            mov ah, 0          ; Wait untill a key is pressed
            int 16h
           
            mov ah, 0          ; Set the screen to standard format
            mov al, 3
            int 10h
            
            jmp menu           ; Go back to the menu
                                                     
         exit:
              lea dx, thank
              mov ah, 9
              int 21h
              mov ah, 4ch
              int 21h
         main endp     
         
         
    ; Procedure to verify password
    validate_pass PROC 
        mov bl, 0                 ; Flag stored in BL
        lea si, pass              ; Store offset of correct password in SI
        mov cl, pass_len          ; Length of entered password has to be compared with actual password length.
        
        verify: 
            mov ah, 7             ; Character input without echo to output device.
            int 21h
                                
            cmp al, 13            ; Break if user presses enter key.
            je break_pass
                        
            inc entered_pass_len
            cmp al, [si]          ; Compare with actual password.
            jne set_pass_bl
            je continue_pass
                           
            set_pass_bl: 
                mov bl, 1
                       
            continue_pass:
                mov dl, 02Ah     ; To display * on screen
                mov ah, 2 
                int 21h
                inc si
            jmp verify
                          
        break_pass: 
            cmp cl, entered_pass_len
            jne pass_fail
                   
            cmp bl, 1
            je pass_fail
            jmp return_pass
            
        pass_fail: 
            lea dx, pass_wrong   
            jmp wrong 
                                       
        return_pass: 
            ret
    validate_pass endp 
    
    withdraw proc 
            mov ah, 0
            int 16h
                
            ; Display withdrawal prompt
            lea dx, withdraw_prompt
            mov ah, 9
            int 21h
    
            call take_amount        ; line number = 414
        
            validate_amount:
                 ; Check if amount is within limits (100-5000)
                 cmp bx, min_limit
                 jl amount_too_small
                 cmp bx, max_limit
                 jg amount_too_large
        
                 ; Check if amount <= current balance
                 cmp bx, current_balance
                 jg insufficient_balance
        
                 ; Perform withdrawal
                 sub current_balance, bx
        
                 ; Display success message
                 lea dx, operation_successful
                 mov ah, 9
                 int 21h
        
                 ; Display new balance
                 lea dx, current_balance_msg
                 mov ah, 9
                 int 21h
        
                 mov ax, current_balance
                 call display_data
        
                 jmp withdraw_exit
        
               amount_too_small:
                    lea dx, under_limit
                    mov ah, 9
                    int 21h
                    jmp withdraw_exit
        
               amount_too_large:
                    lea dx, above_limit
                    mov ah, 9
                    int 21h
                    jmp withdraw_exit
         
               insufficient_balance:
                    lea dx, low_balance
                    mov ah, 9
                    int 21h
        
               withdraw_exit:
                    jmp back
        
    withdraw endp  
    
    deposit proc
            mov ah, 0
            int 16h

            ; Display deposit prompt
            lea dx, deposit_prompt
            mov ah, 9
            int 21h

            ; Initialize for input
            xor ax, ax
            xor bx, bx      ; Clear BX to store final amount
            xor dx, dx
            mov cx, 5       ; Allow maximum 5 digits (5000 max limit)
                
            input_dep:
               ; Get digit input
               mov ah, 1
               int 21h
        
               ; Check if Enter is pressed
               cmp al, 13
               je verify_amount
        
               ; Check if input is a digit
               cmp al, '0'
               jl input    ; If less than '0', ignore
               cmp al, '9'
               jg input    ; If greater than '9', ignore
        
               ; Convert ASCII to number and store
               sub al, 48        ; Convert ASCII to number
               push ax           ; Save current digit
        
               ; Multiply current amount by 10
               mov ax, bx
               mov dx, 10
               mul dx
               mov bx, ax
        
               ; Add new digit
               pop ax
               xor ah, ah
               add bx, ax
                               
               loop input_dep   
                         
               verify_amount: 
                    ; Check if amount is within limits (100-5000)
                    cmp bx, min_limit
                    jl amount_too_small
                    cmp bx, max_limit
                    jg amount_too_large
                              
                    ; Perform withdrawal
                    mov ax, current_balance
                    add ax, bx
                             mov current_balance, ax 
                             
                    ; Display success message
                    lea dx, operation_successful
                    mov ah, 9
                    int 21h
        
                    ; Display new balance
                    lea dx, current_balance_msg
                    mov ah, 9
                    int 21h
        
                    mov ax, current_balance
                    call display_data             ; line number = 455
                             
                    jmp deposit_exit   
                             
                    amount_small:
                        lea dx, under_limit
                        mov ah, 9
                        int 21h
                        jmp deposit_exit
        
                    amount_large:
                        lea dx, above_limit
                        mov ah, 9
                        int 21h
                        jmp deposit_exit
                             
               deposit_exit:
                        jmp back 
    deposit endp

    take_amount proc  
            ; Initialize for input
            xor bx, bx      ; Clear BX to store final amount
            mov cx, 5       ; Allow maximum 5 digits (5000 max limit)
                
            input:
              ; Get digit input
              mov ah, 1
              int 21h
        
             ; Check if Enter is pressed
             cmp al, 13
             je validate_amount               ; line number = 273
        
             ; Check if input is a digit
             cmp al, '0'
             jl input    ; If less than '0', ignore
             cmp al, '9'
             jg input    ; If greater than '9', ignore 
        
             ; Convert ASCII to number and store
             sub al, 48        ; Convert ASCII to number
             push ax           ; Save current digit
        
             ; Multiply current amount by 10
             mov ax, bx
             mov dx, 10
             mul dx
             mov bx, ax
        
             ; Add new digit
             pop ax
             xor ah, ah
             add bx, ax
        
             loop input
            
            ret
    take_amount endp            

    ; Procedure to display numbers
    display_data proc
            push bx                ; Save registers
            push cx
            push dx
    
            mov bx, 10             ; Divisor for decimal conversion
            xor cx, cx             ; Clear counter
    
            convert_loop:
                xor dx, dx         ; Clear DX for division
                div bx             ; Divide AX by 10
                push dx            ; Save remainder (digit)
                inc cx             ; Increment digit counter
                cmp ax, 0          ; Check if quotient is 0
                jnz convert_loop   ; If not zero, continue converting
    
            display_loop:
                pop dx             ; Get digit
                add dl, 48         ; Convert to ASCII
                mov ah, 2          ; Display character function
                int 21h
                loop display_loop
    
            pop dx                 ; Restore registers
            pop cx
            pop bx
            ret
    display_data endp
        
end main