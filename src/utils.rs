use std::fs::File;
use std::io::Read;
use std::vec;
use tree_sitter;
use lazy_static::lazy_static;
use std::sync::Mutex;

use crate::model::*;

//source file code
lazy_static! {
    static ref SOURCE_FILE_MUTEX: Mutex<String> = Mutex::new("".to_string());
}

#[allow(dead_code)]
pub fn print_all_node_kind(node: &tree_sitter::Node) {
    println!("{} node: {}-{}, {}/{} children",node.kind(),node.start_byte(),node.end_byte(),
    node.named_child_count(),node.child_count());
    let children = get_children(node);
    for child in children {
        print_all_node_kind(&child);
    }
}

//Read and parse minizinc file
pub fn parse_minizinc_file(file_path: &str) -> tree_sitter::Tree {
    let mut file = File::open(&file_path).expect("Error opening file");
    let mut code = String::new();
    file.read_to_string(&mut code).expect("Error reading file");
    let mut source_file_lock = SOURCE_FILE_MUTEX.lock().unwrap();
    *source_file_lock = code.clone();

    let mut parser = tree_sitter::Parser::new();
    parser.set_language(&minizinc_compile::language()).expect("Error loading Minizinc grammar");
    let tree = parser.parse(code, None).unwrap();
    tree
}

//retrive all the children of the node
fn get_children<'a>(node: &'a tree_sitter::Node) -> Vec<tree_sitter::Node<'a>> {
    let children_cnt = node.child_count();
    let mut children: Vec<tree_sitter::Node> = Vec::new();
    for i in 0..children_cnt {
        let child = node.child(i).unwrap();
        children.push(child);
    }
    return children;
}
fn get_named_children<'a>(node: &'a tree_sitter::Node) -> Vec<tree_sitter::Node<'a>> {
    let children_cnt = node.named_child_count();
    let mut children: Vec<tree_sitter::Node> = Vec::new();
    for i in 0..children_cnt {
        let child = node.named_child(i).unwrap();
        children.push(child);
    }
    return children;
}

pub fn visit_source_file(node: &tree_sitter::Node) -> Model {
    let mut model = Model {
        vars: vec![],
        constraints: vec![],
        task: Task::Sat
    };
    let children = get_children(node);
    for child in children {
        match child.kind() {
            "declaration" => {
                let (ty, name, assign) = visit_declaration(&child);
                model.vars.push((ty, name, assign));
            },
            "constraint" => {
                model.constraints.push(visit_expr(&child.child(1).unwrap()));
            },
            "goal" => {
                model.task = visit_task(&child);
            },
            "line_comment" => {}
            "output" => {} //ignore
            _ => { 
                if child.is_named(){
                    println!("Unsolved item :{}",child.kind());
                }
            }
        }
    }
    return model;
}

fn visit_declaration(node: &tree_sitter::Node) -> (Type, String, String) {
    let type_child = node.child_by_field_name("type").unwrap();
    let ty = visit_type(&type_child);

    let name_child = node.child_by_field_name("name").unwrap();
    let name = visit_id(&name_child);

    let assign_child = node.child_by_field_name("expr");
    if assign_child.is_some() {     // var name = expr
        let assign = visit_id(&assign_child.unwrap());
        return (ty, name, assign);
    }
    return (ty, name, "".to_string());  // var name
}

fn visit_task(node: &tree_sitter::Node) -> Task {
    let task = Task::Sat;
    let mut find_min = false; // if it's a minimize task
    let children = get_children(node);

    for child in children {
        match child.kind() {
            "solve" => {}
            "maximize" => { // solve maximize expr
                find_min = false;
            },
            "minimize" => { // solve minimize expr
                find_min = true;
            },
            "satisfy" => { // solve satisfy
                return Task::Sat;
            },
            _ => { // expr
                let expr = visit_expr(&child);
                if find_min { // maximize (- expr)
                    return Task::Opt(Expr::Call("-".to_string(), vec![Box::new(expr)]));
                } else {
                    return Task::Opt(expr)
                }
            }
        }
    }
    return task;
}

fn visit_id(node: &tree_sitter::Node) -> String {
    let source_file = SOURCE_FILE_MUTEX.lock().unwrap();
    return node.utf8_text(source_file.as_bytes()).unwrap().to_string();
}

fn visit_type(node: &tree_sitter::Node) -> Type {
    let ty = match node.kind() {
        "type_base" => { // var Type
            let basic_type = visit_base_type(&node.named_child(0).unwrap());
            for child in get_children(&node) {
                match child.kind() {
                    "var" => {
                        return Type::Var(basic_type);
                    },
                    "par" => {
                        return Type::Par(basic_type);
                    },
                    _ => {} // opt set ... ignored
                }
            }
            Type::Par(basic_type) //default par
        },
        "array_type" => { // array[Type1, Type2, ...] of Type
            let children = get_named_children(&node);
            let mut types: Vec<Box<Type>> = Vec::new();
            for i in 0..children.len()-1 {
                types.push(Box::new(visit_type(&children[i])));
            }
            let ty = visit_type(&children[children.len()-1]);
            Type::Array(types, Box::new(ty))
        },
        _ => {
            println!("Unknown type: {}", node.kind());
            Type::Var(BasicType::Int(IntType::Base))
        }
    };
    return ty;
}

