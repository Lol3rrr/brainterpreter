use crate::{
    core::{
        traits::{Input, Output},
        Command, ExecutionResult,
    },
    util,
};

pub fn execute<I, O>(commands: Vec<Command>, mut input: I, mut output: O)
where
    I: Input,
    O: Output,
{
    let mut instruction_ptr = 0;
    let mut data_ptr = 0;
    let mut data: Vec<u8> = Vec::new();
    loop {
        let cmd = match commands.get(instruction_ptr) {
            Some(c) => c,
            None => {
                break;
            }
        };

        match cmd.execute(&mut data_ptr, &mut data, &mut input, &mut output) {
            ExecutionResult::ExecuteNext => {
                instruction_ptr += 1;
            }
            ExecutionResult::JumpEndOfBlock => {
                if let Some(end_index) = util::find_end_block(&commands, instruction_ptr) {
                    instruction_ptr = end_index;
                }
                instruction_ptr += 1;
            }
            ExecutionResult::JumpStartOfBlock => {
                if let Some(start_index) = util::find_start_block(&commands, instruction_ptr) {
                    instruction_ptr = start_index;
                }
                instruction_ptr += 1;
            }
        }
    }
}
