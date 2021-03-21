use super::Instruction;

pub fn cleanup(instr: &mut Vec<Instruction>) {
    let mut index = 0;
    while index + 1 < instr.len() {
        let first = instr.get(index).unwrap();
        let second = instr.get(index + 1).unwrap();

        let remove_second = match (first, second) {
            (Instruction::Call(ref first_call), Instruction::Call(ref second_call))
                if first_call == "write_data" && second_call == "read_data" =>
            {
                true
            }
            (Instruction::Call(ref first_call), Instruction::Call(ref second_call))
                if first_call == "write_data" && second_call == "write_data" =>
            {
                true
            }
            (Instruction::Call(ref first_call), Instruction::Call(ref second_call))
                if first_call == "read_data" && second_call == "read_data" =>
            {
                true
            }
            (_, _) => false,
        };

        if remove_second {
            instr.remove(index + 1);
        } else {
            index += 1;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn remove() {
        let mut instructions = vec![
            Instruction::Call("read_data".to_owned()),
            Instruction::Sub("al".to_owned(), "0x1".to_owned()),
            Instruction::Call("write_data".to_owned()),
            Instruction::Call("read_data".to_owned()),
            Instruction::Cmp("al".to_owned(), "0x0".to_owned()),
        ];

        let expected = vec![
            Instruction::Call("read_data".to_owned()),
            Instruction::Sub("al".to_owned(), "0x1".to_owned()),
            Instruction::Call("write_data".to_owned()),
            Instruction::Cmp("al".to_owned(), "0x0".to_owned()),
        ];

        cleanup(&mut instructions);

        assert_eq!(expected, instructions);
    }
    #[test]
    fn remove_double() {
        let mut instructions = vec![
            Instruction::Call("read_data".to_owned()),
            Instruction::Sub("al".to_owned(), "0x1".to_owned()),
            Instruction::Call("write_data".to_owned()),
            Instruction::Call("write_data".to_owned()),
        ];

        let expected = vec![
            Instruction::Call("read_data".to_owned()),
            Instruction::Sub("al".to_owned(), "0x1".to_owned()),
            Instruction::Call("write_data".to_owned()),
        ];

        cleanup(&mut instructions);

        assert_eq!(expected, instructions);
    }

    #[test]
    fn dont_remove() {
        let mut instructions = vec![
            Instruction::Call("read_data".to_owned()),
            Instruction::Sub("al".to_owned(), "0x1".to_owned()),
            Instruction::Call("write_data".to_owned()),
            Instruction::Call("print_data".to_owned()),
        ];

        let expected = vec![
            Instruction::Call("read_data".to_owned()),
            Instruction::Sub("al".to_owned(), "0x1".to_owned()),
            Instruction::Call("write_data".to_owned()),
            Instruction::Call("print_data".to_owned()),
        ];

        cleanup(&mut instructions);

        assert_eq!(expected, instructions);
    }
}
