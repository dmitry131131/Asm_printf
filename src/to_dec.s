global write_dec_value

; Function converts number to DEC
; Entry         DL - Number (0-9)
; Return        DL - Number ('0'-'9')
; Destroy       DL
number_to_dec_digit:  
            add dl, '0'                 ; (0x30)
            ret

; Function write qword to dec
; Entry     RAX - current position in output buffer
;           RDI - current argument adress 
; Destroy   RAX - add count of writen symbols
write_dec_value:
            push rcx                    ; save rcx and rbx
            push rbx
            push rdx
            push r8

            xor rcx, rcx                ; rcx = 0
            mov rbx, [rdi]              ; put number to rbx
            mov r8, rax                 ; save rax in r8

            cmp rbx, 0                  ; if number is 0
            jne .next
            mov byte [rax], 48          ; write '0'
            inc rax
            jmp .end_func

.next:      cmp rbx, 0
            je .end_loop

            mov rax, rbx                ; mov number to rax
            cqo                         ; rax -> rdx:rax
            mov rbx, 10                 ; mov 10 in rbx
            div rbx                     ; rax / 10 -> rax(rdx)
   
            call number_to_dec_digit    ; convert digit to symbol
            push rdx                    ; save symbol in stack

            mov rbx, rax                ; 
            inc rcx                     ; rcx++

            jmp .next                   ; next iteration

.end_loop:

            mov rax, r8                 ; repair rax from r8

.out_next:                              ; output symbols loop
            pop rbx
            mov [rax], bl
            inc rax

            loop .out_next
.end_func:
            pop r8                      ; repair rbx, rcx, rdx and r8
            pop rdx
            pop rbx                     
            pop rcx

            ret