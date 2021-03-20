use crate::core::traits::Output;

pub struct MockOutput {
    pub data: Vec<u8>,
}

impl MockOutput {
    pub fn new() -> Self {
        Self { data: Vec::new() }
    }
}

impl Output for MockOutput {
    fn output(&mut self, byte: u8) {
        self.data.push(byte);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn basic() {
        let mut output = MockOutput::new();

        assert_eq!(Vec::<u8>::new(), output.data);

        output.output(12);

        assert_eq!(vec![12u8], output.data);
    }
}
