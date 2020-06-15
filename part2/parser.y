%{

#include <stdio.h>
#include <stdlib.h>


typedef char* string;

char* _PLUS = "+";
char* _MINUS = "-";
char* _MULTIPLY = "*";
char* _DIVIDE = "/";
char* _MODULO = "%";
char* _INCREMENT = "++";
char* _DECREMENT = "--";
char* _NOT = "!";
char* _LESS = "<";
char* _LESS_EQUAL = "<=";
char* _GREATER = ">";
char* _GREATER_EQUAL = ">=";
char* _EQUAL = "==";
char* _NOT_EQUAL = "!=";
char* _ASSIGN = "=";
char* _AND = "&&";
char* _OR = "||";
char* _OP_AND = "&";
char* _OP_OR = "|";
char* _COLON = ":";
char* _EOL = ";";
char* _COMMA = ",";
char* _L_BRACKET = "(";
char* _R_BRACKET = ")";
char* _L_SQR_BRACKET = "[";
char* _R_SQR_BRACKET = "]";
char* _L_PARENTHESIS = "{";
char* _R_PARENTHESIS = "}";
char* _CONST = "const";
char* _IF = "if";
char* _ELSE = "else";
char* _SWITCH = "switch";
char* _CASE = "case";
char* _DEFAULT = "default";
char* _FOR = "for";
char* _WHILE = "while";
char* _DO = "do";
char* _RETURN = "return";
char* _BREAK = "break";
char* _CONTINUE = "continue";
char* _OPEN_SCALAR = "<scalar_decl>";
char* _CLOSE_SCALAR = "</scalar_decl>";
char* _OPEN_ARRAY = "<array_decl>";
char* _CLOSE_ARRAY = "</array_decl>";
char* _OPEN_CONST = "<const_decl>";
char* _CLOSE_CONST = "</const_decl>";
char* _OPEN_FUNC = "<func_decl>";
char* _CLOSE_FUNC = "</func_decl>";
char* _OPEN_DEF = "<func_def>";
char* _CLOSE_DEF = "</func_def>";
char* _OPEN_EXPR = "<expr>";
char* _CLOSE_EXPR = "</expr>";
char* _OPEN_STMT = "<stmt>";
char* _CLOSE_STMT = "</stmt>";

char* int2string(int x) {
    int y = x;
    int l = 1;
    while (y > 9) {
        y /= 10;
        l += 1;
    }
    char* t = malloc(sizeof(char) * l);
    sprintf(t, "%d", x);
    return t;
}


char* double2string(double x) {
    char* s = malloc(sizeof(char) * 30);
    sprintf(s, "%f", x);
    return s;
}


%}

%union {
    int ival;
    double dval;
    char* sval;
}

%token <sval> TYPE_VOID TYPE_INT TYPE_DOUBLE TYPE_FLOAT TYPE_CHAR
%token PLUS MINUS MULTIPLY DIVIDE MODULO
%token INCREMENT DECREMENT NOT
%token LESS LESS_EQUAL GREATER GREATER_EQUAL EQUAL NOT_EQUAL ASSIGN
%token AND OR OP_AND OP_OR
%token COLON EOL COMMA
%token L_BRACKET R_BRACKET L_SQR_BRACKET R_SQR_BRACKET L_PARENTHESIS R_PARENTHESIS
%token FOR DO WHILE IF ELSE SWITCH RETURN BREAK CONTINUE CONST CASE DEFAULT

%token <sval> IDENT
%token <sval> CHAR
%token <sval> STRING
%token <ival> INT
%token <dval> DOUBLE

%type <sval> declaration_definition_multiple declaration_statement_multiple statement_multiple
%type <sval> declaration_definition_driver declaration_statement_driver
%type <sval> declaration_driver_list declaration_driver definition_driver

%type <sval> scalar_declaration_driver scalar_declarator_driver_list scalar_declarator_driver scalar_declarator
%type <sval> array_declaration_driver array_declarator_driver_list array_declarator_driver array_declarator array_content_driver 
%type <sval> const_declaration_driver const_declarator_driver_list const_declarator_driver const_declarator
%type <sval> function_declaration_driver
%type <sval> array_specifier

