%{

#include <stdio.h>
#include <stdlib.h>
#include "code.h"

typedef char* string;
extern FILE* codegen;
extern char* yytext;
int local_var_idx = 1;

%}

%union {
    int ival;
    char* sval;
}

%token DIGITALWRITE DELAY
%token TYPE_INT TYPE_VOID IDENT INT
%token ASSIGN COMMA INT IF ELSE DO WHILE FOR RETURN
%token LESS LESS_EQUAL GREATER GREATER_EQUAL EQUAL NOT_EQUAL
%token PLUS MINUS INCREMENT DECREMENT MULTIPLE DIVIDE
%token AND OR L_BRACKET R_BRACKET L_PARENTHESIS R_PARENTHESIS EOL IDENT

%type <sval> function_declaration expression declaration param prefunction
%type <sval> IDENT primary
%type <ival> INT

%left EOL
%left ASSIGN
%left IDENT
%left COMMA
%left OR
%left AND
%left EQUAL NOT_EQUAL
%left GREATER GREATER_EQUAL LESS LESS_EQUAL
%left PLUS MINUS
%left MULTIPLY DIVIDE
%right INCREMENT DECREMENT

%start program

%%

program: functions;

functions: functions function
         | function
         ;

function: prefunction
        declarations {
            int index = look_up_symbol($1);
            for (int i = index + 1; i < cur_counter; ++i) {
                int val_idx = look_up_symbol_kw(table[i].name) + 1;
                if (table[i].scope != cur_scope) break;
                if (symbol_t[val_idx].token != INT) continue;
        
            local_var_idx = 0;
            fprintf(codegen, "  \n");
            }
        }
        statements {
            pop_up_symbol(cur_scope);
            --cur_scope;
            code_gen_at_end_of_function_body($1);
            } R_PARENTHESIS
        | prefunction statements {
            pop_up_symbol(cur_scope);
            --cur_scope;
            code_gen_at_end_of_function_body($1);
            }
        R_PARENTHESIS
        | function_declaration EOL;

prefunction: function_declaration {
            ++cur_scope;
            code_gen_func_header($1);
            set_scope_and_offset_of_param($1);
            $$ = $1;
            }
            L_PARENTHESIS;

function_declaration: type IDENT {
                        if (look_up_symbol($2) == -1)
                            $$ = install_symbol($2);
                        }
                    L_BRACKET param_list R_BRACKET {
                        $$ = $2;   
                        }
                    ;

param_list: param_list COMMA param
          | param
          ;

param: /* empty */ {}
     | type IDENT {
         $$ =  install_symbol($2);
     }
     ;

declarations: declaration
            | declarations declaration;

declaration: type IDENT {
                $$ = install_symbol($2);
            } ASSIGN expression EOL {
                int index = look_up_symbol($2);
                table[index].scope = cur_scope;
                table[index].mode = LOCAL_MODE;
                table[index].offset = local_var_idx;
                ++local_var_idx;
            }
            | type IDENT EOL {
                $$ = install_symbol($2);
                int index = look_up_symbol($2);
                table[index].scope = cur_scope;
                table[index].mode = LOCAL_MODE;
                table[index].offset = local_var_idx;
                ++local_var_idx;
            }
            ;

statements: statement
          | statements statement;

