use crate::core::Command;

pub fn find_end_block(cmds: &[Command], current: usize) -> Option<usize> {
    let mut index = current + 1;
    let mut inner_block_count = 0;

    while index < cmds.len() {
        match &cmds[index] {
            Command::StartBlock => {
                inner_block_count += 1;
            }
            Command::EndBlock if inner_block_count > 0 => {
                inner_block_count -= 1;
            }
            Command::EndBlock if inner_block_count == 0 => return Some(index),
            _ => {}
        };

        index += 1;
    }

    None
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn simple() {
        let cmds = vec![
            Command::StartBlock,
            Command::IncValue,
            Command::DecValue,
            Command::EndBlock,
        ];
        let current = 0;

        assert_eq!(Some(cmds.len() - 1), find_end_block(&cmds, current));
    }
    #[test]
    fn with_other_inner() {
        let cmds = vec![
            Command::StartBlock,
            Command::IncValue,
            Command::StartBlock,
            Command::DecDataPtr,
            Command::EndBlock,
            Command::DecValue,
            Command::EndBlock,
        ];
        let current = 0;

        assert_eq!(Some(cmds.len() - 1), find_end_block(&cmds, current));
    }
    #[test]
    fn with_other_outer() {
        let cmds = vec![
            Command::StartBlock,
            Command::DecDataPtr,
            Command::StartBlock,
            Command::IncValue,
            Command::DecValue,
            Command::EndBlock,
            Command::EndBlock,
        ];
        let current = 2;

        assert_eq!(Some(cmds.len() - 2), find_end_block(&cmds, current));
    }

    #[test]
    fn no_start() {
        let cmds = vec![Command::StartBlock, Command::IncValue, Command::DecValue];
        let current = 0;

        assert_eq!(None, find_end_block(&cmds, current));
    }
}