%type <sval> expression
%type <sval> assign_expression or_expression and_expression op_or_expression op_and_expression
%type <sval> equal_expression compare_expression add_expression multiply_expression
%type <sval> second_expression first_expression entry_expression

%type <sval> argument_list
%type <sval> param_list param

%type <sval> type var

%type <sval> statement expression_statement if_statement switch_statement while_statement
%type <sval> for_statement jump_statement compound_statement
%type <sval> switch_clauses case_multiple case_statement default_statement


%start program

%%

program: declaration_definition_multiple {printf("%s", $1);};


declaration_definition_multiple: /* empty */ {$$ = "";}
                               | declaration_definition_multiple declaration_definition_driver {
                               char* s = malloc(sizeof(char) * (strlen($1) + strlen($2)));
                               strcpy(s, $1);
                               strcat(s, $2);
                               $$ = s;
                               };

declaration_definition_driver: definition_driver {$$ = $1;}
                             | declaration_driver {$$ = $1;};

declaration_driver: scalar_declaration_driver {$$ = $1;}
                  | array_declaration_driver {$$ = $1;}
                  | const_declaration_driver {$$ = $1;}
                  | function_declaration_driver {$$ = $1;};

definition_driver: type IDENT L_BRACKET param_list R_BRACKET compound_statement {
                 char* s = malloc(sizeof(char) * (10 + strlen($1) + strlen($2) + 1 + strlen($4) + 1 + strlen($6) + 11));
                 strcpy(s, _OPEN_DEF);
                 strcat(s, $1);
                 strcat(s, $2);
                 strcat(s, _L_BRACKET);
                 strcat(s, $4);
                 strcat(s, _R_BRACKET);
                 strcat(s, $6);
                 strcat(s, _CLOSE_DEF);
                 $$ = s;
                 };

declaration_driver_list: declaration_driver {$$ = $1;}
                       | declaration_driver_list declaration_driver {
                       char* s = malloc(sizeof(char) * (strlen($1) + strlen($2)));
                       strcpy(s, $1);
                       strcat(s, $2);
                       $$ = s;
                       };

function_declaration_driver: type IDENT L_BRACKET param_list R_BRACKET EOL {
                           char* s = malloc(sizeof(char) * (11 + strlen($1) + strlen($2) + 1 + strlen($4) + 1 + 1 + 12));
                           strcpy(s, _OPEN_FUNC);
                           strcat(s, $1);
                           strcat(s, $2);
                           strcat(s, _L_BRACKET);
                           strcat(s, $4);
                           strcat(s, _R_BRACKET);
                           strcat(s, _EOL);
                           strcat(s, _CLOSE_FUNC);
                           $$ = s;
                           };

param_list: /* empty */ {$$ = "";}
          | param {$$ = $1;}
          | param_list COMMA param {
          char* s = malloc(sizeof(char) * (strlen($1) + 1 + strlen($3)));
          strcpy(s, $1);
          strcat(s, _COMMA);
          strcat(s, $3);
          $$ = s;
          };

param: type IDENT {
     char* s = malloc(sizeof(char) * (strlen($1) + strlen($2)));
     strcpy(s, $1);
     strcat(s, $2);
     $$ = s;
     };

const_declaration_driver: CONST type const_declarator_driver_list EOL {
                        char* s = malloc(sizeof(char) * (12 + 5 + strlen($2) + strlen($3) + 1 + 13));
                        strcpy(s, _OPEN_CONST);
                        strcat(s, _CONST);
                        strcat(s, $2);
                        strcat(s, $3);
                        strcat(s, _EOL);
                        strcat(s, _CLOSE_CONST);
                        $$ = s;
                        };

const_declarator_driver_list: const_declarator_driver {$$ = $1;}
                            | const_declarator_driver_list COMMA const_declarator_driver {
                            char* s = malloc(sizeof(char) * (strlen($1) + 1 + strlen($3)));
                            strcpy(s, $1);
                            strcat(s, _COMMA);
                            strcat(s, $3);
                            $$ = s;
                            };

