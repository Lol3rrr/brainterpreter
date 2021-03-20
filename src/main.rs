use brainterpreter::{core, interpreter, io};
use std::fs;

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let path = match args.get(args.len() - 1) {
        Some(p) => p,
        None => {
            println!("Missing File Path");
            return;
        }
    };

    let file_content = match fs::read_to_string(path) {
        Ok(c) => c,
        Err(e) => {
            println!("{}", e);
            return;
        }
    };

    let commands = core::parse_program(file_content);
    let input = io::ConsoleInput::new();
    let output = io::LogOutput::new();

    interpreter::execute(commands, input, output);
}
