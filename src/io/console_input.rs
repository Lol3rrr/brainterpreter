use crate::core::traits::Input;

use std::io::{stdin, Read};

pub struct ConsoleInput {}

impl ConsoleInput {
    pub fn new() -> Self {
        Self {}
    }
}

impl Input for ConsoleInput {
    fn get_input(&mut self) -> Option<u8> {
        println!("Please Enter something:");

        let mut buf = [0u8];
        match stdin().read_exact(&mut buf) {
            Ok(_) => Some(buf[0]),
            Err(_) => None,
        }
    }
}
