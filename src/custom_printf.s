global _Z3gayv
global _Z13custom_printfPKcz

section .text

extern printf
extern calloc
extern _Z13test_functionv

%macro push_arguments 0
    push rdi
    push rsi
    push rdx
    push rcx
    push r8
    push r9
%endmacro

%macro pop_arguments 0
    pop r9
    pop r8
    pop rcx
    pop rdx
    pop rsi
    pop rdi
%endmacro

_Z3gayv:    sub rsp, 8
            mov rdi, Msg
            call printf
            call _Z13test_functionv
            add rsp, 8

            ret
; TODO Сделать приём аргументов из стека
; custom printf function
_Z13custom_printfPKcz:
            push rbp        ; Save rbp
            mov  rbp, rsp
            push_arguments  ; save all parameters 

            ;mov [rbp - 8],  rdi
            ;mov [rbp - 16], rsi
            ;mov [rbp - 24], rdx
            ;mov [rbp - 32], rcx
            ;mov [rbp - 40], r8
            ;mov [rbp - 48], r9

            mov rsi, [rbp - 8]
            lea rdi, [rbp - 16]
            call compile_str
            mov rsi, rax

            mov rax, 0x01      ; write64 (rdi, rsi, rdx) ... r10, r8, r9
            mov rdi, 1         ; stdout
            call str_len       ; strlen (Msg)
            syscall

            pop_arguments   ; repair all parameters
            call printf
            call _Z13test_functionv

            pop rbp
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
            shr rdx, 3              ; rdx * 8

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

            cmp byte [rsi + 1], 'c'
            jne .not_c

            mov bl, [rdi]
            mov [rax], bl
            inc rax
            sub rdi, 8
.not_c:

            cmp byte [rsi + 1], '%'
            jne .not_percent

            mov [rax], byte '%'
            inc rax
.not_percent:

            cmp byte [rsi + 1], 's'
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
            sub rdi, 8
.not_s:

            pop rbx
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
            
Msg:        db "Hui", 0x0a
MsgLen      equ $ - Msg
