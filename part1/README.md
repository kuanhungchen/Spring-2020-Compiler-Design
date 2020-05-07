# Part1: Lexical Analyzer (Scanner)

- Use Lex tool to generate tokens from source code.
- Support subset of C language.
- DONE:
  - Keywords: void, const, NULL, for, do, while, break, continue, if, else, return, struct, switch, case, default
  - Primitive types: int, double, float, char
  - Library functions in [here](https://www.tutorialspoint.com/c_standard_library/stdio_h.htm)
  - Identifiers: follow the standard C variable naming rule
  - Operators: + - * / % ++ -- < <= > >= == != = && || ! & |
  - Punctuation characters: : ; , . [ ] ( ) { }
