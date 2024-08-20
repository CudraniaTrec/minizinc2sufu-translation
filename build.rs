fn main() {
    let src_dir = std::path::Path::new("tree-sitter-minizinc/src");
    let parser_path = src_dir.join("parser.c");

    let mut c_config = cc::Build::new();
    c_config.std("c11").include(src_dir);
    c_config.file(&parser_path);
    println!("cargo:rerun-if-changed={}", parser_path.to_str().unwrap());
    c_config.compile("tree-sitter-minizinc");
}