const_declarator_driver: const_declarator ASSIGN or_expression {
                       char* s = malloc(sizeof(char) * (strlen($1) + 1 + strlen($3)));
                       strcpy(s, $1);
                       strcat(s, _ASSIGN);
                       strcat(s, $3);
                       $$ = s;
                       };

const_declarator: IDENT {$$ = $1;};


scalar_declaration_driver: type scalar_declarator_driver_list EOL {
                         char* s = malloc(sizeof(char) * (13 + strlen($1) + strlen($2) + 1 + 14));
                         strcpy(s, _OPEN_SCALAR);
                         strcat(s, $1);
                         strcat(s, $2);
                         strcat(s, _EOL);
                         strcat(s, _CLOSE_SCALAR);
                         $$ = s;
                         };

scalar_declarator_driver_list: scalar_declarator_driver {$$ = $1;}
                             | scalar_declarator_driver_list COMMA scalar_declarator_driver {
                             char* s = malloc(sizeof(char) * (strlen($1) + 1 + strlen($3)));
                             strcpy(s, $1);
                             strcat(s, _COMMA);
                             strcat(s, $3);
                             $$ = s;
                             };

scalar_declarator_driver: scalar_declarator ASSIGN or_expression {
                        char* s = malloc(sizeof(char) * (strlen($1) + 1 + strlen($3)));
                        strcpy(s, $1);
                        strcat(s, _ASSIGN);
                        strcat(s, $3);
                        $$ = s;}
                        | scalar_declarator {$$ = $1;};

scalar_declarator: IDENT {$$ = $1;};

array_declaration_driver: type array_declarator_driver_list EOL {
                        char* s = malloc(sizeof(char) * (12 + strlen($1) + strlen($2) + 1 + 13));
                        strcpy(s, _OPEN_ARRAY);
                        strcat(s, $1);
                        strcat(s, $2);
                        strcat(s, _EOL);
                        strcat(s, _CLOSE_ARRAY);
                        $$ = s;
                        };

array_declarator_driver_list: array_declarator_driver {$$ = $1;}
                            | array_declarator_driver_list COMMA array_declarator_driver {
                            char* s = malloc(sizeof(char) * (strlen($1) + 1 + strlen($3)));
                            strcpy(s, $1);
                            strcat(s, _COMMA);
                            strcat(s, $3);
                            $$ = s;
                            };

array_declarator_driver: IDENT L_SQR_BRACKET INT R_SQR_BRACKET array_declarator ASSIGN L_PARENTHESIS array_content_driver R_PARENTHESIS {
                       char* s = malloc(sizeof(char) * (strlen($1) + 1 + strlen(int2string($3)) + 1 + strlen($5) + 1 + 1 + strlen($8) + 1));
                       strcpy(s, $1);
                       strcat(s, _L_SQR_BRACKET);
                       strcat(s, int2string($3));
                       strcat(s, _R_SQR_BRACKET);
                       strcat(s, $5);
                       strcat(s, _ASSIGN);
                       strcat(s, _L_PARENTHESIS);
                       strcat(s, $8);
                       strcat(s, _R_PARENTHESIS);
                       $$ = s;
                       }
                       | IDENT L_SQR_BRACKET INT R_SQR_BRACKET array_declarator {
                       char* s = malloc(sizeof(char) * (strlen($1) + 1 + strlen(int2string($3)) + 1 + strlen($5)));
                       strcpy(s, $1);
                       strcat(s, _L_SQR_BRACKET);
                       strcat(s, int2string($3));
                       strcat(s, _R_SQR_BRACKET);
                       strcat(s, $5);
                       $$ = s;
                       };

array_declarator: /* empty */ {$$ = "";}
                | L_SQR_BRACKET INT R_SQR_BRACKET array_declarator {
                char* s = malloc(sizeof(char) * (1 + strlen(int2string($2) + 1 + strlen($4))));
                strcpy(s, _L_SQR_BRACKET);
                strcat(s, int2string($2));
                strcat(s, _R_SQR_BRACKET);
                strcat(s, $4);
                $$ = s;
                };