statement: IDENT ASSIGN expression EOL { // assign statement
            int index = look_up_symbol($1);
            fprintf(codegen, "  lw t0, %d(s0)\n", table[index].offset * (-4) - 48);
            fprintf(codegen, "  sw t0, -4(sp)\n");
            fprintf(codegen, "  addi sp, sp, -4\n");
            fprintf(codegen, "  \n");        
        }
        | DIGITALWRITE L_BRACKET INT COMMA INT R_BRACKET EOL{
            fprintf(codegen, "  li t0, %d\n", $5);
            fprintf(codegen, "  sw t0, -4(sp)\n");
            fprintf(codegen, "  addi sp, sp, -4\n");
            fprintf(codegen, "  li t0, %d\n", $3);
            fprintf(codegen, "  sw t0, -4(sp)\n");
            fprintf(codegen, "  addi sp, sp, -4\n");
            fprintf(codegen, "  lw a0, 0(sp)\n");
            fprintf(codegen, "  addi sp, sp, 4\n");
            fprintf(codegen, "  lw a1, 0(sp)\n");
            fprintf(codegen, "  addi sp, sp, 4\n");
            fprintf(codegen, "  sw ra, -4(sp)\n");
            fprintf(codegen, "  addi sp, sp, -4\n");
            fprintf(codegen, "  jal ra, digitalWrite\n");
            fprintf(codegen, "  lw ra, 0(sp)\n");
            fprintf(codegen, "  addi sp, sp, 4\n");
            fprintf(codegen, "  \n");
        }
        | DELAY L_BRACKET expression R_BRACKET EOL {
            fprintf(codegen, "  lw a0, 0(sp)\n");
            fprintf(codegen, "  addi sp, sp, 4\n");
            fprintf(codegen, "  sw ra, -4(sp)\n");
            fprintf(codegen, "  addi sp, sp, -4\n");
            fprintf(codegen, "  jal ra, delay\n");
            fprintf(codegen, "  lw ra, 0(sp)\n");
            fprintf(codegen, "  addi sp, sp, 4\n");
            fprintf(codegen, "  \n");
        }
        | if_stmt ELSE {
            fprintf(codegen, "  j L3\n");
            fprintf(codegen, "  \n");
            fprintf(codegen, "L2:\n");
        } L_PARENTHESIS statements R_PARENTHESIS {
            fprintf(codegen, "  \n");
            fprintf(codegen, "L3:\n");
        }
        | if_stmt {
            fprintf(codegen, "  \n");
            fprintf(codegen, "L2:\n");
        }
        | WHILE L_BRACKET {
            fprintf(codegen, "  \n");
            fprintf(codegen, "C2:\n");
        } expression {
            if ($4 != NULL) {
                fprintf(codegen, "  lw t0, 0(sp)\n");
                fprintf(codegen, "  addi sp, sp, 4\n");
                fprintf(codegen, "  beq zero, t0, L2\n");
            }
        } R_BRACKET L_PARENTHESIS {
        } statements {
            fprintf(codegen, "  j C2\n");
            fprintf(codegen, "  \n");
            fprintf(codegen, "L2:\n");
        } R_PARENTHESIS
        | DO L_PARENTHESIS {
            fprintf(codegen, "  \n");
            fprintf(codegen, "L2:\n");
        } statements R_PARENTHESIS WHILE L_BRACKET expression {
            if ($8 != NULL) {
                fprintf(codegen, "  lw t0, 0(sp)\n");
                fprintf(codegen, "  addi sp, sp, 4\n");
                fprintf(codegen, "  beq zero, to, L2\n");
            }
        } R_BRACKET EOL
        ;

if_stmt: IF L_BRACKET expression {
            if ($3 != NULL) {
                fprintf(codegen, "  lw t0, 0(sp)\n");
                fprintf(codegen, "  addi sp, sp, 4\n");
                fprintf(codegen, "  beq zero, t0, L2\n");
            }
        } R_BRACKET L_PARENTHESIS statements R_PARENTHESIS;

type: TYPE_VOID
    | TYPE_INT;

expression: primary {
            $$ = $1;
        }
        | L_BRACKET expression R_BRACKET {
            $$ = NULL;
        }
        | expression PLUS expression {
            fprintf(codegen, "  lw t0, 0(sp)\n");
            fprintf(codegen, "  addi sp, sp, 4\n");
            fprintf(codegen, "  lw t1, 0(sp)\n");
            fprintf(codegen, "  addi sp, sp, 4\n");
            fprintf(codegen, "  add t0, t0, t1\n");
            fprintf(codegen, "  sw t0, -4(sp)\n");
            fprintf(codegen, "  addi sp, sp, -4\n");
            $$ = NULL;
        }
        | expression MINUS expression {
            fprintf(codegen, "  lw t0, 0(sp)\n");
            fprintf(codegen, "  addi sp, sp, 4\n");
            fprintf(codegen, "  lw t1, 0(sp)\n");
            fprintf(codegen, "  addi sp, sp, 4\n");
            fprintf(codegen, "  sub t0, t1, t0\n");
            fprintf(codegen, "  sw t0, -4(sp)\n");
            fprintf(codegen, "  addi sp, sp, -4\n");
            $$ = NULL;
        }
        | expression MULTIPLY expression {
            fprintf(codegen, "  lw t0, 0(sp)\n");
            fprintf(codegen, "  addi sp, sp, 4\n");
            fprintf(codegen, "  lw t1, 0(sp)\n");
            fprintf(codegen, "  addi sp, sp, 4\n");
            fprintf(codegen, "  mul t0, t0, t1\n");
            fprintf(codegen, "  sw t0, -4(sp)\n");
            fprintf(codegen, "  addi sp, sp, -4\n");
            $$ = NULL;
        }
        | expression DIVIDE expression {
            fprintf(codegen, "  lw t0, 0(sp)\n");
            fprintf(codegen, "  addi sp, sp, 4\n");
            fprintf(codegen, "  lw t1, 0(sp)\n");
            fprintf(codegen, "  addi sp, sp, 4\n");
            fprintf(codegen, "  div t0, t1, t0\n");
            fprintf(codegen, "  sw t0, -4(sp)\n");
            fprintf(codegen, "  addi sp, sp, -4\n");
            $$ = NULL;
        }
        | expression EQUAL expression {
            fprintf(codegen, "  lw t0, 0(sp)\n");
            fprintf(codegen, "  addi sp, sp, 4\n");
            fprintf(codegen, "  lw t1, 0(sp)\n");
            fprintf(codegen, "  addi sp, sp, 4\n");
            fprintf(codegen, "  bne t0, t1, L2\n");
            $$ = NULL;
        }
        | expression LESS_EQUAL expression {
            fprintf(codegen, "  lw t0, 0(sp)\n");
            fprintf(codegen, "  addi sp, sp, 4\n");
            fprintf(codegen, "  lw t1, 0(sp)\n");
            fprintf(codegen, "  addi sp, sp, 4\n");
            fprintf(codegen, "  addi t0, t0, 1\n");
            fprintf(codegen, "  blt t1, t0, L2\n");
            $$ = NULL;
        }
        ;

