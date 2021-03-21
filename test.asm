section .bss
    outputBuffer resb 1
    inputBuffer resb 1
section .data
    enter_msg db 'Enter something: '
    enter_len equ $ - enter_msg
section .text
global _start
    print_enter_msg:
        mov ecx, enter_msg
        mov edx, enter_len
        mov eax, 4
        mov ebx, 1
        int 0x80
        ret
    print_data:
        mov [outputBuffer], edi
        mov ecx, outputBuffer
        mov edx, 0x01
        mov eax, 4
        mov ebx, 1
        int 0x80
        ret
    read_input_data:
        mov eax, 0x03
        mov ebx, 0x02
        mov ecx, inputBuffer
        mov edx, 0x01
        int 0x80
        mov eax, [inputBuffer]
        ret
    expand_data:
        add eax, 0x01
        mov ecx, eax
        mov eax, 192
        xor ebx, ebx
        mov edx, 0x7
        mov esi, 0x22
        mov edi, -1
        xor ebp, ebp
        int 0x80
        push rcx
        push rax
        mov ebx, eax
        xor eax, eax
        push rcx
    copy_loop_top:
        cmp eax, r10d
        jge copy_loop_bot
        mov ecx, [r9d + eax]
        mov [ebx + eax], ecx
        inc eax
        jmp copy_loop_top
    copy_loop_bot:
        pop rcx
        mov eax, r10d
        xor rdx, rdx
    zero_loop_top:
        cmp eax, ecx
        jge zero_loop_bottom
        mov [ebx + eax], rdx
        inc eax
        jmp zero_loop_top
    zero_loop_bottom:
        cmp r9d, 0
        je expand_data_post_dealloc
        mov eax, 91
        mov ebx, r9d
        mov ecx, r10d
        int 0x80
        expand_data_post_dealloc:
        pop rax
        mov r9d, eax
        pop rax
        mov r10d, eax
        ret
    read_data:
        cmp r8d, r10d
        jl read_data_post_expand
        mov eax, r8d
        call expand_data
        read_data_post_expand:
        mov eax, [r9d + r8d]
        ret
    write_data:
        push rax
        cmp r8d, r10d
        jl write_data_post_expand
        push rax
        mov eax, r8d
        call expand_data
        pop rax
        write_data_post_expand:
        pop rax
        mov [r9d + r8d], eax
        ret
_start:
    xor r8d, r8d
    xor r9d, r9d
    xor r10d, r10d
    call read_data
    add al, 0xd
    call write_data
    cmp al, 0x0
    jle loop_bot_0
loop_top_0:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x2
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x5
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x2
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    cmp al, 0x0
    jg loop_top_0
loop_bot_0:
    add r8d, 0x5
    call read_data
    add al, 0x6
    call write_data
    add r8d, 0x1
    call read_data
    sub al, 0x3
    call write_data
    add r8d, 0xa
    call read_data
    add al, 0xf
    call write_data
    cmp al, 0x0
    jle loop_bot_1
loop_top_1:
    call read_data
    cmp al, 0x0
    jle loop_bot_2
loop_top_2:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_2
loop_bot_2:
    call read_data
    add al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_3
loop_top_3:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_3
loop_bot_3:
    add r8d, 0x9
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_1
loop_bot_1:
    call read_data
    add al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_4
loop_top_4:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_5
loop_top_5:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_5
loop_bot_5:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_4
loop_bot_4:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_6
loop_top_6:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_6
loop_bot_6:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_7
loop_top_7:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_7
loop_bot_7:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    add al, 0x5
    call write_data
    cmp al, 0x0
    jle loop_bot_8
loop_top_8:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_9
loop_top_9:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_9
loop_bot_9:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_8
loop_bot_8:
    add r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1b
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x11
    call read_data
    cmp al, 0x0
    jle loop_bot_10
loop_top_10:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_10
loop_bot_10:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_11
loop_top_11:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_11
loop_bot_11:
    call read_data
    add al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_12
loop_top_12:
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_13
loop_top_13:
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_14
loop_top_14:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_14
loop_bot_14:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_13
loop_bot_13:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_15
loop_top_15:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_15
loop_bot_15:
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_16
loop_top_16:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_16
loop_bot_16:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    add al, 0x4
    call write_data
    cmp al, 0x0
    jle loop_bot_17
loop_top_17:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_18
loop_top_18:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_18
loop_bot_18:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_17
loop_bot_17:
    add r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    add al, 0x7
    call write_data
    cmp al, 0x0
    jle loop_bot_19
loop_top_19:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_20
loop_top_20:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_20
loop_bot_20:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_19
loop_bot_19:
    add r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x10
    call read_data
    cmp al, 0x0
    jle loop_bot_21
loop_top_21:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_21
loop_bot_21:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_22
loop_top_22:
    call read_data
    cmp al, 0x0
    jle loop_bot_23
loop_top_23:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_23
loop_bot_23:
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_24
loop_top_24:
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_25
loop_top_25:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jg loop_top_25
loop_bot_25:
    sub r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_26
loop_top_26:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_26
loop_bot_26:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_24
loop_bot_24:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_27
loop_top_27:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_27
loop_bot_27:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_28
loop_top_28:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_29
loop_top_29:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_29
loop_bot_29:
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_30
loop_top_30:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_30
loop_bot_30:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_28
loop_bot_28:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_31
loop_top_31:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_31
loop_bot_31:
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_32
loop_top_32:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_32
loop_bot_32:
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_33
loop_top_33:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_33
loop_bot_33:
    add r8d, 0x9
    call read_data
    add al, 0xf
    call write_data
    cmp al, 0x0
    jle loop_bot_34
loop_top_34:
    call read_data
    cmp al, 0x0
    jle loop_bot_35
loop_top_35:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_35
loop_bot_35:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_36
loop_top_36:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_36
loop_bot_36:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_37
loop_top_37:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_37
loop_bot_37:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_38
loop_top_38:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_38
loop_bot_38:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_39
loop_top_39:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_39
loop_bot_39:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_40
loop_top_40:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_40
loop_bot_40:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_41
loop_top_41:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_41
loop_bot_41:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_42
loop_top_42:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_42
loop_bot_42:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_43
loop_top_43:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_43
loop_bot_43:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_44
loop_top_44:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_44
loop_bot_44:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_45
loop_top_45:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_45
loop_bot_45:
    add r8d, 0x9
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_34
loop_bot_34:
    call read_data
    add al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_46
loop_top_46:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_46
loop_bot_46:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_47
loop_top_47:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_47
loop_bot_47:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_48
loop_top_48:
    add r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_49
loop_top_49:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_49
loop_bot_49:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_50
loop_top_50:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_51
loop_top_51:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_52
loop_top_52:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_52
loop_bot_52:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_53
loop_top_53:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_53
loop_bot_53:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_51
loop_bot_51:
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_54
loop_top_54:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_54
loop_bot_54:
    call read_data
    cmp al, 0x0
    jg loop_top_50
