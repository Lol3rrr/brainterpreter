use crate::compiler;
use crate::core::Command;

pub fn compile<W>(cmds: Vec<Command>, output: &mut W)
where
    W: std::io::Write,
{
    let mut ir = compiler::lexer::parse(cmds.into_iter());

    compiler::optimizer::optimize(&mut ir);

    let final_assembly = compiler::generator::generate(ir);
    if let Err(e) = output.write_all(final_assembly.as_bytes()) {
        println!("Error Writing final Assembly: {}", e);
    }
}
