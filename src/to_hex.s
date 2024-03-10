global write_hex_value

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

; Function convert byte to HEX number text
; Entry             BL - byte
;                   RAX - position of output buffer
; Destroy           RAX
byte_to_hex_str:  

            push rbx                     ; save ax

            mov bh, bl                   ; save al in ah
            shr bl, 4                    ; get hi digit
            cmp bl, 0
            je .skip_hi_digit

            call number_to_hex_digit      
            mov [rax], bl                ; add to string
            inc rax                 
.skip_hi_digit:
            mov bl, bh                   ; repair al
            and bl, 0Fh                  ; get low digit
            call number_to_hex_digit       
            mov [rax], bl                ; add to string
            inc rax                 

            pop rbx                      ; repair ax

            ret

; Function write qword to hex
; Entry     RAX - current position in output buffer
;           RDI - current argument adress 
; Destroy   RAX - add count of writen symbols
write_hex_value:
            push rcx            ; save rcx and rbx
            push rbx

            mov rcx, 5          ; rcx = 4

.skip_zero_next:                ; skip zero loop
            dec rcx
            mov rbx, [rdi]

            shl cl, 3           ; mov current byte to bl
            shr rbx, cl
            shr cl, 3

            cmp rcx, 0          ; check counter
            je .skip_zero_end

            cmp bl, 0
            je .skip_zero_next
.skip_zero_end:

inc rcx

.next:      dec rcx
            mov rbx, [rdi]          ; mov hex from memory to register    

            shl cl, 3               ; mov current byte to bl
            shr rbx, cl
            shr cl, 3

            call byte_to_hex_str    ; write current byte

            cmp rcx, 1              ; check counter
            ja .next

            pop rbx                 ; repair rbx and rcx
            pop rcx

            ret