loop_bot_50:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_55
loop_top_55:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_55
loop_bot_55:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_56
loop_top_56:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_57
loop_top_57:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_57
loop_bot_57:
    sub r8d, 0xa
    call read_data
    cmp al, 0x0
    jg loop_top_56
loop_bot_56:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_58
loop_top_58:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_58
loop_bot_58:
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_48
loop_bot_48:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_59
loop_top_59:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_60
loop_top_60:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_60
loop_bot_60:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_61
loop_top_61:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_62
loop_top_62:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jg loop_top_62
loop_bot_62:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_63
loop_top_63:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_63
loop_bot_63:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_61
loop_bot_61:
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_64
loop_top_64:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_64
loop_bot_64:
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_59
loop_bot_59:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_65
loop_top_65:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_65
loop_bot_65:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_66
loop_top_66:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_66
loop_bot_66:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_67
loop_top_67:
    add r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_68
loop_top_68:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_68
loop_bot_68:
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_69
loop_top_69:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_70
loop_top_70:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_71
loop_top_71:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_71
loop_bot_71:
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_72
loop_top_72:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_72
loop_bot_72:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_70
loop_bot_70:
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_73
loop_top_73:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_73
loop_bot_73:
    call read_data
    cmp al, 0x0
    jg loop_top_69
loop_bot_69:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_74
loop_top_74:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_74
loop_bot_74:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_75
loop_top_75:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_76
loop_top_76:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_76
loop_bot_76:
    sub r8d, 0xb
    call read_data
    cmp al, 0x0
    jg loop_top_75
loop_bot_75:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_77
loop_top_77:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_77
loop_bot_77:
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_67
loop_bot_67:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_78
loop_top_78:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_79
loop_top_79:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_79
loop_bot_79:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_80
loop_top_80:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_81
loop_top_81:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jg loop_top_81
loop_bot_81:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_82
loop_top_82:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_82
loop_bot_82:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_80
loop_bot_80:
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_83
loop_top_83:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_83
loop_bot_83:
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_78
loop_bot_78:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_84
loop_top_84:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_85
loop_top_85:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x24
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x24
    call read_data
    cmp al, 0x0
    jg loop_top_85
loop_bot_85:
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_84
loop_bot_84:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_86
loop_top_86:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_86
loop_bot_86:
    add r8d, 0x9
    call read_data
    add al, 0xf
    call write_data
    cmp al, 0x0
    jle loop_bot_87
loop_top_87:
    call read_data
    cmp al, 0x0
    jle loop_bot_88
loop_top_88:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_88
loop_bot_88:
    sub r8d, 0x9
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_89
loop_top_89:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_89
loop_bot_89:
    add r8d, 0x9
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_87
loop_bot_87:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x15
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_90
loop_top_90:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_90
loop_bot_90:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_91
loop_top_91:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_92
loop_top_92:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_92
loop_bot_92:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_93
loop_top_93:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_94
loop_top_94:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_94
loop_bot_94:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_95
loop_top_95:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0xd
    call read_data
    cmp al, 0x0
    jle loop_bot_96
loop_top_96:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_96
loop_bot_96:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_97
loop_top_97:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_97
loop_bot_97:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_98
loop_top_98:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_98
loop_bot_98:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_95
loop_bot_95:
    call read_data
    cmp al, 0x0
    jg loop_top_93
loop_bot_93:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_99
loop_top_99:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_99
loop_bot_99:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_100
loop_top_100:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_101
loop_top_101:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_101
loop_bot_101:
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_102
loop_top_102:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0xc
    call read_data
    cmp al, 0x0
    jle loop_bot_103
loop_top_103:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_103
loop_bot_103:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_104
loop_top_104:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_104
loop_bot_104:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_105
loop_top_105:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_105
loop_bot_105:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_106
loop_top_106:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_106
loop_bot_106:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_102
loop_bot_102:
    call read_data
    cmp al, 0x0
    jg loop_top_100
loop_bot_100:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_107
loop_top_107:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_108
loop_top_108:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_108
loop_bot_108:
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_107
loop_bot_107:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_91
loop_bot_91:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_109
loop_top_109:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_109
loop_bot_109:
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_110
loop_top_110:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_110
loop_bot_110:
    add r8d, 0x9
    call read_data
    add al, 0x28
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_111
loop_top_111:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_111
loop_bot_111:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_112
loop_top_112:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_113
loop_top_113:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_113
loop_bot_113:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_112
loop_bot_112:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_114
loop_top_114:
    sub r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_115
loop_top_115:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_116
loop_top_116:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_116
loop_bot_116:
    call read_data
    cmp al, 0x0
    jg loop_top_115
loop_bot_115:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_117
loop_top_117:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_118
loop_top_118:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_118
loop_bot_118:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_117
loop_bot_117:
    add r8d, 0xd
    call read_data
    cmp al, 0x0
    jle loop_bot_119
loop_top_119:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_120
loop_top_120:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_120
loop_bot_120:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_121
loop_top_121:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_121
loop_bot_121:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_122
loop_top_122:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_122
loop_bot_122:
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_119
loop_bot_119:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_123
loop_top_123:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_123
loop_bot_123:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_124
loop_top_124:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_124
loop_bot_124:
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_125
loop_top_125:
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_126
loop_top_126:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_126
loop_bot_126:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_127
loop_top_127:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_127
loop_bot_127:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_125
loop_bot_125:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_128
loop_top_128:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_128
loop_bot_128:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_129
loop_top_129:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_130
loop_top_130:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_130
loop_bot_130:
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_129
loop_bot_129:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_131
loop_top_131:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_131
loop_bot_131:
    add r8d, 0x9
    call read_data
    add al, 0xf
    call write_data
    cmp al, 0x0
    jle loop_bot_132
loop_top_132:
    call read_data
    cmp al, 0x0
    jle loop_bot_133
loop_top_133:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_133
loop_bot_133:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_134
loop_top_134:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_134
loop_bot_134:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_135
loop_top_135:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_135
loop_bot_135:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_136
loop_top_136:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_136
loop_bot_136:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_137
loop_top_137:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_137
loop_bot_137:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_138
loop_top_138:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_138
loop_bot_138:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_139
loop_top_139:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_139
loop_bot_139:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_140
loop_top_140:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_140
loop_bot_140:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_141
loop_top_141:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_141
loop_bot_141:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_142
loop_top_142:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_142
loop_bot_142:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_143
loop_top_143:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_143
loop_bot_143:
    add r8d, 0x9
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_132
loop_bot_132:
    call read_data
    add al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_144
loop_top_144:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_144
loop_bot_144:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_145
loop_top_145:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_145
loop_bot_145:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_146
loop_top_146:
    add r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_147
loop_top_147:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_147
loop_bot_147:
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_148
loop_top_148:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_149
loop_top_149:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_150
loop_top_150:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_150
loop_bot_150:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_151
loop_top_151:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_151
loop_bot_151:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_149
loop_bot_149:
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_152
loop_top_152:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_152
loop_bot_152:
    call read_data
    cmp al, 0x0
    jg loop_top_148
