global write_dec_value
extern number_to_digit

; Function write qword to dec
; Entry     RAX - current position in output buffer
;           RDI - current argument adress 
; Destroy   RAX - add count of writen symbols
write_dec_value:
            push rcx                    ; save rcx, rbx, rdx and r8
            push rbx
            push rdx
            push r8

            xor rcx, rcx                ; rcx = 0
            mov rbx, [rdi]              ; put number to rbx
            mov r8, rax                 ; save rax in r8

            cmp rbx, 0                  ; if number is 0
            jne .check_sign
            mov byte [rax], '0'         ; write '0'
            inc rax
            jmp .end_func

.check_sign:
            test ebx, ebx
            jns .not_minus

            mov byte [rax], '-'
            inc r8
            neg ebx

.not_minus:

.next:      cmp rbx, 0
            je .end_loop

            mov rax, rbx                ; mov number to rax
            cdq                         ; rax -> rdx:rax
            mov ebx, 10                 ; mov 10 in rbx
            div ebx                     ; rax / 10 -> rax(rdx)
   
            mov rbx, rdx
            call number_to_digit        ; convert digit to symbol
            push rbx                    ; save symbol in stack

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