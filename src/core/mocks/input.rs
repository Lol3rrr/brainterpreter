use crate::core::traits::Input;

pub struct MockInput {
    data: Vec<u8>,
}

impl MockInput {
    pub fn new(data: Vec<u8>) -> Self {
        Self { data }
    }

    pub fn add_data(&mut self, data: u8) {
        self.data.push(data);
    }
}

impl Input for MockInput {
    fn get_input(&mut self) -> Option<u8> {
        if self.data.len() == 0 {
            return None;
        }

        Some(self.data.remove(0))
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn valid_read() {
        let mut input = MockInput::new(vec![0, 1, 2]);

        assert_eq!(Some(0), input.get_input());
        assert_eq!(Some(1), input.get_input());
        assert_eq!(Some(2), input.get_input());
        assert_eq!(None, input.get_input());
    }

    #[test]
    fn valid_add() {
        let mut input = MockInput::new(vec![0]);

        input.add_data(1);

        assert_eq!(Some(0), input.get_input());
        assert_eq!(Some(1), input.get_input());
        assert_eq!(None, input.get_input());
    }
}