loop_bot_148:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_153
loop_top_153:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_153
loop_bot_153:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_154
loop_top_154:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_155
loop_top_155:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_155
loop_bot_155:
    sub r8d, 0xa
    call read_data
    cmp al, 0x0
    jg loop_top_154
loop_bot_154:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_156
loop_top_156:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_156
loop_bot_156:
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_146
loop_bot_146:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_157
loop_top_157:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_158
loop_top_158:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_158
loop_bot_158:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_159
loop_top_159:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_160
loop_top_160:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_160
loop_bot_160:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_161
loop_top_161:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_161
loop_bot_161:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_159
loop_bot_159:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_162
loop_top_162:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_162
loop_bot_162:
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_157
loop_bot_157:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_163
loop_top_163:
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_164
loop_top_164:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_164
loop_bot_164:
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_165
loop_top_165:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_165
loop_bot_165:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_163
loop_bot_163:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_166
loop_top_166:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_166
loop_bot_166:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_167
loop_top_167:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_167
loop_bot_167:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_168
loop_top_168:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_168
loop_bot_168:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_169
loop_top_169:
    add r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_170
loop_top_170:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_170
loop_bot_170:
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_171
loop_top_171:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_172
loop_top_172:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_173
loop_top_173:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_173
loop_bot_173:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_174
loop_top_174:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_174
loop_bot_174:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_172
loop_bot_172:
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_175
loop_top_175:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_175
loop_bot_175:
    call read_data
    cmp al, 0x0
    jg loop_top_171
loop_bot_171:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_176
loop_top_176:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_176
loop_bot_176:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_177
loop_top_177:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_178
loop_top_178:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_178
loop_bot_178:
    sub r8d, 0xa
    call read_data
    cmp al, 0x0
    jg loop_top_177
loop_bot_177:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_179
loop_top_179:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_179
loop_bot_179:
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_169
loop_bot_169:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_180
loop_top_180:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_181
loop_top_181:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_181
loop_bot_181:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_182
loop_top_182:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_183
loop_top_183:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jg loop_top_183
loop_bot_183:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_184
loop_top_184:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_184
loop_bot_184:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_182
loop_bot_182:
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_185
loop_top_185:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_185
loop_bot_185:
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_180
loop_bot_180:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_186
loop_top_186:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_187
loop_top_187:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x24
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x24
    call read_data
    cmp al, 0x0
    jg loop_top_187
loop_bot_187:
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_186
loop_bot_186:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_188
loop_top_188:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_188
loop_bot_188:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_189
loop_top_189:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_190
loop_top_190:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x24
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x24
    call read_data
    cmp al, 0x0
    jg loop_top_190
loop_bot_190:
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jg loop_top_189
loop_bot_189:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_191
loop_top_191:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_191
loop_bot_191:
    add r8d, 0x9
    call read_data
    add al, 0xf
    call write_data
    cmp al, 0x0
    jle loop_bot_192
loop_top_192:
    call read_data
    cmp al, 0x0
    jle loop_bot_193
loop_top_193:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_193
loop_bot_193:
    sub r8d, 0x9
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_194
loop_top_194:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_194
loop_bot_194:
    add r8d, 0x9
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_192
loop_bot_192:
    call read_data
    add al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_195
loop_top_195:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_196
loop_top_196:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_196
loop_bot_196:
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_197
loop_top_197:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_197
loop_bot_197:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_195
loop_bot_195:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_198
loop_top_198:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_198
loop_bot_198:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_199
loop_top_199:
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_200
loop_top_200:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_200
loop_bot_200:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_199
loop_bot_199:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_201
loop_top_201:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_201
loop_bot_201:
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_202
loop_top_202:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_202
loop_bot_202:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_203
loop_top_203:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_204
loop_top_204:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    add al, 0x2
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_204
loop_bot_204:
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_205
loop_top_205:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_205
loop_bot_205:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_203
loop_bot_203:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_206
loop_top_206:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_206
loop_bot_206:
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_207
loop_top_207:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_207
loop_bot_207:
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_208
loop_top_208:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_208
loop_bot_208:
    sub r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_209
loop_top_209:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_209
loop_bot_209:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_210
loop_top_210:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_211
loop_top_211:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_212
loop_top_212:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_212
loop_bot_212:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_213
loop_top_213:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_214
loop_top_214:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_214
loop_bot_214:
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_215
loop_top_215:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0xc
    call read_data
    cmp al, 0x0
    jle loop_bot_216
loop_top_216:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_216
loop_bot_216:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_217
loop_top_217:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_217
loop_bot_217:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_218
loop_top_218:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_218
loop_bot_218:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_215
loop_bot_215:
    call read_data
    cmp al, 0x0
    jg loop_top_213
loop_bot_213:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_219
loop_top_219:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_219
loop_bot_219:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_220
loop_top_220:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_221
loop_top_221:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_221
loop_bot_221:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_222
loop_top_222:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0xb
    call read_data
    cmp al, 0x0
    jle loop_bot_223
loop_top_223:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_223
loop_bot_223:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_224
loop_top_224:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_224
loop_bot_224:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_225
loop_top_225:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_225
loop_bot_225:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_226
loop_top_226:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_226
loop_bot_226:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_222
loop_bot_222:
    call read_data
    cmp al, 0x0
    jg loop_top_220
loop_bot_220:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_227
loop_top_227:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_228
loop_top_228:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_228
loop_bot_228:
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_227
loop_bot_227:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_211
loop_bot_211:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_229
loop_top_229:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_229
loop_bot_229:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_230
loop_top_230:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_230
loop_bot_230:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_231
loop_top_231:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_232
loop_top_232:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_233
loop_top_233:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_233
loop_bot_233:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_234
loop_top_234:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_234
loop_bot_234:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_232
loop_bot_232:
    sub r8d, 0x8
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_235
loop_top_235:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_236
loop_top_236:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_237
loop_top_237:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xe
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xb
    call read_data
    cmp al, 0x0
    jle loop_bot_238
loop_top_238:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_238
loop_bot_238:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_237
loop_bot_237:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_239
loop_top_239:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xe
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xb
    call read_data
    cmp al, 0x0
    jg loop_top_239
loop_bot_239:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_236
loop_bot_236:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_240
loop_top_240:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_241
loop_top_241:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xe
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xb
    call read_data
    cmp al, 0x0
    jg loop_top_241
loop_bot_241:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_240
loop_bot_240:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_242
loop_top_242:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_242
loop_bot_242:
    sub r8d, 0xc
    call read_data
    cmp al, 0x0
    jg loop_top_235
loop_bot_235:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_243
loop_top_243:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_243
loop_bot_243:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_231
loop_bot_231:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_244
loop_top_244:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_244
loop_bot_244:
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_245
loop_top_245:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_246
loop_top_246:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_247
loop_top_247:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_247
loop_bot_247:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_248
loop_top_248:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_248
loop_bot_248:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_246
loop_bot_246:
    sub r8d, 0x8
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_249
loop_top_249:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_250
loop_top_250:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_251
loop_top_251:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xe
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xa
    call read_data
    cmp al, 0x0
    jle loop_bot_252
