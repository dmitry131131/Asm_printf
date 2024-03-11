global _Z13custom_printfPKcz

section .text

extern printf
extern calloc
extern _Z13test_functionv
extern write_hex_value
extern write_oct_value
extern write_bin_value
extern write_dec_value

%macro push_arguments 0
            push r9
            push r8
            push rcx
            push rdx
            push rsi
            push rdi
%endmacro

%macro pop_arguments 0
            pop rdi
            pop rsi
            pop rdx
            pop rcx
            pop r8
            pop r9
%endmacro

; custom printf function
_Z13custom_printfPKcz:
            push rbp                ; Save rbp
            mov  rbp, rsp

            mov [Stack_argument_adress], rsp      ; save stack arguments adress
            push_arguments          ; save all parameters 

            mov rsi, [rsp]
            lea rdi, [rsp + 8]
            call compile_str
            mov [Start_of_final_string], rax
            mov rsi, rax

            mov rax, 0x01           ; write64 (rdi, rsi, rdx) ... r10, r8, r9
            mov rdi, 1              ; stdout
            call str_len            ; strlen (Msg)
            syscall

            pop_arguments           ; repair all parameters

            mov rax, [rsp]          ; save old RBP value
            mov [Old_RBP], rax
            add rsp, 8

            mov rax, [rsp]          ; save return adress
            mov [Return_adress], rax 
            add rsp, 8

            call printf             ; call default printf

            push qword [Return_adress]  ; return old Return adress and rbp in stack
            push qword [Old_RBP]

            call _Z13test_functionv ; call End of programm function

            pop rbp

            mov rax, [End_of_final_string]          ; put value to return register
            sub rax, [Start_of_final_string]
            ret

; Function convert format string to output string
; Entry     SI - pointer to string
;           DI - adress of the first argument
; Return    AX - pointer to final string
compile_str:
            push rsi                ; Save registers
            push rdi
            push rdx
            push rbx

            push rdi

            call str_len            ; count symbols of start string
            shl rdx, 5              ; rdx * 32

            push rsi                ; save rsi
            mov rdi, rdx            ; count of symbols of final string 
            mov rsi, 1              ; sizof(char)
            call calloc             ; allocate memory
            pop rsi                 ; repair rsi

            pop rdi

            push rax                ; save start of final string

.next:      cmp byte [rsi], 0       ; compairing with 0
            je .end_loop

            cmp byte [rsi], '%'
            jne .skip_flag

            call compile_flag
            inc rsi
            inc rsi

.skip_flag:
            mov bl, [rsi]           ; mov default symbol to final string
            mov [rax], bl
            inc rsi
            inc rax

            jmp .next 
.end_loop:

            mov byte [rax], 0       ; add \0 in the end of string

            mov [End_of_final_string], rax  ; save end of final string adress
            pop rax                 ; set ax on start of final string

            pop rbx                 ; Repair registers
            pop rdx
            pop rdi
            pop rsi                 
            ret

; Function compiling flags
; Entry     SI - pointer to string
;           AX - pointer to final string
;           DI - adress to current argument
; Return    AX - pointer to current position in final string
;           DI - adress of next argument
compile_flag:
            push rbx

            cmp byte [rsi + 1], 'c' ; check %c
            jne .not_c

            mov bl, [rdi]
            mov [rax], bl
            inc rax
            add rdi, 8
.not_c:

            cmp byte [rsi + 1], '%'     ; check %%
            jne .not_percent

            mov [rax], byte '%'
            inc rax
.not_percent:

            cmp byte [rsi + 1], 'x'
            jne .not_x

            call write_hex_value

            add rdi, 8

.not_x:
            cmp byte [rsi + 1], 'o'
            jne .not_o

            call write_oct_value

            add rdi, 8

.not_o:
            cmp byte [rsi + 1], 'b'
            jne .not_b

            call write_bin_value

            add rdi, 8

.not_b:
            cmp byte [rsi + 1], 'u'
            jne .not_u

            ;call write_dec_value

            add rdi, 8
.not_u:

            cmp byte [rsi + 1], 'd'
            jne .not_d

            call write_dec_value

            add rdi, 8

.not_d:

            cmp byte [rsi + 1], 's'     ; check %s
            jne .not_s

            push r8
            mov r8, [rdi]

.next:      
            cmp byte [r8], 0          ; copy string to final string
            je .end_loop

            mov bl, [r8]
            mov [rax], bl
            inc r8
            inc rax

            jmp .next
.end_loop:

            pop r8                    ; repair rcx
            add rdi, 8
.not_s:
            pop rbx

            cmp rdi, [Stack_argument_adress]
            jne .skip_rdi_change

            add rdi, 16

.skip_rdi_change:

            ret

; Count symbols in string
; Entry     SI - pointer to string
; Return    DX - count of symbols
; Destroy   DX
str_len:
            push rsi                ; save rsi
            xor rdx, rdx

.next:      cmp byte [rsi], 0       ; counter loop
            je .end_loop
            inc rdx
            inc rsi
            jmp .next

.end_loop:

            pop rsi                 ; repair rsi
            ret
            
section     .data
            
Stack_argument_adress: dq 0
Return_adress: dq 0
Old_RBP: dq 0
Start_of_final_string: dq 0
End_of_final_string: dq 0

Msg:        db "Hui", 0x0a
MsgLen      equ $ - Msg
