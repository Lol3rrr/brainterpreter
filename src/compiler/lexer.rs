use crate::core::Command;

#[derive(Debug, PartialEq, Clone)]
pub enum Token {
    Root(Vec<Token>),
    Loop(Vec<Token>),
    IncData(usize),
    DecData(usize),
    IncValue(usize),
    DecValue(usize),
    Output,
    Input,
    Noop,
}

fn parse_tokens<I>(cmds: &mut I) -> Vec<Token>
where
    I: Iterator<Item = Command>,
{
    let mut result = Vec::new();

    while let Some(cmd) = cmds.next() {
        let tmp = match cmd {
            Command::IncValue => Token::IncValue(1),
            Command::DecValue => Token::DecValue(1),
            Command::IncDataPtr => Token::IncData(1),
            Command::DecDataPtr => Token::DecData(1),
            Command::Input => Token::Input,
            Command::Output => Token::Output,
            Command::StartBlock => {
                let entries = parse_tokens(cmds);
                Token::Loop(entries)
            }
            Command::EndBlock => {
                return result;
            }
        };

        result.push(tmp);
    }

    result
}
pub fn parse<I>(mut commands: I) -> Token
where
    I: Iterator<Item = Command>,
{
    Token::Root(parse_tokens(&mut commands))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn no_loop() {
        // The inner part of the loop for the first example
        // https://en.wikipedia.org/wiki/Brainfuck#Examples

        let inputs = vec![
            Command::DecValue,
            Command::IncDataPtr,
            Command::IncValue,
            Command::DecDataPtr,
        ];
        let expected = Token::Root(vec![
            Token::DecValue(1),
            Token::IncData(1),
            Token::IncValue(1),
            Token::DecData(1),
        ]);

        assert_eq!(expected, parse(inputs.into_iter()));
    }

    #[test]
    fn one_loop() {
        // The first example
        // https://en.wikipedia.org/wiki/Brainfuck#Examples

        let inputs = vec![
            Command::StartBlock,
            Command::DecValue,
            Command::IncDataPtr,
            Command::IncValue,
            Command::DecDataPtr,
            Command::EndBlock,
        ];
        let expected = Token::Root(vec![Token::Loop(vec![
            Token::DecValue(1),
            Token::IncData(1),
            Token::IncValue(1),
            Token::DecData(1),
        ])]);

        assert_eq!(expected, parse(inputs.into_iter()));
    }
}