loop_top_252:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_252
loop_bot_252:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_251
loop_bot_251:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_253
loop_top_253:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xe
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xa
    call read_data
    cmp al, 0x0
    jg loop_top_253
loop_bot_253:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_250
loop_bot_250:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_254
loop_top_254:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_255
loop_top_255:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xe
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xa
    call read_data
    cmp al, 0x0
    jg loop_top_255
loop_bot_255:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_254
loop_bot_254:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_256
loop_top_256:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_256
loop_bot_256:
    sub r8d, 0xb
    call read_data
    cmp al, 0x0
    jg loop_top_249
loop_bot_249:
    add r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    cmp al, 0x0
    jg loop_top_245
loop_bot_245:
    call read_data
    cmp al, 0x0
    jg loop_top_210
loop_bot_210:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_257
loop_top_257:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_257
loop_bot_257:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_258
loop_top_258:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_259
loop_top_259:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_259
loop_bot_259:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_260
loop_top_260:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_261
loop_top_261:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_262
loop_top_262:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xe
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xb
    call read_data
    cmp al, 0x0
    jle loop_bot_263
loop_top_263:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_263
loop_bot_263:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_262
loop_bot_262:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_264
loop_top_264:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xe
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xb
    call read_data
    cmp al, 0x0
    jg loop_top_264
loop_bot_264:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_261
loop_bot_261:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_265
loop_top_265:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_266
loop_top_266:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xe
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xb
    call read_data
    cmp al, 0x0
    jg loop_top_266
loop_bot_266:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_265
loop_bot_265:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_267
loop_top_267:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_267
loop_bot_267:
    sub r8d, 0xc
    call read_data
    cmp al, 0x0
    jg loop_top_260
loop_bot_260:
    call read_data
    cmp al, 0x0
    jg loop_top_258
loop_bot_258:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_268
loop_top_268:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_268
loop_bot_268:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_269
loop_top_269:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_269
loop_bot_269:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_270
loop_top_270:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_270
loop_bot_270:
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_271
loop_top_271:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_272
loop_top_272:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_272
loop_bot_272:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_273
loop_top_273:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_273
loop_bot_273:
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jg loop_top_271
loop_bot_271:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_274
loop_top_274:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_274
loop_bot_274:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_275
loop_top_275:
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_276
loop_top_276:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_276
loop_bot_276:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_277
loop_top_277:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_277
loop_bot_277:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_275
loop_bot_275:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_278
loop_top_278:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_278
loop_bot_278:
    add r8d, 0x9
    call read_data
    add al, 0xf
    call write_data
    cmp al, 0x0
    jle loop_bot_279
loop_top_279:
    call read_data
    cmp al, 0x0
    jle loop_bot_280
loop_top_280:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_280
loop_bot_280:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_281
loop_top_281:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_281
loop_bot_281:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_282
loop_top_282:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_282
loop_bot_282:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_283
loop_top_283:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_283
loop_bot_283:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_284
loop_top_284:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_284
loop_bot_284:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_285
loop_top_285:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_285
loop_bot_285:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_286
loop_top_286:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_286
loop_bot_286:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_287
loop_top_287:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_287
loop_bot_287:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_288
loop_top_288:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_288
loop_bot_288:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_289
loop_top_289:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_289
loop_bot_289:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_290
loop_top_290:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_290
loop_bot_290:
    add r8d, 0x9
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_279
loop_bot_279:
    call read_data
    add al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_291
loop_top_291:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_291
loop_bot_291:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_292
loop_top_292:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_292
loop_bot_292:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_293
loop_top_293:
    add r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_294
loop_top_294:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_294
loop_bot_294:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_295
loop_top_295:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_296
loop_top_296:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_297
loop_top_297:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_297
loop_bot_297:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_298
loop_top_298:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_298
loop_bot_298:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_296
loop_bot_296:
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_299
loop_top_299:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_299
loop_bot_299:
    call read_data
    cmp al, 0x0
    jg loop_top_295
loop_bot_295:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_300
loop_top_300:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_300
loop_bot_300:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_301
loop_top_301:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_302
loop_top_302:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_302
loop_bot_302:
    sub r8d, 0xa
    call read_data
    cmp al, 0x0
    jg loop_top_301
loop_bot_301:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_303
loop_top_303:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_303
loop_bot_303:
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_293
loop_bot_293:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_304
loop_top_304:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_305
loop_top_305:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_305
loop_bot_305:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_306
loop_top_306:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_307
loop_top_307:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_307
loop_bot_307:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_308
loop_top_308:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_308
loop_bot_308:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_306
loop_bot_306:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_309
loop_top_309:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_309
loop_bot_309:
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_304
loop_bot_304:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_310
loop_top_310:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_311
loop_top_311:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x24
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x24
    call read_data
    cmp al, 0x0
    jg loop_top_311
loop_bot_311:
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jg loop_top_310
loop_bot_310:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_312
loop_top_312:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_312
loop_bot_312:
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_313
loop_top_313:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_313
loop_bot_313:
    add r8d, 0x4
    call read_data
    add al, 0xf
    call write_data
    cmp al, 0x0
    jle loop_bot_314
loop_top_314:
    call read_data
    cmp al, 0x0
    jle loop_bot_315
loop_top_315:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_315
loop_bot_315:
    sub r8d, 0x9
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_316
loop_top_316:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_316
loop_bot_316:
    add r8d, 0x9
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_314
loop_bot_314:
    call read_data
    add al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_317
loop_top_317:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_318
loop_top_318:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_318
loop_bot_318:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_319
loop_top_319:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_320
loop_top_320:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_320
loop_bot_320:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_321
loop_top_321:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0xd
    call read_data
    cmp al, 0x0
    jle loop_bot_322
loop_top_322:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_322
loop_bot_322:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_323
loop_top_323:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_323
loop_bot_323:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_324
loop_top_324:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_324
loop_bot_324:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_321
loop_bot_321:
    call read_data
    cmp al, 0x0
    jg loop_top_319
loop_bot_319:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_325
loop_top_325:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_325
loop_bot_325:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_326
loop_top_326:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_327
loop_top_327:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_327
loop_bot_327:
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_328
loop_top_328:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0xc
    call read_data
    cmp al, 0x0
    jle loop_bot_329
loop_top_329:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_329
loop_bot_329:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_330
loop_top_330:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_330
loop_bot_330:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_331
loop_top_331:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_331
loop_bot_331:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_332
loop_top_332:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_332
loop_bot_332:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_328
loop_bot_328:
    call read_data
    cmp al, 0x0
    jg loop_top_326
