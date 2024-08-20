## 结构

- `src/main.rs` : 主文件，运行翻译流程
- `src/model.rs` : 定义minizinc语言的rust模型
- `src/utils.rs` : parser相关的函数
---
- `benchmarks_methyl` : methyl数据集
- `benchmarks_synmem` : synmem数据集
---
- `tree-sitter-minizinc` : minizinc语言的tree-sitter parser generator。其中语法定义为`tree-sitter-minizinc/grammar.js`，parser已经被编译好为`tree-sitter-minizinc/src/parser.c`，这个文件可以被rust直接调用
- `run.py` : 用python简单调用minizinc parser

## 运行环境
1. gcc (编译`parser.c`)
2. rust/cargo 
    - `cargo run`运行主程序
    - `cargo test -- --nocapture`运行测试
3. node(如果要重新从grammar.js编译得到parser.c的话)