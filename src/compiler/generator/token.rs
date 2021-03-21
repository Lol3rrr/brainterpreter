use crate::compiler::asm::Instruction;
use crate::compiler::lexer::Token;

pub fn generate(tmp: Token, unique_count: &mut usize) -> Vec<Instruction> {
    match tmp {
        Token::Root(sub_tokens) => {
            let mut result = Vec::new();
            for tmp_sub in sub_tokens.into_iter() {
                result.append(&mut generate(tmp_sub, unique_count));
            }

            result
        }
        Token::IncData(value) => vec![Instruction::Add("r8d".to_owned(), format!("{:#x}", value))],
        Token::DecData(value) => vec![Instruction::Sub("r8d".to_owned(), format!("{:#x}", value))],
        Token::IncValue(value) => vec![
            Instruction::Call("read_data".to_owned()),
            Instruction::Add("al".to_owned(), format!("{:#x}", value)),
            Instruction::Call("write_data".to_owned()),
        ],
        Token::DecValue(value) => vec![
            Instruction::Call("read_data".to_owned()),
            Instruction::Sub("al".to_owned(), format!("{:#x}", value)),
            Instruction::Call("write_data".to_owned()),
        ],
        Token::Input => vec![
            Instruction::Call("print_enter_msg".to_owned()),
            Instruction::Call("read_input_data".to_owned()),
            Instruction::Call("write_data".to_owned()),
        ],
        Token::Output => vec![
            Instruction::Call("read_data".to_owned()),
            Instruction::Move("edi".to_owned(), "eax".to_owned()),
            Instruction::Call("print_data".to_owned()),
        ],
        Token::Loop(sub_tokens) => {
            let mut result = Vec::new();
            let top_label = format!("loop_top_{}", unique_count);
            let bottom_label = format!("loop_bot_{}", unique_count);
            *unique_count += 1;

            result.push(Instruction::Call("read_data".to_owned()));
            result.push(Instruction::Cmp("al".to_owned(), "0x0".to_owned()));
            result.push(Instruction::Jle(bottom_label.clone()));
            result.push(Instruction::Label(top_label.clone()));
            for tmp_sub in sub_tokens.into_iter() {
                result.append(&mut generate(tmp_sub, unique_count));
            }
            result.push(Instruction::Call("read_data".to_owned()));
            result.push(Instruction::Cmp("al".to_owned(), "0x0".to_owned()));
            result.push(Instruction::Jg(top_label));
            result.push(Instruction::Label(bottom_label));

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
            vec![Instruction::Add("r8d".to_owned(), "0x1".to_owned())],
            generate(Token::IncData(1), &mut 0)
        );
        assert_eq!(
            vec![Instruction::Sub("r8d".to_owned(), "0x1".to_owned())],
            generate(Token::DecData(1), &mut 0)
        );
    }
}
