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
    add r8d, 0x5 ; [Token::IncData]
    call print_enter_msg ; [Token::Input]
    call read_input_data ; [Token::Input] Reads into eax
    call write_data; [Token::Input] Stores eax into the current Data
    add r8d, 0x1 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x2 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    sub r8d, 0x5 ; [Token::DecData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_0 ; [Token::Loop] Jump to end
    loop_top_0: ; [Token::Loop] Top Level label for loop
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_0 ; [Token::Loop] Jump top if nonzero
    loop_bot_0: ; [Token::Loop] Bottom Level label for loop
    add r8d, 0x1 ; [Token::IncData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_1 ; [Token::Loop] Jump to end
    loop_top_1: ; [Token::Loop] Top Level label for loop
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_1 ; [Token::Loop] Jump top if nonzero
    loop_bot_1: ; [Token::Loop] Bottom Level label for loop
    add r8d, 0x1 ; [Token::IncData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_2 ; [Token::Loop] Jump to end
    loop_top_2: ; [Token::Loop] Top Level label for loop
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_2 ; [Token::Loop] Jump top if nonzero
    loop_bot_2: ; [Token::Loop] Bottom Level label for loop
    add r8d, 0x1 ; [Token::IncData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_3 ; [Token::Loop] Jump to end
    loop_top_3: ; [Token::Loop] Top Level label for loop
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_3 ; [Token::Loop] Jump top if nonzero
    loop_bot_3: ; [Token::Loop] Bottom Level label for loop
    add r8d, 0x1 ; [Token::IncData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_4 ; [Token::Loop] Jump to end
    loop_top_4: ; [Token::Loop] Top Level label for loop
    sub r8d, 0x4 ; [Token::DecData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    add r8d, 0x4 ; [Token::IncData]
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_4 ; [Token::Loop] Jump top if nonzero
    loop_bot_4: ; [Token::Loop] Bottom Level label for loop
    sub r8d, 0x4 ; [Token::DecData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_5 ; [Token::Loop] Jump to end
    loop_top_5: ; [Token::Loop] Top Level label for loop
    add r8d, 0x5 ; [Token::IncData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_6 ; [Token::Loop] Jump to end
    loop_top_6: ; [Token::Loop] Top Level label for loop
    sub r8d, 0x4 ; [Token::DecData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    add r8d, 0x1 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    add r8d, 0x3 ; [Token::IncData]
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_6 ; [Token::Loop] Jump top if nonzero
    loop_bot_6: ; [Token::Loop] Bottom Level label for loop
    sub r8d, 0x3 ; [Token::DecData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_7 ; [Token::Loop] Jump to end
    loop_top_7: ; [Token::Loop] Top Level label for loop
    add r8d, 0x3 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    sub r8d, 0x3 ; [Token::DecData]
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_7 ; [Token::Loop] Jump top if nonzero
    loop_bot_7: ; [Token::Loop] Bottom Level label for loop
    sub r8d, 0x1 ; [Token::DecData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_8 ; [Token::Loop] Jump to end
    loop_top_8: ; [Token::Loop] Top Level label for loop
    add r8d, 0x1 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    sub r8d, 0x2 ; [Token::DecData]
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_9 ; [Token::Loop] Jump to end
    loop_top_9: ; [Token::Loop] Top Level label for loop
    add r8d, 0x2 ; [Token::IncData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_10 ; [Token::Loop] Jump to end
    loop_top_10: ; [Token::Loop] Top Level label for loop
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_10 ; [Token::Loop] Jump top if nonzero
    loop_bot_10: ; [Token::Loop] Bottom Level label for loop
    add r8d, 0x1 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    sub r8d, 0x3 ; [Token::DecData]
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_9 ; [Token::Loop] Jump top if nonzero
    loop_bot_9: ; [Token::Loop] Bottom Level label for loop
    add r8d, 0x3 ; [Token::IncData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_11 ; [Token::Loop] Jump to end
    loop_top_11: ; [Token::Loop] Top Level label for loop
    sub r8d, 0x3 ; [Token::DecData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    add r8d, 0x3 ; [Token::IncData]
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_11 ; [Token::Loop] Jump top if nonzero
    loop_bot_11: ; [Token::Loop] Bottom Level label for loop
    sub r8d, 0x1 ; [Token::DecData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_12 ; [Token::Loop] Jump to end
    loop_top_12: ; [Token::Loop] Top Level label for loop
    sub r8d, 0x1 ; [Token::DecData]
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_13 ; [Token::Loop] Jump to end
    loop_top_13: ; [Token::Loop] Top Level label for loop
    add r8d, 0x3 ; [Token::IncData]
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    sub r8d, 0x3 ; [Token::DecData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_14 ; [Token::Loop] Jump to end
    loop_top_14: ; [Token::Loop] Top Level label for loop
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_14 ; [Token::Loop] Jump top if nonzero
    loop_bot_14: ; [Token::Loop] Bottom Level label for loop
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_13 ; [Token::Loop] Jump top if nonzero
    loop_bot_13: ; [Token::Loop] Bottom Level label for loop
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    add r8d, 0x1 ; [Token::IncData]
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_12 ; [Token::Loop] Jump top if nonzero
    loop_bot_12: ; [Token::Loop] Bottom Level label for loop
    sub r8d, 0x1 ; [Token::DecData]
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_8 ; [Token::Loop] Jump top if nonzero
    loop_bot_8: ; [Token::Loop] Bottom Level label for loop
    add r8d, 0x3 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    sub r8d, 0x4 ; [Token::DecData]
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_5 ; [Token::Loop] Jump top if nonzero
    loop_bot_5: ; [Token::Loop] Bottom Level label for loop
    add r8d, 0x6 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    add r8d, 0x1 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x7 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_15 ; [Token::Loop] Jump to end
    loop_top_15: ; [Token::Loop] Top Level label for loop
    add r8d, 0x1 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x5 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    sub r8d, 0x1 ; [Token::DecData]
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_15 ; [Token::Loop] Jump top if nonzero
    loop_bot_15: ; [Token::Loop] Bottom Level label for loop
    add r8d, 0x1 ; [Token::IncData]
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x3 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    sub r8d, 0x1 ; [Token::DecData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x7 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_16 ; [Token::Loop] Jump to end
    loop_top_16: ; [Token::Loop] Top Level label for loop
    add r8d, 0x2 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x5 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    sub r8d, 0x2 ; [Token::DecData]
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_16 ; [Token::Loop] Jump top if nonzero
    loop_bot_16: ; [Token::Loop] Bottom Level label for loop
    sub r8d, 0x0 ; [Token::DecData]
    call read_data ; [Token::IncValue] Load value
    add al, 0xa ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    sub r8d, 0x3 ; [Token::DecData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_17 ; [Token::Loop] Jump to end
    loop_top_17: ; [Token::Loop] Top Level label for loop
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    add r8d, 0x6 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    add r8d, 0x1 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    add r8d, 0x9 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    sub r8d, 0x10 ; [Token::DecData]
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_17 ; [Token::Loop] Jump top if nonzero
    loop_bot_17: ; [Token::Loop] Bottom Level label for loop
    add r8d, 0x2 ; [Token::IncData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_18 ; [Token::Loop] Jump to end
    loop_top_18: ; [Token::Loop] Top Level label for loop
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    add r8d, 0x7 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    sub r8d, 0x7 ; [Token::DecData]
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_18 ; [Token::Loop] Jump top if nonzero
    loop_bot_18: ; [Token::Loop] Bottom Level label for loop
    add r8d, 0x4 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_19 ; [Token::Loop] Jump to end
    loop_top_19: ; [Token::Loop] Top Level label for loop
    add r8d, 0x1 ; [Token::IncData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_20 ; [Token::Loop] Jump to end
    loop_top_20: ; [Token::Loop] Top Level label for loop
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    add r8d, 0x1 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    add r8d, 0x3 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    add r8d, 0x2 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    sub r8d, 0x6 ; [Token::DecData]
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_20 ; [Token::Loop] Jump top if nonzero
    loop_bot_20: ; [Token::Loop] Bottom Level label for loop
    add r8d, 0x2 ; [Token::IncData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_21 ; [Token::Loop] Jump to end
    loop_top_21: ; [Token::Loop] Top Level label for loop
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    add r8d, 0x1 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    add r8d, 0x2 ; [Token::IncData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    sub r8d, 0x3 ; [Token::DecData]
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_21 ; [Token::Loop] Jump top if nonzero
    loop_bot_21: ; [Token::Loop] Bottom Level label for loop
    add r8d, 0x2 ; [Token::IncData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_22 ; [Token::Loop] Jump to end
    loop_top_22: ; [Token::Loop] Top Level label for loop
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    sub r8d, 0x7 ; [Token::DecData]
    call read_data ; [Token::Output] Loads the data into eax
    mov edi, eax; [Token::Output] Move the data into edi
    call print_data ; [Token::Output]
    add r8d, 0x7 ; [Token::IncData]
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_22 ; [Token::Loop] Jump top if nonzero
    loop_bot_22: ; [Token::Loop] Bottom Level label for loop
    add r8d, 0x1 ; [Token::IncData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_23 ; [Token::Loop] Jump to end
    loop_top_23: ; [Token::Loop] Top Level label for loop
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    sub r8d, 0x7 ; [Token::DecData]
    call read_data ; [Token::Output] Loads the data into eax
    mov edi, eax; [Token::Output] Move the data into edi
    call print_data ; [Token::Output]
    add r8d, 0x7 ; [Token::IncData]
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_23 ; [Token::Loop] Jump top if nonzero
    loop_bot_23: ; [Token::Loop] Bottom Level label for loop
    add r8d, 0x1 ; [Token::IncData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_24 ; [Token::Loop] Jump to end
    loop_top_24: ; [Token::Loop] Top Level label for loop
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    sub r8d, 0x9 ; [Token::DecData]
    call read_data ; [Token::Output] Loads the data into eax
    mov edi, eax; [Token::Output] Move the data into edi
    call print_data ; [Token::Output]
    add r8d, 0x9 ; [Token::IncData]
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_24 ; [Token::Loop] Jump top if nonzero
    loop_bot_24: ; [Token::Loop] Bottom Level label for loop
    sub r8d, 0xa ; [Token::DecData]
    call read_data ; [Token::Output] Loads the data into eax
    mov edi, eax; [Token::Output] Move the data into edi
    call print_data ; [Token::Output]
    add r8d, 0x5 ; [Token::IncData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_25 ; [Token::Loop] Jump to end
    loop_top_25: ; [Token::Loop] Top Level label for loop
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    sub r8d, 0x1 ; [Token::DecData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    add r8d, 0x1 ; [Token::IncData]
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_25 ; [Token::Loop] Jump top if nonzero
    loop_bot_25: ; [Token::Loop] Bottom Level label for loop
    sub r8d, 0x1 ; [Token::DecData]
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    add r8d, 0x3 ; [Token::IncData]
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_26 ; [Token::Loop] Jump to end
    loop_top_26: ; [Token::Loop] Top Level label for loop
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    sub r8d, 0x1 ; [Token::DecData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x1 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    add r8d, 0x1 ; [Token::IncData]
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_26 ; [Token::Loop] Jump top if nonzero
    loop_bot_26: ; [Token::Loop] Bottom Level label for loop
    sub r8d, 0x1 ; [Token::DecData]
    call read_data ; [Token::IncValue] Load value
    add al, 0x2 ; [Token::IncValue] Increment value
    call write_data ; [Token::IncValue] Store/Write value
    sub r8d, 0x3 ; [Token::DecData]
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_19 ; [Token::Loop] Jump top if nonzero
    loop_bot_19: ; [Token::Loop] Bottom Level label for loop
    add r8d, 0xa ; [Token::IncData]
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data; [Token::Loop] Stores the Value into eax
    cmp al, 0 ; [Token::Loop]
    jle loop_bot_27 ; [Token::Loop] Jump to end
    loop_top_27: ; [Token::Loop] Top Level label for loop
    sub r8d, 0xc ; [Token::DecData]
    call read_data ; [Token::Output] Loads the data into eax
    mov edi, eax; [Token::Output] Move the data into edi
    call print_data ; [Token::Output]
    add r8d, 0xc ; [Token::IncData]
    call read_data ; [Token::DecValue] Load value
    sub eax, 0x1 ; [Token::DecValue] Decrement value
    call write_data ; [Token::DecValue] Store/Write value
    call read_data ; [Token::Loop] Read the current Value into eax
    cmp al, 0
    jg loop_top_27 ; [Token::Loop] Jump top if nonzero
    loop_bot_27: ; [Token::Loop] Bottom Level label for loop
    sub r8d, 0xb ; [Token::DecData]
    call read_data ; [Token::Output] Loads the data into eax
    mov edi, eax; [Token::Output] Move the data into edi
    call print_data ; [Token::Output]
    call read_data ; [Token::Output] Loads the data into eax
    mov edi, eax; [Token::Output] Move the data into edi
    call print_data ; [Token::Output]
    call read_data ; [Token::Output] Loads the data into eax
    mov edi, eax; [Token::Output] Move the data into edi
    call print_data ; [Token::Output]
    mov eax,1 ;system call number (sys_exit)
    int 0x80  ;call kernel