fn visit_base_type(node: &tree_sitter::Node) -> BasicType {
    let kind = node.kind();
    if kind == "primitive_type" { //int, bool
        let basic_type = match visit_id(&node).as_str() {
            "int" => BasicType::Int(IntType::Base),
            "bool" => BasicType::Bool,
            _ => { // float, string, ...
                println!("Unknown basic type: {}", visit_id(&node));
                BasicType::Int(IntType::Base)
            }
        };
        return basic_type;
    } else if kind=="infix_operator" { // 1..10
        let left = visit_expr(&node.child_by_field_name("left").unwrap());
        let right = visit_expr(&node.child_by_field_name("right").unwrap());
        return BasicType::Int(IntType::Range(left, right))
    }else {
        println!("Unknown base type: {}", node.kind());
        return BasicType::Int(IntType::Base);
    }
}

fn visit_expr(node: &tree_sitter::Node) -> Expr {
    let expr = match node.kind() {
        "integer_literal" => {
            Expr::Int(visit_id(&node).parse::<i32>().unwrap())
        },
        "true" => {
            Expr::True
        },
        "false" => {
            Expr::False
        },
        "identifier" => {
            Expr::Var(visit_id(&node))
        },
        "if_then_else" => { // if expr1 then expr2 else expr3
            if node.named_child_count() != 3 {
                print!("Error: if_then_else node should have 3 children");
                return Expr::Int(0);
            }
            let cond = Box::new(visit_expr(&node.named_child(0).unwrap()));
            let then_expr = Box::new(visit_expr(&node.named_child(1).unwrap()));
            let else_expr = Box::new(visit_expr(&node.named_child(2).unwrap()));
            Expr::If(cond, then_expr, else_expr)
        },
        "call" => {
            let name = visit_id(&node.child_by_field_name("name").unwrap());
            let mut args: Vec<Box<Expr>> = Vec::new();
            let mut cursor = node.walk();
            let children = node.children_by_field_name("arguments", &mut cursor);
            for child in children {
                if child.kind() == "," {
                    continue;
                }
                args.push(Box::new(visit_expr(&child)));
            }
            Expr::Call(name, args)
        },
        "generator_call" => {
            let gen_name = visit_id(&node.child_by_field_name("name").unwrap()); // forall, exists
            let mut generators = GenExpr::Empty;
            let mut cursor = node.walk();
            let children = node.children_by_field_name("generators", &mut cursor);
            for child in children {
                if child.kind() == "," {
                    continue;
                }
                let gen_expr = visit_gen_expr(&child);
                generators = merge_gen_expr(generators, gen_expr);
            }
            let expr=visit_expr(&node.child_by_field_name("template").unwrap());
            Expr::Call(gen_name, vec![Box::new(Expr::Comprehension(generators, Box::new(expr)))])
        },
        "infix_operator" => { // expr1 + expr2
            let left = Box::new(visit_expr(&node.child_by_field_name("left").unwrap()));
            let right = Box::new(visit_expr(&node.child_by_field_name("right").unwrap()));
            let op = visit_id(&node.child_by_field_name("operator").unwrap());
            Expr::Call(op, vec![left, right])
        },
        "prefix_operator" => { // -expr
            let expr = Box::new(visit_expr(&node.child(1).unwrap()));
            let op = visit_id(&node.child_by_field_name("operator").unwrap());
            Expr::Call(op, vec![expr])
        },
        "array_comprehension" => {// {expr | gen_expr} 
            let children = get_named_children(&node);
            let expr = visit_expr(&children[0]);
            let mut gen_expr = GenExpr::Empty;
            for i in 1..children.len() {
                let tmp_gen_expr = visit_gen_expr(&children[i]);
                gen_expr = merge_gen_expr(gen_expr, tmp_gen_expr)
            }
            Expr::Comprehension(gen_expr, Box::new(expr))
        },
        "indexed_access" => { // array[expr1, expr2, ...]
            let array = Box::new(visit_expr(&node.child_by_field_name("collection").unwrap()));
            let mut indices: Vec<Box<Expr>> = Vec::new();
            let mut cursor = node.walk();
            let children = node.children_by_field_name("indices", &mut cursor);
            for child in children {
                if child.kind() == "," {
                    continue;
                }
                indices.push(Box::new(visit_expr(&child)));
            }
            Expr::ArrayAccess(array, indices)
        },
        "parenthesised_expression" => {
            visit_expr(&node.named_child(0).unwrap())
        },
        _ => {
            println!("Unknown expr: {}, {:?}", node.kind(),node);
            Expr::Int(0)
        }
    };
    return expr;
}

//generator expression
fn visit_gen_expr(node: &tree_sitter::Node) -> GenExpr {
    let mut gen_expr = GenExpr::Empty;
    let children = get_children(node);
    let mut var = "".to_string();
    let mut is_guard = false;// if the current expression is a guard
    for child in children {
        match child.kind() {
            "identifier" => {
                var = visit_id(&child);
            },
            "in" => {
                is_guard = false; // followed by a range or set
            }
            "where" => {
                is_guard = true; // followed by a guard
            },
            _ => {
                if is_guard {
                    gen_expr = GenExpr::Guard(Box::new(gen_expr), Box::new(visit_expr(&child)));
                } else {
                    gen_expr = GenExpr::Enum(Box::new(gen_expr), var.clone(), Box::new(visit_expr(&child)));
                }
            }
        }
    }
    return gen_expr;
}

fn merge_gen_expr(gen_expr1: GenExpr, gen_expr2: GenExpr) -> GenExpr {
    match gen_expr2 {
        GenExpr::Empty => gen_expr1,
        GenExpr::Enum(g, s, e) => {
            GenExpr::Enum(Box::new(merge_gen_expr(*g, gen_expr1)), s, e)
        },
        GenExpr::Guard(g, e) => {
            GenExpr::Guard(Box::new(merge_gen_expr(*g, gen_expr1)), e)
        }
    }
}