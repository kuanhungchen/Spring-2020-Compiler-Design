# Part1: Lexical Analyzer (Scanner)
A [Lex](http://dinosaur.compilertools.net/lex/)-based lexical analyzer to generate tokens from source code.

## Supported inputs

**Keywords:**  
"void", "const", "NULL", "for", "do", "while", "break", "continue", "if", "else", "return", "struct", "switch", "case", "default"

**Primitive types:**  
"int", "double", "float", "char"

**Library functions:**  
Names of library functions in [here](https://www.tutorialspoint.com/c_standard_library/stdio_h.htm).

**Identifiers:**  
Follow the standard C variable naming rule.

**Operators:**  
"+" ,"-" ,"*" ,"/", "%", "++", "--", "<", "<=", ">", ">=", "==", "!=", "=", "&&", "||", "!", "&", "|"

**Punctuation characters:**  
":", ";", ",", ".", "[", "]", "(", ")", "{", "}"

**Integer/Floating point constants:**  
E.g. 0, -0, 1, 123, 0.0, 0.123, 12.34, -0.0, -0.12

**String/Character constants:**  
E.g. "This is a string", 'a', '\t', '\0'

**C Comments:**  
Both //... and /\*.../\* are supported.
