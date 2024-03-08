global _Z3gayv

section .text

extern printf

_Z3gayv:    sub rsp, 8
            mov rdi, Msg
            call printf
            add rsp, 8

            ret
            
section     .data
            
Msg:        db "Hui", 0x0a
MsgLen      equ $ - Msg
