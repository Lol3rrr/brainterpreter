use crate::core::traits::{Input, Output};

#[derive(Debug, PartialEq)]
pub enum ExecutionResult {
    ExecuteNext,
    JumpEndOfBlock,
    JumpStartOfBlock,
}

#[derive(Debug, PartialEq, Clone)]
pub enum Command {
    IncDataPtr,
    DecDataPtr,
    IncValue,
    DecValue,
    Output,
    Input,
    StartBlock,
    EndBlock,
}

impl Command {
    pub fn parse(byte: u8) -> Option<Self> {
        match byte {
            b'>' => Some(Command::IncDataPtr),
            b'<' => Some(Command::DecDataPtr),
            b'+' => Some(Command::IncValue),
            b'-' => Some(Command::DecValue),
            b'.' => Some(Command::Output),
            b',' => Some(Command::Input),
            b'[' => Some(Command::StartBlock),
            b']' => Some(Command::EndBlock),
            _ => None,
        }
    }

    pub fn execute<I, O>(
        &self,
        data_ptr: &mut usize,
        data: &mut Vec<u8>,
        input: &mut I,
        output: &mut O,
    ) -> ExecutionResult
    where
        I: Input,
        O: Output,
    {
        match self {
            Self::IncDataPtr => {
                *data_ptr += 1;
                ExecutionResult::ExecuteNext
            }
            Self::DecDataPtr => {
                *data_ptr -= 1;
                ExecutionResult::ExecuteNext
            }
            Self::IncValue => {
                match data.get_mut(*data_ptr) {
                    Some(entry) => {
                        *entry = entry.saturating_add(1);
                    }
                    None => {
                        data.resize(*data_ptr + 1, 0);

                        let entry = data.get_mut(*data_ptr).unwrap();
                        *entry = entry.saturating_add(1);
                    }
                };

                ExecutionResult::ExecuteNext
            }
            Self::DecValue => {
                match data.get_mut(*data_ptr) {
                    Some(entry) => {
                        *entry = entry.saturating_sub(1);
                    }
                    None => {
                        data.resize(*data_ptr + 1, 0);

                        let entry = data.get_mut(*data_ptr).unwrap();
                        *entry = entry.saturating_sub(1);
                    }
                };

                ExecutionResult::ExecuteNext
            }
            Self::Output => {
                let data = match data.get(*data_ptr) {
                    Some(d) => *d,
                    None => 0,
                };

                output.output(data);

                ExecutionResult::ExecuteNext
            }
            Self::Input => {
                let in_data = match input.get_input() {
                    Some(d) => d,
                    None => 0,
                };

                match data.get_mut(*data_ptr) {
                    Some(entry) => {
                        *entry = in_data;
                    }
                    None => {
                        data.resize(*data_ptr + 1, 0);

                        let entry = data.get_mut(*data_ptr).unwrap();
                        *entry = in_data;
                    }
                };

                ExecutionResult::ExecuteNext
            }
            Self::StartBlock => {
                let entry = match data.get(*data_ptr) {
                    Some(d) => *d,
                    None => 0,
                };

                if entry == 0 {
                    ExecutionResult::JumpEndOfBlock
                } else {
                    ExecutionResult::ExecuteNext
                }
            }
            Self::EndBlock => {
                let entry = match data.get(*data_ptr) {
                    Some(d) => *d,
                    None => 0,
                };

                if entry != 0 {
                    ExecutionResult::JumpStartOfBlock
                } else {
                    ExecutionResult::ExecuteNext
                }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    use crate::core::mocks::{MockInput, MockOutput};

    #[test]
    fn parse_commands() {
        assert_eq!(Some(Command::IncDataPtr), Command::parse(b'>'));
        assert_eq!(Some(Command::DecDataPtr), Command::parse(b'<'));
        assert_eq!(Some(Command::IncValue), Command::parse(b'+'));
        assert_eq!(Some(Command::DecValue), Command::parse(b'-'));
        assert_eq!(Some(Command::Output), Command::parse(b'.'));
        assert_eq!(Some(Command::Input), Command::parse(b','));
        assert_eq!(Some(Command::StartBlock), Command::parse(b'['));
        assert_eq!(Some(Command::EndBlock), Command::parse(b']'));

        assert_eq!(None, Command::parse(b's'))
    }

    #[test]
    fn increment_data_ptr() {
        let command = Command::IncDataPtr;

        let mut data_ptr = 0;
        let mut data = Vec::new();

        assert_eq!(
            ExecutionResult::ExecuteNext,
            command.execute(
                &mut data_ptr,
                &mut data,
                &mut MockInput::new(vec![]),
                &mut MockOutput::new()
            )
        );

        assert_eq!(1, data_ptr);
    }
    #[test]
    fn decrement_data_ptr() {
        let command = Command::DecDataPtr;

        let mut data_ptr = 1;
        let mut data = Vec::new();

        assert_eq!(
            ExecutionResult::ExecuteNext,
            command.execute(
                &mut data_ptr,
                &mut data,
                &mut MockInput::new(vec![]),
                &mut MockOutput::new()
            )
        );

        assert_eq!(0, data_ptr);
    }

    #[test]
    fn increment_value_exists() {
        let command = Command::IncValue;

        let mut data_ptr = 0;
        let mut data = vec![0];

        assert_eq!(
            ExecutionResult::ExecuteNext,
            command.execute(
                &mut data_ptr,
                &mut data,
                &mut MockInput::new(vec![]),
                &mut MockOutput::new()
            )
        );

        assert_eq!(vec![1], data);
    }
    #[test]
    fn increment_value_doesnt_exist() {
        let command = Command::IncValue;

        let mut data_ptr = 0;
        let mut data = vec![];

        assert_eq!(
            ExecutionResult::ExecuteNext,
            command.execute(
                &mut data_ptr,
                &mut data,
                &mut MockInput::new(vec![]),
                &mut MockOutput::new()
            )
        );

        assert_eq!(vec![1], data);
    }
    #[test]
    fn decrement_value_exists() {
        let command = Command::DecValue;

        let mut data_ptr = 0;
        let mut data = vec![1];

        assert_eq!(
            ExecutionResult::ExecuteNext,
            command.execute(
                &mut data_ptr,
                &mut data,
                &mut MockInput::new(vec![]),
                &mut MockOutput::new()
            )
        );

        assert_eq!(vec![0], data);
    }
    #[test]
    fn decrement_value_doesnt_exist() {
        let command = Command::DecValue;

        let mut data_ptr = 0;
        let mut data = vec![];

        assert_eq!(
            ExecutionResult::ExecuteNext,
            command.execute(
                &mut data_ptr,
                &mut data,
                &mut MockInput::new(vec![]),
                &mut MockOutput::new()
            )
        );

        assert_eq!(vec![0], data);
    }

    #[test]
    fn input_valid() {
        let command = Command::Input;
        let mut input = MockInput::new(vec![2]);

        let mut data_ptr = 0;
        let mut data = vec![];

        assert_eq!(
            ExecutionResult::ExecuteNext,
            command.execute(&mut data_ptr, &mut data, &mut input, &mut MockOutput::new())
        );

        assert_eq!(vec![2], data);
    }

    #[test]
    fn output_valid() {
        let command = Command::Output;
        let mut output = MockOutput::new();

        let mut data_ptr = 0;
        let mut data = vec![2];

        assert_eq!(
            ExecutionResult::ExecuteNext,
            command.execute(
                &mut data_ptr,
                &mut data,
                &mut MockInput::new(vec![]),
                &mut output
            )
        );

        assert_eq!(vec![2], output.data);
    }
    #[test]
    fn output_valid_doesnt_exist() {
        let command = Command::Output;
        let mut output = MockOutput::new();

        let mut data_ptr = 0;
        let mut data = vec![];

        assert_eq!(
            ExecutionResult::ExecuteNext,
            command.execute(
                &mut data_ptr,
                &mut data,
                &mut MockInput::new(vec![]),
                &mut output
            )
        );

        assert_eq!(vec![0], output.data);
    }

    #[test]
    fn start_block_no_jump() {
        let command = Command::StartBlock;

        let mut data_ptr = 0;
        let mut data = vec![1];

        assert_eq!(
            ExecutionResult::ExecuteNext,
            command.execute(
                &mut data_ptr,
                &mut data,
                &mut MockInput::new(vec![]),
                &mut MockOutput::new()
            )
        );
    }
    #[test]
    fn start_block_jump() {
        let command = Command::StartBlock;

        let mut data_ptr = 0;
        let mut data = vec![0];

        assert_eq!(
            ExecutionResult::JumpEndOfBlock,
            command.execute(
                &mut data_ptr,
                &mut data,
                &mut MockInput::new(vec![]),
                &mut MockOutput::new()
            )
        );
    }
    #[test]
    fn start_block_jump_doesnt_exist() {
        let command = Command::StartBlock;

        let mut data_ptr = 0;
        let mut data = vec![];

        assert_eq!(
            ExecutionResult::JumpEndOfBlock,
            command.execute(
                &mut data_ptr,
                &mut data,
                &mut MockInput::new(vec![]),
                &mut MockOutput::new()
            )
        );
    }

    #[test]
    fn end_block_no_jump() {
        let command = Command::EndBlock;

        let mut data_ptr = 0;
        let mut data = vec![0];

        assert_eq!(
            ExecutionResult::ExecuteNext,
            command.execute(
                &mut data_ptr,
                &mut data,
                &mut MockInput::new(vec![]),
                &mut MockOutput::new()
            )
        );
    }
    #[test]
    fn end_block_no_jump_doesnt_exist() {
        let command = Command::EndBlock;

        let mut data_ptr = 0;
        let mut data = vec![];

        assert_eq!(
            ExecutionResult::ExecuteNext,
            command.execute(
                &mut data_ptr,
                &mut data,
                &mut MockInput::new(vec![]),
                &mut MockOutput::new()
            )
        );
    }
    #[test]
    fn end_block_jump() {
        let command = Command::EndBlock;

        let mut data_ptr = 0;
        let mut data = vec![1];

        assert_eq!(
            ExecutionResult::JumpStartOfBlock,
            command.execute(
                &mut data_ptr,
                &mut data,
                &mut MockInput::new(vec![]),
                &mut MockOutput::new()
            )
        );
    }
}
