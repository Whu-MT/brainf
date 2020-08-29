%{
#include <stdio.h>
#include <stdlib.h>
#include "lex.h"

static char stack[30000]={0};
static char *sp=stack;
static char code[30000]={0};
static char *ip=code;
int yywrap(void)
{
    return 1;
}
%}

%%
"<"     { *ip++ = LSHIFT; }
">"     { *ip++ = RSHIFT; }
"+"     { *ip++ = INCR; }
"-"     { *ip++ = DECR; }
"["     { *ip++ = LBRACK; }
"]"     { *ip++ = RBRACK; }
","     { *ip++ = INPUT; }
"."     { *ip++ = OUTPUT; }
\n      continue;
.       continue;

%%
int main(int argc, char *argv[])
{
    if(argc == 2)
        yyin = fopen(argv[1], "r");
    else 
        yyin = stdin;
    while(!feof(yyin))
        yylex();

    ip = code;
    while(*ip)
    {
        switch(*ip){
            case LSHIFT:
                --sp;
                break;
            case RSHIFT:
                ++sp;
                break;
            case INCR:
                ++(*sp);
                break;
            case DECR:
                --(*sp);
                break;
            case INPUT:
                *sp = getchar();
                break;
            case OUTPUT:
                putchar(*sp);
                break;
            case LBRACK:
            {
                int n=1;
                if(0 == *sp)
                {
                    for(++ip; n; ++ip)
                    {
                        if(LBRACK == *ip)
                            ++n;
                        if(RBRACK == *ip)
                            --n;
                    }
                    --ip;
                }
                break;
            }
            case RBRACK:
            {
                int n=1;
                if(0 != *sp)
                {
                    for(--ip; n; --ip)
                    {
                        if(RBRACK == *ip)
                            ++n;
                        if(LBRACK == *ip)
                            --n;
                    }
                    ++ip;
               }
                break;
            }
            default:
                printf("unrecognized code\n");
                exit(EXIT_FAILURE);
        }
        ++ip;
    }

    return 0;
}
