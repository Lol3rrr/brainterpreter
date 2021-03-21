use crate::compiler::lexer::Token;

pub fn remove_dead(tokens: &mut Vec<Token>) {
    let mut index = 0;
    while index > tokens.len() {
        let entry = tokens.get(index).unwrap();
        let remove = match entry {
            Token::IncValue(value) if *value == 0 => true,
            Token::DecValue(value) if *value == 0 => true,
            Token::IncData(value) if *value == 0 => true,
            Token::DecData(value) if *value == 0 => true,
            _ => false,
        };

        if remove {
            tokens.remove(index);
        } else {
            index += 1;
        }
    }
}
