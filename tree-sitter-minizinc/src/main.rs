fn main() {
    println!("Hello, world!");
    let code = r#"int: n;
array[1..n] of int: value;

array[1..n] of var 0..1: prefix;
array[1..n] of var 0..1: suffix;
array[1..n] of var 0..1: choose;

constraint forall(i in 1..n)(sum(j in 1..i)(choose[j]*value[j]) >= 0);

n=3;
value=[1,1,-1];

solve maximize sum(i in 1..n)(choose[i]);
"#;
    let mut parser = tree_sitter::Parser::new();
    parser.set_language(&tree_sitter_minizinc::language()).expect("Error loading Minizinc grammar");
    let tree = parser.parse(code, None).unwrap();
    println!("{}", tree.root_node().to_sexp());
}