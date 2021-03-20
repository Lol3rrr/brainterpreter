use crate::core::traits::Output;

pub struct LogOutput {}

impl LogOutput {
    pub fn new() -> Self {
        Self {}
    }
}

impl Output for LogOutput {
    fn output(&mut self, byte: u8) {
        print!("{}", byte as char);
    }
}
