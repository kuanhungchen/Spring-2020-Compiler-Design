%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"
    #include "code.h"
    
    FILE* codegen;
    int line_number = 1;
	char* _NEW_LINE = "\n";
	char* _TAB = "\t";
	char* _BSLASH = "\\";
	char* _SINGLE_QUOTE = "\'";
    char tmp[2];

	char* remove_single_quote(char* s) {
		if (s[2] == '\'') {
            memcpy(tmp, &s[1], 1);
            tmp[1] = '\0';
			return tmp;
		} else if (s[2] == 'n') {
			return _NEW_LINE;
		} else if (s[2] == 't') {
			return _TAB;
		} else if (s[2] == '\\') {
			return _BSLASH;
		} else {
			return _SINGLE_QUOTE;
		}
	}


%}

Keywords "void"|"const"|"NULL"|"for"|"do"|"while"|"break"|"continue"|"if"|"else"|"return"|"struct"|"switch"|"case"|"default"|"int"|"double"|"float"|"char"|"fclose"|"clearerr"|"feof"|"ferror"|"fflush"|"fgetpos"|"fopen"|"fread"|"freopen"|"fseek"|"fsetpos"|"ftell"|"fwrite"|"remove"|"rename"|"rewind"|"setbuf"|"setvbuf"|"tmpfile"|"tmpnam"|"fprintf"|"printf"|"sprintf"|"vfprintf"|"vprintf"|"vsprintf"|"fscanf"|"scanf"|"sscanf"|"fgetc"|"fgets"|"fputc"|"fputs"|"getc"|"getchar"|"gets"|"putc"|"putchar"|"puts"|"ungetc"|"perror"
Operators   "+"|"-"|"*"|"/"|"%"|"++"|"--"|"<"|"<="|">"|">="|"=="|"!="|"="|"&&"|"||"|"!"|"&"|"|"
PuncChars   ":"|";"|","|"."|"["|"]"|"("|")"|"{"|"}"
Space       " "|"\t"

%x          COMMENT

%%

\n                                                  {++line_number;}
{Space}                                             {}
"void"                                              {yylval.sval = strdup(yytext); return TYPE_VOID;}
"int"                                               {yylval.sval = strdup(yytext); return TYPE_INT;}
"="                                                 {return ASSIGN;}
","                                                 {return COMMA;}
[0-9]+                                              {yylval.ival = atoi(yytext); return INT;}
"if"                                                {return IF;}
"else"                                              {return ELSE;}
"do"                                                {return DO;}
"while"                                             {return WHILE;}
"for"                                               {return FOR;}
"return"                                            {return RETURN;}
"digitalWrite"                                      {return DIGITALWRITE;}
"delay"                                             {return DELAY;}
"<"                                                 {return LESS;}
"<="                                                {return LESS_EQUAL;}
">"                                                 {return GREATER;}
">="                                                {return GREATER_EQUAL;}
"=="                                                {return EQUAL;}
"!="                                                {return NOT_EQUAL;}
"+"                                                 {return PLUS;}
"-"                                                 {return MINUS;}
"++"                                                {return INCREMENT;}
"--"                                                {return DECREMENT;}
"*"                                                 {return MULTIPLY;}
"/"                                                 {return DIVIDE;}
"&&"                                                {return AND;}
"||"                                                {return OR;}
"("                                                 {return L_BRACKET;}
")"                                                 {return R_BRACKET;}
"{"                                                 {return L_PARENTHESIS;}
"}"                                                 {return R_PARENTHESIS;}
";"                                                 {return EOL;}
(_|[a-zA-Z])(_|[a-zA-Z]|[0-9])*                     {yylval.sval = strdup(yytext); return IDENT;}

"//".*                                              {}
"/*"                                                {BEGIN COMMENT;}
<COMMENT>"*/"                                       {BEGIN 0;}
<COMMENT>.                                          {}
<COMMENT>\n                                         {}

%%

/*
{Space}                                             {if (strcmp(yytext, " ") == 0) {concat(space);} else {concat(tab);}}
\n                                                  {print_src();}
{Keywords}                                          {printf("#token key:%s\n", yytext); concat(yytext);}
{Operators}                                         {printf("#token op:%s\n", yytext); concat(yytext);}
{PuncChars}                                         {printf("#token punc:%s\n", yytext); concat(yytext);}


\"(\\.|[^\n"\\])*\"                                 {printf("#token string:%s\n", yytext); concat(yytext);}

*/

