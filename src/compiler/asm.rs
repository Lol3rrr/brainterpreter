mod cleanup;
pub use cleanup::cleanup;

#[derive(Debug, PartialEq)]
pub enum Instruction {
    Add(String, String),
    Sub(String, String),
    Move(String, String),
    Call(String),
    Cmp(String, String),
    Jle(String),
    Jg(String),
    Label(String),
}

impl Instruction {
    pub fn serialize(&self) -> String {
        match self {
            Self::Add(ref a1, ref a2) => format!("add {}, {}", a1, a2),
            Self::Sub(ref a1, ref a2) => format!("sub {}, {}", a1, a2),
            Self::Move(ref a1, ref a2) => format!("mov {}, {}", a1, a2),
            Self::Call(ref a1) => format!("call {}", a1),
            Self::Cmp(ref a1, ref a2) => format!("cmp {}, {}", a1, a2),
            Self::Jle(ref a1) => format!("jle {}", a1),
            Self::Jg(ref a1) => format!("jg {}", a1),
            Self::Label(ref a1) => format!("{}:", a1),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn serialize() {
        assert_eq!(
            "add eax, 0x01".to_owned(),
            Instruction::Add("eax".to_owned(), "0x01".to_owned()).serialize()
        );
        assert_eq!(
            "sub eax, 0x01".to_owned(),
            Instruction::Sub("eax".to_owned(), "0x01".to_owned()).serialize()
        );
        assert_eq!(
            "mov eax, 0x01".to_owned(),
            Instruction::Move("eax".to_owned(), "0x01".to_owned()).serialize()
        );
        assert_eq!(
            "call target".to_owned(),
            Instruction::Call("target".to_owned()).serialize()
        );
        assert_eq!(
            "cmp eax, 0x01".to_owned(),
            Instruction::Cmp("eax".to_owned(), "0x01".to_owned()).serialize()
        );
        assert_eq!(
            "jle target".to_owned(),
            Instruction::Jle("target".to_owned()).serialize()
        );
    }
}