array_content_driver: expression {$$ = $1;}
                    | L_PARENTHESIS array_content_driver R_PARENTHESIS {
                    char* s = malloc(sizeof(char) * (1 + strlen($2) + 1));
                    strcpy(s, _L_PARENTHESIS);
                    strcat(s, $2);
                    strcat(s, _R_PARENTHESIS);
                    $$ = s;
                    }
                    | array_content_driver COMMA array_content_driver {
                    char* s = malloc(sizeof(char) * (strlen($1) + 1 + strlen($3)));
                    strcpy(s, $1);
                    strcat(s, _COMMA);
                    strcat(s, $3);
                    $$ = s;
                    };


expression: assign_expression {$$ = $1;}
          | expression COMMA assign_expression {
          char* s = malloc(sizeof(char) * (strlen($1) + 1 + strlen($3)));
          strcpy(s, $1);
          strcat(s, _COMMA);
          strcat(s, $3);
          $$ = s;
          };

assign_expression: var ASSIGN assign_expression {
                 char* s = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7));
                 strcpy(s, _OPEN_EXPR);
                 strcat(s, $1);
                 strcat(s, _ASSIGN);
                 strcat(s, $3);
                 strcat(s, _CLOSE_EXPR);
                 $$ = s;
                 }
                 | or_expression {$$ = $1;};

var: IDENT array_specifier {
   char* s = malloc(sizeof(char) * (strlen($1) + strlen($2)));
   strcpy(s, $1);
   strcat(s, $2);
   $$ = s;
   };

array_specifier: /* empty */ {$$ = "";}
               | L_SQR_BRACKET or_expression R_SQR_BRACKET array_specifier {
               char* s = malloc(sizeof(char) * (1 + strlen($2) + 1 + strlen($4)));
               strcpy(s, _L_SQR_BRACKET);
               strcat(s, $2);
               strcat(s, _R_SQR_BRACKET);
               strcat(s, $4);
               $$ = s;
               };

or_expression: and_expression {$$ = $1;}
             | or_expression OR and_expression {
             char* s = malloc(sizeof(char) * (6 + strlen($1) + 2 + strlen($3) + 7));
             strcpy(s, _OPEN_EXPR);
             strcat(s, $1);
             strcat(s, _OR);
             strcat(s, $3);
             strcat(s, _CLOSE_EXPR);
             $$ = s;
             };

and_expression: op_or_expression {$$ = $1;}
              | and_expression AND op_or_expression {
              char* s = malloc(sizeof(char) * (6 + strlen($1) + 2 + strlen($3) + 7));
              strcpy(s, _OPEN_EXPR);
              strcat(s, $1);
              strcat(s, _AND);
              strcat(s, $3);
              strcat(s, _CLOSE_EXPR);
              $$ = s;
              };

op_or_expression: op_and_expression {$$ = $1;}
                | op_or_expression OP_OR op_and_expression {
                char* s = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7));
                strcpy(s, _OPEN_EXPR);
                strcat(s, $1);
                strcat(s, _OP_OR);
                strcat(s, $3);
                strcat(s, _CLOSE_EXPR);
                $$ = s;
                };

op_and_expression: equal_expression {$$ = $1;}
                 | op_and_expression OP_AND equal_expression {
                 char* s = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7));
                 strcpy(s, _OPEN_EXPR);
                 strcat(s, $1);
                 strcat(s, _OP_AND);
                 strcat(s, $3);
                 strcat(s, _CLOSE_EXPR);
                 $$ = s;
                 };

equal_expression: compare_expression {$$ = $1;}
                | equal_expression EQUAL compare_expression {
                char* s = malloc(sizeof(char) * (6 + strlen($1) + 2 + strlen($3) + 7));
                strcpy(s, _OPEN_EXPR);
                strcat(s, $1);
                strcat(s, _EQUAL);
                strcat(s, $3);
                strcat(s, _CLOSE_EXPR);
                $$ = s;}
                | equal_expression NOT_EQUAL compare_expression {
                char* s = malloc(sizeof(char) * (6 + strlen($1) + 2 + strlen($3) + 7));
                strcpy(s, _OPEN_EXPR);
                strcat(s, $1);
                strcat(s, _NOT_EQUAL);
                strcat(s, $3);
                strcat(s, _CLOSE_EXPR);
                $$ = s;
                };

