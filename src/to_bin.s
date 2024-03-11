global write_bin_value
global number_to_digit

; Function converts number to BIN
; Entry         BL - Number (0-1)
; Return        BL - Number ('0'-'1')
; Destroy       BL
number_to_digit:  
            add bl, '0'              ; (0x30)
            ret

; Function write qword to bin
; Entry     RAX - current position in output buffer
;           RDI - current argument adress 
; Destroy   RAX - add count of writen symbols
write_bin_value:
            push rcx            ; save rcx and rbx
            push rbx

            mov rcx, 32         ; rcx = 32

.skip_zero_next:                ; skip zero loop
            dec rcx
            mov rbx, [rdi]

            shr rbx, cl         ; mov current bit to bl
            and rbx, 0x1

            cmp rcx, 0          ; check counter
            je .skip_zero_end

            cmp bl, 0
            je .skip_zero_next
.skip_zero_end:

            inc rcx

.next:      dec rcx
            mov rbx, [rdi]              ; mov hex from memory to register    

            shr rbx, cl                 ; mov current number to bl
            and rbx, 0x1

            call number_to_digit    ; write current byte
            mov [rax], rbx
            inc rax

            cmp rcx, 0                  ; check counter
            ja .next

            pop rbx                     ; repair rbx and rcx
            pop rcx

            ret