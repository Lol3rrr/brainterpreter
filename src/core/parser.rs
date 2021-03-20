use crate::core::Command;

pub fn parse_program<S>(content: S) -> Vec<Command>
where
    S: AsRef<str>,
{
    let mut result = Vec::new();

    for tmp_byte in content.as_ref().as_bytes().iter() {
        if let Some(cmd) = Command::parse(*tmp_byte) {
            result.push(cmd);
        }
    }

    result
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_valid() {
        let result = parse_program("> + < -");
        assert_eq!(
            vec![
                Command::IncDataPtr,
                Command::IncValue,
                Command::DecDataPtr,
                Command::DecValue
            ],
            result
        );
    }
}
