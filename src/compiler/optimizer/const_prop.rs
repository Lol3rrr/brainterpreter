use crate::compiler::lexer::Token;

pub fn constant_combiner(tokens: &mut Vec<Token>) {
    for tmp_tokens in tokens.iter_mut() {
        if let Token::Loop(sub_tokens) | Token::Root(sub_tokens) = tmp_tokens {
            constant_combiner(sub_tokens);
        }
    }

    let mut index = 0;
    while index + 1 < tokens.len() {
        let first = tokens.get(index).unwrap();
        let second = tokens.get(index + 1).unwrap();

        let replace = match (first, second) {
            (Token::IncData(first_data), Token::IncData(second_data)) => {
                Some(Token::IncData(first_data + second_data))
            }
            (Token::DecData(first_data), Token::DecData(second_data)) => {
                Some(Token::DecData(first_data + second_data))
            }
            (Token::IncData(first_data), Token::DecData(second_data)) => {
                if first_data < second_data {
                    Some(Token::DecData(second_data - first_data))
                } else {
                    Some(Token::IncData(first_data - second_data))
                }
            }
            (Token::DecData(first_data), Token::IncData(second_data)) => {
                if first_data < second_data {
                    Some(Token::IncData(second_data - first_data))
                } else {
                    Some(Token::DecData(first_data - second_data))
                }
            }
            (Token::IncValue(first_data), Token::IncValue(second_data)) => {
                Some(Token::IncValue(first_data + second_data))
            }
            (Token::DecValue(first_data), Token::DecValue(second_data)) => {
                Some(Token::DecValue(first_data + second_data))
            }
            (Token::IncValue(first_data), Token::DecValue(second_data)) => {
                if first_data < second_data {
                    Some(Token::DecValue(second_data - first_data))
                } else {
                    Some(Token::IncValue(first_data - second_data))
                }
            }
            (Token::DecValue(first_data), Token::IncValue(second_data)) => {
                if first_data < second_data {
                    Some(Token::IncValue(second_data - first_data))
                } else {
                    Some(Token::DecValue(first_data - second_data))
                }
            }
            (_, _) => None,
        };

        if let Some(n_token) = replace {
            tokens.remove(index + 1);
            let first_mut = tokens.get_mut(index).unwrap();
            *first_mut = n_token;
        } else {
            index += 1;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn no_combination() {
        let mut tokens = vec![Token::IncData(1), Token::IncValue(1), Token::Output];
        let expected = vec![Token::IncData(1), Token::IncValue(1), Token::Output];

        constant_combiner(&mut tokens);
        assert_eq!(expected, tokens);
    }
    #[test]
    fn one_time_inc_data_combination() {
        let mut tokens = vec![Token::IncData(1), Token::IncData(1), Token::Output];
        let expected = vec![Token::IncData(2), Token::Output];

        constant_combiner(&mut tokens);
        assert_eq!(expected, tokens);
    }
    #[test]
    fn multiple_inc_data_combination() {
        let mut tokens = vec![
            Token::IncData(1),
            Token::IncData(1),
            Token::IncData(1),
            Token::IncData(1),
            Token::Output,
        ];
        let expected = vec![Token::IncData(4), Token::Output];

        constant_combiner(&mut tokens);
        assert_eq!(expected, tokens);
    }
    #[test]
    fn multiple_seperate_inc_data_combination() {
        let mut tokens = vec![
            Token::IncData(1),
            Token::IncData(1),
            Token::Output,
            Token::IncData(1),
            Token::IncData(1),
            Token::Output,
        ];
        let expected = vec![
            Token::IncData(2),
            Token::Output,
            Token::IncData(2),
            Token::Output,
        ];

        constant_combiner(&mut tokens);
        assert_eq!(expected, tokens);
    }

    #[test]
    fn mixed_inc_dec_data_combination() {
        let mut tokens = vec![Token::IncData(2), Token::DecData(1), Token::Output];
        let expected = vec![Token::IncData(1), Token::Output];

        constant_combiner(&mut tokens);
        assert_eq!(expected, tokens);
    }
    #[test]
    fn multiple_mixed_inc_dec_data_combination() {
        let mut tokens = vec![
            Token::IncData(2),
            Token::DecData(1),
            Token::DecData(3),
            Token::IncData(1),
            Token::Output,
        ];
        let expected = vec![Token::DecData(1), Token::Output];

        constant_combiner(&mut tokens);
        assert_eq!(expected, tokens);
    }
}
