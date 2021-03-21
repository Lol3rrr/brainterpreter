use super::lexer::Token;

mod boilerplate;
mod token;

// r8d holds the Data-Index
// r9d holds the Actual data Ptr
// r10d holds the Data-Size

pub fn generate(final_ir: Token) -> String {
    let mut result = String::new();

    // All the BSS-Stuff
    result.push_str("section .bss\n");
    for part in boilerplate::generate_bss() {
        result.push_str("    ");
        result.push_str(&part);
        result.push_str("\n");
    }

    // All the Data-Stuff
    result.push_str("section .data\n");
    for part in boilerplate::generate_data() {
        result.push_str("    ");
        result.push_str(&part);
        result.push_str("\n");
    }

    // All the Text-Stuff
    result.push_str("section .text\nglobal _start\n");
    for part in boilerplate::generate_text() {
        result.push_str("    ");
        result.push_str(&part);
        result.push_str("\n");
    }
    result.push_str("_start:\n");
    result.push_str("    xor r8d, r8d\n");
    result.push_str("    xor r9d, r9d\n");
    result.push_str("    xor r10d, r10d\n");
    for part in token::generate(final_ir, &mut 0) {
        result.push_str("    ");
        result.push_str(&part);
        result.push_str("\n");
    }
    result.push_str("    mov eax,1 ;system call number (sys_exit)\n");
    result.push_str("    int 0x80  ;call kernel");

    result
}
