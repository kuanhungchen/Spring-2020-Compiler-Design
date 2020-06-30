# Part3: Code Generator

A code generator based on [part1](https://github.com/kuanhungchen/Spring-2020-Compiler-Design/tree/master/part1) and [part2](https://github.com/kuanhungchen/Spring-2020-Compiler-Design/tree/master/part2).  
The code generated is targeted to Andes Corvette-F1-N25 board (see [here](http://www.andestech.com/en/products-solutions/andeshape-platforms/corvette-f1-n25/)).

## Implementation

### Symbol Table

- A table which keeps the information of symboles (e.g. scope, type, memory location, parameters, ...)
- When a symbol (variable/function) declaration is encountered, store the information of the symbol into this table
- When a symbol is accessed later, read the symbol table to find out how to access the symbol

### Stack

- A process has a stack memory allocated for it
- Program can allocate memory on stack for variables
- Program can save temporary results on stack

## Supported function

- digitalWrite(pin, value)
  - pin: an integer
  - value: 1 or 0
  - To write a HIGH/LOW signal to the specified pin on the board

- delay(ms)
  - ms: an integer
  - To sleep for the specified amount of time

## Features

### Done
  - Simple arithmetic expression
  - Simple branch (if, if-else)
  - Simple loop (while, do-while)

### TODO
  - Function call
  - Nested branch