loop_bot_326:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_333
loop_top_333:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_334
loop_top_334:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_334
loop_bot_334:
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_333
loop_bot_333:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_317
loop_bot_317:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_335
loop_top_335:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_335
loop_bot_335:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_336
loop_top_336:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_336
loop_bot_336:
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_337
loop_top_337:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_338
loop_top_338:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_339
loop_top_339:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_339
loop_bot_339:
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_340
loop_top_340:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_340
loop_bot_340:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_338
loop_bot_338:
    sub r8d, 0x8
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_341
loop_top_341:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_342
loop_top_342:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_343
loop_top_343:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xa
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xc
    call read_data
    cmp al, 0x0
    jle loop_bot_344
loop_top_344:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_344
loop_bot_344:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_343
loop_bot_343:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_345
loop_top_345:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xa
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xc
    call read_data
    cmp al, 0x0
    jg loop_top_345
loop_bot_345:
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_342
loop_bot_342:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_346
loop_top_346:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_347
loop_top_347:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xa
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xc
    call read_data
    cmp al, 0x0
    jg loop_top_347
loop_bot_347:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_346
loop_bot_346:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_348
loop_top_348:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_348
loop_bot_348:
    sub r8d, 0xd
    call read_data
    cmp al, 0x0
    jg loop_top_341
loop_bot_341:
    call read_data
    cmp al, 0x0
    jg loop_top_337
loop_bot_337:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_349
loop_top_349:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_349
loop_bot_349:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_350
loop_top_350:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_351
loop_top_351:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_352
loop_top_352:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_352
loop_bot_352:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_353
loop_top_353:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_353
loop_bot_353:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_351
loop_bot_351:
    sub r8d, 0x8
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_354
loop_top_354:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_355
loop_top_355:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_356
loop_top_356:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xa
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xb
    call read_data
    cmp al, 0x0
    jle loop_bot_357
loop_top_357:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_357
loop_bot_357:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_356
loop_bot_356:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_358
loop_top_358:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xa
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xb
    call read_data
    cmp al, 0x0
    jg loop_top_358
loop_bot_358:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_355
loop_bot_355:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_359
loop_top_359:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_360
loop_top_360:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xa
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xb
    call read_data
    cmp al, 0x0
    jg loop_top_360
loop_bot_360:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_359
loop_bot_359:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_361
loop_top_361:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_361
loop_bot_361:
    sub r8d, 0xc
    call read_data
    cmp al, 0x0
    jg loop_top_354
loop_bot_354:
    add r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_350
loop_bot_350:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_362
loop_top_362:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_363
loop_top_363:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_363
loop_bot_363:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_364
loop_top_364:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_364
loop_bot_364:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_365
loop_top_365:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_365
loop_bot_365:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_362
loop_bot_362:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_366
loop_top_366:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_366
loop_bot_366:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_367
loop_top_367:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_367
loop_bot_367:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_368
loop_top_368:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_368
loop_bot_368:
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_369
loop_top_369:
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_370
loop_top_370:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jg loop_top_370
loop_bot_370:
    sub r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_371
loop_top_371:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_371
loop_bot_371:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_369
loop_bot_369:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_372
loop_top_372:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_372
loop_bot_372:
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_373
loop_top_373:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_373
loop_bot_373:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_374
loop_top_374:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_375
loop_top_375:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    add al, 0x2
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_375
loop_bot_375:
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_376
loop_top_376:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_376
loop_bot_376:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_374
loop_bot_374:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_377
loop_top_377:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_377
loop_bot_377:
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_378
loop_top_378:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_378
loop_bot_378:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_379
loop_top_379:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_379
loop_bot_379:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_380
loop_top_380:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_381
loop_top_381:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_382
loop_top_382:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_382
loop_bot_382:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_383
loop_top_383:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_384
loop_top_384:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_384
loop_bot_384:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_385
loop_top_385:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0xb
    call read_data
    cmp al, 0x0
    jle loop_bot_386
loop_top_386:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_386
loop_bot_386:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_387
loop_top_387:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_387
loop_bot_387:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_388
loop_top_388:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_388
loop_bot_388:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_385
loop_bot_385:
    call read_data
    cmp al, 0x0
    jg loop_top_383
loop_bot_383:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_389
loop_top_389:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_389
loop_bot_389:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_390
loop_top_390:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_391
loop_top_391:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_391
loop_bot_391:
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_392
loop_top_392:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0xc
    call read_data
    cmp al, 0x0
    jle loop_bot_393
loop_top_393:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_393
loop_bot_393:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_394
loop_top_394:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_394
loop_bot_394:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_395
loop_top_395:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_395
loop_bot_395:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_396
loop_top_396:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_396
loop_bot_396:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_392
loop_bot_392:
    call read_data
    cmp al, 0x0
    jg loop_top_390
loop_bot_390:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_397
loop_top_397:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_398
loop_top_398:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_398
loop_bot_398:
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_397
loop_bot_397:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_381
loop_bot_381:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_399
loop_top_399:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_399
loop_bot_399:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_400
loop_top_400:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_400
loop_bot_400:
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_401
loop_top_401:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_402
loop_top_402:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_403
loop_top_403:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_403
loop_bot_403:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_404
loop_top_404:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_404
loop_bot_404:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_402
loop_bot_402:
    sub r8d, 0x8
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_405
loop_top_405:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_406
loop_top_406:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_407
loop_top_407:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xd
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xa
    call read_data
    cmp al, 0x0
    jle loop_bot_408
loop_top_408:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_408
loop_bot_408:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_407
loop_bot_407:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_409
loop_top_409:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xd
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xa
    call read_data
    cmp al, 0x0
    jg loop_top_409
loop_bot_409:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_406
loop_bot_406:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_410
loop_top_410:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_411
loop_top_411:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xd
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xa
    call read_data
    cmp al, 0x0
    jg loop_top_411
loop_bot_411:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_410
loop_bot_410:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_412
loop_top_412:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_412
loop_bot_412:
    sub r8d, 0xb
    call read_data
    cmp al, 0x0
    jg loop_top_405
loop_bot_405:
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_413
loop_top_413:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_413
loop_bot_413:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_414
loop_top_414:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_414
loop_bot_414:
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_415
loop_top_415:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_415
loop_bot_415:
    call read_data
    cmp al, 0x0
    jg loop_top_401
loop_bot_401:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_416
loop_top_416:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_416
loop_bot_416:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_417
loop_top_417:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_418
loop_top_418:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_419
loop_top_419:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_419
loop_bot_419:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_420
loop_top_420:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_420
loop_bot_420:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_418
loop_bot_418:
    sub r8d, 0x8
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_421
loop_top_421:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_422
loop_top_422:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_423
loop_top_423:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xd
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xb
    call read_data
    cmp al, 0x0
    jle loop_bot_424
loop_top_424:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_424
loop_bot_424:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_423
loop_bot_423:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_425
loop_top_425:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xd
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xb
    call read_data
    cmp al, 0x0
    jg loop_top_425
loop_bot_425:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_422
loop_bot_422:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_426
loop_top_426:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_427
loop_top_427:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xd
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xb
    call read_data
    cmp al, 0x0
    jg loop_top_427
loop_bot_427:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_426
loop_bot_426:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_428
loop_top_428:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_428
loop_bot_428:
    sub r8d, 0xc
    call read_data
    cmp al, 0x0
    jg loop_top_421
