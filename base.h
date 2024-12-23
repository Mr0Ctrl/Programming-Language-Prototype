#ifndef INFRASTRUCTURE_H
#define INFRASTRUCTURE_H

#include <stdbool.h>
#include <stdlib.h>
#include <string.h>


typedef enum
{
    tBool,
    tInt,
    tFloat,
    tChar
} typeEnum;

typedef union
{
    int ival;
    float fval;
    char cval;
    bool bval;
} vValue;

struct Data
{
    typeEnum type;
    vValue value;
};

#pragma region SymbolTable

struct SymbolTable
{
    char *name;
    struct Data *data;
};

extern struct SymbolTable symbolTable[100];
extern int symbolTableIndex;

int findSymbol(char *name)
{
    for (int i = 0; i < symbolTableIndex; i++)
    {
        if (strcmp(symbolTable[i].name, name) == 0)
        {
            return i;
        }
    }
    return -1;
}

int addSymbol(char *name, int type)
{
    int existing = findSymbol(name);
    if (existing != -1)
        return existing;

    symbolTable[symbolTableIndex].name = strdup(name);

    symbolTable[symbolTableIndex].data = malloc(sizeof(struct Data));
    symbolTable[symbolTableIndex].data->type = type;
    return symbolTableIndex++;
}

#pragma endregion


struct Data *basicMOp(char oper,struct Data* a ,struct Data* b)
{

    struct Data *p;
    int i;

    p = malloc(sizeof(struct Data));
    if (p == NULL)
        yyerror("out of memory");



    if (a->type == b->type)
    {
        p->type = a->type;

        if (oper == '+')
        { 
            if(p->type == tInt){
                p->value.ival = a->value.ival+b->value.ival;
            }

            if(p->type == tFloat){
                p->value.fval = a->value.fval + b->value.fval;
            }
        }
        
        if (oper  == '-')
        {
            if(p->type == tInt){
                p->value.ival = a->value.ival - b->value.ival;
            }

            if(p->type == tFloat){
                p->value.fval = a->value.fval - b->value.fval;
            }
            
        }
    
        if (oper  == '*')
        {
            if(p->type == tInt){
                p->value.ival = a->value.ival * b->value.ival;
            }

            if(p->type == tFloat){
                p->value.fval = a->value.fval * b->value.fval;
            }
            
        }

        if (oper  == '/')
        {
            if(p->type == tInt){
                p->value.fval = a->value.ival / b->value.ival;
            }

            if(p->type == tFloat){
                p->value.fval = a->value.fval / b->value.fval;
            }
            
        }
        
    }
    

    if ((a->type==tFloat) && (b->type==tInt))
    {
        p->type = tFloat;

        if (oper == '+')
        { 
            p->value.fval = a->value.fval + b->value.ival;
        }
        
        if (oper == '-')
        { 
            p->value.fval = a->value.fval - b->value.ival;
        }
    
        if (oper == '*')
        { 
            p->value.fval = a->value.fval * b->value.ival;
        }

        if (oper == '/')
        { 
            p->value.fval = a->value.fval / b->value.ival;
        }
    }

    if ((a->type==tInt) && (b->type==tFloat))
    {
        p->type = tFloat;

        if (oper == '+')
        { 
            p->value.fval = a->value.ival + b->value.fval;
        }
        
        if (oper == '-')
        { 
            p->value.fval = a->value.ival - b->value.fval;
        }
    
        if (oper == '*')
        { 
            p->value.fval = a->value.ival * b->value.fval;
        }

        if (oper == '/')
        { 
            p->value.fval = a->value.ival / b->value.fval;
        }
    }
    
    free(a);
    free(b);
    return p;
}

#endif // INFRASTRUCTURE_H