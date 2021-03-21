mod expand_data;

pub fn generate_bss() -> Vec<String> {
    let mut result = Vec::new();

    result.push("outputBuffer resb 1".to_owned());
    result.push("inputBuffer resb 1".to_owned());

    result
}

pub fn generate_data() -> Vec<String> {
    let mut result = Vec::new();

    result.push("enter_msg db 'Enter something: '".to_owned());
    result.push("enter_len equ $ - enter_msg".to_owned());

    result
}

pub fn generate_text() -> Vec<String> {
    let mut result = Vec::new();

    result.push("print_enter_msg:".to_owned());
    result.push("    mov ecx, enter_msg".to_owned());
    result.push("    mov edx, enter_len".to_owned());
    result.push("    mov eax, 4".to_owned());
    result.push("    mov ebx, 1".to_owned());
    result.push("    int 0x80".to_owned());
    result.push("    ret".to_owned());

    result.push("print_data:".to_owned());
    result.push("    mov [outputBuffer], edi".to_owned());
    result.push("    mov ecx, outputBuffer".to_owned());
    result.push("    mov edx, 0x01".to_owned());
    result.push("    mov eax, 4".to_owned());
    result.push("    mov ebx, 1".to_owned());
    result.push("    int 0x80".to_owned());
    result.push("    ret".to_owned());

    result.push("read_input_data:".to_owned());
    result.push("    mov eax, 0x03".to_owned());
    result.push("    mov ebx, 0x02".to_owned());
    result.push("    mov ecx, inputBuffer".to_owned());
    result.push("    mov edx, 0x01".to_owned());
    result.push("    int 0x80".to_owned());
    result.push("    mov eax, [inputBuffer]".to_owned());
    result.push("    ret".to_owned());

    expand_data::expand_data(&mut result);

    // Reads the Data from the current index (r8d)
    // into eax
    result.push("read_data:".to_owned());
    result.push("    cmp r8d, r10d".to_owned());
    result.push("    jl read_data_post_expand".to_owned());
    result.push("    mov eax, r8d".to_owned());
    result.push("    call expand_data".to_owned());
    result.push("    read_data_post_expand:".to_owned());
    result.push("    mov eax, [r9d + r8d]".to_owned());
    result.push("    ret".to_owned());

    // Writes the value in eax into the
    // current index (r8d) of the data
    result.push("write_data:".to_owned());
    result.push("    push rax".to_owned());
    result.push("    cmp r8d, r10d".to_owned());
    result.push("    jl write_data_post_expand".to_owned());
    result.push("    push rax".to_owned());
    result.push("    mov eax, r8d".to_owned());
    result.push("    call expand_data".to_owned());
    result.push("    pop rax".to_owned());
    result.push("    write_data_post_expand:".to_owned());
    result.push("    pop rax".to_owned());
    result.push("    mov [r9d + r8d], eax".to_owned());
    result.push("    ret".to_owned());

    result
}