compare_expression: add_expression {$$ = $1;}
                  | compare_expression LESS add_expression {
                  char* s = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7));
                  strcpy(s, _OPEN_EXPR);
                  strcat(s, $1);
                  strcat(s, _LESS);
                  strcat(s, $3);
                  strcat(s, _CLOSE_EXPR);
                  $$ = s;}
                  | compare_expression LESS_EQUAL add_expression {
                  char* s = malloc(sizeof(char) * (6 + strlen($1) + 2 + strlen($3) + 7));
                  strcpy(s, _OPEN_EXPR);
                  strcat(s, $1);
                  strcat(s, _LESS_EQUAL);
                  strcat(s, $3);
                  strcat(s, _CLOSE_EXPR);
                  $$ = s;}
                  | compare_expression GREATER add_expression {
                  char* s = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7));
                  strcpy(s, _OPEN_EXPR);
                  strcat(s, $1);
                  strcat(s, _GREATER);
                  strcat(s, $3);
                  strcat(s, _CLOSE_EXPR);
                  $$ = s;}
                  | compare_expression GREATER_EQUAL add_expression {
                  char* s = malloc(sizeof(char) * (6 + strlen($1) + 2 + strlen($3) + 7));
                  strcpy(s, _OPEN_EXPR);
                  strcat(s, $1);
                  strcat(s, _GREATER_EQUAL);
                  strcat(s, $3);
                  strcat(s, _CLOSE_EXPR);
                  $$ = s; 
                  };

add_expression: multiply_expression {$$ = $1;}
              | add_expression PLUS multiply_expression {
              char* s = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7));
              strcpy(s, _OPEN_EXPR);
              strcat(s, $1);
              strcat(s, _PLUS);
              strcat(s, $3);
              strcat(s, _CLOSE_EXPR);
              $$ = s;}
              | add_expression MINUS multiply_expression {
              char* s = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7));
              strcpy(s, _OPEN_EXPR);
              strcat(s, $1);
              strcat(s, _MINUS);
              strcat(s, $3);
              strcat(s, _CLOSE_EXPR);
              $$ = s;
              };

multiply_expression: second_expression {$$ = $1;}
                   | multiply_expression MULTIPLY second_expression {
                   char* s = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7));
                   strcpy(s, _OPEN_EXPR);
                   strcat(s, $1);
                   strcat(s, _MULTIPLY);
                   strcat(s, $3);
                   strcat(s, _CLOSE_EXPR);
                   $$ = s;}
                   | multiply_expression DIVIDE second_expression {
                   char* s = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7));
                   strcpy(s, _OPEN_EXPR);
                   strcat(s, $1);
                   strcat(s, _DIVIDE);
                   strcat(s, $3);
                   strcat(s, _CLOSE_EXPR);
                   $$ = s;}
                   | multiply_expression MODULO second_expression {
                   char* s = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7));
                   strcpy(s, _OPEN_EXPR);
                   strcat(s, $1);
                   strcat(s, _MODULO);
                   strcat(s, $3);
                   strcat(s, _CLOSE_EXPR);
                   $$ = s;
                   };

second_expression: first_expression {$$ = $1;}
                 | INCREMENT var {
                 char* s = malloc(sizeof(char) * (6 + 2 + strlen($2) + 7));
                 strcpy(s, _OPEN_EXPR);
                 strcat(s, _INCREMENT);
                 strcat(s, $2);
                 strcat(s, _CLOSE_EXPR);
                 $$ = s;}
                 | DECREMENT var {
                 char* s = malloc(sizeof(char) * (6 + 2 + strlen($2) + 7));
                 strcpy(s, _OPEN_EXPR);
                 strcat(s, _DECREMENT);
                 strcat(s, $2);
                 strcat(s, _CLOSE_EXPR);
                 $$ = s;}
                 | PLUS second_expression {      
                 char* s = malloc(sizeof(char) * (6 + 1 + strlen($2) + 7));
                 strcpy(s, _OPEN_EXPR);
                 strcat(s, _PLUS);
                 strcat(s, $2);
                 strcat(s, _CLOSE_EXPR);
                 $$ = s;}
                 | MINUS second_expression {
                 char* s = malloc(sizeof(char) * (6 + 1 + strlen($2)) + 7);
                 strcpy(s, _OPEN_EXPR);
                 strcat(s, _MINUS);
                 strcat(s, $2);
                 strcat(s, _CLOSE_EXPR);
                 $$ = s;}
                 | NOT second_expression {
                 char* s = malloc(sizeof(char) * (6 + 1 + strlen($2) + 7));
                 strcpy(s, _OPEN_EXPR);
                 strcat(s, _NOT);
                 strcat(s, $2);
                 strcat(s, _CLOSE_EXPR);
                 $$ = s;
                 };