primary: IDENT DECREMENT {
            int index = look_up_symbol($1);
            fprintf(codegen, "  lw t0, %d(s0)\n", table[index].offset * (-4) - 48);
            fprintf(codegen, "  addi t1, t0, -1\n");
            fprintf(codegen, "  sw t1, %d(s0)\n", table[index].offset * (-4) - 48);
            fprintf(codegen, "  sw t0, -4(sp)\n");
            fprintf(codegen, "  addi sp, sp, -4\n");
            $$ = $1;
       }
       | IDENT INCREMENT {
            int index = look_up_symbol($1);
            fprintf(codegen, "  lw t0, %d(s0)\n", table[index].offset * (-4) - 48);
            fprintf(codegen, "  addi t1, t0, 1\n");
            fprintf(codegen, "  sw t1, %d(s0)\n", table[index].offset * (-4) - 48);
            fprintf(codegen, "  sw t0, -4(sp)\n");
            fprintf(codegen, "  addi sp, sp, -4\n");
            $$ = $1;
       }
       | DECREMENT IDENT {
            int index = look_up_symbol($2);
            fprintf(codegen, "  lw t0, %d(s0)\n", table[index].offset * (-4) - 48);
            fprintf(codegen, "  addi t0, t0, -1\n");
            fprintf(codegen, "  sw t0, %d(s0)\n", table[index].offset * (-4) - 48);
            fprintf(codegen, "  sw t0, -4(sp)\n");
            fprintf(codegen, "  addi sp, sp, -4\n");
            $$ = $2;
       }
       | INCREMENT IDENT {
            int index = look_up_symbol($2);
            fprintf(codegen, "  lw t0, %d(s0)\n", table[index].offset * (-4) - 48);
            fprintf(codegen, "  addi t0, t0, 1\n");
            fprintf(codegen, "  sw t0, %d(s0)\n", table[index].offset * (-4) - 48);
            fprintf(codegen, "  sw t0, -4(sp)\n");
            fprintf(codegen, "  addi sp, sp, -4\n");
            $$ = $2;
       }
       | IDENT {
            int index = look_up_symbol($1);
            fprintf(codegen, "  lw t0, %d(s0)\n", table[index].offset * (-4) - 48);
            fprintf(codegen, "  sw t0, -4(sp)\n");
            fprintf(codegen, "  addi sp, sp, -4\n");
            $$ = $1;
        }
        | INT {
            fprintf(codegen, "  li t0, %d\n", $1);
            fprintf(codegen, "  sw t0, -4(sp)\n");
            fprintf(codegen, "  addi sp, sp, -4\n");
            $$ = NULL;
        };

%%

int yylex();

int main(void) {

    if ((codegen = fopen("codegen.S", "w")) == NULL) {
        printf("Error\n");
        exit(1);
    }
    fprintf(codegen, ".global codegen\n");

    init_symbol_table();
    yyparse();
    printf("parse successfully.\n");
    fprintf(codegen, "\n");
    return 0;
}

void yyerror(char *msg) {
    fprintf(stderr, "Error: %s\n", msg);
    fprintf(stderr, "Unmatched: %s\n", yytext);
    exit(1);
}

