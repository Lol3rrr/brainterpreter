use crate::compiler::lexer::Token;

pub fn generate(tmp: Token, unique_count: &mut usize) -> Vec<String> {
    match tmp {
        Token::Root(sub_tokens) => {
            let mut result = Vec::new();
            for tmp_sub in sub_tokens.into_iter() {
                result.append(&mut generate(tmp_sub, unique_count));
            }

            result
        }
        Token::IncData(value) => vec![format!("add r8d, {:#x} ; [Token::IncData]", value)],
        Token::DecData(value) => vec![format!("sub r8d, {:#x} ; [Token::DecData]", value)],
        Token::IncValue(value) => vec![
            "call read_data ; [Token::IncValue] Load value".to_owned(),
            format!("add al, {:#x} ; [Token::IncValue] Increment value", value),
            "call write_data ; [Token::IncValue] Store/Write value".to_owned(),
        ],
        Token::DecValue(value) => vec![
            "call read_data ; [Token::DecValue] Load value".to_owned(),
            format!("sub eax, {:#x} ; [Token::DecValue] Decrement value", value),
            "call write_data ; [Token::DecValue] Store/Write value".to_owned(),
        ],
        Token::Input => vec![
            "call print_enter_msg ; [Token::Input]".to_owned(),
            "call read_input_data ; [Token::Input] Reads into eax".to_owned(),
            "call write_data; [Token::Input] Stores eax into the current Data".to_owned(),
        ],
        Token::Output => vec![
            "call read_data ; [Token::Output] Loads the data into eax".to_owned(),
            "mov edi, eax; [Token::Output] Move the data into edi".to_owned(),
            "call print_data ; [Token::Output]".to_owned(),
        ],
        Token::Loop(sub_tokens) => {
            let mut result = Vec::new();
            let top_label = format!("loop_top_{}", unique_count);
            let bottom_label = format!("loop_bot_{}", unique_count);
            *unique_count += 1;

            result.push("call read_data; [Token::Loop] Stores the Value into eax".to_owned());
            result.push("cmp al, 0 ; [Token::Loop]".to_owned());
            result.push(format!("jle {} ; [Token::Loop] Jump to end", bottom_label));
            result.push(format!(
                "{}: ; [Token::Loop] Top Level label for loop",
                top_label
            ));
            for tmp_sub in sub_tokens.into_iter() {
                result.append(&mut generate(tmp_sub, unique_count));
            }
            result
                .push("call read_data ; [Token::Loop] Read the current Value into eax".to_owned());
            result.push("cmp al, 0".to_owned());
            result.push(format!(
                "jg {} ; [Token::Loop] Jump top if nonzero",
                top_label
            ));
            result.push(format!(
                "{}: ; [Token::Loop] Bottom Level label for loop",
                bottom_label
            ));

            result
        }
        _ => Vec::new(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn data_ptr() {
        assert_eq!(
            vec!["add r8d, 0x1 ; [Token::IncData]".to_owned()],
            generate(Token::IncData(1), &mut 0)
        );
        assert_eq!(
            vec!["sub r8d, 0x1 ; [Token::DecData]".to_owned()],
            generate(Token::DecData(1), &mut 0)
        );
    }
}