first_expression: entry_expression {$$ = $1;}
                | var INCREMENT {
                char* s = malloc(sizeof(char) * (6 + strlen($1) + 2 + 7));
                strcpy(s, _OPEN_EXPR);
                strcat(s, $1);
                strcat(s, _INCREMENT);
                strcat(s, _CLOSE_EXPR);
                $$ = s;}
                | var DECREMENT {
                char* s = malloc(sizeof(char) * (6 + strlen($1) + 2 + 7));
                strcpy(s, _OPEN_EXPR);
                strcat(s, $1);
                strcat(s, _DECREMENT);
                strcat(s, _CLOSE_EXPR);
                $$ = s;}
                | IDENT array_specifier {
                char* s = malloc(sizeof(char) * (6 + strlen($1) + strlen($2) + 7));
                strcpy(s, _OPEN_EXPR);
                strcat(s, $1);
                strcat(s, $2);
                strcat(s, _CLOSE_EXPR);
                $$ = s;}
                | IDENT L_BRACKET R_BRACKET {
                char* s = malloc(sizeof(char) * (6 + strlen($1) + 1 + 1 + 7));
                strcpy(s, _OPEN_EXPR);
                strcat(s, $1);
                strcat(s, _L_BRACKET);
                strcat(s, _R_BRACKET);
                strcat(s, _CLOSE_EXPR);
                $$ = s;}
                | IDENT L_BRACKET argument_list R_BRACKET {
                char* s = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 1 + 7));
                strcpy(s, _OPEN_EXPR);
                strcat(s, $1);
                strcat(s, _L_BRACKET);
                strcat(s, $3);
                strcat(s, _R_BRACKET);
                strcat(s, _CLOSE_EXPR);
                $$ = s;
                };

entry_expression: IDENT {
                char* s = malloc(sizeof(char) * (6 + strlen($1) + 7));
                strcpy(s, _OPEN_EXPR);
                strcat(s, $1);
                strcat(s, _CLOSE_EXPR);
                $$ = s;}
                | INT {
                char* s = malloc(sizeof(char) * (6 + strlen(int2string($1)) + 7));
                strcpy(s, _OPEN_EXPR);
                strcat(s, int2string($1));
                strcat(s, _CLOSE_EXPR);
                $$ = s;}
                | DOUBLE {
                char* s = malloc(sizeof(char) * (6 + strlen(double2string($1)) + 7));
                strcpy(s, _OPEN_EXPR);
                strcat(s, double2string($1));
                strcat(s, _CLOSE_EXPR);
                $$ = s;}
                | CHAR {
                char* s = malloc(sizeof(char) * (6 + strlen($1) + 7));
                strcpy(s, _OPEN_EXPR);
                strcat(s, $1);
                strcat(s, _CLOSE_EXPR);
                $$ = s;}
                | STRING {
                char* s = malloc(sizeof(char) * (6 + strlen($1) + 7));
                strcpy(s, _OPEN_EXPR);
                strcat(s, $1);
                strcat(s, _CLOSE_EXPR);
                $$ = s;};

argument_list: assign_expression {$$ = $1;}
             | argument_list COMMA assign_expression {
             char* s = malloc(sizeof(char) * (strlen($1) + 1 + strlen($3)));
             strcpy(s, $1);
             strcat(s, _COMMA);
             strcat(s, $3);
             $$ = s;
             };

compound_statement: L_PARENTHESIS declaration_statement_multiple R_PARENTHESIS {
                  char* s = malloc(sizeof(char) * (1 + strlen($2) + 1));
                  strcpy(s, _L_PARENTHESIS);
                  strcat(s, $2);
                  strcat(s, _R_PARENTHESIS);
                  $$ = s;
                  };

