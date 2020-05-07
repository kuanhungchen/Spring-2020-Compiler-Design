%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    char* src = "";
    char* res;
    char* space = " ";
    char* tab = "\t";

    int line_number = 1;
    int pragma_src = 1;
    int pragma_token = 1;

    void print_src() {
        if (pragma_src) {
            printf("%d:%s\n", line_number, src);
        }
        src = "";
        line_number += 1;
    }
    void concat(const char* s) {
        res = malloc(strlen(src) + strlen(s) + 1);
        strcpy(res, src);
        strcat(res, s);
        src = res;
    }
%}

Keywords "void"|"const"|"NULL"|"for"|"do"|"while"|"break"|"continue"|"if"|"else"|"return"|"struct"|"switch"|"case"|"default"|"int"|"double"|"float"|"char"|"fclose"|"clearerr"|"feof"|"ferror"|"fflush"|"fgetpos"|"fopen"|"fread"|"freopen"|"fseek"|"fsetpos"|"ftell"|"fwrite"|"remove"|"rename"|"rewind"|"setbuf"|"setvbuf"|"tmpfile"|"tmpnam"|"fprintf"|"printf"|"sprintf"|"vfprintf"|"vprintf"|"vsprintf"|"fscanf"|"scanf"|"sscanf"|"fgetc"|"fgets"|"fputc"|"fputs"|"getc"|"getchar"|"gets"|"putc"|"putchar"|"puts"|"ungetc"|"perror"
Operators   "+"|"-"|"*"|"/"|"%"|"++"|"--"|"<"|"<="|">"|">="|"=="|"!="|"="|"&&"|"||"|"!"|"&"|"|"
PuncChars   ":"|";"|","|"."|"["|"]"|"("|")"|"{"|"}"
Space       " "|"\t"
Symbols     [#$@^_?~\\`]

%x          COMMENT

%%

{Space}                                             {if (strcmp(yytext, " ") == 0) {concat(space);} else {concat(tab);}}
\n                                                  {print_src();}
{Keywords}                                          {if (pragma_token) {printf("#token key:%s\n", yytext);} concat(yytext);}
{Operators}                                         {if (pragma_token) {printf("#token op:%s\n", yytext);} concat(yytext);}
{PuncChars}                                         {if (pragma_token) {printf("#token punc:%s\n", yytext);} concat(yytext);}
(_|[a-zA-Z])(_|[a-zA-Z]|[0-9])*                     {if (pragma_token) {printf("#token id:%s\n", yytext);} concat(yytext);}
[+-]?[0-9]+                                         {if (pragma_token) {printf("#token integer:%s\n", yytext);} concat(yytext);}
[+-]?("."[0-9]+|[0-9]+"."|[0-9]+"."[0-9]+)          {if (pragma_token) {printf("#token double:%s\n", yytext);} concat(yytext);}


\'(\\.|[^\n'\\])\'                                  {if (pragma_token) {printf("#token char:%s\n", yytext);} concat(yytext);}
\"(\\.|[^\n"\\])*\"                                 {if (pragma_token) {printf("#token string:%s\n", yytext);} concat(yytext);}


#{Space}*pragma{Space}+source{Space}+on             {pragma_src = 1; concat(yytext);}
#{Space}*pragma{Space}+source{Space}+off            {pragma_src = 0; concat(yytext);}
#{Space}*pragma{Space}+token{Space}+on              {pragma_token = 1; concat(yytext);}
#{Space}*pragma{Space}+token{Space}+off             {pragma_token = 0; concat(yytext);}


"//".*                                              {concat(yytext);}
"/*"                                                {concat(yytext); BEGIN COMMENT;}
<COMMENT>"*/"                                       {concat(yytext); BEGIN 0;}
<COMMENT>.					    {concat(yytext);}
<COMMENT>\n                                         {print_src();}

%%

int main() {
    yylex();

    return 0;
}
