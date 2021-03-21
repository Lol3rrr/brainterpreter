use brainterpreter::{compiler, core, interpreter, io};
use std::fs;

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let command = match args.get(args.len() - 2) {
        Some(c) => c,
        None => {
            println!("Missing Command");
            return;
        }
    };

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
    match command.as_str() {
        "run" => {
            let input = io::ConsoleInput::new();
            let output = io::LogOutput::new();

            interpreter::execute(commands, input, output);
        }
        "build" => {
            let mut file = std::fs::File::create("./test.asm").unwrap();
            compiler::compile(commands.clone(), &mut file);
        }
        _ => {
            println!("Unknown Command: '{}'", command);
        }
    };
}
