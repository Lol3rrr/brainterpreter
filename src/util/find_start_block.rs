use crate::core::Command;

pub fn find_start_block(cmds: &[Command], current: usize) -> Option<usize> {
    let mut index = current - 1;

    let mut inner_block_count = 0;
    loop {
        match &cmds[index] {
            Command::EndBlock => {
                inner_block_count += 1;
            }
            Command::StartBlock if inner_block_count > 0 => {
                inner_block_count -= 1;
            }
            Command::StartBlock if inner_block_count == 0 => return Some(index),
            _ => {}
        };

        match index.checked_sub(1) {
            Some(n) => index = n,
            None => return None,
        }
    }
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
        let current = cmds.len() - 1;

        assert_eq!(Some(0), find_start_block(&cmds, current));
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
        let current = cmds.len() - 1;

        assert_eq!(Some(0), find_start_block(&cmds, current));
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
        let current = cmds.len() - 2;

        assert_eq!(Some(2), find_start_block(&cmds, current));
    }

    #[test]
    fn no_start() {
        let cmds = vec![Command::IncValue, Command::DecValue, Command::EndBlock];
        let current = cmds.len() - 1;

        assert_eq!(None, find_start_block(&cmds, current));
    }
}