loop_bot_421:
    call read_data
    cmp al, 0x0
    jg loop_top_417
loop_bot_417:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_429
loop_top_429:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_429
loop_bot_429:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_380
loop_bot_380:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_430
loop_top_430:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_430
loop_bot_430:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_431
loop_top_431:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_432
loop_top_432:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_432
loop_bot_432:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_433
loop_top_433:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_433
loop_bot_433:
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_434
loop_top_434:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_434
loop_bot_434:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_435
loop_top_435:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_435
loop_bot_435:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_436
loop_top_436:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_437
loop_top_437:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_438
loop_top_438:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xd
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xb
    call read_data
    cmp al, 0x0
    jle loop_bot_439
loop_top_439:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_439
loop_bot_439:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_438
loop_bot_438:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_440
loop_top_440:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xd
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xb
    call read_data
    cmp al, 0x0
    jg loop_top_440
loop_bot_440:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_437
loop_bot_437:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_441
loop_top_441:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_442
loop_top_442:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0xd
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0xb
    call read_data
    cmp al, 0x0
    jg loop_top_442
loop_bot_442:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_441
loop_bot_441:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_443
loop_top_443:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_443
loop_bot_443:
    sub r8d, 0xc
    call read_data
    cmp al, 0x0
    jg loop_top_436
loop_bot_436:
    call read_data
    cmp al, 0x0
    jg loop_top_431
loop_bot_431:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_444
loop_top_444:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_445
loop_top_445:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_445
loop_bot_445:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_446
loop_top_446:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_446
loop_bot_446:
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jg loop_top_444
loop_bot_444:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_447
loop_top_447:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_447
loop_bot_447:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_448
loop_top_448:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_448
loop_bot_448:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_449
loop_top_449:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_449
loop_bot_449:
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_450
loop_top_450:
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_451
loop_top_451:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_451
loop_bot_451:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_452
loop_top_452:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_452
loop_bot_452:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_450
loop_bot_450:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_453
loop_top_453:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_453
loop_bot_453:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_454
loop_top_454:
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_455
loop_top_455:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_455
loop_bot_455:
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_456
loop_top_456:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_456
loop_bot_456:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_454
loop_bot_454:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_457
loop_top_457:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_457
loop_bot_457:
    add r8d, 0x9
    call read_data
    add al, 0xf
    call write_data
    cmp al, 0x0
    jle loop_bot_458
loop_top_458:
    call read_data
    cmp al, 0x0
    jle loop_bot_459
loop_top_459:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_459
loop_bot_459:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_460
loop_top_460:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_460
loop_bot_460:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_461
loop_top_461:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_461
loop_bot_461:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_462
loop_top_462:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_462
loop_bot_462:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_463
loop_top_463:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_463
loop_bot_463:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_464
loop_top_464:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_464
loop_bot_464:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_465
loop_top_465:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_465
loop_bot_465:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_466
loop_top_466:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_466
loop_bot_466:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_467
loop_top_467:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_467
loop_bot_467:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_468
loop_top_468:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_468
loop_bot_468:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_469
loop_top_469:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_469
loop_bot_469:
    add r8d, 0x9
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_458
loop_bot_458:
    call read_data
    add al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_470
loop_top_470:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_470
loop_bot_470:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_471
loop_top_471:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_471
loop_bot_471:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_472
loop_top_472:
    add r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_473
loop_top_473:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_473
loop_bot_473:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_474
loop_top_474:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_475
loop_top_475:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_476
loop_top_476:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_476
loop_bot_476:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_477
loop_top_477:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_477
loop_bot_477:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_475
loop_bot_475:
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_478
loop_top_478:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_478
loop_bot_478:
    call read_data
    cmp al, 0x0
    jg loop_top_474
loop_bot_474:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_479
loop_top_479:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_479
loop_bot_479:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_480
loop_top_480:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_481
loop_top_481:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_481
loop_bot_481:
    sub r8d, 0xa
    call read_data
    cmp al, 0x0
    jg loop_top_480
loop_bot_480:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_482
loop_top_482:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_482
loop_bot_482:
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_472
loop_bot_472:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_483
loop_top_483:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_484
loop_top_484:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_484
loop_bot_484:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_485
loop_top_485:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_486
loop_top_486:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jg loop_top_486
loop_bot_486:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_487
loop_top_487:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_487
loop_bot_487:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_485
loop_bot_485:
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_488
loop_top_488:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_488
loop_bot_488:
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_483
loop_bot_483:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_489
loop_top_489:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_489
loop_bot_489:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_490
loop_top_490:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_490
loop_bot_490:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_491
loop_top_491:
    add r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_492
loop_top_492:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_492
loop_bot_492:
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_493
loop_top_493:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_494
loop_top_494:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_495
loop_top_495:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_495
loop_bot_495:
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_496
loop_top_496:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_496
loop_bot_496:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_494
loop_bot_494:
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_497
loop_top_497:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_497
loop_bot_497:
    call read_data
    cmp al, 0x0
    jg loop_top_493
loop_bot_493:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_498
loop_top_498:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_498
loop_bot_498:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_499
loop_top_499:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_500
loop_top_500:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_500
loop_bot_500:
    sub r8d, 0xb
    call read_data
    cmp al, 0x0
    jg loop_top_499
loop_bot_499:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_501
loop_top_501:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_501
loop_bot_501:
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_491
loop_bot_491:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_502
loop_top_502:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_503
loop_top_503:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_503
loop_bot_503:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_504
loop_top_504:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_505
loop_top_505:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jg loop_top_505
loop_bot_505:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_506
loop_top_506:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_506
loop_bot_506:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_504
loop_bot_504:
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_507
loop_top_507:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_507
loop_bot_507:
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_502
loop_bot_502:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_508
loop_top_508:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_509
loop_top_509:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x24
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x24
    call read_data
    cmp al, 0x0
    jg loop_top_509
loop_bot_509:
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_508
loop_bot_508:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_510
loop_top_510:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_510
loop_bot_510:
    add r8d, 0x9
    call read_data
    add al, 0xf
    call write_data
    cmp al, 0x0
    jle loop_bot_511
loop_top_511:
    call read_data
    cmp al, 0x0
    jle loop_bot_512
loop_top_512:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_512
loop_bot_512:
    sub r8d, 0x9
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_513
loop_top_513:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_513
loop_bot_513:
    add r8d, 0x9
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_511
loop_bot_511:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x15
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_514
loop_top_514:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_514
loop_bot_514:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_515
loop_top_515:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_516
loop_top_516:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_516
loop_bot_516:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_517
loop_top_517:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_518
loop_top_518:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_518
loop_bot_518:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_519
loop_top_519:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0xd
    call read_data
    cmp al, 0x0
    jle loop_bot_520
loop_top_520:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_520
loop_bot_520:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_521
loop_top_521:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_521
loop_bot_521:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_522
loop_top_522:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_522
loop_bot_522:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_519
loop_bot_519:
    call read_data
    cmp al, 0x0
    jg loop_top_517
