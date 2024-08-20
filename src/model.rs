
// Types
#[derive(Clone, PartialEq, Debug)]
pub enum Type {
    Var(BasicType), // var type     
    Par(BasicType), // par type   
    Array(Vec<Box<Type>>, Box<Type>) // array[Type1, Type2, ...] of Type
}
#[derive(Clone, PartialEq, Debug)]
pub enum BasicType {     
    Int(IntType), 
    Bool 
}
#[derive(Clone, PartialEq, Debug)]
pub enum IntType {     
    Base, //i32
    Range(Expr, Expr) //1..10
}

// Expressions 
#[derive(Clone, PartialEq, Debug)]
pub enum Expr {
  Var(String),
  True, False, 
  Int(i32), 
  If(Box<Expr>, Box<Expr>, Box<Expr>),   // if expr1 then expr2 else expr3
  Call(String, Vec<Box<Expr>>),          // func(expr1, expr2, ...)
  Comprehension(GenExpr, Box<Expr>),     // {expr | genexpr}
  ArrayAccess(Box<Expr>, Vec<Box<Expr>>) // expr[expr1, expr2, ...]

  // forall can be regarded as a built-in operator + a list comprehension 
  // e.g., forall(i in 1..2)(i > 0) can be regarded as forall([i > 0 | i in 1..2]),
  // which can be represented as Call("forall", Comprehension(/*i in 1..2*/, /*i > 0*/))
}
#[derive(Clone, PartialEq, Debug)]
pub enum GenExpr {
  Empty,
  Enum(Box<GenExpr>, String, Box<Expr>), // ... , i in expr
  Guard(Box<GenExpr>, Box<Expr>) // ... , where expr
}

// The whole program 
#[derive(Clone, PartialEq, Debug)]
pub struct Model {
    pub vars: Vec<(Type,String,String)>,   //type : var; ...
    pub constraints: Vec<Expr>,   //constraint expr1; constraint expr2; ...
    pub task: Task //solve ...
}
#[derive(Clone, PartialEq, Debug)]
pub enum Task {
    Opt(Expr), //solve maximize expr
    Sat //solve satisfy
}

//implement output function for the model
static INFIX_OPERATOR : [&str; 14] = ["+", "-", "*", "/", "<", "<=", ">", ">=", "==", "!=", "..", "=", "/\\", "\\/"];

impl std::fmt::Display for Model {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        let mut s = String::new();
        for (t, v, assign) in &self.vars {
            if assign == "" {
                s.push_str(&format!("{} : {};\n", t, v));
            } else {
                s.push_str(&format!("{} : {} = {};\n", t, v, assign));
            }
        }
        for c in &self.constraints {
            s.push_str(&format!("constraint {};\n", c));
        }
        match &self.task {
            Task::Opt(e) => s.push_str(&format!("solve maximize {};", e)),
            Task::Sat => s.push_str("solve satisfy;")
        }
        write!(f, "{}", s)
    }
}

impl std::fmt::Display for Type {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        match self {
            Type::Var(t) => write!(f, "var {}", t),
            Type::Par(t) => write!(f, "{}", t),
            Type::Array(ts, t) => {
                let mut s = String::new();
                for t in ts {
                    s.push_str(&format!("{}, ", t));
                }
                // remove the last ", "
                s.pop(); s.pop();
                write!(f, "array[{}] of {}", s, t)
            }
        }
    }
}

impl std::fmt::Display for BasicType {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        match self {
            BasicType::Int(t) => write!(f, "{}", t),
            BasicType::Bool => write!(f, "bool")
        }
    }
}

impl std::fmt::Display for IntType {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        match self {
            IntType::Base => write!(f, "int"),
            IntType::Range(e1, e2) => write!(f, "{}..{}", e1, e2)
        }
    }
}

impl std::fmt::Display for Expr {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        match self {
            Expr::Var(v) => write!(f, "{}", v),
            Expr::True => write!(f, "true"),
            Expr::False => write!(f, "false"),
            Expr::Int(i) => write!(f, "{}", i),
            Expr::If(e1, e2, e3) => write!(f, "if {} then {} else {} endif", e1, e2, e3),
            Expr::Call(s, es) => {
                let mut args = String::new();
                for e in es {
                    args.push_str(&format!("{}, ", e));
                }
                // remove the last ", "
                args.pop(); args.pop();
                if INFIX_OPERATOR.contains(&s.as_str()) && es.len() == 2 {
                    write!(f, "{} {} {}", es[0], s, es[1])
                } else {
                    match &*es[0] {
                        Expr::Comprehension(g, e) => {
                            let mut gen_string = format!("{}", g);
                            gen_string.pop(); gen_string.pop(); // remove the last ", "
                            write!(f, "{} ({})({})", s, gen_string, e)
                        },
                        _ => write!(f, "{}({})", s, args)
                    }
                }
            },
            Expr::Comprehension(g, e) => {
                let mut gen_expr = format!("{}", g);
                gen_expr.pop(); gen_expr.pop(); // remove the last ", "
                write!(f, "[{} | {}]", e, gen_expr)
            },
            Expr::ArrayAccess(e, es) => {
                let mut s = String::new();
                for e in es {
                    s.push_str(&format!("{}, ", e));
                }
                // remove the last ", "
                s.pop(); s.pop();
                write!(f, "{}[{}]", e, s)
            }
        }
    }
}

impl std::fmt::Display for GenExpr {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        match self {
            GenExpr::Empty => write!(f, ""),
            GenExpr::Enum(g, s, e) => write!(f, "{}{} in {}, ", g, s, e),
            GenExpr::Guard(g, e) => write!(f, "{}where {}, ", g, e)
        }
    }
}