declaration_statement_multiple: /* empty */ {$$ = "";}
                              | declaration_statement_multiple declaration_statement_driver {
                              char* s = malloc(sizeof(char) * (strlen($1) + strlen($2)));
                              strcpy(s, $1);
                              strcat(s, $2);
                              $$ = s;
                              };

declaration_statement_driver: declaration_driver {$$ = $1;}
                            | statement {$$ = $1;};

statement: expression_statement {
         char* s = malloc(sizeof(char) * (6 + strlen($1) + 7));
         strcpy(s, _OPEN_STMT);
         strcat(s, $1);
         strcat(s, _CLOSE_STMT);
         $$ = s;
         }
         | if_statement {
         char* s = malloc(sizeof(char) * (6 + strlen($1) + 7));
         strcpy(s, _OPEN_STMT);
         strcat(s, $1);
         strcat(s, _CLOSE_STMT);
         $$ = s;
         }
         | switch_statement {
         char* s = malloc(sizeof(char) * (6 + strlen($1) + 7));
         strcpy(s, _OPEN_STMT);
         strcat(s, $1);
         strcat(s, _CLOSE_STMT);
         $$ = s;
         }
         | while_statement {
         char* s = malloc(sizeof(char) * (6 + strlen($1) + 7));
         strcpy(s, _OPEN_STMT);
         strcat(s, $1);
         strcat(s, _CLOSE_STMT);
         $$ = s;
         }
         | for_statement {
         char* s = malloc(sizeof(char) * (6 + strlen($1) + 7));
         strcpy(s, _OPEN_STMT);
         strcat(s, $1);
         strcat(s, _CLOSE_STMT);
         $$ = s;
         }
         | jump_statement {
         char* s = malloc(sizeof(char) * (6 + strlen($1) + 7));
         strcpy(s, _OPEN_STMT);
         strcat(s, $1);
         strcat(s, _CLOSE_STMT);
         $$ = s;
         }
         | compound_statement {
         char* s = malloc(sizeof(char) * (6 + strlen($1) + 7));
         strcpy(s, _OPEN_STMT);
         strcat(s, $1);
         strcat(s, _CLOSE_STMT);
         $$ = s;
         };

statement_multiple: /* empty */ {$$ = "";}
                  | statement {$$ = $1;}
                  | statement_multiple statement {
                  char* s = malloc(sizeof(char) * (strlen($1) + strlen($2)));
                  strcpy(s, $1);
                  strcat(s, $2);
                  $$ = s;
                  };

expression_statement: EOL {
                    char* s = malloc(sizeof(char) * 1);
                    strcpy(s, _EOL);
                    $$ = s;
                    }
                    | expression EOL {
                    char* s = malloc(sizeof(char) * (strlen($1) + 1));
                    strcpy(s, $1);
                    strcat(s, _EOL);
                    $$ = s;
                    };

if_statement: IF L_BRACKET expression R_BRACKET compound_statement {
            char* s = malloc(sizeof(char) * (2 + 1 + strlen($3) + 1 + strlen($5)));
			strcpy(s, _IF);
            strcat(s, _L_BRACKET);
            strcat(s, $3);
            strcat(s, _R_BRACKET);
            strcat(s, $5);
			$$ = s;
            }
            | IF L_BRACKET expression R_BRACKET compound_statement ELSE compound_statement {
            char* s = malloc(sizeof(char) * (2 + 1 + strlen($3) + 1 + strlen($5) + 4 + strlen($7)));
            strcpy(s, _IF);
            strcat(s, _L_BRACKET);
            strcat(s, $3);
            strcat(s, _R_BRACKET);
            strcat(s, $5);
            strcat(s, _ELSE);
            strcat(s, $7);
            $$ = s;
            };

switch_statement: SWITCH L_BRACKET expression R_BRACKET L_PARENTHESIS switch_clauses R_PARENTHESIS {
	char* s = malloc(sizeof(char) * (6 + 1 + strlen($3) + 1 + 1 + strlen($6) + 1));
	strcpy(s, _SWITCH);
	strcat(s, _L_BRACKET);
	strcat(s, $3);
	strcat(s, _R_BRACKET);
	strcat(s, _L_PARENTHESIS);
	strcat(s, $6);
	strcat(s, _R_PARENTHESIS);
	$$ = s;
	};

