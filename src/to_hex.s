global write_hex_value

; BUG Исправить вывод hex
; Function converts number to HEX
; Entry             BL - Number (0-15)
; Return            BL - Number ('0'-'F')
; Destroy           BL
number_to_hex_digit:  
            add bl, '0'              ; (0x30)
            cmp bl, '9'              ; (0x39)
            jbe .end             
            add bl, 39               ; Add 39 for 'A' - 'F' symbols
.end:
            ret

; Function write qword to bin
; Entry     RAX - current position in output buffer
;           RDI - current argument adress 
; Destroy   RAX - add count of writen symbols
write_hex_value:
            push rcx            ; save rcx and rbx
            push rbx

            mov rcx, 8         ; rcx = 8

.skip_zero_next:                ; skip zero loop
            dec rcx
            mov rbx, [rdi]

            shl cl, 2
            shr rbx, cl         ; mov current bit to bl
            shr cl, 2
            and rbx, 0xf

            cmp rcx, 0          ; check counter
            je .skip_zero_end

            cmp bl, 0
            je .skip_zero_next
.skip_zero_end:

            inc rcx

.next:      dec rcx
            mov rbx, [rdi]              ; mov hex from memory to register    

            shl cl, 2
            shr rbx, cl                 ; mov current number to bl
            shr cl, 2
            and rbx, 0xf

            call number_to_hex_digit    ; write current byte
            mov [rax], rbx
            inc rax

            cmp rcx, 0                  ; check counter
            ja .next

            pop rbx                     ; repair rbx and rcx
            pop rcx

            ret