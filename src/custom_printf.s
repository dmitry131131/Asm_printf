global _Z3gayv
global _Z13custom_printfPKcz

section .text

extern printf
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

; custom printf function
_Z13custom_printfPKcz:
            push rbp        ; Save rbp
            push_arguments  ; save all parameters 
            mov  rbp, rsp

            mov [rbp - 8], rdi
            mov [rbp - 16], rsi
            mov [rbp - 24], rdx
            mov [rbp - 32], rcx
            mov [rbp - 40], r8
            mov [rbp - 16], r9

            mov rax, 0x01      ; write64 (rdi, rsi, rdx) ... r10, r8, r9
            mov rdi, 1         ; stdout
            mov rsi, [rbp - 8]
            call str_len       ; strlen (Msg)
            syscall

            pop_arguments   ; repair all parameters
            call printf
            call _Z13test_functionv

            pop rbp
            ret

; Count symbols in string
; Entry     SI - pointer to string
; Return    DX - count of symbols
; Destroy   DX
str_len:
            push rsi
            xor rdx, rdx

.next:      cmp byte [rsi], 0
            je .end_loop
            inc rdx
            inc rsi
            jmp .next

.end_loop:

            pop rsi
            ret
            
section     .data
            
Msg:        db "Hui", 0x0a
MsgLen      equ $ - Msg
