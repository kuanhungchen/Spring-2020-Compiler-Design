# Part2: Syntax Analyzer (Parser)
A [Yacc](http://dinosaur.compilertools.net/yacc/)-based syntax analyzer to generate syntax tree.

## Supported features

- Scalar Declaration
  - Supports initialization
- Array Declaration
  - Supports initialization
  - Supports multi-dimensional
- const Declaration
- Function Declaration
- Function Definition
- Expression
  - Supports precedence and associativity
  - Supports operators: "+", "-", "*", "/", "%", "++", "--", "<", "<=", ">", ">=", "==", "!=", "=", "&&", "||", "!", "&", "|"  
  - Also includes: function invocation, array subscription, assignment
- Statement
  - Expression Statement
  - IF / IF-ELSE Statement (no ElSE-IF)
  - SWITCH Statement
  - WHILE Statement (includes DO-WHILE)
  - FOR Statement
  - RETURN, BREAK, CONTINUE Statement
  - Compound Statement
