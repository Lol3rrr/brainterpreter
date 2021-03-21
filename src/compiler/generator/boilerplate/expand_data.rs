pub fn expand_data(result: &mut Vec<String>) {
    // Expands the data buffer to (eax + 1) in size
    result.push("expand_data:".to_owned());
    // Calculate the new size and place it inside ecx
    result.push("    add eax, 0x01".to_owned()); // Add 1
    result.push("    mov ecx, eax".to_owned()); // Move the size into ecx
                                                // Allocate the new memory block
    result.push("    mov eax, 192".to_owned()); // Mmap2 system call
    result.push("    xor ebx, ebx".to_owned()); // addr = NULL
    result.push("    mov edx, 0x7".to_owned()); // prot = READ|WRITE|EXEC
    result.push("    mov esi, 0x22".to_owned()); // flags = PRIVATE|ANONYMOUS
    result.push("    mov edi, -1".to_owned()); // fd = -1
    result.push("    xor ebp, ebp".to_owned()); // offset = 0
    result.push("    int 0x80".to_owned()); // Perform the system call
    result.push("    push rcx".to_owned());
    result.push("    push rax".to_owned());

    // Move all the Data from the old to the new
    result.push("    mov ebx, eax".to_owned());
    result.push("    xor eax, eax".to_owned());
    result.push("    push rcx".to_owned());
    result.push("copy_loop_top:".to_owned()); // top of the copy-loop
    result.push("    cmp eax, r10d".to_owned());
    result.push("    jge copy_loop_bot".to_owned());
    result.push("    mov ecx, [r9d + eax]".to_owned());
    result.push("    mov [ebx + eax], ecx".to_owned());
    result.push("    inc eax".to_owned());
    result.push("    jmp copy_loop_top".to_owned());
    result.push("copy_loop_bot:".to_owned()); // bottom of the copy-loop

    // Zero out rest of the Data
    result.push("    pop rcx".to_owned());
    result.push("    mov eax, r10d".to_owned());
    result.push("    xor rdx, rdx".to_owned());
    result.push("zero_loop_top:".to_owned());
    result.push("    cmp eax, ecx".to_owned());
    result.push("    jge zero_loop_bottom".to_owned());
    result.push("    mov [ebx + eax], rdx".to_owned());
    result.push("    inc eax".to_owned());
    result.push("    jmp zero_loop_top".to_owned());
    result.push("zero_loop_bottom:".to_owned());

    // Deallocate the old Data
    result.push("    cmp r9d, 0".to_owned());
    result.push("    je expand_data_post_dealloc".to_owned());
    result.push("    mov eax, 91".to_owned());
    result.push("    mov ebx, r9d".to_owned());
    result.push("    mov ecx, r10d".to_owned());
    result.push("    int 0x80".to_owned());
    result.push("    expand_data_post_dealloc:".to_owned());
    // Set the new Data as current
    result.push("    pop rax".to_owned());
    result.push("    mov r9d, eax".to_owned());
    result.push("    pop rax".to_owned());
    result.push("    mov r10d, eax".to_owned());
    result.push("    ret".to_owned());
}
