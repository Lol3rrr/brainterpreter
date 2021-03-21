use super::lexer::Token;

mod const_prop;
mod remove_dead;

pub fn optimize(root: &mut Token) {
    if let Token::Root(tokens) = root {
        const_prop::constant_combiner(tokens);
        remove_dead::remove_dead(tokens);
    }
}