switch_clauses: case_multiple {$$ = $1;}
              | case_multiple default_statement {
              char* s = malloc(sizeof(char) * (strlen($1) + strlen($2)));
              strcpy(s, $1);
              strcat(s, $2);
              $$ = s;
              };

case_multiple: /* empty */ {$$ = "";}
             | case_statement {$$ = $1;}
             | case_multiple case_statement {
             char* s = malloc(sizeof(char) * (strlen($1) + strlen($2)));
             strcpy(s, $1);
             strcat(s, $2);
             $$ = s;
             };

case_statement: CASE INT COLON statement_multiple {
              char* s = malloc(sizeof(char) * (4 + strlen(int2string($2)) + 1 + strlen($4)));
              strcpy(s, _CASE);
              strcat(s, int2string($2));
              strcat(s, _COLON);
              strcat(s, $4);
              $$ = s;
              };

default_statement: DEFAULT COLON statement_multiple {
                 char* s = malloc(sizeof(char) * (7 + 1 + strlen($3)));
                 strcpy(s, _DEFAULT);
                 strcat(s, _COLON);
                 strcat(s, $3);
                 $$ = s;
                 };

while_statement: WHILE L_BRACKET assign_expression R_BRACKET statement {
               char* s = malloc(sizeof(char) * (5 + 1 + strlen($3) + 1 + strlen($5)));
               strcpy(s, _WHILE);
               strcat(s, _L_BRACKET);
               strcat(s, $3);
               strcat(s, _R_BRACKET);
               strcat(s, $5);
               $$ = s;
               }
               | DO statement WHILE L_BRACKET assign_expression R_BRACKET EOL {
               char* s = malloc(sizeof(char) * (2 + strlen($2) + 5 + 1 + strlen($5) + 1 + 1));
               strcpy(s, _DO);
               strcat(s, $2);
               strcat(s, _WHILE);
               strcat(s, _L_BRACKET);
               strcat(s, $5);
               strcat(s, _R_BRACKET);
               strcat(s, _EOL);
               $$ = s;
               };

for_statement: FOR L_BRACKET expression EOL expression EOL expression R_BRACKET statement {
             char* s = malloc(sizeof(char) * (3 + 1 + strlen($3) + 1 + strlen($5) + 1 + strlen($7) + 1 + strlen($9)));
             strcpy(s, _FOR);
             strcat(s, _L_BRACKET);
             strcat(s, $3);
             strcat(s, _EOL);
             strcat(s, $5);
             strcat(s, _EOL);
             strcat(s, $7);
             strcat(s, _R_BRACKET);
             strcat(s, $9);
             $$ = s;
             };

jump_statement: RETURN expression EOL {
              char* s = malloc(sizeof(char) * (6 + strlen($2) + 1));
              strcpy(s, _RETURN);
              strcat(s, $2);
              strcat(s, _EOL);
              $$ = s;
              }
              | RETURN EOL {
              char* s = malloc(sizeof(char) * (6 + 1));
              strcpy(s, _RETURN);
              strcat(s, _EOL);
              $$ = s;
              }
              | BREAK EOL {
              char* s = malloc(sizeof(char) * (5 + 1));
              strcpy(s, _BREAK);
              strcat(s, _EOL);
              $$ = s;
              }
              | CONTINUE EOL {
              char* s = malloc(sizeof(char) * (8 + 1));
              strcpy(s, _CONTINUE);
              strcat(s, _EOL);
              $$ = s;
              };


type: TYPE_VOID {$$ = $1;}
    | TYPE_INT {$$ = $1;}
    | TYPE_DOUBLE {$$ = $1;}
    | TYPE_FLOAT {$$ = $1;}
    | TYPE_CHAR {$$ = $1;};

%%

int yylex();

int main(void) {
    yyparse();

    return 0;
}

void yyerror(char *msg) {
    fprintf(stderr, "Error: %s\n", msg);
    exit(1);
}
