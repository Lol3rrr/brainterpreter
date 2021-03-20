mod command;
pub use command::{Command, ExecutionResult};

mod parser;
pub use parser::parse_program;

pub mod traits;

#[cfg(test)]
pub mod mocks;
