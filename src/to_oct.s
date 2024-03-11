global write_oct_value

; Function converts number to OCT
; Entry             BL - Number (0-7)
; Return            BL - Number ('0'-'7')
; Destroy           BL
number_to_oct_digit:  
            add bl, '0'              ; (0x30)
            ret

; Function write qword to oct
; Entry     RAX - current position in output buffer
;           RDI - current argument adress 
; Destroy   RAX - add count of writen symbols
write_oct_value:
            push rcx            ; save rcx and rbx
            push rbx

            mov rcx, 11         ; rcx = 10

.skip_zero_next:                ; skip zero loop
            dec rcx
            mov rbx, [rdi]

            shr rbx, cl         ; mov current byte to bl
            shr rbx, cl
            shr rbx, cl
            and rbx, 0x7

            cmp rcx, 0          ; check counter
            je .skip_zero_end

            cmp bl, 0
            je .skip_zero_next
.skip_zero_end:

            inc rcx
;--------------------------------------- write hi digit 
            cmp rcx, 11
            jne .next

            dec rcx
            mov rbx, [rdi]              ; mov hex from memory to register    

            shr rbx, cl                 ; mov current number to bl
            shr rbx, cl
            shr rbx, cl
            and rbx, 0x3

            call number_to_oct_digit    ; write current byte
            mov [rax], rbx
            inc rax
;-----------------------------------------
.next:      dec rcx
            mov rbx, [rdi]              ; mov hex from memory to register    

            shr rbx, cl                 ; mov current number to bl
            shr rbx, cl
            shr rbx, cl
            and rbx, 0x7

            call number_to_oct_digit    ; write current byte
            mov [rax], rbx
            inc rax

            cmp rcx, 0                  ; check counter
            ja .next

            pop rbx                     ; repair rbx and rcx
            pop rcx

            ret