loop_bot_517:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_523
loop_top_523:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_523
loop_bot_523:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_524
loop_top_524:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_525
loop_top_525:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_525
loop_bot_525:
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_526
loop_top_526:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0xc
    call read_data
    cmp al, 0x0
    jle loop_bot_527
loop_top_527:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_527
loop_bot_527:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_528
loop_top_528:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_528
loop_bot_528:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_529
loop_top_529:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_529
loop_bot_529:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_530
loop_top_530:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_530
loop_bot_530:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_526
loop_bot_526:
    call read_data
    cmp al, 0x0
    jg loop_top_524
loop_bot_524:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_531
loop_top_531:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_532
loop_top_532:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_532
loop_bot_532:
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_531
loop_bot_531:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_515
loop_bot_515:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_533
loop_top_533:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_533
loop_bot_533:
    add r8d, 0x2
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_534
loop_top_534:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_534
loop_bot_534:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_535
loop_top_535:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_536
loop_top_536:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_536
loop_bot_536:
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_535
loop_bot_535:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_114
loop_bot_114:
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_537
loop_top_537:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_537
loop_bot_537:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_538
loop_top_538:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    mov edi, eax
    call print_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_538
loop_bot_538:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_539
loop_top_539:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    mov edi, eax
    call print_data
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_539
loop_bot_539:
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_540
loop_top_540:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_540
loop_bot_540:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_541
loop_top_541:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_541
loop_bot_541:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_542
loop_top_542:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_542
loop_bot_542:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_543
loop_top_543:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_543
loop_bot_543:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_544
loop_top_544:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_544
loop_bot_544:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_545
loop_top_545:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_545
loop_bot_545:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_546
loop_top_546:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_547
loop_top_547:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_547
loop_bot_547:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_548
loop_top_548:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_548
loop_bot_548:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_549
loop_top_549:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_549
loop_bot_549:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_550
loop_top_550:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_550
loop_bot_550:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_551
loop_top_551:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_551
loop_bot_551:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_552
loop_top_552:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_552
loop_bot_552:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_546
loop_bot_546:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_553
loop_top_553:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_553
loop_bot_553:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_554
loop_top_554:
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_555
loop_top_555:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_555
loop_bot_555:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_554
loop_bot_554:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_556
loop_top_556:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_556
loop_bot_556:
    add r8d, 0x1
    call read_data
    add al, 0xc
    call write_data
    cmp al, 0x0
    jle loop_bot_557
loop_top_557:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_558
loop_top_558:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_558
loop_bot_558:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_557
loop_bot_557:
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0xe
    call read_data
    cmp al, 0x0
    jle loop_bot_559
loop_top_559:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_559
loop_bot_559:
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_560
loop_top_560:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_560
loop_bot_560:
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_561
loop_top_561:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_562
loop_top_562:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_562
loop_bot_562:
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_563
loop_top_563:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_563
loop_bot_563:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_564
loop_top_564:
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_565
loop_top_565:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jg loop_top_565
loop_bot_565:
    sub r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_566
loop_top_566:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_567
loop_top_567:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_567
loop_bot_567:
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_568
loop_top_568:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_568
loop_bot_568:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_566
loop_bot_566:
    sub r8d, 0xa
    call read_data
    cmp al, 0x0
    jg loop_top_564
loop_bot_564:
    call read_data
    cmp al, 0x0
    jg loop_top_561
loop_bot_561:
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_569
loop_top_569:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_569
loop_bot_569:
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_570
loop_top_570:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_571
loop_top_571:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_572
loop_top_572:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_572
loop_bot_572:
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_573
loop_top_573:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_573
loop_bot_573:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_571
loop_bot_571:
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_574
loop_top_574:
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_575
loop_top_575:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_575
loop_bot_575:
    sub r8d, 0xe
    call read_data
    cmp al, 0x0
    jg loop_top_574
loop_bot_574:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_576
loop_top_576:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_576
loop_bot_576:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_577
loop_top_577:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_578
loop_top_578:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_578
loop_bot_578:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_579
loop_top_579:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_580
loop_top_580:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_580
loop_bot_580:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_581
loop_top_581:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_581
loop_bot_581:
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_579
loop_bot_579:
    sub r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_582
loop_top_582:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    cmp al, 0x0
    jg loop_top_582
loop_bot_582:
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_577
loop_bot_577:
    add r8d, 0x7
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_583
loop_top_583:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_583
loop_bot_583:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_570
loop_bot_570:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_584
loop_top_584:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_584
loop_bot_584:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_585
loop_top_585:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_586
loop_top_586:
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_587
loop_top_587:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_587
loop_bot_587:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jg loop_top_586
loop_bot_586:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_588
loop_top_588:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_589
loop_top_589:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_589
loop_bot_589:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_590
loop_top_590:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_591
loop_top_591:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_591
loop_bot_591:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_592
loop_top_592:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_592
loop_bot_592:
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_590
loop_bot_590:
    sub r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_593
loop_top_593:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    cmp al, 0x0
    jg loop_top_593
loop_bot_593:
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_588
loop_bot_588:
    add r8d, 0x1
    call read_data
    add al, 0x5
    call write_data
    cmp al, 0x0
    jle loop_bot_594
loop_top_594:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_595
loop_top_595:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_595
loop_bot_595:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_594
loop_bot_594:
    add r8d, 0x4
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_596
loop_top_596:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_596
loop_bot_596:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_597
loop_top_597:
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_598
loop_top_598:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_598
loop_bot_598:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_599
loop_top_599:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_600
loop_top_600:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_600
loop_bot_600:
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_601
loop_top_601:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x10
    call read_data
    cmp al, 0x0
    jle loop_bot_602
loop_top_602:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_602
loop_bot_602:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_603
loop_top_603:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_603
loop_bot_603:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_604
loop_top_604:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_604
loop_bot_604:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_601
loop_bot_601:
    call read_data
    cmp al, 0x0
    jg loop_top_599
loop_bot_599:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_605
loop_top_605:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_605
loop_bot_605:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_606
loop_top_606:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_607
loop_top_607:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_607
loop_bot_607:
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_608
loop_top_608:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0xe
    call read_data
    cmp al, 0x0
    jle loop_bot_609
loop_top_609:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_609
loop_bot_609:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_610
loop_top_610:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_610
loop_bot_610:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_611
loop_top_611:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_611
loop_bot_611:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_612
loop_top_612:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_612
loop_bot_612:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_608
loop_bot_608:
    call read_data
    cmp al, 0x0
    jg loop_top_606
loop_bot_606:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_613
loop_top_613:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_614
loop_top_614:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_614
loop_bot_614:
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_613
loop_bot_613:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_597
loop_bot_597:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_615
loop_top_615:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_615
loop_bot_615:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_616
loop_top_616:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_616
loop_bot_616:
    sub r8d, 0x3
    call read_data
    add al, 0x5
    call write_data
    cmp al, 0x0
    jle loop_bot_617
