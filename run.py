from tree_sitter import Language, Parser

MINIZINC_LANGUAGE = Language('build/my-languages.so', 'minizinc')
parser = Parser()
parser.set_language(MINIZINC_LANGUAGE)


# pretty print the sexp
def format_code(code):
    formatted_code = ""
    indent_level = 0
    for i, char in enumerate(code):
        if char == " ":
            if code[i - 1] != ":":
                formatted_code += "\n" + "    " * (indent_level + 1)
            else:
                formatted_code += " "
            if code[i + 1] == "(":
                indent_level += 1
        elif char == ")":
            indent_level -= 1
            formatted_code += ")\n"
            if i + 1 < len(code) and code[i + 1] == ")":
                formatted_code += "    " * (indent_level)
        else:
            formatted_code += char
    # remove blank lines
    formatted_code = "\n".join(
        [line for line in formatted_code.split("\n") if line.strip() != ""]
    )
    return formatted_code

source_code = open("test.mzn").read().encode()
tree = parser.parse(bytes(source_code))
print(format_code(tree.root_node.sexp()))