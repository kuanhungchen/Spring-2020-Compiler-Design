
/*
   This is a very simple c compiler written by Prof. Jenq Kuen Lee,
   Department of Computer Science, National Tsing-Hua Univ., Taiwan,
   Fall 1995.

   This is used in compiler class.
   This file contains Symbol Table Handling.

*/

#include <stdio.h>  
#include <stdlib.h>
#include <string.h>
//#include <error.h>
#include "code.h"

extern FILE *codegen;
int cur_counter = 0;
int cur_scope   = 1;
int symbol_t_index = 0;
char *copys();



/*

  init_symbol_table();

*/
void init_symbol_table()
{

  bzero(&table[0], sizeof(struct symbol_entry)*MAX_TABLE_SIZE);

}

/*
   To install a symbol in the symbol table 

*/
char * install_symbol(char *s)
{
    if (cur_counter >= MAX_TABLE_SIZE)
        perror("Symbol Table Full");
    else {
        table[cur_counter].scope = cur_scope;
        table[cur_counter].name = copys(s);
        table[cur_counter].mode = LOCAL_MODE;
        cur_counter++;
    }
    return s;
}



/*
   To return an integer as an index of the symbol table

*/
int look_up_symbol(char *s)
{
    int i;

    if (cur_counter == 0) return -1;
    for (i=cur_counter-1;i>=0; i--)
    {
        if (!strcmp(s,table[i].name)) return i;
    }
    return -1;
}


int look_up_symbol_kw(char* s)
{
    if (symbol_t_index == 0) return -1;
    for (int i = symbol_t_index - 1; i >= 0; i--) {
        if (!strcmp(s, symbol_t[i].lexptr)) return i;
    }
    return -1;
}

/*
   Pop up symbols of the given scope from the symbol table upon the
   exit of a given scope.

*/
void pop_up_symbol(int scope)
{
   int i;
   if (cur_counter==0) return;
   for (i=cur_counter-1;i>=0; i--)
     {
       if (table[i].scope !=scope) break;
     }
   if (i<0) cur_counter = 0;
   cur_counter = i+1;
  
}



/*
   Set up parameter scope and offset

*/
void set_scope_and_offset_of_param(char *s)
{

  int i,j,index;
  int total_args;

   index = look_up_symbol(s);
   if (index<0) perror("Error in function header");
   else {
      table[index].type = T_FUNCTION;
      total_args = cur_counter -index -1;
      table[index].total_args=total_args;
      for (j=total_args, i=cur_counter-1;i>index; i--,j--)
        {
          table[i].scope= cur_scope;
          table[i].offset= j;
          table[i].mode  = ARGUMENT_MODE;
          table[i].functor_index  = index;
        }
   }

}



/*
   Set up local var offset

*/
void set_local_vars(char *functor)
{

    int i,j,index,index1;
    int total_locals;

    index = look_up_symbol(functor);
    index1 = index + table[index].total_args;
    total_locals = cur_counter -index1 -1;
    if (total_locals <0)
        perror("Error in number of local variables");
    table[index].total_locals = total_locals;
    for (j = total_locals, i = cur_counter-1;j>0; i--,j--)
    {
        table[i].scope = cur_scope;
        table[i].offset = j;
        table[i].mode = LOCAL_MODE;
        printf("set %s to scope %d, offset %d\n", table[i].name, table[i].scope, table[i].offset);
    }
}



/*
  Set GLOBAL_MODE to global variables

*/

void set_global_vars(char *s)
{
  int index;
  index =look_up_symbol(s);
  table[index].mode = GLOBAL_MODE;
  table[index].scope =1;
}


/*

To generate house-keeping work at the beginning of the function

*/