loop_top_617:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_618
loop_top_618:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_618
loop_bot_618:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_617
loop_bot_617:
    add r8d, 0x4
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_619
loop_top_619:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_619
loop_bot_619:
    call read_data
    cmp al, 0x0
    jg loop_top_585
loop_bot_585:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_22
loop_bot_22:
    sub r8d, 0x4
    call read_data
    mov edi, eax
    call print_data
    add r8d, 0xa
    call read_data
    cmp al, 0x0
    jle loop_bot_620
loop_top_620:
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_621
loop_top_621:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_621
loop_bot_621:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_620
loop_bot_620:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_622
loop_top_622:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_622
loop_bot_622:
    add r8d, 0x1
    call read_data
    add al, 0xb
    call write_data
    cmp al, 0x0
    jle loop_bot_623
loop_top_623:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_624
loop_top_624:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_624
loop_bot_624:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_623
loop_bot_623:
    add r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0xf
    call read_data
    cmp al, 0x0
    jle loop_bot_625
loop_top_625:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_625
loop_bot_625:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_626
loop_top_626:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x8
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_626
loop_bot_626:
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_627
loop_top_627:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    add al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_628
loop_top_628:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_628
loop_bot_628:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_629
loop_top_629:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_629
loop_bot_629:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_630
loop_top_630:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_631
loop_top_631:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_631
loop_bot_631:
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_632
loop_top_632:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_633
loop_top_633:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_633
loop_bot_633:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_634
loop_top_634:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_634
loop_bot_634:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_632
loop_bot_632:
    sub r8d, 0xa
    call read_data
    cmp al, 0x0
    jg loop_top_630
loop_bot_630:
    call read_data
    cmp al, 0x0
    jg loop_top_627
loop_bot_627:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_635
loop_top_635:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x8
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_635
loop_bot_635:
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_636
loop_top_636:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_637
loop_top_637:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_638
loop_top_638:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_638
loop_bot_638:
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_639
loop_top_639:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jg loop_top_639
loop_bot_639:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_637
loop_bot_637:
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_640
loop_top_640:
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_641
loop_top_641:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_641
loop_bot_641:
    sub r8d, 0xf
    call read_data
    cmp al, 0x0
    jg loop_top_640
loop_bot_640:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_642
loop_top_642:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_642
loop_bot_642:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_643
loop_top_643:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_644
loop_top_644:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_644
loop_bot_644:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_645
loop_top_645:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x8
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_646
loop_top_646:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_646
loop_bot_646:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_647
loop_top_647:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_647
loop_bot_647:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_645
loop_bot_645:
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_648
loop_top_648:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_648
loop_bot_648:
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_643
loop_bot_643:
    add r8d, 0x8
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_649
loop_top_649:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_649
loop_bot_649:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_636
loop_bot_636:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_650
loop_top_650:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x8
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_650
loop_bot_650:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_651
loop_top_651:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_652
loop_top_652:
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_653
loop_top_653:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_653
loop_bot_653:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_652
loop_bot_652:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_654
loop_top_654:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_655
loop_top_655:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_655
loop_bot_655:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_656
loop_top_656:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x8
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_657
loop_top_657:
    sub r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jg loop_top_657
loop_bot_657:
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_658
loop_top_658:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_658
loop_bot_658:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_656
loop_bot_656:
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jle loop_bot_659
loop_top_659:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x7
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x7
    call read_data
    cmp al, 0x0
    jg loop_top_659
loop_bot_659:
    sub r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_654
loop_bot_654:
    add r8d, 0x1
    call read_data
    add al, 0x5
    call write_data
    cmp al, 0x0
    jle loop_bot_660
loop_top_660:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_661
loop_top_661:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_661
loop_bot_661:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_660
loop_bot_660:
    add r8d, 0x5
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1b
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_662
loop_top_662:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_662
loop_bot_662:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_663
loop_top_663:
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_664
loop_top_664:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jg loop_top_664
loop_bot_664:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_665
loop_top_665:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_666
loop_top_666:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x8
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_666
loop_bot_666:
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_667
loop_top_667:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x11
    call read_data
    cmp al, 0x0
    jle loop_bot_668
loop_top_668:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_668
loop_bot_668:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_669
loop_top_669:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_669
loop_bot_669:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x5
    call read_data
    cmp al, 0x0
    jle loop_bot_670
loop_top_670:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_670
loop_bot_670:
    add r8d, 0x1
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_667
loop_bot_667:
    call read_data
    cmp al, 0x0
    jg loop_top_665
loop_bot_665:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_671
loop_top_671:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x8
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_671
loop_bot_671:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jle loop_bot_672
loop_top_672:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x8
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x2
    call read_data
    cmp al, 0x0
    jle loop_bot_673
loop_top_673:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jg loop_top_673
loop_bot_673:
    sub r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_674
loop_top_674:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0xf
    call read_data
    cmp al, 0x0
    jle loop_bot_675
loop_top_675:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_675
loop_bot_675:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jle loop_bot_676
loop_top_676:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_676
loop_bot_676:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_677
loop_top_677:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_677
loop_bot_677:
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_678
loop_top_678:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_678
loop_bot_678:
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jg loop_top_674
loop_bot_674:
    call read_data
    cmp al, 0x0
    jg loop_top_672
loop_bot_672:
    call read_data
    add al, 0x1
    call write_data
    add r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_679
loop_top_679:
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x1
    call read_data
    cmp al, 0x0
    jle loop_bot_680
loop_top_680:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_680
loop_bot_680:
    sub r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_679
loop_bot_679:
    add r8d, 0x8
    call read_data
    cmp al, 0x0
    jg loop_top_663
loop_bot_663:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jle loop_bot_681
loop_top_681:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_681
loop_bot_681:
    add r8d, 0x4
    call read_data
    cmp al, 0x0
    jle loop_bot_682
loop_top_682:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jg loop_top_682
loop_bot_682:
    sub r8d, 0x3
    call read_data
    add al, 0x5
    call write_data
    cmp al, 0x0
    jle loop_bot_683
loop_top_683:
    call read_data
    sub al, 0x1
    call write_data
    cmp al, 0x0
    jle loop_bot_684
loop_top_684:
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x9
    call read_data
    add al, 0x1
    call write_data
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_684
loop_bot_684:
    add r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_683
loop_bot_683:
    add r8d, 0x5
    call read_data
    sub al, 0x1
    call write_data
    add r8d, 0x1b
    call read_data
    sub al, 0x1
    call write_data
    sub r8d, 0x6
    call read_data
    cmp al, 0x0
    jle loop_bot_685
loop_top_685:
    sub r8d, 0x9
    call read_data
    cmp al, 0x0
    jg loop_top_685
loop_bot_685:
    call read_data
    cmp al, 0x0
    jg loop_top_651
loop_bot_651:
    add r8d, 0x3
    call read_data
    cmp al, 0x0
    jg loop_top_12
loop_bot_12:
    mov eax,1 ;system call number (sys_exit)
    int 0x80  ;call kernel