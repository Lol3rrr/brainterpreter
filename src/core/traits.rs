pub trait Input {
    fn get_input(&mut self) -> Option<u8>;
}

pub trait Output {
    fn output(&mut self, byte: u8);
}