void code_gen_func_header(char *functor)
{
    fprintf(codegen, "%s:\n", functor);
    fprintf(codegen, "  // BEGIN PROLOGUE\n");
    fprintf(codegen, "  sw s0, -4(sp) // save frame pointer\n");
    fprintf(codegen, "  addi sp, sp, -4\n");
    fprintf(codegen, "  addi s0, sp, 0 // set new frame pointer\n");
    fprintf(codegen, "  sw sp, -4(s0)\n");
    fprintf(codegen, "  sw s1, -8(s0)\n");
    fprintf(codegen, "  sw s2, -12(s0)\n");
    fprintf(codegen, "  sw s3, -16(s0)\n");
    fprintf(codegen, "  sw s4, -20(s0)\n");
    fprintf(codegen, "  sw s5, -24(s0)\n");
    fprintf(codegen, "  sw s6, -28(s0)\n");
    fprintf(codegen, "  sw s7, -32(s0)\n");
    fprintf(codegen, "  sw s8, -36(s0)\n");
    fprintf(codegen, "  sw s9, -40(s0)\n");
    fprintf(codegen, "  sw s10, -44(s0)\n");
    fprintf(codegen, "  sw s11, -48(s0)\n");
    fprintf(codegen, "  addi sp, s0, -48 // update stack pointer\n");
    fprintf(codegen, "  // END PROLOGUE\n");
    fprintf(codegen, "  \n");
}

/*

  To generate global symbol vars

*/
void code_gen_global_vars()
{
  int i;


  for (i=0; i<cur_counter; i++)
     {
       if (table[i].mode == GLOBAL_MODE)
	 {
            fprintf(codegen, "        .type   %s,@object\n",table[i].name);
            fprintf(codegen, "        .comm   %s,4,4\n",table[i].name);
         }
     }

  fprintf(codegen, " \n");
  fprintf(codegen, "        .ident \"NTHU Compiler Class Code Generator for RISC-V\"\n");  
  fprintf(codegen, "        .section \"note.stack\",\"\",@progbits\n");  
}


/*

 To geenrate house-keeping work at the end of a function

*/

void code_gen_at_end_of_function_body(char *functor)
{
    int i;
    fprintf(codegen, "  \n");
    fprintf(codegen, "  // BEGIN EPILOGUE\n");
    fprintf(codegen, "  lw s11, -48(s0)\n");
    fprintf(codegen, "  lw s10, -44(s0)\n");
    fprintf(codegen, "  lw s9, -40(s0)\n");
    fprintf(codegen, "  lw s8, -36(s0)\n");
    fprintf(codegen, "  lw s7, -32(s0)\n");
    fprintf(codegen, "  lw s6, -28(s0)\n");
    fprintf(codegen, "  lw s5, -24(s0)\n");
    fprintf(codegen, "  lw s4, -20(s0)\n");
    fprintf(codegen, "  lw s3, -16(s0)\n");
    fprintf(codegen, "  lw s2, -12(s0)\n");
    fprintf(codegen, "  lw s1, -8(s0)\n");
    fprintf(codegen, "  lw sp, -4(s0)\n");
    fprintf(codegen, "  addi sp, sp, 4\n");
    fprintf(codegen, "  lw s0, -4(sp)\n");
    fprintf(codegen, "  // END EPILOGUE\n");
    fprintf(codegen, "  \n");
    fprintf(codegen, "  jalr zero, 0(ra) // return\n");
}


/*******************Utility Functions ********************/
/*
 * copyn -- makes a copy of a string with known length
 *
 * input:
 *	  n - lenght of the string "s"
 *	  s - the string to be copied
 *
 * output:
 *	  pointer to the new string
 */

char * copyn(register int n, register char *s)
{
	register char *p, *q;

	p = q = calloc(1,n);
	while (--n >= 0)
		*q++ = *s++;
	return (p);
}


/*
 * copys -- makes a copy of a string
 *
 * input:
 *	  s - string to be copied
 *
 * output:
 *	  pointer to the new string
 */
char * copys(char *s)
{
	return (copyn(strlen(s) + 1, s));
}






